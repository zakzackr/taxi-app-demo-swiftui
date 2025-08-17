//
//  MainViewModel.swift
//  TaxiAppWithSwiftUI
//
//  Created on 2025/08/14.
//

import Foundation
import CoreLocation
import MapKit
import SwiftUI
import FirebaseFirestore

class MainViewModel: ObservableObject {
    @Published var currentUser = User.mock
        
    @Published var showSearchView = false

    @Published var ridePointAddress: String?
    var ridePointCoordinates: CLLocationCoordinate2D?
    
    @Published var destinationAddress: String?
    var destinationCoordinates: CLLocationCoordinate2D?
    
    @Published var mainCamera: MapCameraPosition = .userLocation(fallback: .automatic)
    @Published var route: MKRoute?
    
    @Published var taxis: [Taxi] = []
    var taxisListener: ListenerRegistration?
    
    @Published var selectedTaxi: Taxi?
    
    @MainActor
    func setRideLocation(coordinates: CLLocationCoordinate2D) async {
        ridePointCoordinates = coordinates
        ridePointAddress = await coordinates.getLocationAddress()
    }
    
    @MainActor
    func setDestination(coordinates: CLLocationCoordinate2D) async {
        destinationCoordinates = coordinates
        destinationAddress = await coordinates.getLocationAddress()
    }
    
    @MainActor
    func fetchRoute() async {
        guard let ridePointCoordinates else { return }
        guard let destinationCoordinates else { return }
        
        let request = MKDirections.Request()
        request.source = .init(placemark: .init(coordinate: ridePointCoordinates))
        request.destination = .init(placemark: .init(coordinate: destinationCoordinates))
        
        do {
            let directions = try await MKDirections(request: request).calculate()
            route = directions.routes.first
            
            changeCameraPosition()
        } catch {
            print("ルート生成に失敗しました: \(error.localizedDescription)")
        }
    }
    
    func startTaxisListening() {
        let firestore = Firestore.firestore()
        
        taxisListener = firestore.collection("taxis")
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    print("リスナーの取得に失敗しました: \(error.localizedDescription)")
                    return
                }
                
                guard let snapshot = querySnapshot else {
                    print("リスナーにデータ無し")
                    return
                }
                

                snapshot.documentChanges.forEach { diff in
                    
                    do {
                        let taxi = try diff.document.data(as: Taxi.self)
                        
                        switch diff.type {
                        case .added:
                            print("DEBUG: 追加")
                            self.taxis.append(taxi)
                        case .removed:
                            print("DEBUG: 削除")
                            self.taxis.removeAll(where: { $0.id == taxi.id })
                        case .modified:
                            print("DEBUG: 更新")
                            if let index = self.taxis.firstIndex(where: { $0.id == taxi.id }) {
                                self.taxis[index] = taxi
                            }
                        }
                        
                    } catch {
                        print("Taxiデータ変換に失敗しました: \(error.localizedDescription)")
                    }
                }
            }
    }
    
    func callATaxi() async {
        guard let selectedTaxiId = await getSelectedTaxiId() else { return }
        
        do {
            try await Firestore.firestore().collection("taxis").document(selectedTaxiId).updateData(["state": TaxiState.goingToRidePoint.rawValue])
            
            taxisListener?.remove()
            
            Firestore.firestore().collection("taxis").document(selectedTaxiId).addSnapshotListener { documentSnapshot, error in
                if let error {
                    print("配車するタクシーのリスナーの取得に失敗しました: \(error.localizedDescription)")
                    return
                }
                
                guard let snapshot = documentSnapshot else {
                    print("配車するタクシーのリスナーデータが取得できませんでした")
                    return
                }
                
                do {
                    let taxi = try snapshot.data(as: Taxi.self)
                    self.selectedTaxi = taxi
                } catch {
                    print("配車するタクシーのデータ変換に失敗しました: \(error.localizedDescription)")
                }
                
                
            }
        } catch {
            print("タクシーデータの更新に失敗: \(error.localizedDescription)")
        }
        
    }
    
    func reset() {
        currentUser.state = .setRidePoint
        ridePointAddress = nil
        ridePointCoordinates = nil
        destinationAddress = nil
        destinationCoordinates = nil
        route = nil
        changeCameraPosition()
    }
}

extension MainViewModel {
    
    private func changeCameraPosition() {
        
        switch currentUser.state {
        case .confirmed:
            guard var rect = route?.polyline.boundingMapRect else { return }
            let paddingWidth = rect.size.width * Constants.paddingRatio
            let paddingHeight = rect.size.height * Constants.paddingRatio
            
            rect.size.width += paddingWidth
            rect.size.height += paddingHeight
            
            rect.origin.x -= paddingWidth / 2
            rect.origin.y -= paddingHeight / 2
            
            mainCamera = .rect(rect)
        default:
            mainCamera = .userLocation(fallback: .automatic)
        }
    }
    
    private func fetchTaxis() async -> [Taxi]? {
        let firestore = Firestore.firestore()
        
        do {
            let snapshot = try await firestore.collection("taxis").getDocuments()
            var tempTaxis: [Taxi] = []
            
            for document in snapshot.documents {
                let taxi = try document.data(as: Taxi.self)
                tempTaxis.append(taxi)
            }
            
            return tempTaxis
        } catch {
            print("Taxiデータの取得に失敗しました：\(error.localizedDescription)")
            return nil
        }
    }
    
    private func getSelectedTaxiId() async -> String? {
        guard let allTaxis = await fetchTaxis(),
              let ridePointCoordinates = ridePointCoordinates
        else { return nil}
        
        let rideLocation = CLLocation(latitude: ridePointCoordinates.latitude, longitude: ridePointCoordinates.longitude)
        var minDistance: CLLocationDistance = .infinity
        var selectedTaxiId: String?
        
        for taxi in allTaxis {
            guard taxi.state == .empty else { continue }
            
            let taxiLocation = CLLocation(latitude: taxi.coordinates.latitude, longitude: taxi.coordinates.longitude)
            let distance = rideLocation.distance(from: taxiLocation)
            
            if distance < minDistance {
                minDistance = distance
                selectedTaxiId = taxi.id
            }
        }
        
        return selectedTaxiId
    }
}

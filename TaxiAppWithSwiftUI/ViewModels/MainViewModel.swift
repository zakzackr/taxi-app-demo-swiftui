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

enum UserState {
    case setRidePoint
    case searchLocation
}

class MainViewModel: ObservableObject {
    
    var userState: UserState = .setRidePoint
    
    @Published var showSearchView = false

    @Published var ridePointAddress = ""
    var ridePointCoordinates: CLLocationCoordinate2D?
    
    @Published var destinationAddress = ""
    var destinationCoordinates: CLLocationCoordinate2D?
    
    @Published var mainCamera: MapCameraPosition = .userLocation(fallback: .automatic)
    @Published var route: MKRoute?
    
    @MainActor
    func setRideLocation(latitude: CLLocationDegrees, longitude: CLLocationDegrees) async {
        let location = CLLocation(latitude: latitude, longitude: longitude)
        ridePointCoordinates = location.coordinate
        ridePointAddress = await getLocationAddress(location: location)
    }
    
    @MainActor
    func setDestination(latitude: CLLocationDegrees, longitude: CLLocationDegrees) async {
        let location = CLLocation(latitude: latitude, longitude: longitude)
        destinationCoordinates = location.coordinate
        destinationAddress = await getLocationAddress(location: location)
    }
    
    func getLocationAddress(location: CLLocation) async -> String {
        let geoCoder = CLGeocoder()
                
        do {
            let placemarks = try await geoCoder.reverseGeocodeLocation(location)
            
            guard let placemark = placemarks.first else { return "" }
            
            let administrativeArea = placemark.administrativeArea ?? ""
            let locality = placemark.locality ?? ""
            let subLocality = placemark.subLocality ?? ""
            let thoroughfare = placemark.thoroughfare ?? ""
            let subThoroughfare = placemark.subThoroughfare ?? ""
            
            return "\(administrativeArea)\(locality)\(subLocality)\(thoroughfare)\(subThoroughfare)"
            
        } catch {
            print("位置情報の取得に失敗：\(error.localizedDescription)")
            return ""
        }
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
    
    private func changeCameraPosition() {
        
        guard var rect = route?.polyline.boundingMapRect else { return }
        let paddingWidth = rect.size.width * 0.2
        let paddingHeight = rect.size.height * 0.2
        
        rect.size.width += paddingWidth
        rect.size.height += paddingHeight
        
        rect.origin.x -= paddingWidth / 2
        rect.origin.y -= paddingHeight / 2
        
        mainCamera = .rect(rect)
    }
}

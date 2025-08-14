//
//  MainViewModel.swift
//  TaxiAppWithSwiftUI
//
//  Created on 2025/08/14.
//

import Foundation
import CoreLocation

enum UserState {
    case setRidePoint
    case searchLocation
}

class MainViewModel: ObservableObject {
    
    var userState: UserState = .setRidePoint
    
    @Published var ridePointName = ""
    var ridePointCoordinates: CLLocationCoordinate2D?
    
    @MainActor
    func getLocationAddress(latitude: CLLocationDegrees, longitude: CLLocationDegrees) async {
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: latitude, longitude: longitude)
        
        ridePointCoordinates = location.coordinate
        
        do {
            let placemarks = try await geoCoder.reverseGeocodeLocation(location)
            
            guard let placemark = placemarks.first else { return }
            
            let administrativeArea = placemark.administrativeArea ?? ""
            let locality = placemark.locality ?? ""
            let subLocality = placemark.subLocality ?? ""
            let thoroughfare = placemark.thoroughfare ?? ""
            let subThoroughfare = placemark.subThoroughfare ?? ""
            
            ridePointName = "\(administrativeArea)\(locality)\(subLocality)\(thoroughfare)\(subThoroughfare)"
            
        } catch {
            print("位置情報の取得に失敗：\(error.localizedDescription)")
        }
    }
    
}

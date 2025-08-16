//
//  CLLocationCoordinate2DExt.swift
//  TaxiAppWithSwiftUI
//
//  Created by Ryuichi Kozaki on 2025/08/16.
//

import Foundation
import MapKit

extension CLLocationCoordinate2D {
    
    func getLocationAddress() async -> String {
        let geoCoder = CLGeocoder()
                
        do {
            let placemarks = try await geoCoder.reverseGeocodeLocation(CLLocation(latitude: self.latitude, longitude: self.longitude))
            
            guard let placemark = placemarks.first else { return "" }
            return MKPlacemark(placemark: placemark).addressString
            
        } catch {
            print("位置情報の取得に失敗：\(error.localizedDescription)")
            return ""
        }
    }
}



//
//  SearchViewModel.swift
//  TaxiAppWithSwiftUI
//
//  Created on 2025/08/14.
//

import Foundation
import MapKit

class SearchViewModel: ObservableObject {
    
    @Published var searchResults: [MKMapItem] = []
        
    @MainActor
    func searchPlace(searchText: String, center: CLLocationCoordinate2D, meters: CLLocationDistance) async {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchText
        request.region = MKCoordinateRegion(center: center, latitudinalMeters: meters, longitudinalMeters: meters)
        
        do {
            let results = try await MKLocalSearch(request: request).start()
            searchResults = results.mapItems
            print("検索結果：\(results)")
        } catch {
            print("施設検索に失敗：\(error)")
        }
    }
    
    func getAddressString(placemark: MKPlacemark) -> String {
        let administrativeArea = placemark.administrativeArea ?? ""
        let locality = placemark.locality ?? ""
        let subLocality = placemark.subLocality ?? ""
        let thoroughfare = placemark.thoroughfare ?? ""
        let subThoroughfare = placemark.subThoroughfare ?? ""
        
        return "\(administrativeArea)\(locality)\(subLocality)\(thoroughfare)\(subThoroughfare)"
    }
}

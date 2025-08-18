//
//  Constants.swift
//  TaxiAppWithSwiftUI
//
//  Created by Ryuichi Kozaki on 2025/08/16.
//

import Foundation
import CoreLocation

struct Constants {
    static let paddingRatio = 0.2
    static let informationAreaHeight: CGFloat = 240
    
    static let sampleCoordinates: CLLocationCoordinate2D = .init(latitude: 35.452183, longitude: 139.632419)
    
    static let searchRegion: CLLocationDistance = 1000
    static let cameraDistance: Double = 1000
    
    static let pinHeight: CGFloat = 40
    static let cameraMargin: CGFloat = 1.25
    static let meterOfRange: Double = 10.0
}

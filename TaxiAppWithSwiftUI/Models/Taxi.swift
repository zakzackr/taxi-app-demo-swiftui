//
//  Taxi.swift
//  TaxiAppWithSwiftUI
//
//  Created by Ryuichi Kozaki on 2025/08/16.
//

import Foundation
import CoreLocation

struct Taxi {
    let id: String
    let number: String
    var coordinates: CLLocationCoordinate2D
    var state: TaxiState
}

enum TaxiState {
    case empty
    case goingToRidePoint
}

extension Taxi: Identifiable {
    
    static var mocks: [Self] {
        [
            Taxi(
                id: "1",
                number: "111-111",
                coordinates: .init(latitude: 35.45024933203917, longitude: 139.63091754052357),
                state: .empty
            ),
            Taxi(
                id: "2",
                number: "222-222",
                coordinates: .init(latitude: 35.45762264893872, longitude: 139.6358223085829),
                state: .empty
            ),
            Taxi(
                id: "3",
                number: "333-333",
                coordinates: .init(latitude: 35.4580885544616, longitude: 139.62589837664265),
                state: .goingToRidePoint
            ),
            Taxi(
                id: "4",
                number: "444-444",
                coordinates: .init(latitude: 35.44998327370894, longitude: 139.62716243048024),
                state: .empty
            ),
            Taxi(
                id: "5",
                number: "555-555",
                coordinates: .init(latitude: 35.447348742599324, longitude: 139.63230460286928),
                state: .goingToRidePoint
            ),
            Taxi(
                id: "6",
                number: "666-666",
                coordinates: .init(latitude: 35.455875478531276, longitude: 139.63106053644591),
                state: .goingToRidePoint
            ),
            Taxi(
                id: "7",
                number: "777-777",
                coordinates: .init(latitude: 35.44625371395893, longitude: 139.6392256158568),
                state: .empty
            ),
            Taxi(
                id: "8",
                number: "888-888",
                coordinates: .init(latitude: 35.45429134421111, longitude: 139.63739526634797),
                state: .goingToRidePoint
            ),
            Taxi(
                id: "9",
                number: "999-999",
                coordinates: .init(latitude: 35.44571784300777, longitude: 139.62734263722658),
                state: .empty
            )
        ]
    }
}

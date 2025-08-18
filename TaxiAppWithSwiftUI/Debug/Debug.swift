//
//  Debug.swift
//  TaxiAppWithSwiftUI
//
//  Created by Ryuichi Kozaki on 2025/08/18.
//

import Foundation
import FirebaseFirestore

struct Debug {
    
    static func setTaxi() async {
        do {
            try await Firestore.firestore().collection("taxis").document("ZN9LkihHSHkxOQbj1w89").updateData([
                "state": TaxiState.empty.rawValue,
                "geoPoint": GeoPoint(latitude: 35.45024933203917, longitude: 139.63091754052357)
            ])
            print("ドキュメントを初期化")
        } catch {
            print("ドキュメントの初期化に失敗しました。: \(error.localizedDescription)")
        }
    }
    
    static func moveTaxi(id: String, state: TaxiState, delay: Double = 1.0) async {
        var points: [GeoPoint] = []
        
        switch state {
        case .goingToRidePoint:
            points = toRidePoint
        case .gointToDestination:
            points = toDestination
        default:
            return
        }
        
        for point in points {
            do {
                try await Task.sleep(for: .seconds(delay))
                try await Firestore.firestore().collection("taxis").document(id).updateData([
                    "geoPoint" : point
                ])
            } catch {
                print("FirebaseのgeoPointの更新に失敗: \(error.localizedDescription)")
            }
        }
    }
    
    static let toRidePoint: [GeoPoint] = [
        GeoPoint(latitude: 35.45042722836313, longitude: 139.63133102525933),
        GeoPoint(latitude: 35.45066488613193, longitude: 139.63177228486575),
        GeoPoint(latitude: 35.451037710226196, longitude: 139.6321205516676),
        GeoPoint(latitude: 35.45145212228258, longitude: 139.63229559678967),
        GeoPoint(latitude: 35.451995756367744, longitude: 139.6323831193506),
        GeoPoint(latitude: 35.45215765765758, longitude: 139.63241229359326),
    ]

    static let toDestination: [GeoPoint] = [
         GeoPoint(latitude: 35.45274212439097, longitude: 139.63168971968284),
         GeoPoint(latitude: 35.454349585160415, longitude: 139.6303312561288),
         GeoPoint(latitude: 35.456341394172064, longitude: 139.6287010994713),
         GeoPoint(latitude: 35.45861269514968, longitude: 139.62697084638805),
         GeoPoint(latitude: 35.46067428205731, longitude: 139.62659905685877),
         GeoPoint(latitude: 35.46271252207881, longitude: 139.6266991545936),
         GeoPoint(latitude: 35.462741737669056, longitude: 139.62822624412155),
         GeoPoint(latitude: 35.46348826908946, longitude: 139.6284373478614),
         GeoPoint(latitude: 35.46439367406622, longitude: 139.62853621915428),
         GeoPoint(latitude: 35.46497478196538, longitude: 139.62947950516198),
    ]

}

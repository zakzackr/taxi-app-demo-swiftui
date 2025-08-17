//
//  User.swift
//  TaxiAppWithSwiftUI
//
//  Created by Ryuichi Kozaki on 2025/08/16.
//

import Foundation

struct User {
    let id: String
    let name: String
    let email: String
    var state: UserState
}

enum UserState {
    case setRidePoint
    case searchLocation
    case setDestination
    case confirmed
    case ordered
}

extension User {
    
    static var mock: Self {
        mocks[0]
    }
    
    static var mocks: [Self] {
        [
            User(
                id: "1",
                name: "ブルー",
                email: "test1@example.com",
                state: .setRidePoint
            ),
            User(
                id: "2",
                name: "パープル",
                email: "test2@example.com",
                state: .setRidePoint
            ),
            User(
                id: "3",
                name: "ピンク",
                email: "test3@example.com",
                state: .setRidePoint
            ),
            User(
                id: "4",
                name: "グリーン",
                email: "test4@example.com",
                state: .setRidePoint
            ),
            User(
                id: "5",
                name: "イエロー",
                email: "test5@example.com",
                state: .setRidePoint
            )
        ]
    }
}


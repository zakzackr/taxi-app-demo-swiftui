//
//  ViewExt.swift
//  TaxiAppWithSwiftUI
//
//  Created by Ryuichi Kozaki on 2025/08/16.
//

import Foundation
import SwiftUI

extension View {
    func threeTriangles(x: CGFloat, y: CGFloat) -> some View {
        // self省略可能
//        self.
            overlay(alignment: .topLeading) {
                VStack {
                    Image(systemName: "arrowtriangle.down.fill")
                    Image(systemName: "arrowtriangle.down.fill").opacity(0.66)
                    Image(systemName: "arrowtriangle.down.fill").opacity(0.33)
                }
                .font(.caption2)
                .foregroundStyle(.main)
                .offset(x: x, y: y)
            }
    }
}

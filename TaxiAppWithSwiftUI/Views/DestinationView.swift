//
//  DestinationView.swift
//  TaxiAppWithSwiftUI
//
//  Created by Ryuichi Kozaki on 2025/08/13.
//

import SwiftUI

struct DestinationView: View {
    var body: some View {
        VStack {
            // Map Area
            map
            
            // Information Area
            information
            
        }
    }
}

#Preview {
    DestinationView()
}

extension DestinationView {
    private var map: some View {
        Color.gray
    }
    
    private var information: some View {
        VStack(alignment: .leading, spacing: 14) {
            // Caption
            VStack(alignment: .leading) {
                Text("この場所でよろしいですか？")
                    .font(.title3)
                    .fontWeight(.bold)
                Text("地図を動かして地点と調整")
                    .font(.caption)
                    .foregroundStyle(.gray)
            }
            
            // Destination
            Destination()
                            
            // Button
            Capsule()
                .frame(height: 70)
        }
        .padding(.top, 14)
        .padding(.horizontal)
    }
}

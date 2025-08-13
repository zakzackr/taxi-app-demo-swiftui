//
//  Destination.swift
//  TaxiAppWithSwiftUI
//
//  Created by Ryuichi Kozaki on 2025/08/13.
//

import SwiftUI

struct Destination: View {
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "mappin.and.ellipse")
                .imageScale(.large)
            
            VStack(alignment: .leading) {
                Text("目的地")
                    .font(.subheadline)
                Text("指定してください")
                    .font(.headline)
            }
            
            Spacer()
        }
        .foregroundStyle(.secondary)
        .padding(9)
        .background(Color(uiColor: .secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }
}

#Preview {
    Destination()
}

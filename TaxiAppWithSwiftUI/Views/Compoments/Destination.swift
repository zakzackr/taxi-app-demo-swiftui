//
//  Destination.swift
//  TaxiAppWithSwiftUI
//
//  Created on 2025/08/13.
//

import SwiftUI

struct Destination: View {
    
    var address: String?
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "mappin.and.ellipse")
                .imageScale(.large)
            
            VStack(alignment: .leading) {
                Text("目的地")
                    .font(.subheadline)
                Text(address ?? "指定してください")
                    .font(.headline)
            }
            
            Spacer()
        }
        .foregroundStyle(address == nil ? .secondary: .primary)
        .padding(9)
        .background(Color(uiColor: .secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }
}

#Preview {
    Destination()
}

//
//  SearchView.swift
//  TaxiAppWithSwiftUI
//
//  Created by Ryuichi Kozaki on 2025/08/13.
//

import SwiftUI

struct SearchView: View {
    var body: some View {
        VStack(spacing: 0) {
            // Input filed
            Divider()
            
            Capsule()
                .frame(height: 70)
                .padding()
            
            Divider()
            
            // Result
            ScrollView {
                VStack(spacing: 16) {
                    Text("検索結果")
                        .font(.title2)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    ForEach(0 ..< 10) { _ in
                        RoundedRectangle(cornerRadius: 18)
                            .frame(height: 70)
                    }
                    
                }
                .padding()
            }
            .background(Color(uiColor: .secondarySystemBackground))
            
        }
    }
}

#Preview {
    SearchView()
}

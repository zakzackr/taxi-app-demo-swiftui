//
//  DestinationView.swift
//  TaxiAppWithSwiftUI
//
//  Created on 2025/08/13.
//

import SwiftUI

struct DestinationView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            // Map Area
            map
            
            // Information Area
            information
            
        }
        .navigationTitle("地点を確認・調整")
        .navigationBarBackButtonHidden()
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.headline)
                }
                .foregroundStyle(.black)

            }
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
            Button {
                print("ボタンがタップされました")
            } label: {
                Text("ここに行く")
                    .modifier(BasicButton())
            }

        }
        .padding(.top, 14)
        .padding(.horizontal)
    }
}

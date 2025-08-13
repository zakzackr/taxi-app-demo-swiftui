//
//  MainView.swift
//  TaxiAppWithSwiftUI
//
//  Created by Ryuichi Kozaki on 2025/08/13.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        VStack {
            // Map Area
            Color.gray
            
            // Information Area
            VStack {
                // Starting Point
                HStack(spacing: 12) {
                    Circle()
                        .frame(width: 30, height: 30)
                    
                    VStack(alignment: .leading) {
                        HStack {
                            Text("乗車地")
                                .font(.subheadline)
                            Text("地図を動かして地図を調整")
                                .font(.caption)
                                .foregroundStyle(.gray)
                        }
                        
                        Text("横浜市西区みなとみらい1-1")
                            .font(.headline)
                    }
                    
                    Spacer()
                }.padding(.vertical)
                
                // Destination
                HStack(spacing: 12) {
                    Circle()
                        .frame(width: 30, height: 30)
                    
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
                
                Spacer()
                
                // Button
                Capsule()
                    .frame(height: 60)
            }
            .padding(.horizontal)
            .frame(height: 240)
        }
    }
}

#Preview {
    MainView()
}

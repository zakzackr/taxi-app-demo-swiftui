//
//  Status.swift
//  TaxiAppWithSwiftUI
//
//  Created by Ryuichi Kozaki on 2025/08/17.
//

import SwiftUI

struct Status: View {
    var body: some View {
        VStack {
            // Status bar
            HStack {
                imageAndText(imageName: "figure.wave.circle", text: "手配")
                
                Spacer()
                bar
                Spacer()

                imageAndText(imageName: "car.circle", text: "乗車")
                
                Spacer()
                bar
                Spacer()

                imageAndText(imageName: "checkmark.circle", text: "到着")
            }
            
            // Message
            Text("タクシーを手配しています")
                .font(.headline)
        }
        .foregroundStyle(.main)
    }
}

#Preview {
    Status()
}

extension Status {
    private func imageAndText(imageName: String, text: String) -> some View {
        VStack(spacing: 6) {
            Image(systemName: imageName)
                .imageScale(.large)
            Text(text)
                .font(.caption)
                .fontWeight(.bold)
        }
    }
    
    private var bar: some View {
        HStack(spacing: 0) {
            Rectangle()
                .frame(width: 50, height: 4)
                .opacity(0.2)
            Rectangle()
                .frame(width: 50, height: 4)
                .opacity(0.2)
        }
    }
}

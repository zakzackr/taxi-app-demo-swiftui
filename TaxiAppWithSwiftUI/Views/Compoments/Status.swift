//
//  Status.swift
//  TaxiAppWithSwiftUI
//
//  Created by Ryuichi Kozaki on 2025/08/17.
//

import SwiftUI

struct Status: View {
    let state: TaxiState
    
    var body: some View {
        VStack {
            // Status bar
            HStack {
                imageAndText(
                    imageName: state == .empty ? "figure.wave.circle": "checkmark.circle.fill",
                    text: "手配"
                )
                
                Spacer()
                if state == .empty {
                    bar(progress: .notStarted)
                } else if state == .goingToRidePoint {
                    bar(progress: .middle)
                } else {
                    bar(progress: .arrived)
                }
                Spacer()

                imageAndText(
                    imageName: state == .empty || state == .goingToRidePoint ?  "car.circle": "checkmark.circle.fill",
                    text: "乗車"
                )
                
                Spacer()
                if state == .gointToDestination {
                    bar(progress: .middle)
                } else if state == .arrivedAtDestination {
                    bar(progress: .arrived)
                } else {
                    bar(progress: .notStarted)
                }
                Spacer()

                imageAndText(
                    imageName: state == .arrivedAtDestination ? "checkmark.circle.fill": "checkmark.circle",
                    text: "到着"
                )
            }
            
            // Message
            Text(state.message)
                .font(.headline)
        }
        .foregroundStyle(.main)
    }
}

#Preview {
    Status(state: .empty)
}

enum Progress {
    case notStarted, middle, arrived
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
    
    private func bar(progress: Progress) -> some View {
        HStack(spacing: 0) {
            Rectangle()
                .frame(width: 50, height: 4)
                .opacity(progress == .notStarted ? 0.2 : 1.0)
            Rectangle()
                .frame(width: 50, height: 4)
                .opacity(progress == .arrived ? 1.0 : 0.2)
        }
    }
}

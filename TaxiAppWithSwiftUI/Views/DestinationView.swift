//
//  DestinationView.swift
//  TaxiAppWithSwiftUI
//
//  Created on 2025/08/13.
//

import SwiftUI
import MapKit

struct DestinationView: View {
    @EnvironmentObject var mainViewModel: MainViewModel
    @Environment(\.dismiss) var dismiss
    @State private var cameraPosition: MapCameraPosition = .automatic
    
    let placemark: MKPlacemark
    
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
    DestinationView(placemark: .init(coordinate: Constants.sampleCoordinates)
    )
    .environmentObject(MainViewModel())
}

extension DestinationView {
    private var map: some View {
        Map(position: $cameraPosition){
        }
        .overlay{
            CenterPin()
        }
        .onAppear {
            mainViewModel.currentUser.state = .setDestination
            cameraPosition = .camera(MapCamera(centerCoordinate: placemark.coordinate, distance: Constants.cameraDistance))
        }
        .onMapCameraChange(frequency: .onEnd) { context in
            Task {
                await mainViewModel.setDestination(coordinates: context.region.center)
            }
        }
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
            Destination(address: mainViewModel.destinationAddress)
                            
            // Button
            Button {
                mainViewModel.currentUser.state = .confirmed
                mainViewModel.showSearchView = false
                Task {
                    await mainViewModel.fetchRoute()
                }
            } label: {
                Text("ここに行く")
                    .modifier(BasicButton())
            }

        }
        .padding(.top, 14)
        .padding(.horizontal)
    }
}

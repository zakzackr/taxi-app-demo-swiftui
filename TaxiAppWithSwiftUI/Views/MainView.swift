//
//  MainView.swift
//  TaxiAppWithSwiftUI
//
//  Created on 2025/08/13.
//

import SwiftUI
import MapKit
import CoreLocation

struct MainView: View {
    @State private var showSearchView = false
//    @State private var cameraPosition: MapCameraPosition = .region(
//        MKCoordinateRegion(
//            center: .init(latitude: 35.452183, longitude: 139.632419),
//            latitudinalMeters: 10000,
//            longitudinalMeters: 10000
//        )
//    )
    
    @State private var cameraPosition: MapCameraPosition = .userLocation(fallback: .automatic)
    
    var body: some View {
        VStack {
            // Map Area
            map
            
            // Information Area
            information  
        }
        .sheet(isPresented: $showSearchView) {
            SearchView()
        }
    }
}

#Preview {
    MainView()
}

extension MainView {
    
    private var map: some View {
        Map(position: $cameraPosition) {
            UserAnnotation()
        }
        .onAppear{
            CLLocationManager().requestWhenInUseAuthorization()
        }
    }
    
    private var information: some View {
        VStack {
            // Starting Point
            HStack(spacing: 12) {
                Image(systemName: "figure.wave")
                    .imageScale(.large)
                    .foregroundStyle(.main)
                
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
            Destination()
                .overlay(alignment: .topLeading) {
                    VStack {
                        Image(systemName: "arrowtriangle.down.fill")
                        Image(systemName: "arrowtriangle.down.fill").opacity(0.66)
                        Image(systemName: "arrowtriangle.down.fill").opacity(0.33)
                    }
                    .font(.caption2)
                    .foregroundStyle(.main)
                    .offset(x: 8, y: -16)
                }
            
            Spacer()
            
            // Button
            Button {
                showSearchView.toggle()
            } label: {
                Text("目的地を指定する")
                    .modifier(BasicButton())
            }

        }
        .padding(.horizontal)
        .frame(height: 240)
    }
}

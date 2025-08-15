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
    
    @ObservedObject var mainViewModel = MainViewModel()
        
    var body: some View {
        VStack {
            // Map Area
            map
            
            // Information Area
            information  
        }
        .sheet(isPresented: $mainViewModel.showSearchView) {
            mainViewModel.userState = .setRidePoint
        } content: {
            SearchView(center: mainViewModel.ridePointCoordinates)
                .environmentObject(mainViewModel)
        }
    }
}

#Preview {
    MainView()
}

extension MainView {
    
    private var map: some View {
        Map(position: $mainViewModel.mainCamera) {
            UserAnnotation()
            
            if let polyline = mainViewModel.route?.polyline {
                MapPolyline(polyline)
                    .stroke(.blue, lineWidth: 7)
            }
        }
        .overlay{
            CenterPin()
        }
        .onAppear{
            CLLocationManager().requestWhenInUseAuthorization()
        }
        .onMapCameraChange(frequency: .onEnd) { context in
            if mainViewModel.userState == .setRidePoint {
                let center = context.region.center
                Task {
                    await mainViewModel.setRideLocation(latitude: center.latitude, longitude: center.longitude)
                }
            }
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
                    
                    Text(mainViewModel.ridePointAddress)
                        .font(.headline)
                }
                
                Spacer()
            }.padding(.vertical)
            
            // Destination
            Destination(address: "設定してください")
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
                mainViewModel.userState = .searchLocation
                mainViewModel.showSearchView.toggle()
            } label: {
                Text("目的地を指定する")
                    .modifier(BasicButton())
            }

        }
        .padding(.horizontal)
        .frame(height: 240)
    }
}

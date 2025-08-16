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
    
    @StateObject var mainViewModel = MainViewModel()
        
    var body: some View {
        VStack {
            // Map Area
            map
            
            // Information Area
            information  
        }
        .sheet(isPresented: $mainViewModel.showSearchView) {
            if mainViewModel.currentUser.state != .confirmed {
                mainViewModel.currentUser.state = .setRidePoint
            }
        } content: {
            SearchView()
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
            // User's current location
            UserAnnotation()
            
            // Ride Point and Destination
            if let ridePoint = mainViewModel.ridePointCoordinates,
               let destination = mainViewModel.destinationCoordinates{
                Marker("乗車地", coordinate: ridePoint).tint(.blue)
                Marker("目的地", coordinate: destination).tint(.blue)
            }
            
            // Route polyline
            if let polyline = mainViewModel.route?.polyline {
                MapPolyline(polyline)
                    .stroke(.blue, lineWidth: 7)
            }
            
            // Taxi location
            ForEach(mainViewModel.taxis) { taxi in
                Annotation(taxi.number, coordinate: taxi.coordinates) {
                    Image(systemName: "car.circle.fill")
                }
            }
        }
        .overlay{
            if mainViewModel.currentUser.state == .setRidePoint {
                CenterPin()
            }
        }
        .onAppear{
            CLLocationManager().requestWhenInUseAuthorization()
        }
        .onMapCameraChange(frequency: .onEnd) { context in
            if mainViewModel.currentUser.state == .setRidePoint {
                Task {
                    await mainViewModel.setRideLocation(coordinates: context.region.center)
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
                    
                    Text(mainViewModel.ridePointAddress ?? "")
                        .font(.headline)
                }
                
                Spacer()
            }.padding(.vertical)
            
            // Destination
            Destination(address: mainViewModel.destinationAddress)
                .threeTriangles(x: 8, y: -16)
            
            Spacer()
            
            // Button
            if mainViewModel.currentUser.state == .confirmed {
                HStack(spacing: 16) {
                    Button {
                        mainViewModel.reset()
                    }
                    label: {
                        Text("キャンセル")
                            .modifier(BasicButton(isPrimary: false))
                    }
                    
                    Button {
                        
                    }
                    label: {
                        Text("タクシーを呼ぶ")
                            .modifier(BasicButton(isPrimary: true))
                    }
                }
                
            } else {
                Button {
                    mainViewModel.currentUser.state = .searchLocation
                    mainViewModel.showSearchView.toggle()
                } label: {
                    Text("目的地を指定する")
                        .modifier(BasicButton(isPrimary: true))
                }
            }
        }
        .padding(.horizontal)
        .frame(height: Constants.informationAreaHeight)
    }
}

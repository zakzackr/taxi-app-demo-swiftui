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
        .alert("確認", isPresented: $mainViewModel.showAlertAtRidePoint) {
            Button("OK") {
                Task {
                    await mainViewModel.updateTaxiState(id: mainViewModel.selectedTaxi?.id, state: .gointToDestination)
                }
            }
        } message: {
            Text("タクシーが乗車地に到着しました")
        }
        .alert("確認", isPresented: $mainViewModel.showAlertAtDestination) {
            Button("OK") {
                Task {
                    await mainViewModel.updateTaxiState(id: mainViewModel.selectedTaxi?.id, state: .empty)
                    mainViewModel.reset()
                }
            }
        } message: {
            Text("タクシーが目的地に到着しました")
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
            
            // Taxi location
            if mainViewModel.currentUser.state == .setRidePoint {
                ForEach(mainViewModel.taxis) { taxi in
                    if taxi.state == .empty {
                        Annotation(taxi.number, coordinate: taxi.coordinates) {
                            Image(systemName: "car.circle.fill")
                        }
                    }
                }
            }
            
            if mainViewModel.currentUser.state == .confirmed ||
                mainViewModel.currentUser.state == .ordered
            {
                // Ride Point and Destination
                if let ridePoint = mainViewModel.ridePointCoordinates,
                   let destination = mainViewModel.destinationCoordinates{
                    Marker("乗車地", coordinate: ridePoint).tint(.blue)
                    Marker("目的地", coordinate: destination).tint(.blue)
                }
            }
            
            if mainViewModel.currentUser.state == .confirmed {
                // Route polyline
                if let polyline = mainViewModel.route?.polyline {
                    MapPolyline(polyline)
                        .stroke(.blue, lineWidth: 7)
                }
            }
            
            if mainViewModel.currentUser.state == .ordered {
                // Selected Taxi
                if let taxi = mainViewModel.selectedTaxi {
                    Annotation(taxi.number, coordinate: taxi.coordinates) {
                        Image(systemName: "car.circle.fill")
                            .font(.largeTitle)
                            .foregroundStyle(.main)
                    }
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
            mainViewModel.listeningForAllTaxis()
        }
        .onMapCameraChange(frequency: .onEnd) { context in
            if mainViewModel.currentUser.state == .setRidePoint {
                Task {
                    await mainViewModel.setRideLocation(coordinates: context.region.center)
                }
            }
        }
        .animation(.default, value: mainViewModel.mainCamera)
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
            
            // Button or Status
            if mainViewModel.currentUser.state == .ordered {
                if let state = mainViewModel.selectedTaxi?.state {
                    Status(state: state)
                }
            } else if mainViewModel.currentUser.state == .confirmed {
                HStack(spacing: 16) {
                    Button {
                        mainViewModel.reset()
                    }
                    label: {
                        Text("キャンセル")
                            .modifier(BasicButton(isPrimary: false))
                    }
                    
                    Button {
                        mainViewModel.currentUser.state = .ordered
                        Task {
                            await mainViewModel.callATaxi()
                        }
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

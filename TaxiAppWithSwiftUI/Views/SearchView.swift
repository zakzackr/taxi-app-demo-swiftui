//
//  SearchView.swift
//  TaxiAppWithSwiftUI
//
//  Created on 2025/08/13.
//

import SwiftUI
import MapKit

struct SearchView: View {
    
    @ObservedObject var searchViewModel = SearchViewModel()
    
    @Environment(\.dismiss) var dismiss
    @State private var searchText = ""
    let center: CLLocationCoordinate2D?
    
    var body: some View {
        NavigationStack{
            VStack(spacing: 0) {
                Divider()
                
                // Input filed
                inputField
                
                Divider()
                
                // Result
                searchResult
            }
            .navigationTitle("目的地を検索")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("キャンセル") {
                        dismiss()
                    }
                    .foregroundStyle(.black)
                }
            }
        }
    }
}

#Preview {
    SearchView(center: .init(CLLocationCoordinate2D(latitude: 35.452183, longitude: 139.632419)))
}

extension SearchView {
    private var inputField: some View {
        
        TextField("場所を入力...", text: $searchText)
            .padding()
            .background(Color(uiColor: .secondarySystemBackground))
            .clipShape(.capsule)
            .padding()
            .onSubmit {
                guard !searchText.isEmpty, let center else { return }
                Task {
                    await searchViewModel.searchPlace(searchText: searchText, center: center, meters: 1000)
                }
            }
        
    }
    
    private var searchResult: some View {
        ScrollView {
            VStack(spacing: 16) {
                Text("検索結果")
                    .font(.title2)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                ForEach(searchViewModel.searchResults, id: \.self) { mapItem in
                    searchResultRow(mapItem: mapItem)
                }
                
            }
            .padding()
        }
        .background(Color(uiColor: .secondarySystemBackground))
    }
    
    private func searchResultRow(mapItem: MKMapItem) -> some View {
        NavigationLink {
            DestinationView(placemark: mapItem.placemark)
        } label: {
            HStack(spacing: 12) {
                // Icon
                Image(systemName: "mappin.circle.fill")
                    .resizable()
                    .frame(width: 28, height: 28)
                    .foregroundColor(.main)

                // Text
                VStack(alignment: .leading) {
                    Text(mapItem.name ?? "")
                        .fontWeight(.bold)
                        .foregroundStyle(.black)
                    Text(searchViewModel.getAddressString(placemark: mapItem.placemark))
                        .font(.caption)
                        .foregroundStyle(.gray)
                }
                .multilineTextAlignment(.leading)
                
                Spacer()
                
                // Icon
                Image(systemName: "chevron.right")
                    .foregroundStyle(.main)
            }
            .padding()
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 14))
        }
    }
}



//
//  SearchView.swift
//  TaxiAppWithSwiftUI
//
//  Created by Ryuichi Kozaki on 2025/08/13.
//

import SwiftUI

struct SearchView: View {
    
    @Environment(\.dismiss) var dismiss
    @State private var searchText = ""
    
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
    SearchView()
}

extension SearchView {
    private var inputField: some View {
        
        TextField("場所を入力...", text: $searchText)
            .padding()
            .background(Color(uiColor: .secondarySystemBackground))
            .clipShape(.capsule)
            .padding()
        
    }
    
    private var searchResult: some View {
        ScrollView {
            VStack(spacing: 16) {
                Text("検索結果")
                    .font(.title2)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                ForEach(0 ..< 10) { _ in
                    searchResultRow
                }
                
            }
            .padding()
        }
        .background(Color(uiColor: .secondarySystemBackground))
    }
    
    private var searchResultRow: some View {
        NavigationLink {
            DestinationView()
        } label: {
            HStack(spacing: 12) {
                // Icon
                Image(systemName: "mappin.circle.fill")
                    .resizable()
                    .frame(width: 28, height: 28)
                    .foregroundColor(.black)

                // Text
                VStack(alignment: .leading) {
                    Text("Kアリーナ")
                        .fontWeight(.bold)
                        .foregroundStyle(.black)
                    Text("横浜市西区みなとみらい1-1")
                        .font(.caption)
                        .foregroundStyle(.gray)
                }
                
                Spacer()
                
                // Icon
                Image(systemName: "chevron.right")
                    .foregroundStyle(.black)
                
                
                
            }
            .padding()
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 14))
        }
    }
}



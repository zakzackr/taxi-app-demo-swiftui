//
//  BasicButton.swift
//  TaxiAppWithSwiftUI
//
//  Created on 2025/08/13.
//

import SwiftUI

struct BasicButton: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity)
            .padding()
            .fontWeight(.bold)
            .foregroundColor(.white)
            .background(.main)
            .clipShape(.capsule)
    }
}


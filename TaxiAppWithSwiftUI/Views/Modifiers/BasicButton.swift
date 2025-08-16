//
//  BasicButton.swift
//  TaxiAppWithSwiftUI
//
//  Created on 2025/08/13.
//

import SwiftUI

struct BasicButton: ViewModifier {
    var isPrimary: Bool = true
    
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity)
            .padding()
            .fontWeight(.bold)
            .foregroundColor(isPrimary ? .white: .main)
            .background(isPrimary ? .main : Color(uiColor: .systemFill))
            .clipShape(.capsule)
    }
}


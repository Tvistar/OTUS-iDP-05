//
//  ActivityIndicatorView.swift
//  SwiftUIAppNav
//
//  Created by exey on 07.12.2020.
//

import UIKit
import SwiftUI

public struct ActivityIndicatorView: UIViewRepresentable {
    
    public init() {}
    
    public func makeUIView(context: UIViewRepresentableContext<ActivityIndicatorView>) -> UIActivityIndicatorView {
        UIActivityIndicatorView(style: .large)
    }
    
    public func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityIndicatorView>) {
        uiView.startAnimating()
    }
}


struct ActivityIndicatorView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Text("Preview")
            ActivityIndicatorView()
        }
    }
}


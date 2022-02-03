//
//  HomeContiner.swift
//  Web
//
//  Created by TOxIC on 01/02/2022.
//

import SwiftUI
import UIKit

struct HomeContiner: UIViewControllerRepresentable {
    
    @Binding var tabs: [Tab]
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        
    }
    

    func makeUIViewController(context: Context) -> UIViewController {
        

        return BrowserContainerViewController(tabs: $tabs)
    }
}

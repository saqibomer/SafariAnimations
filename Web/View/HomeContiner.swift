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
        uiViewController.viewDidLoad()
    }
    

    func makeUIViewController(context: Context) -> UIViewController {
        let vc = BrowserContainerViewController(tabs: $tabs)
        

        return vc
    }
}

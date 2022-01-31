//
//  WebView.swift
//  Web
//
//  Created by Saqib Omer on 31/01/2022.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    
    var tab: Tab
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        let url = URL(string: tab.tabURL)!
        
        webView.load(URLRequest(url: url))
        
        return webView
    }
    func updateUIView(_ uiView: WKWebView, context: Context) {
        <#code#>
    }
}

struct WebView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

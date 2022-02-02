//
//  BrowserContainerViewModel.swift
//  Web
//
//  Created by Saqib Omer on 30/01/2022.
//

import SwiftUI

class TabsObserveable: ObservableObject {
    @Published var tabs: [Tab] = []

}

class BrowserContainerViewModel {
    private let urlGenerator: URLGenerator
    private let keyboardManager: KeyboardManager
    
    var tabs : [Tab] = []
    
    init(urlGenerator: URLGenerator = .init(),
         keyboardManager: KeyboardManager = .init()) {
        self.urlGenerator = urlGenerator
        self.keyboardManager = keyboardManager
    }
    
    func setKeyboardHandler(onKeyboardWillShow keyboardWillShowHandler: ((NSNotification) -> Void)?,
                            onKeyboardWillHide keyboardWillHideHandler: ((NSNotification) -> Void)?) {
        keyboardManager.keyboardWillShowHandler = keyboardWillShowHandler
        keyboardManager.keyboardWillHideHandler = keyboardWillHideHandler
    }
    
    func getURL(for text: String) -> URL? {
        urlGenerator.getURL(for: text)
    }
    
    func getDomain(from url: URL) -> String {
        guard var domain = url.host else { return url.absoluteString }
        if domain.lowercased().hasPrefix("www.") {
            domain.removeFirst(4)
        }
        return domain
    }
}

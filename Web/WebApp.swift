//
//  WebApp.swift
//  Web
//
//  Created by Saqib Omer on 29/01/2022.
//

import SwiftUI

@main
struct WebApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

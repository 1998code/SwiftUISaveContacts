//
//  SwiftUISaveContactsApp.swift
//  Shared
//
//  Created by Ming on 18/12/2021.
//

import SwiftUI

@main
struct SwiftUISaveContactsApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

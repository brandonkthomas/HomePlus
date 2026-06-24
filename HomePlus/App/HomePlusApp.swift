//
//  HomePlusApp.swift
//  HomePlus
//
//  Created by Brandon Thomas on 6/13/26.
//

import SwiftUI

@main // app entry point; aka "start process using this type"
struct HomePlusApp: App {

    // MARK: Properties (Private)

    /// Single app-wide instance of AppEnvironment;
    /// which in turn handles one instance each of HomeKitRepository + HomeStore.
    ///
    /// @State: SwiftUI owns/preserves this value across view/app refreshes;
    /// its changes can trigger UI updates.
    /// SwiftUI can recreate value structs during render lifecycle. @State allows for
    /// "storage" outside the transient struct values.
    /// AppEnvironment is a class (ref obj) so @State preserves ref to this specific instance.
    ///
    /// This is a "var" because @State is a property wrapper which requires "var".
    /// SwiftUI needs writable framework-managed storage behind the scenes;
    /// does not mean we expect to replace appEnvironment.
    @State private var appEnvironment = AppEnvironment()

    // MARK: Properties (Public)

    /// Initial body.
    ///
    /// "some Scene": this is some other type which conforms to the Scene protocol.
    /// WindowGroup is a Scene that presents a group of identically structured windows.
    ///
    /// appEnvironment.store is @Observable HomeStore instance.
    /// \.homeCommands: Set this env value to appEnvironment.commands for this view subtree
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(appEnvironment.store) // inject @Observable HomeStore instance
                .environment(\.homeCommands, appEnvironment.commands) // inject @Observable AppEnvironment.commands instance
        }
    }
}

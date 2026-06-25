//
//  ContentView.swift
//  HomePlus
//
//  Created by Brandon Thomas on 6/13/26.
//

import SwiftUI

/// Reads HomeStore + calls HomeCommands (HomeKitRepository in prod; PreviewHomeCommands in preview)
struct ContentView: View {

    // MARK: Properties (Private)

    /// Read appEnvironment.store environment value from current view environment
    ///
    /// Don't need "\." here because this is a type-based lookup for an observable object
    /// placed into the environment: .environment(store))
    @Environment(HomeStore.self) private var store: HomeStore

    /// Read homeCommands environment value from current view environment
    ///
    /// Need "\." because this is a key-path lookup for a custom environment value:
    /// .environment(\.homeCommands, commands)
    @Environment(\.homeCommands) private var homeCommands: any HomeCommands

    // MARK: Views

    /// Primary view
    ///
    /// "some View": opaque type
    var body: some View {
        TabView {
            Tab("Home", systemImage: "house.fill") {
                HomeView(store: store,
                         homeCommands: homeCommands)
            }
            Tab("Cameras", systemImage: "camera.fill") {
                CamerasView()
            }
        }
        .tabBarMinimizeBehavior(TabBarMinimizeBehavior.onScrollDown) // added in iOS 26
    }
}

// MARK: Xcode Canvas Previews

// ContentView reads from store
// PreviewHomeCommands mutates that same store
// SwiftUI observes the mutation and updates the preview
#Preview("Ready") {
    let store = PreviewFixtures.makeStore(homeKitLoadState: .ready)

    ContentView()
        .environment(store)
        .environment(\.homeCommands, PreviewHomeCommands(store: store))
}

#Preview("Ready (No Homes)") {
    let store = PreviewFixtures.makeStore(homeKitLoadState: .ready,
                                          addHomes: false)

    ContentView()
        .environment(store)
        .environment(\.homeCommands, PreviewHomeCommands(store: store))
}

#Preview("Loading") {
    let store = PreviewFixtures.makeStore(homeKitLoadState: .loading)

    ContentView()
        .environment(store)
        .environment(\.homeCommands, PreviewHomeCommands(store: store))
}

#Preview("Unauthorized") {
    let store = PreviewFixtures.makeStore(homeKitLoadState: .unauthorized,
                                          addHomes: false)

    ContentView()
        .environment(store)
        .environment(\.homeCommands, PreviewHomeCommands(store: store))
}

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

    /// Map store's homeKitLoadState to String
    private var loadStateText: String {
        switch store.homeKitLoadState {
        case .loading:
            "Connecting..."
        case .ready:
            "Connected"
        case .unauthorized:
            "Unauthorized"
        }
    }

    // MARK: Views

    /// Primary view
    ///
    /// "some View": opaque type
    var body: some View {
        TabView {
            Tab("Home", systemImage: "house.fill") {
                homeTab
            }
            Tab("Cameras", systemImage: "camera.fill") {
                camerasTab
            }
        }.tabBarMinimizeBehavior(TabBarMinimizeBehavior.onScrollDown) // added in iOS 26
    }

    /// Tab 1: Home
    var homeTab: some View {
        NavigationStack {
            List {
                Section("Homes") {
                    ForEach(store.homes) { home in
                        Button {
                            // SwiftUI observes store.selectedHome + redraws view on change
                            homeCommands.selectHome(home)
                        } label: {
                            let isSelected = home.id == store.selectedHome?.id
                            HomeRowView(home: home, isSelected: isSelected)
                        }
                    }
                }
            }
            .navigationTitle(store.selectedHome?.name ?? "HomePlus")
            .navigationSubtitle(loadStateText) // added in iOS 26
        }
    }

    /// Tab 2: Cameras
    var camerasTab: some View {
        Text("Todo")
    }
}

/// View: Row for a specific Home w/ Selected status
private struct HomeRowView: View {

    let home: HomeModel
    let isSelected: Bool

    var body: some View {
        HStack {
            Text(home.name)
            Spacer()

            if isSelected {
                Text("Selected")
            }
        }
    }
}

// MARK: Xcode Canvas Preview

private func createPreviewStore(state homeKitLoadState: HomeKitLoadState) -> HomeStore {
    let store = HomeStore()

    let home1 = HomeModel(id: UUID(), name: "My Home")
    let home2 = HomeModel(id: UUID(), name: "Vacation Home")

    store.homeKitLoadState = homeKitLoadState
    store.homes = [home1, home2]
    store.selectedHome = home1

    return store
}

// ContentView reads from store
// PreviewHomeCommands mutates that same store
// SwiftUI observes the mutation and updates the preview
#Preview("Ready") {
    let store = createPreviewStore(state: .ready)

    ContentView()
        .environment(store)
        .environment(\.homeCommands, PreviewHomeCommands(store: store))
}

#Preview("Loading") {
    let store = createPreviewStore(state: .loading)

    ContentView()
        .environment(store)
        .environment(\.homeCommands, PreviewHomeCommands(store: store))
}

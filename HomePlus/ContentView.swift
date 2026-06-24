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
    @Environment(HomeStore.self) private var store: HomeStore

    /// Read homeCommands environment value from current view environment
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

    /// Initial view
    ///
    /// "some View": opaque type
    var body: some View {
        NavigationStack {
            List {
                Section("Homes") {
                    ForEach(store.homes) { home in
                        Button {
                            // SwiftUI observes store.selectedHome + redraws view on change
                            homeCommands.selectHome(home)
                        } label: {
                            HStack {
                                Text(home.name)
                                Spacer()

                                if store.selectedHome?.id == home.id {
                                    Text("Selected")
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle(store.selectedHome?.name ?? "HomePlus")
            .navigationSubtitle(loadStateText) // added in iOS 26
        }
    }
}

// MARK: Xcode Canvas Preview

private var previewStore: HomeStore {
    let store = HomeStore()

    let home1 = HomeModel(id: UUID(), name: "My Home")
    let home2 = HomeModel(id: UUID(), name: "Vacation Home")

    store.homeKitLoadState = .ready
    store.homes = [home1, home2]
    store.selectedHome = home1

    return store
}

// ContentView reads from store
// PreviewHomeCommands mutates that same store
// SwiftUI observes the mutation and updates the preview
#Preview {
    let store = previewStore

    ContentView()
        .environment(store)
        .environment(\.homeCommands, PreviewHomeCommands(store: store))
}

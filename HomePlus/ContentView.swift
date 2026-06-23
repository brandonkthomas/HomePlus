//
//  ContentView.swift
//  HomePlus
//
//  Created by Brandon Thomas on 6/13/26.
//

import SwiftUI

struct ContentView: View {

    // MARK: Properties (Private)

    @Environment(HomeStore.self) private var store: HomeStore

    /// Map store's homeKitLoadState to String
    private var loadStateText: String {
        switch store.homeKitLoadState {
        case .loading:
            "Loading"
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
                            store.selectHome(home)
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

#Preview {
    ContentView()
        .environment(previewStore)
}

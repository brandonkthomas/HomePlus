//
//  HomeView.swift
//  HomePlus
//
//  Created by Brandon Thomas on 6/24/26.
//

import SwiftUI

/// View: Home tab
struct HomeTabView: View {

    let store: HomeStore
    let homeCommands: any HomeCommands

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

    /// Message shown when there are no homes
    private var emptyStoreText: String {
        switch store.homeKitLoadState {
        case .unauthorized:
            "Home access is denied."
        default:
            "No Homes found."
        }
    }

    var body: some View {
        NavigationStack {
            if store.homes.isEmpty {
                VStack {
                    Image(systemName: "house.slash.fill")
                        .font(.system(size: 24, weight: .medium))
                        .padding(8)
                    Text(emptyStoreText)
                        .font(.system(size: 12, weight: .medium))
                }
            } else {
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
                Image(systemName: "checkmark")
            }
        }
    }
}

// MARK: Xcode Canvas Preview

// ContentView reads from store
// PreviewHomeCommands mutates that same store
// SwiftUI observes the mutation and updates the preview
#Preview("Ready") {
    let store = PreviewFixtures.makeStore(homeKitLoadState: .ready)
    let homeCommands = PreviewHomeCommands(store: store)

    HomeTabView(store: store,
                homeCommands: homeCommands)
}

//
//  HomeView.swift
//  HomePlus
//
//  Created by Brandon Thomas on 6/24/26.
//

import SwiftUI

/// View: Home tab
struct HomeView: View {

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
            "No Access"
        default:
            "No Homes"
        }
    }

    /// Description message shown when there are no homes
    private var emptyStoreDescription: String {
        switch store.homeKitLoadState {
        case .unauthorized:
            "HomePlus requires Apple Home access."
        default:
            "You have no configured Homes."
        }
    }

    /// Description message shown when there are no homes
    private var emptyStoreImage: String {
        switch store.homeKitLoadState {
        case .unauthorized:
            "hand.raised.slash.fill"
        default:
            "house.slash.fill"
        }
    }

    var body: some View {
        NavigationStack {
            if store.homes.isEmpty {
                ContentUnavailableView {
                    Label(emptyStoreText, systemImage: emptyStoreImage)
                } description: {
                    Text(emptyStoreDescription)
                }
            } else {
                List {
                    // All Homes
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

                    // Selected Home's Rooms
                    if !store.rooms.isEmpty {
                        Section("Rooms") {
                            ForEach(store.rooms) { room in
                                NavigationLink {
                                    RoomDetailView(room: room,
                                                   services: store.services(in: room))
                                } label: {
                                    Label(room.name, systemImage: "square.split.bottomrightquarter.fill")
                                }
                            }
                        }
                    }
                }
                .listStyle(.insetGrouped)
                .navigationTitle(store.selectedHome?.name ?? "HomePlus")
                .navigationSubtitle(loadStateText) // added in iOS 26
            }
        }
    }
}

// MARK: Xcode Canvas Previews

#Preview("Ready") {
    let store = PreviewFixtures.makeStore(homeKitLoadState: .ready)
    let homeCommands = PreviewHomeCommands(store: store)

    HomeView(store: store,
             homeCommands: homeCommands)
}

#Preview("Ready (No Homes)") {
    let store = PreviewFixtures.makeStore(homeKitLoadState: .ready,
                                          addHomes: false)
    let homeCommands = PreviewHomeCommands(store: store)

    HomeView(store: store,
             homeCommands: homeCommands)
}

#Preview("Loading") {
    let store = PreviewFixtures.makeStore(homeKitLoadState: .loading)
    let homeCommands = PreviewHomeCommands(store: store)

    HomeView(store: store,
             homeCommands: homeCommands)
}

#Preview("Unauthorized") {
    let store = PreviewFixtures.makeStore(homeKitLoadState: .unauthorized,
                                          addHomes: false)
    let homeCommands = PreviewHomeCommands(store: store)

    HomeView(store: store,
             homeCommands: homeCommands)
}

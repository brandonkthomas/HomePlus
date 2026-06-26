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
            "Hearth requires Apple Home access."
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

    /// Toolbar item group: appends 1 selectable checkmark-visible button for each home in store.homes
    @ToolbarContentBuilder
    private var homeToolbarItem: some ToolbarContent {
        ToolbarItemGroup(placement: .primaryAction) {
            Menu {
                Menu {
                    ForEach(store.homes) { home in
                        Button {
                            homeCommands.selectHome(home)
                        } label: {
                            if home.id == store.selectedHome?.id {
                                Label(home.name, systemImage: "checkmark")
                            } else {
                                Text(home.name)
                            }
                        }
                    }
                    Divider()
                    Button {

                    } label: {
                        Label("Add Home...", systemImage: "plus")
                    }
                } label: {
                    Label("Homes", systemImage: "house")
                }
                Menu {
                    Button { } label: {
                        Label("Rename Home", systemImage: "pencil.line")
                    }
                } label: {
                    Label("Settings", systemImage: "gear")
                }
            } label: {
                Image(systemName: "ellipsis")
            }
        }
        ToolbarItemGroup(placement: .primaryAction) {
            Button {

            } label: {
                Label("Room Info", systemImage: "info.circle")
            }
        }
    }

    /// Primary "Home" tab view
    var body: some View {
        NavigationStack {
            Group {
                if store.homes.isEmpty {
                    ContentUnavailableView {
                        Label(emptyStoreText, systemImage: emptyStoreImage)
                    } description: {
                        Text(emptyStoreDescription)
                    }
                } else {
                    List {
                        // Selected Home's Rooms
                        if !store.rooms.isEmpty {
                            Section("Rooms") {
                                ForEach(store.rooms.sorted { $0.name < $1.name }) { room in
                                    NavigationLink {
                                        RoomDetailView(room: room,
                                                       services: store.services(in: room))
                                        .navigationBarTitleDisplayMode(.inline)
                                    } label: {
                                        Label(room.name,
                                              systemImage: "square.split.bottomrightquarter.fill")
                                    }
                                }
                            }
                        }
                    }
                    .listStyle(.insetGrouped)
                    .navigationTitle(store.selectedHome?.name ?? "Hearth")
                    #if DEBUG
                    .navigationSubtitle(loadStateText) // added in iOS 26
                    #endif
                }
            }
            .toolbar {
                homeToolbarItem
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

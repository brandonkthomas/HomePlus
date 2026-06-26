//
//  RoomDetailView.swift
//  HomePlus
//
//  Created by Brandon Thomas on 6/24/26.
//

import SwiftUI

/// Primary "Room Detail" view -- sub-view of "Home" tab
struct RoomDetailView: View {

    let room: RoomModel
    let services: [ServiceModel]

    @ToolbarContentBuilder
    private var roomDetailToolbarItem: some ToolbarContent {
        ToolbarItemGroup(placement: .primaryAction) {
            Menu {
                Button {

                } label: {
                    Label("Rename Room", systemImage: "pencil.line")
                }
                Button {

                } label: {
                    Label("Change Icon", systemImage: "paintbrush")
                }
            } label: {
                Label("Settings", systemImage: "gear")
            }
        }
        ToolbarItemGroup(placement: .primaryAction) {
            Button {

            } label: {
                Label("Room Info", systemImage: "info.circle")
            }
        }
    }

    /// Primary "Room Detail" view -- sub-view of "Home" tab
    var body: some View {
        Group {
            if services.isEmpty {
                ContentUnavailableView {
                    Label("No Accessories", systemImage: "lightbulb.slash.fill")
                } description: {
                    Text("Accessories added to this room will appear here.")
                }
            } else {
                List {
                    Section {
                        ForEach(
                            services.sorted { $0.accessoryName < $1.accessoryName
                            }) { service in
                            ServiceRowView(service: service)
                        }
                    }
                }
                .listStyle(.insetGrouped)
            }
        }
        .navigationTitle(room.name)
        .toolbar {
            roomDetailToolbarItem
        }
    }
}

// MARK: Xcode Canvas Previews

#Preview("Populated") {
    let store = PreviewFixtures.makeStore(homeKitLoadState: .ready)

    if let room = store.rooms.first {
        RoomDetailView(room: room,
                       services: store.services)
    }
}

#Preview("Unreachable") {
    let room = PreviewFixtures.livingRoom()
    let accessory = PreviewFixtures.floorLampAccessory(roomID: room.id)
    let service = PreviewFixtures.unreachableLightService(roomID: room.id,
                                                          accessory: accessory)
    RoomDetailView(room: room,
                   services: [service])
}

#Preview("Empty") {
    let room = PreviewFixtures.livingRoom()
    RoomDetailView(room: room,
                   services: [])
}

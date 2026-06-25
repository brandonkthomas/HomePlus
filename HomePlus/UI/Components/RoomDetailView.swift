//
//  RoomDetailView.swift
//  HomePlus
//
//  Created by Brandon Thomas on 6/24/26.
//

import SwiftUI

struct RoomDetailView: View {

    let room: RoomModel
    let services: [ServiceModel]

    var body: some View {
        if services.isEmpty {
            ContentUnavailableView {
                Label("No Accessories", systemImage: "lightbulb.slash.fill")
            } description: {
                Text("Accessories added to this room will appear here.")
            }
            .navigationTitle(room.name)
        } else {
            List {
                Section {
                    ForEach(services) { service in
                        ServiceRowView(service: service)
                    }
                }
            }
            .navigationTitle(room.name)
        }
    }
}

// MARK: Xcode Canvas Previews

#Preview("Populated") {
    let room = PreviewFixtures.livingRoom()
    let accessory = PreviewFixtures.floorLampAccessory(roomID: room.id)
    let service = PreviewFixtures.floorLampService(roomID: room.id,
                                                   accessory: accessory)
    
    RoomDetailView(room: room,
                   services: [service])
}

#Preview("Empty") {
    let room = PreviewFixtures.livingRoom()

    RoomDetailView(room: room,
                   services: [])
}

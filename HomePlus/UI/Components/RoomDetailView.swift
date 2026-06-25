//
//  RoomDetailView.swift
//  HomePlus
//
//  Created by Brandon Thomas on 6/24/26.
//

import SwiftUI

struct RoomDetailView: View {

    let room: RoomModel

    var body: some View {
        ContentUnavailableView {
            Label("No Accessories", systemImage: "lightbulb.slash.fill")
        } description: {
            Text("Accessories added to this room will appear here.")
        }
        .navigationTitle(room.name)
    }
}

// MARK: Xcode Canvas Previews

#Preview("Ready") {
    let room = RoomModel(id: UUID(), name: "Living Room")

    RoomDetailView(room: room)
}

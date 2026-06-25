//
//  PreviewFixtures.swift
//  HomePlus
//
//  Created by Brandon Thomas on 6/24/26.
//

import Foundation

enum PreviewFixtures {

    /// Create a dummy HomeStore for use in Xcode Canvas Previews
    static func makeStore(homeKitLoadState: HomeKitLoadState,
                          addHomes: Bool = true,
                          addRooms: Bool = true) -> HomeStore {
        let store = HomeStore()

        if addHomes {
            let home1 = HomeModel(id: UUID(), name: "My Home")
            let home2 = HomeModel(id: UUID(), name: "Vacation Home")
            store.homes = [home1, home2]
        }

        if addHomes && addRooms {
            let room1 = RoomModel(id: UUID(), name: "Living Room")
            let room2 = RoomModel(id: UUID(), name: "Kitchen")
            let room3 = RoomModel(id: UUID(), name: "Bedroom")
            store.rooms = [room1, room2, room3]
        }

        store.selectedHome = store.homes.first
        store.homeKitLoadState = homeKitLoadState

        return store
    }
}

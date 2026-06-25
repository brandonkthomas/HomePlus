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
                          addHomes: Bool = true) -> HomeStore {
        let store = HomeStore()

        if addHomes {
            let home1 = HomeModel(id: UUID(), name: "My Home")
            let home2 = HomeModel(id: UUID(), name: "Vacation Home")
            store.homes = [home1, home2]
        }

        store.selectedHome = store.homes.first
        store.homeKitLoadState = homeKitLoadState

        return store
    }
}

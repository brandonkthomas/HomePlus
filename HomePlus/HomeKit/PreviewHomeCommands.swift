//
//  PreviewHomeCommands.swift
//  HomePlus
//
//  Created by Brandon Thomas on 6/23/26.
//

/// HomeCommands implementation used only for Xcode Canvas preview
final class PreviewHomeCommands: HomeCommands {

    // MARK: Properties (Private)

    private let store: HomeStore

    // MARK: Init

    init(store: HomeStore) {
        self.store = store
    }

    // MARK: Functions

    /// Preview selection currently changes only selectedHome.
    /// Production selection refreshes child collections through HomeKitRepository.
    func selectHome(_ home: HomeModel) {
        store.selectHome(home)
    }
}

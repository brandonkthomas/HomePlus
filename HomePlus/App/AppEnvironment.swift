//
//  AppEnvironment.swift
//  HomePlus
//
//  Created by Brandon Thomas on 6/13/26.
//

import Observation

/// App-wide owner of our single HomeKitRepository
@Observable
final class AppEnvironment {

    // MARK: Properties (Private)

    private let repository: HomeKitRepository

    // MARK: Properties

    let store: HomeStore

    /// Expose 1 dependency as its protocol type, dont forward every method;
    /// keep concrete HomeKitRepository private;
    /// views get HomeCommands rather than raw repository internals
    var commands: any HomeCommands {
        repository
    }

    // MARK: Init

    init(store: HomeStore = HomeStore()) {
        self.store = store
        self.repository = .init(store: self.store)
    }
}

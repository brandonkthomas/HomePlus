//
//  AppEnvironment.swift
//  HomePlus
//
//  Created by Brandon Thomas on 6/13/26.
//

/// App-wide owner of our single HomeKitRepository
final class AppEnvironment {

    // MARK: Properties

    let store: HomeStore
    let repository: HomeKitRepository

    // MARK: Init

    init() {
        self.store = .init()
        self.repository = .init(store: self.store)
    }
}

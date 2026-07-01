//
//  HomeCommands.swift
//  HomePlus
//
//  Created by Brandon Thomas on 6/23/26.
//

import SwiftUI

// Swift protocols are similar to C# interfaces
/// Command contract; shared between HomeKitRepository and preview/test implementations.
/// Contains only the commands that SwiftUI views are allowed to call.
///
/// ContentView calls commands.selectHome(home) without knowing which implementation it has.
///
/// Production HomeCommands = HomeKitRepository
///   Preview HomeCommands = PreviewHomeCommands
///   Both update the same HomeStore instance they were paired with
///   SwiftUI observes HomeStore and redraws
protocol HomeCommands {
    func selectHome(_ home: HomeModel)

    func setPower(_ isOn: Bool,
                  for serviceID: ServiceModel.ID) async throws
}

enum HomeCommandError: Error {
    case missingImplementation
    case serviceNotFound
    case unsupportedOperation
}

/// Fallback used when a view reads HomeCommands without an injected implementation
private struct MissingHomeCommands: HomeCommands {
    func selectHome(_ home: HomeModel) {
        assertionFailure("Missing HomeCommands environment value")
    }

    func setPower(_ isOn: Bool, for serviceID: ServiceModel.ID) async throws {
        assertionFailure("Missing HomeCommands environment value")
        throw HomeCommandError.missingImplementation
    }
}

/// HomeCommands Key (Environment Key)
private struct HomeCommandsKey: EnvironmentKey {
    /// If no real commands object was injected, use this development-error object
    static let defaultValue: any HomeCommands = MissingHomeCommands()
}

/// Environment Values
extension EnvironmentValues {
    var homeCommands: any HomeCommands {
        get { self[HomeCommandsKey.self] }
        set { self[HomeCommandsKey.self] = newValue }
    }
}

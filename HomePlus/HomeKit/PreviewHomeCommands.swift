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

    ///
    func setPower(_ isOn: Bool,
                  for serviceID: ServiceModel.ID) async throws {
        let serviceIndex = store.services.firstIndex(where: { service in
            service.id == serviceID
        })

        guard let index = serviceIndex else {
            throw HomeCommandError.serviceNotFound
        }

        guard store.services[index].capabilities.supportsPower else {
            throw HomeCommandError.unsupportedOperation
        }

        // Prod will NEVER modify HomeStore!
        // Preview is our exception.
        store.services[index].values.isOn = isOn
    }
}

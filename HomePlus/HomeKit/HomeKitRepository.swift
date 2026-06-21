//
//  HomeKitRepository.swift
//  HomePlus
//
//  Created by Brandon Thomas on 6/13/26.
//

import Foundation
import HomeKit

/// Repository for live HK objects (isolates from app-facing models).
///
/// Commands/infrastructure: HomeKitRepository;
/// queries/state: HomeStore.
///
/// DI w/ HomeStore:
///  create HomeStore =>
///  give to HomeKitRepository =>
///  HomeKitRepository updates & SwiftUI observes that HomeStore.
///
/// For user actions:
///   - SwiftUI user action
///   - HomeKitRepository command
///   - HMHome / HMCharacteristic operation
///   - HomeKit callback or write completion
///   - HomeStore update
///   - SwiftUI redraw
///
/// For home selection:
///   - View reads store.homes
///   - View calls repository.selectHome(home)
///   - Repository calls store.selectHome(home)
///   - Repository refreshes selected HMHome data
///   - Store changes
///   - View redraws
///
/// NSObject is inherited to provide Objective-C interop for HK delegates (HMHomeManagerDelegate, HMHomeDelegate).
final class HomeKitRepository: NSObject, HMHomeManagerDelegate, HMHomeDelegate {

    // MARK: Properties
    
    // External callers can interact w/ homeManager + store *only indirectly* through repo's
    // public functions.
    private let homeManager: HMHomeManager
    private let store: HomeStore
    
    // MARK: Properties (Calculated)

    /// Retrieve HomeStore's selected Home mapped to HomeKit.HMHome (calculated)
    private var selectedHMHome: HMHome? {
        if let id = store.selectedHome?.id,
           let home = homeManager.homes.first(where: { $0.uniqueIdentifier == id }) {
            return home
        }
        return nil
    }
    
    // MARK: Init
    
    /// Configures the repository for use.
    init(store: HomeStore,
         homeManager: HMHomeManager = HMHomeManager()) {
        self.store = store
        self.homeManager = homeManager
        
        super.init() // initialize NSObject; now we can use "self"
        
        homeManager.delegate = self // assign this repo as manager's delegate
    }
    
    // MARK: Functions
    
    /// Selects a new Home & re-retrieves available Rooms.
    ///
    /// HomeStore (internal mapping class) is the underlying updated class here.
    func selectHome(_ home: HomeModel) {
        store.selectHome(home)

        // Apply selected Home's children to local HomeStore
        if let selectedHome = self.selectedHMHome { // this should always be true
            refreshSelectedHomeData(for: selectedHome)
        } else {
            clearSelectedHomeData()
        }
    }

    // MARK: Delegate Callbacks (HMHomeManager)

    /// Fired when the manager has loaded / changed its list of Homes.
    /// "manager" parameter is the exact manager who triggered this callback.
    ///
    /// Required by HMHomeManagerDelegate
    func homeManagerDidUpdateHomes(_ manager: HMHomeManager) {
        // Publish updated Homes to our HomeStore instance
        refreshAllHomes(from: manager)

        // Apply delegates to all Homes to keep all changes synced at all times
        for home in manager.homes {
            home.delegate = self
        }

        // Apply selected Home's children to local HomeStore
        if let selectedHome = self.selectedHMHome { // this should always be true
            refreshSelectedHomeData(for: selectedHome)
        } else {
            clearSelectedHomeData()
        }

        // we're done loading; set state = ready if we're authorized
        if manager.authorizationStatus.contains(.restricted) {
            store.homeKitLoadState = .unauthorized
        } else {
            store.homeKitLoadState = .ready
        }
    }

    /// Inherited from HMHomeManagerDelegate.homeManager(_:didUpdate:).
    func homeManager(_ manager: HMHomeManager,
                     didUpdate status: HMHomeManagerAuthorizationStatus) {
        if status.contains(.restricted) {
            store.homeKitLoadState = .unauthorized
        }

        // using "} else { ... = .loading" above may suppress already-ready stores
        // if callbacks arrive out of order...
    }

    // MARK: Delegate Callbacks (HMHome)

    /// Handle Home rename actions (update local store)
    func homeDidUpdateName(_ home: HMHome) {
        refreshAllHomes(from: homeManager)
    }

    /// Handle Room rename for selected Home (refresh local store data)
    func home(_ home: HMHome,
              didUpdateNameFor room: HMRoom) {
        guard home.uniqueIdentifier == store.selectedHome?.id else {
            return
        }

        refreshSelectedHomeRooms(for: self.selectedHMHome)
    }

    /// Handle Room addition
    func home(_ home: HMHome,
              didAdd room: HMRoom) {
        guard home.uniqueIdentifier == store.selectedHome?.id else {
            return
        }

        refreshSelectedHomeData(for: home)
    }

    /// Handle Room removal
    func home(_ home: HMHome,
              didRemove room: HMRoom) {
        guard home.uniqueIdentifier == store.selectedHome?.id else {
            return
        }

        refreshSelectedHomeData(for: home)
    }

    // MARK: Delegate Callbacks (HMAccessory)

    /// Handle Accessory addition
    func home(_ home: HMHome, didAdd accessory: HMAccessory) {
        guard home.uniqueIdentifier == store.selectedHome?.id else {
            return
        }

        refreshSelectedHomeData(for: home)
    }

    /// Handle Accessory removal
    func home(_ home: HMHome, didRemove accessory: HMAccessory) {
        guard home.uniqueIdentifier == store.selectedHome?.id else {
            return
        }

        refreshSelectedHomeData(for: home)
    }

    // MARK: Private Helpers

    /// Maps manager.homes => HomeModel; calls store.replaceHomes()
    ///
    /// Requires HMHomeManager parameter to allow delegate callers using their generated params
    private func refreshAllHomes(from manager: HMHomeManager) {
        let mappedHomes: [HomeModel] = manager.homes.map { home in
            HomeKitMapper.homeModel(from: home)
        }

        store.replaceHomes(with: mappedHomes)
    }

    private func clearSelectedHomeData() {
        store.rooms = []
        store.accessories = []
        store.services = []
        store.scenes = []
        store.cameras = []
    }

    /// Retrieve a HomeKit.HMHome's child .rooms/.accessories/.services/.scenes/.cameras,
    /// map them to HomePlus \*Models,
    /// & apply to HomeKitRepository's local HomeStore properties
    /// (rooms, accessories, services, scenes, cameras)
    private func refreshSelectedHomeData(for selectedHome: HMHome) {
        refreshSelectedHomeRooms(for: selectedHome)
        refreshSelectedHomeAccessories(for: selectedHome)
        refreshSelectedHomeServices(for: selectedHome)
        refreshSelectedHomeScenes(for: selectedHome)
        refreshSelectedHomeCameras(for: selectedHome)
    }

    /// Retrieve + map Rooms; apply to local HomeStore
    private func refreshSelectedHomeRooms(for selectedHome: HMHome? = nil) {
        if let home = selectedHome {
            let mappedRooms: [RoomModel] = home.rooms.map { room in
                HomeKitMapper.roomModel(from: room)
            }

            store.rooms = mappedRooms
        } else {
            store.rooms = []
        }
    }

    /// Retrieve + map Accessories; apply to local HomeStore
    private func refreshSelectedHomeAccessories(for selectedHome: HMHome? = nil) {
        if let home = selectedHome {
            let mappedAccessories: [AccessoryModel] = home.accessories.map { accessory in
                HomeKitMapper.accessoryModel(from: accessory)
            }

            store.accessories = mappedAccessories
        } else {
            store.accessories = []
        }
    }

    /// Retrieve + map Services; apply to local HomeStore
    private func refreshSelectedHomeServices(for selectedHome: HMHome? = nil) {
        if let home = selectedHome {
            var services: [ServiceModel] = []

            for accessory in home.accessories {
                for service in accessory.services {
                    let mappedService: ServiceModel = HomeKitMapper.serviceModel(from: service,
                                                                                 accessory: accessory)

                    if case .unsupported = mappedService.kind { // if case in Swift is backwards :(
                        continue
                    }

                    services.append(mappedService)
                }
            }

            store.services = services
        } else {
            store.services = []
        }
    }

    /// Retrieve + map Scenes; apply to local HomeStore
    private func refreshSelectedHomeScenes(for selectedHome: HMHome? = nil) {
        if let home = selectedHome {
            let filteredActionSets = home.actionSets.filter { actionSet in
                actionSet.actionSetType != HMActionSetTypeTriggerOwned
                    && !actionSet.actions.isEmpty
            }

            let mappedScenes: [SceneModel] = filteredActionSets.map { actionSet in
                HomeKitMapper.sceneModel(from: actionSet)
            }

            store.scenes = mappedScenes
        } else {
            store.scenes = []
        }
    }

    /// Retrieve + map Cameras; apply to local HomeStore
    private func refreshSelectedHomeCameras(for selectedHome: HMHome? = nil) {
        if let home = selectedHome {
            var cameras: [CameraModel] = []

            for accessory in home.accessories {
                for cameraProfile in accessory.cameraProfiles ?? [] {
                    cameras.append(HomeKitMapper.cameraModel(from: cameraProfile,
                                                             accessory: accessory))
                }
            }

            store.cameras = cameras
        } else {
            store.cameras = []
        }
    }
}

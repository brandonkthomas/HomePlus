//
//  HomeKitRepository.swift
//  HomePlus
//
//  Created by Brandon Thomas on 6/13/26.
//

import Foundation
import HomeKit
import OSLog

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
/// NSObject is inherited to provide Objective-C interop for HK delegates (HMHomeManagerDelegate, HMHomeDelegate,
/// HMAccessoryDelegate).
final class HomeKitRepository:
    NSObject, HMHomeManagerDelegate, HMHomeDelegate, HMAccessoryDelegate,
    HomeCommands
{
    // MARK: Properties
    
    // External callers can interact w/ homeManager + store *only indirectly* through repo's
    // public functions.
    private let homeManager: HMHomeManager
    private let store: HomeStore

    /// Shared logger
    private static let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? "Hearth",
        category: "HomeKitRepository"
    )

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
    
    /// Selects a new Home & re-retrieves available Rooms, Accessories, Services,
    /// Scenes, & Cameras.
    ///
    /// HomeStore (internal mapping class) is the underlying updated class here.
    func selectHome(_ home: HomeModel) {
        store.selectHome(home)

        // Apply selected Home's children to local HomeStore
        if let selectedHome = self.selectedHMHome { // user has no homes / last home removed / auth changed
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

        // Establish subscription to all Homes' delegates
        //  (to keep all changes synced at all times)
        for home in manager.homes {
            home.delegate = self

            // Establish subscription to + notifications for this accessory's delegate
            for accessory in home.accessories {
                accessory.delegate = self
                enableNotifications(for: accessory)
            }
        }

        // Apply selected Home's children to local HomeStore
        if let selectedHome = self.selectedHMHome {
            refreshSelectedHomeData(for: selectedHome)
        } else {
            clearSelectedHomeData() // user has no homes / last home removed / auth changed
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

        refreshSelectedHomeRooms(for: home)
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
    func home(_ home: HMHome,
              didAdd accessory: HMAccessory) {
        // Assign before anything else so that additions to unselected homes are still tracked
        accessory.delegate = self
        enableNotifications(for: accessory)

        guard home.uniqueIdentifier == store.selectedHome?.id else {
            return
        }

        refreshSelectedHomeData(for: home)
    }

    /// Handle Accessory removal
    func home(_ home: HMHome,
              didRemove accessory: HMAccessory) {
        guard home.uniqueIdentifier == store.selectedHome?.id else {
            return
        }

        refreshSelectedHomeData(for: home)
    }

    /// An Accessory's reachability state was updated
    func accessoryDidUpdateReachability(_ accessory: HMAccessory) {
        guard let accessoryHome = accessory.home,
              accessoryHome.uniqueIdentifier == store.selectedHome?.id else {
            return
        }

        refreshSelectedHomeAccessories(for: accessoryHome)
        refreshSelectedHomeServices(for: accessoryHome)
    }

    /// An Accessory's name was updated
    func accessoryDidUpdateName(_ accessory: HMAccessory) {
        guard let accessoryHome = accessory.home,
              accessoryHome.uniqueIdentifier == store.selectedHome?.id else {
            return
        }

        refreshSelectedHomeAccessories(for: accessoryHome)
        refreshSelectedHomeServices(for: accessoryHome)
        refreshSelectedHomeCameras(for: accessoryHome)
    }

    /// An Accessory Service's name was updated
    func accessory(_ accessory: HMAccessory,
                   didUpdateNameFor service: HMService) {
        guard let accessoryHome = accessory.home,
              accessoryHome.uniqueIdentifier == store.selectedHome?.id else {
            return
        }

        refreshSelectedHomeServices(for: accessoryHome)
    }

    /// An Accessory's Service collection was updated
    func accessoryDidUpdateServices(_ accessory: HMAccessory) {
        guard let accessoryHome = accessory.home,
              accessoryHome.uniqueIdentifier == store.selectedHome?.id else {
            return
        }

        refreshSelectedHomeServices(for: accessoryHome)
        refreshSelectedHomeCameras(for: accessoryHome) // hasMotionSensor derives from camera profile services

        enableNotifications(for: accessory)
    }

    /// A generic Accessory Profile was added to an Accessory
    /// (could / could not be a Camera Profile)
    func accessory(_ accessory: HMAccessory,
                   didAdd profile: HMAccessoryProfile) {
        guard let accessoryHome = accessory.home,
              accessoryHome.uniqueIdentifier == store.selectedHome?.id else {
            return
        }

        refreshSelectedHomeCameras(for: accessoryHome)
    }

    /// A generic Accessory Profile was removed from an Accessory
    /// (could / could not be a Camera Profile)
    func accessory(_ accessory: HMAccessory,
                   didRemove profile: HMAccessoryProfile) {
        guard let accessoryHome = accessory.home,
              accessoryHome.uniqueIdentifier == store.selectedHome?.id else {
            return
        }
        
        refreshSelectedHomeCameras(for: accessoryHome)
    }

    /// An Accessory's subscribed/notifying Characteristic was updated
    ///
    /// This only provides a place to receive an update; does not request updates.
    /// Need to also call .enableNotification(true) ... HK model separates handler + subscriber
    func accessory(_ accessory: HMAccessory,
                   service: HMService,
                   didUpdateValueFor characteristic: HMCharacteristic) {
        guard let accessoryHome = accessory.home,
              accessoryHome.uniqueIdentifier == store.selectedHome?.id else {
            return
        }

        refreshSelectedHomeServices(for: accessoryHome)
    }

    // MARK: Delegate Callbacks (HMRoom)

    /// An Accessory was assigned to a different Room
    func home(_ home: HMHome,
              didUpdate room: HMRoom,
              for accessory: HMAccessory) {
        guard home.uniqueIdentifier == store.selectedHome?.id else {
            return
        }

        refreshSelectedHomeData(for: home)
    }

    // MARK: Delegate Callbacks (HMActionSet)

    /// An ActionSet (scene) was added
    func home(_ home: HMHome,
              didAdd actionSet: HMActionSet) {
        guard home.uniqueIdentifier == store.selectedHome?.id else {
            return
        }

        refreshSelectedHomeScenes(for: home)
    }

    /// An ActionSet (scene) was removed
    func home(_ home: HMHome,
              didRemove actionSet: HMActionSet) {
        guard home.uniqueIdentifier == store.selectedHome?.id else {
            return
        }

        refreshSelectedHomeScenes(for: home)
    }

    /// An ActionSet (scene) was renamed
    func home(_ home: HMHome,
              didUpdateNameFor actionSet: HMActionSet) {
        guard home.uniqueIdentifier == store.selectedHome?.id else {
            return
        }

        refreshSelectedHomeScenes(for: home)
    }

    /// An ActionSet (scene) had its Actions modified
    func home(_ home: HMHome,
              didUpdateActionsFor actionSet: HMActionSet) {
        guard home.uniqueIdentifier == store.selectedHome?.id else {
            return
        }

        refreshSelectedHomeScenes(for: home)
    }

    // MARK: Private Helpers (Refresh)

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

                    // if case in Swift is backwards :(  this essentially means:
                    //   If mappedService.kind matches .unsupported enum case,
                    //   regardless of its associated string, then continue
                    // We ignore the .unsupported(String) in this instance.
                    if case .unsupported = mappedService.kind {
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
    ///
    /// Only retrieve ActionSets which are *not* trigger-owned and *not* empty
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

    // MARK: Private Helpers (Notifications)

    /// Loop thru Accessory's Service's Characteristics
    /// & subscribe to notifications for those supported
    private func enableNotifications(for accessory: HMAccessory) {

        for service in accessory.services {
            for characteristic in service.characteristics {

                // Do we even need to subscribe to this (does ServiceValues support it)?
                if HomeKitTypes.Characteristic.observedTypes.contains(characteristic.characteristicType) {
                    characteristic.enableNotification(true) { error in
                        if let error {
                            // lower "self" refers to this instance
                            // capital "Self" refers to this instance's Type
                            Self.logger.error(
                                "Failed to enable notifications for \(characteristic.characteristicType, privacy: .public): \(error.localizedDescription, privacy: .public)"
                            )
                        }
                    }
                }

            } // close: for char
        } // close: for service

    }
}

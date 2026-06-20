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
/// NSObject is inherited to provide Objective-C interop for HK delegates (HMHomeManagerDelegate).
final class HomeKitRepository: NSObject, HMHomeManagerDelegate {
    
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
        refreshSelectedHomeData()
    }
    
    // MARK: Delegate Callbacks
    
    /// Fired when the manager has loaded / changed its list of Homes.
    /// "manager" parameter is the exact manager who triggered this callback.
    ///
    /// Required by HMHomeManagerDelegate
    func homeManagerDidUpdateHomes(_ manager: HMHomeManager) {
        // Publish updated Homes to our HomeStore instance
        let mappedHomes: [HomeModel] = manager.homes.map { home in
            HomeKitMapper.homeModel(from: home)
        }
        
        store.replaceHomes(with: mappedHomes)
        
        // Apply selected Home's children to local HomeStore
        refreshSelectedHomeData()
    }
    
    // MARK: Private Helpers
    
    /// Retrieve a HomeKit.HMHome's child .rooms/.accessories/.services/.scenes/.cameras,
    /// map them to HomePlus \*Models,
    /// & apply to HomeKitRepository's local HomeStore properties
    /// (rooms, accessories, services, scenes, cameras)
    private func refreshSelectedHomeData() {
        if let home = self.selectedHMHome {
            // Rooms
            let mappedRooms: [RoomModel] = home.rooms.map { room in
                HomeKitMapper.roomModel(from: room)
            }

            store.rooms = mappedRooms
            
            // Accessories
            let mappedAccessories: [AccessoryModel] = home.accessories.map { accessory in
                HomeKitMapper.accessoryModel(from: accessory)
            }

            store.accessories = mappedAccessories

            // Services
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

            // Scenes
            let filteredActionSets = home.actionSets.filter { actionSet in
                actionSet.actionSetType != HMActionSetTypeTriggerOwned
                    && !actionSet.actions.isEmpty
            }

            let mappedScenes: [SceneModel] = filteredActionSets.map { actionSet in
                HomeKitMapper.sceneModel(from: actionSet)
            }

            store.scenes = mappedScenes

            // Cameras
            var cameras: [CameraModel] = []

            for accessory in home.accessories {
                for cameraProfile in accessory.cameraProfiles ?? [] {
                    cameras.append(HomeKitMapper.cameraModel(from: cameraProfile, accessory: accessory))
                }
            }

            store.cameras = cameras

        } else {
            store.rooms = []
            store.accessories = []
            store.services = []
            store.scenes = []
            store.cameras = []
        }
    }
}

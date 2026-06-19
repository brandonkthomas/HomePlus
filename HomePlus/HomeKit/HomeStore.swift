//
//  HomeStore.swift
//  HomePlus
//
//  Created by Brandon Thomas on 6/13/26.
//

import Foundation
import Observation

//
// - "final" prevents subclasses (i.e. C# "sealed"); should use this always by default
// - @Observable (modern) is a macro... compiler generates SwiftUI prop tracking automatically;
//   "... class ClassName: ObservableObject" is prev approach + requires "@Published" props
//
/// Observable instance holding current app state.
///
/// Intended app flow:
/// HMAccessory / HMService / HMCharacteristic =>
/// HomeKitRepository =>
/// Model =>
/// HomeStore =>
/// SwiftUI views
@Observable
final class HomeStore {
    
    // MARK: Properties
    
    /// Collection of all Homes available to us
    var homes: [HomeModel] = []
    
    // Optional in case HomeKit has not loaded homes yet; user denied permissions;
    //  user has no homes; multiple homes exist + no default selected yet; etc
    var selectedHome: HomeModel?
    
    // empty arrays are simpler than optional in our case here
    var rooms: [RoomModel] = []
    var accessories: [AccessoryModel] = []
    var services: [ServiceModel] = []
    var scenes: [SceneModel] = []
    var cameras: [CameraModel] = []
    var automations: [AutomationModel] = []
        
    // MARK: Methods (Collections)
    
    /// Returns all available Services for a specific Room
    func services(in room: RoomModel) -> [ServiceModel] {
        // Swift allows implicit return for single-expression functions
        //  (i.e. C# "Func() => val;")
        self.services.filter { service in
            service.roomID == room.id
        }
    }
    
    // MARK: Methods (Management)
    
    /// Selects the active home for the current app state (if it exists in the HomeStore)
    func selectHome(_ home: HomeModel) {
        let requestedHome = findHome(by: home.id)
        
        if requestedHome != nil {
            self.selectedHome = requestedHome
        }
    }
    
    /// Replaces Homes array w/ new copy.
    /// Retains currently selected Home if it exists; otherwise selects first in array.
    func replaceHomes(with newHomes: [HomeModel]) {
        let selectedId = self.selectedHome?.id
        
        self.homes = newHomes
        
        let newSelectedHome: HomeModel? = findHome(by: selectedId)
        
        if newSelectedHome != nil {
            self.selectedHome = newSelectedHome
        } else {
            self.selectedHome = self.homes.first
        }
    }
    
    /// Toggles power for a given Service
    func togglePower(for serviceID: ServiceModel.ID) {
        guard let index = self.services.firstIndex(where: { service in
            service.id == serviceID
        }) else {
            return // service not found; nothing to do
        }
        
        let supportsPower: Bool = services[index].capabilities.supportsPower
        
        guard supportsPower else { // service doesn't support power toggle; nothing to do
            return
        }
        
        let currentState = services[index].values.isOn ?? false // treat nil == false
        
        services[index].values.isOn = !currentState // flip current state
    }
    
    // MARK: Private Helpers
    
    private func findHome(by ID: HomeModel.ID?) -> HomeModel? {
        guard let id = ID else {
            return nil
        }
        
        return self.homes.first(where: { $0.id == id })
    }
}

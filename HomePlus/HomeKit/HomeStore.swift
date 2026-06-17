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
/// Observable instance holding current app state
@Observable
final class HomeStore {
    
    // MARK: Properties
    
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
        
    // MARK: Methods
    
    /// Returns all available Services for a specific Room
    func services(in room: RoomModel) -> [ServiceModel] {
        // Swift allows implicit return for single-expression functions
        //  (i.e. C# "Func() => val;")
        services.filter { service in
            service.roomID == room.id
        }
    }
    
    /// Selects the active home for the current app state
    func selectHome(_ home: HomeModel) {
        selectedHome = home
    }
}

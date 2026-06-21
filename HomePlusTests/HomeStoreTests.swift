//
//  HomePlusTests.swift
//  HomePlusTests
//
//  Created by Brandon Thomas on 6/13/26.
//
// https://developer.apple.com/documentation/testing
//

import Foundation
import Testing
@testable import HomePlus

struct HomeStoreTests {

    // MARK: selectHome() / replaceHomes()

    /// Ensure HomeStore's selectHome() functions as expected
    @Test func selectHomeUpdatesSelectedHome() {
        let store: HomeStore = .init()
        let home: HomeModel = .init(id: UUID(), name: "Test Home")
        
        store.homes.append(home)
        store.selectHome(home)
        
        #expect(store.selectedHome == home)
    }
    
    /// Ensure a selected home retains its updated metadata when replaceHomes() is
    /// called w/ differing values (other than ID)
    @Test func replaceHomesRefreshesSelectedHomeMetadata() {
        let store: HomeStore = .init()
        var home: HomeModel = .init(id: UUID(), name: "Alpha")
        
        store.homes.append(home)
        store.selectHome(home)
        
        #expect(store.selectedHome == home)
        #expect(store.selectedHome?.name == "Alpha")
        
        home.name = "Beta"
        store.replaceHomes(with: [home])
        
        #expect(store.selectedHome == home)
        #expect(store.selectedHome?.name == "Beta")
    }
    
    /// Ensure HomeStore selects first-provided Home by default
    @Test func initialHomesSelectFirst() {
        let store: HomeStore = .init()
        let homeA: HomeModel = .init(id: UUID(), name: "Alpha")
        let homeB: HomeModel = .init(id: UUID(), name: "Beta")

        store.replaceHomes(with: [homeA, homeB])
        
        #expect(store.homes == [homeA, homeB])
        #expect(store.selectedHome == homeA)
    }
    
    /// Ensure HomeStore falls back to another Home when current selection is removed
    @Test func removedSelectionFallsBack() {
        let store: HomeStore = .init()
        let homeA: HomeModel = .init(id: UUID(), name: "Alpha")
        let homeB: HomeModel = .init(id: UUID(), name: "Beta")

        store.replaceHomes(with: [homeA, homeB])
        store.selectHome(homeB)
        
        #expect(store.selectedHome == homeB)

        store.replaceHomes(with: [homeA])
        
        #expect(store.selectedHome == homeA)
    }
    
    /// Ensure HomeStore has no selectedHome when replaceHomes is called with []
    @Test func emptyReplacementClearsSelection() {
        let store: HomeStore = .init()
        let homeA: HomeModel = .init(id: UUID(), name: "Alpha")
        let homeB: HomeModel = .init(id: UUID(), name: "Beta")

        store.replaceHomes(with: [homeA, homeB])
        store.selectHome(homeB)
        
        #expect(store.selectedHome == homeB)

        store.replaceHomes(with: [])
        
        #expect(store.homes.isEmpty)
        #expect(store.selectedHome == nil)
    }
    
    /// Ensure stale caller objects' metadata does not bleed through the selectHome() func;
    /// only ID should be checked and other existing metadata should not be overridden
    @Test func selectHomeStaleCallerCannotOverrideStore() {
        let store: HomeStore = .init()
        let id: UUID = UUID()
        let currentHome: HomeModel = .init(id: id, name: "Current")
        
        store.homes.append(currentHome)
        store.selectHome(currentHome)
        
        #expect(store.selectedHome == currentHome)
        #expect(store.selectedHome?.name == "Current")
        
        let staleHome: HomeModel = .init(id: id, name: "Stale")
        store.selectHome(staleHome)
        
        #expect(store.selectedHome?.name == "Current")
    }

    // MARK: Services

    /// Ensure HomeStore's services() filters by room properly
    @Test func servicesReturnsExpectedResults() {
        let store: HomeStore = .init()

        let room: RoomModel = .init(id: UUID(), name: "Living Room")

        let matchingService: ServiceModel = .init(id: UUID(),
                                                  accessoryID: UUID(),
                                                  roomID: room.id,
                                                  name: "Power",
                                                  accessoryName: "Garage Fan",
                                                  kind: ServiceKind.fan,
                                                  isReachable: true,
                                                  capabilities: .init(supportsPower: true),
                                                  values: .init())
        let otherRoomService: ServiceModel = .init(id: UUID(),
                                                   accessoryID: UUID(),
                                                   roomID: UUID(),
                                                   name: "Power",
                                                   accessoryName: "Garage Fan",
                                                   kind: ServiceKind.fan,
                                                   isReachable: true,
                                                   capabilities: .init(supportsPower: true),
                                                   values: .init())

        store.services.append(matchingService)
        store.services.append(otherRoomService)

        let results = store.services(in: room)

        #expect(results.count == 1)
        #expect(results.first?.id == matchingService.id)
    }

    /// A power-capable service currently off becomes on
    @Test func togglePowerUpdatesServiceState() {
        let store: HomeStore = .init()
        let lightService: ServiceModel = .init(id: UUID(),
                                               accessoryID: UUID(),
                                               roomID: UUID(),
                                               name: "Light",
                                               accessoryName: "Desk Lamp",
                                               kind: ServiceKind.light,
                                               isReachable: true,
                                               capabilities: .init(supportsPower: true),
                                               values: .init())
        
        store.services.append(lightService)
        
        let initialState: Bool? = lightService.values.isOn
        #expect(initialState == nil)
        
        store.togglePower(for: lightService.id)
        
        #expect(store.services.first?.values.isOn == true)
    }
    
    /// A service without power capability remains unchanged
    @Test func togglePowerForUnsupportedServiceRemainsUnchanged() {
        let store: HomeStore = .init()
        let lightService: ServiceModel = .init(id: UUID(),
                                               accessoryID: UUID(),
                                               roomID: UUID(),
                                               name: "Light",
                                               accessoryName: "Desk Lamp",
                                               kind: ServiceKind.light,
                                               isReachable: true,
                                               capabilities: .init(supportsPower: false),
                                               values: .init())
        
        store.services.append(lightService)
        
        let initialState: Bool? = lightService.values.isOn
        #expect(initialState == nil)
        
        store.togglePower(for: lightService.id)
        
        #expect(store.services.first?.values.isOn == nil)
    }
    
    /// An unknown service ID does not change the array or crash.
    @Test func togglePowerForUnknownServiceIdDoesNotThrow() {
        let store: HomeStore = .init()
        
        store.togglePower(for: UUID())
        
        #expect(true) // we didn't die
    }

    // MARK: Load State

    /// When creating HomeStore, homeKitLoadState should be .loading
    @Test func initialStateIsLoading() {
        let store: HomeStore = .init()
        #expect(store.homeKitLoadState == .loading)
    }
}

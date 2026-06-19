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

struct HomePlusTests {

    // MARK: ServiceCapabilities
    
    /// Passes if ServiceCapabilities automatically uses/applies its default values
    @Test func serviceCapabilitiesUseDefaults() throws {
        let capabilities = ServiceCapabilities(supportsPower: true)
        
        #expect(capabilities.supportsPower)
        #expect(!capabilities.supportsBrightness)
    }
    
    // MARK: ServiceModel
    
    /// Proves a single service can carry identity, capabilities, and current values
    @Test func serviceModelCanRepresentDimmableLight()  {
        let serviceID = UUID()
        let accessoryID = UUID()
        let roomID = UUID()
        
        let service = ServiceModel(
            id: serviceID,
            accessoryID: accessoryID,
            roomID: roomID,
            name: "Desk Lamp",
            accessoryName: "Light",
            kind: .light,
            isReachable: true,
            capabilities: ServiceCapabilities(supportsPower: true, supportsBrightness: true),
            values: ServiceValues(isOn: true, brightness: 75)
        )
        
        #expect(service.kind == .light)
        #expect(service.capabilities.supportsBrightness)
        #expect(service.values.brightness == 75)
    }
    
    // MARK: ServiceKind
    
    /// Validates that HomeKitMapper.serviceKind() returns expected results
    @Test func serviceKindPasses() {
        let unsupportedType: String = "dog"
        
        let mapResult1: ServiceKind = HomeKitMapper.serviceKind(for: HomeKitTypes.Service.lightbulb)
        let mapResult2: ServiceKind = HomeKitMapper.serviceKind(for: HomeKitTypes.Service.heaterCooler)
        let mapResult3: ServiceKind = HomeKitMapper.serviceKind(for: HomeKitTypes.Service.door)
        let mapResult4: ServiceKind = HomeKitMapper.serviceKind(for: unsupportedType)
        
        #expect(mapResult1 == .light)
        #expect(mapResult2 == .thermostat)
        #expect(mapResult3 == .door)
        #expect(mapResult4 == .unsupported(unsupportedType))
    }

    // MARK: CharacteristicValue
    
    /// Validates that CharacteristicValue Double parsing returns expected results
    @Test func characteristicValueDoubleParserPasses() {
        let parseResult1: Double? = CharacteristicValue.double(12)
        let parseResult2: Double? = CharacteristicValue.double(true)
        let parseResult3: Double? = CharacteristicValue.double("bad")
        
        #expect(parseResult1 == 12.0)
        #expect(parseResult2 == 1)
        #expect(parseResult3 == nil)
    }
    
    /// Validates that CharacteristicValue Int parsing returns expected results
    @Test func characteristicValueIntParserPasses() {
        let parseResult1: Int? = CharacteristicValue.int(12.8)
        let parseResult2: Int? = CharacteristicValue.int(false)
        let parseResult3: Int? = CharacteristicValue.int(nil)
        
        #expect(parseResult1 == 12)
        #expect(parseResult2 == 0)
        #expect(parseResult3 == nil)
    }
    
    /// Validates that CharacteristicValue Bool parsing returns expected results
    @Test func characteristicValueBoolParserPasses() {
        let parseResult1: Bool? = CharacteristicValue.bool(true)
        let parseResult2: Bool? = CharacteristicValue.bool(0)
        let parseResult3: Bool? = CharacteristicValue.bool(2)
        let parseResult4: Bool? = CharacteristicValue.bool("bad")
        
        #expect(parseResult1 == true)
        #expect(parseResult2 == false)
        #expect(parseResult3 == true)
        #expect(parseResult4 == nil)
    }
    
    // MARK: HomeStore
    
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
    @Test func selectedHomeRetainsMetadataChanges() {
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
        
        #expect(true) // we didn't break
    }
}

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
    @Test func serviceCapabilitiesUseDefaultValues() throws {
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
    @Test func serviceKindMapsProperly() {
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
    @Test func characteristicValueDoubleParserReturnsExpectedResults() {
        let parseResult1: Double? = CharacteristicValue.double(12)
        let parseResult2: Double? = CharacteristicValue.double(true)
        let parseResult3: Double? = CharacteristicValue.double("bad")
        
        #expect(parseResult1 == 12.0)
        #expect(parseResult2 == 1)
        #expect(parseResult3 == nil)
    }
    
    /// Validates that CharacteristicValue Int parsing returns expected results
    @Test func characteristicValueIntParserReturnsExpectedResults() {
        let parseResult1: Int? = CharacteristicValue.int(12.8)
        let parseResult2: Int? = CharacteristicValue.int(false)
        let parseResult3: Int? = CharacteristicValue.int(nil)
        
        #expect(parseResult1 == 12)
        #expect(parseResult2 == 0)
        #expect(parseResult3 == nil)
    }
    

    /// Validates that CharacteristicValue Bool parsing returns expected results
    @Test func characteristicValueBoolParserReturnsExpectedResults() {
        let parseResult1: Bool? = CharacteristicValue.bool(true)
        let parseResult2: Bool? = CharacteristicValue.bool(0)
        let parseResult3: Bool? = CharacteristicValue.bool(2)
        let parseResult4: Bool? = CharacteristicValue.bool("bad")
        
        #expect(parseResult1 == true)
        #expect(parseResult2 == false)
        #expect(parseResult3 == true)
        #expect(parseResult4 == nil)
    }
}

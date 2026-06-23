//
//  ServiceModelTests.swift
//  ServiceModelTests
//
//  Created by Brandon Thomas on 6/13/26.
//
// https://developer.apple.com/documentation/testing
//

import Foundation
import Testing
@testable import HomePlus

struct ServiceModelTests {
    
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
}

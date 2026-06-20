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

struct ServiceKindTests {
    
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
}

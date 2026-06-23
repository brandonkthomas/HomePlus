//
//  ServiceCapabilitiesTests.swift
//  ServiceCapabilitiesTests
//
//  Created by Brandon Thomas on 6/13/26.
//
// https://developer.apple.com/documentation/testing
//

import Foundation
import Testing
@testable import HomePlus

struct ServiceCapabilitiesTests {
    
    /// Passes if ServiceCapabilities automatically uses/applies its default values
    @Test func serviceCapabilitiesUseDefaults() throws {
        let capabilities = ServiceCapabilities(supportsPower: true)
        
        #expect(capabilities.supportsPower)
        #expect(!capabilities.supportsBrightness)
    }
}

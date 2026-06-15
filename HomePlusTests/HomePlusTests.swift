//
//  HomePlusTests.swift
//  HomePlusTests
//
//  Created by Brandon Thomas on 6/13/26.
//
// https://developer.apple.com/documentation/testing
//

import Testing
@testable import HomePlus

struct HomePlusTests {

    @Test func doesServiceCapabilitiesHydrateDefaults() async throws {
        let capabilities = ServiceCapabilities(supportsPower: true)
        
        #expect(capabilities.supportsPower)
        #expect(!capabilities.supportsBrightness)
    }
}

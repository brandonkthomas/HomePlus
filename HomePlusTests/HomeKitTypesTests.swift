//
//  HomeKitTypesTests.swift
//  HomeKitTypesTests
//
//  Created by Brandon Thomas on 6/13/26.
//
// https://developer.apple.com/documentation/testing
//

import Foundation
import Testing
@testable import HomePlus

struct HomeKitTypesTests {

    // MARK: .Characteristics

    @Test func observedTypesContainsExpectedValues() {
        let observedTypes = HomeKitTypes.Characteristic.observedTypes

        #expect(observedTypes.contains(HomeKitTypes.Characteristic.powerState))
        #expect(observedTypes.contains(HomeKitTypes.Characteristic.active))
        #expect(observedTypes.contains(HomeKitTypes.Characteristic.brightness))
        #expect(observedTypes.contains(HomeKitTypes.Characteristic.currentPosition))
        #expect(observedTypes.contains(HomeKitTypes.Characteristic.currentTemperature))

        #expect(!observedTypes.contains(HomeKitTypes.Characteristic.hue))
    }
}

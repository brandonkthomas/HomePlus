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

struct HomeKitMapperTests {

    /// HomeKitMapper.serviceCapabilities correctly returns power/brightness/color
    @Test func supportsPowerBrightnessColor() {
        let hmCharacteristics: Set<String> = [
            HomeKitTypes.Characteristic.powerState,
            HomeKitTypes.Characteristic.brightness,
            HomeKitTypes.Characteristic.hue,
            HomeKitTypes.Characteristic.saturation
        ]

        let capabilities = HomeKitMapper.serviceCapabilities(from: hmCharacteristics)

        #expect(capabilities.supportsPower)
        #expect(capabilities.supportsBrightness)
        #expect(capabilities.supportsColor)
        #expect(!capabilities.supportsColorTemperature)
        #expect(!capabilities.supportsPosition)
        #expect(!capabilities.supportsTilt)
    }

    /// HomeKitMapper.serviceCapabilities correctly returns position/tilt
    @Test func supportsPositionTilt() {
        let hmCharacteristics: Set<String> = [
            HomeKitTypes.Characteristic.targetPosition,
            HomeKitTypes.Characteristic.targetHorizontalTiltAngle
        ]

        let capabilities = HomeKitMapper.serviceCapabilities(from: hmCharacteristics)

        #expect(!capabilities.supportsPower)
        #expect(!capabilities.supportsBrightness)
        #expect(!capabilities.supportsColor)
        #expect(!capabilities.supportsColorTemperature)
        #expect(capabilities.supportsPosition)
        #expect(capabilities.supportsTilt)
    }

    /// HomeKitMapper.serviceCapabilities correctly returns defaults
    @Test func supportsNone() {
        let hmCharacteristics: Set<String> = []

        let capabilities = HomeKitMapper.serviceCapabilities(from: hmCharacteristics)

        #expect(!capabilities.supportsPower)
        #expect(!capabilities.supportsBrightness)
        #expect(!capabilities.supportsColor)
        #expect(!capabilities.supportsColorTemperature)
        #expect(!capabilities.supportsPosition)
        #expect(!capabilities.supportsTilt)
    }
}

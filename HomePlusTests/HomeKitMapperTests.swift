//
//  HomeKitMapperTests.swift
//  HomeKitMapperTests
//
//  Created by Brandon Thomas on 6/13/26.
//
// https://developer.apple.com/documentation/testing
//

import Foundation
import Testing
@testable import HomePlus

struct HomeKitMapperTests {

    // MARK: ServiceCapabilities

    /// HomeKitMapper.serviceCapabilities correctly returns power/brightness/color
    @Test func capabilitiesSupportsPowerBrightnessColor() {
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
    @Test func capabilitiesSupportsPositionTilt() {
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
    @Test func capabilitiesSupportsNone() {
        let hmCharacteristics: Set<String> = []

        let capabilities = HomeKitMapper.serviceCapabilities(from: hmCharacteristics)

        #expect(!capabilities.supportsPower)
        #expect(!capabilities.supportsBrightness)
        #expect(!capabilities.supportsColor)
        #expect(!capabilities.supportsColorTemperature)
        #expect(!capabilities.supportsPosition)
        #expect(!capabilities.supportsTilt)
    }

    // MARK: ServiceValues

    /// HomeKitMapper.serviceValues correctly returns power/brightness
    @Test func valuesSupportPowerBrightness() {
        let hmCharacteristicValues: [String: Any] = [
            HomeKitTypes.Characteristic.powerState: false,
            HomeKitTypes.Characteristic.active: 1,
            HomeKitTypes.Characteristic.brightness: 75
        ]

        let serviceValues = HomeKitMapper.serviceValues(from: hmCharacteristicValues)

        #expect(serviceValues.isOn == false)
        #expect(serviceValues.brightness == 75.0)
    }

    /// HomeKitMapper.serviceValues correctly returns power only w/ nil brightness
    @Test func valuesSupportPower() {
        let hmCharacteristicValues: [String: Any] = [
            HomeKitTypes.Characteristic.active: true
        ]

        let serviceValues = HomeKitMapper.serviceValues(from: hmCharacteristicValues)

        #expect(serviceValues.isOn == true)
        #expect(serviceValues.brightness == nil)
    }

    /// HomeKitMapper.serviceValues correctly returns position/currentTemperature
    @Test func valuesSupportPositionTemperature() {
        let hmCharacteristicValues: [String: Any] = [
            HomeKitTypes.Characteristic.currentPosition: 45.0,
            HomeKitTypes.Characteristic.currentTemperature: 21.5 // ºC
        ]

        let serviceValues = HomeKitMapper.serviceValues(from: hmCharacteristicValues)

        #expect(serviceValues.position == 45.0)
        #expect(serviceValues.currentTemperature == 21.5)
    }

    /// HomeKitMapper.serviceValues correctly returns hue/saturation/colorTemperature
    @Test func valuesSupportHueSaturationColorTemp() {
        let hmCharacteristicValues: [String: Any] = [
            HomeKitTypes.Characteristic.hue: 45.0,
            HomeKitTypes.Characteristic.saturation: 21.5,
            HomeKitTypes.Characteristic.colorTemperature: 30.0
        ]

        let serviceValues = HomeKitMapper.serviceValues(from: hmCharacteristicValues)

        #expect(serviceValues.hue == 45.0)
        #expect(serviceValues.saturation == 21.5)
        #expect(serviceValues.colorTemperature == 30.0)
        #expect(serviceValues.colorMode == .hueSaturation)
    }

    /// HomeKitMapper.serviceValues correctly returns defaults
    @Test func valuesSupportNone() {
        let hmCharacteristicValues: [String: Any] = [:]

        let serviceValues = HomeKitMapper.serviceValues(from: hmCharacteristicValues)

        #expect(serviceValues.isOn == nil)
        #expect(serviceValues.brightness == nil)
        #expect(serviceValues.hue == nil)
        #expect(serviceValues.saturation == nil)
        #expect(serviceValues.colorTemperature == nil)
        #expect(serviceValues.position == nil)
        #expect(serviceValues.currentTemperature == nil)
        #expect(serviceValues.colorMode == nil)
    }
}

//
//  ServiceModel.swift
//  HomePlus
//
//  Created by Brandon Thomas on 6/13/26.
//

import Foundation

/// What type of HMService is this?
enum ServiceKind: Equatable {
    case light
    case switchLike
    case outlet
    case blind
    case garageDoor
    case lock
    case thermostat
    case sensor
    case unsupported(String)
}

/// What capabilities does this HMService have?
struct ServiceCapabilities: Equatable {
    var supportsPower: Bool = false
    var supportsBrightness: Bool = false
    var supportsColor: Bool = false
    var supportsColorTemperature: Bool = false
    var supportsPosition: Bool = false
    var supportsTilt: Bool = false
}

/// What is this HMService doing right now?
/// i.e. the current known state of a service
struct ServiceValues: Equatable {
    var isOn: Bool? = nil
    var brightness: Double? = nil
    var position: Double? = nil
    var temperature: Double? = nil
    var statusText: String? = nil
}

/// Mapping for HMService (a capability exposed by an HMAccessory)
/// Most user-facing interactable UI elements will be services
struct ServiceModel: Identifiable, Equatable {
    let id: UUID
    let accessoryID: UUID
    var roomID: UUID?
    var name: String
    var accessoryName: String
    var kind: ServiceKind // this will likely never change...? still making var just to future proof
    var isReachable: Bool
    var capabilities: ServiceCapabilities // this could change w/ device updates/etc
    var values: ServiceValues // this will change frequently
}

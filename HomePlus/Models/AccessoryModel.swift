//
//  AccessoryModel.swift
//  HomePlus
//
//  Created by Brandon Thomas on 6/13/26.
//
//  Mapping for HMAccessory
//  This is an actual HomeKit accessory such as a bridge, bulb, garage door opener, thermostat, etc.

import Foundation

struct AccessoryModel: Identifiable, Equatable {
    let id: UUID
    var name: String
    var roomID: UUID? // BT 2026-06-14: may need to be "let"; HMAccessory has "var room: HMRoom?" though
    var isReachable: Bool
}

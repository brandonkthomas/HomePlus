//
//  HomeKitMapper.swift
//  HomePlus
//
//  Created by Brandon Thomas on 6/13/26.
//

enum HomeKitMapper { // pseudo-namespace since we do not need instances here
    
    /// Maps a string to ServiceKind enum
    // "for" is the external caller's name; serviceType is the function's internal referenced
    //   parameter name; "_" disregards external labels
    static func serviceKind(for serviceType: String) -> ServiceKind {
        switch serviceType {
        case HomeKitTypes.Service.lightbulb:
            return .light
        case HomeKitTypes.Service.switchLike:
            return .switchLike
        case HomeKitTypes.Service.outlet:
            return .outlet
        case HomeKitTypes.Service.windowCovering:
            return .blind
        case HomeKitTypes.Service.garageDoorOpener:
            return .garageDoor
        case HomeKitTypes.Service.lock:
            return .lock
        case HomeKitTypes.Service.thermostat,
             HomeKitTypes.Service.heaterCooler:
            return .thermostat
        case HomeKitTypes.Service.door:
            return .door
        case HomeKitTypes.Service.window:
            return .window
        case HomeKitTypes.Service.fan,
             HomeKitTypes.Service.fanV2:
            return .fan
        case HomeKitTypes.Service.humidifierDehumidifier:
            return .humidifierDehumidifier
        case HomeKitTypes.Service.airPurifier:
            return .airPurifier
        case HomeKitTypes.Service.valve:
            return .valve
        case HomeKitTypes.Service.faucet:
            return .faucet
        case HomeKitTypes.Service.slat:
            return .slat
        case HomeKitTypes.Service.securitySystem:
            return .securitySystem
        case HomeKitTypes.Service.temperatureSensor,
             HomeKitTypes.Service.leakSensor,
             HomeKitTypes.Service.smokeSensor,
             HomeKitTypes.Service.motionSensor,
             HomeKitTypes.Service.contactSensor,
             HomeKitTypes.Service.humiditySensor,
             HomeKitTypes.Service.occupancySensor,
             HomeKitTypes.Service.carbonDioxideSensor,
             HomeKitTypes.Service.carbonMonoxideSensor:
            return .sensor
        default:
            return .unsupported(serviceType)
        }
    }
}

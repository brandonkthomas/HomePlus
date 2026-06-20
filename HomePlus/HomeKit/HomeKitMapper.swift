//
//  HomeKitMapper.swift
//  HomePlus
//
//  Created by Brandon Thomas on 6/13/26.
//

import HomeKit

enum HomeKitMapper { // enum: pseudo-namespace since we do not need instances here (fully static)
    
    /// Maps a string => HomePlus.ServiceKind enum
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
    
    /// Maps HomeKit.HMHome => HomePlus.HomeModel
    static func homeModel(from home: HMHome) -> HomeModel {
        return .init(id: home.uniqueIdentifier,
                     name: home.name)
    }
    
    /// Maps HomeKit.HMRoom => HomePlus.RoomModel
    static func roomModel(from room: HMRoom) -> RoomModel {
        return .init(id: room.uniqueIdentifier,
                     name: room.name)
    }
    
    /// Maps HomeKit.HMAccessory => HomePlus.AccessoryModel
    static func accessoryModel(from accessory: HMAccessory) -> AccessoryModel {
        return .init(id: accessory.uniqueIdentifier,
                     name: accessory.name,
                     roomID: accessory.room?.uniqueIdentifier,
                     isReachable: accessory.isReachable)
    }

    /// Maps HomeKit.HMActionSet => HomePlus.SceneModel
    static func sceneModel(from actionSet: HMActionSet) -> SceneModel {
        return .init(id: actionSet.uniqueIdentifier,
                     name: actionSet.name,
                     isActive: false)
    }

    /// Maps HomeKit.HMCameraProfile => HomePlus.CameraModel plus parent Accessory
    static func cameraModel(from cameraProfile: HMCameraProfile,
                            accessory: HMAccessory) -> CameraModel {
        let hasMotionSensor: Bool = cameraProfile.services.contains {
            $0.serviceType == HomeKitTypes.Service.motionSensor
        }

        return .init(id: cameraProfile.uniqueIdentifier,
                     name: accessory.name,
                     accessoryID: accessory.uniqueIdentifier,
                     roomID: accessory.room?.uniqueIdentifier,
                     hasMotionSensor: hasMotionSensor)
    }

    /// Maps HomeKit.HMService + its parent HMAccessory => HomePlus.ServiceModel
    static func serviceModel(from service: HMService,
                             accessory: HMAccessory) -> ServiceModel {
        let characteristicTypes: Set<String> = Set(service.characteristics.map { characteristic in
            characteristic.characteristicType
        })

        let valuesByType = service.characteristics.reduce(into: [String: Any]()) {
            dictionary, characteristic in // assign aliases

            if let value = characteristic.value { // unwrap + skip if nil
                dictionary[characteristic.characteristicType] = value // add/replace
            }
        }

        // can also use:
        //var valuesByType: [String: Any] = [:]
        //
        //for characteristic in service.characteristics {
        //    if let value = characteristic.value {
        //        valuesByType[characteristic.characteristicType] = value
        //    }
        //}

        return .init(id: service.uniqueIdentifier,
                     accessoryID: accessory.uniqueIdentifier,
                     roomID: accessory.room?.uniqueIdentifier,
                     name: service.name,
                     accessoryName: accessory.name,
                     kind: serviceKind(for: service.serviceType),
                     isReachable: accessory.isReachable,
                     capabilities: serviceCapabilities(from: characteristicTypes),
                     values: serviceValues(from: valuesByType))
    }
    
    /// Derives app-facing service capabilities from HomeKit characteristic type identifiers
    static func serviceCapabilities(from types: Set<String>) -> ServiceCapabilities {

        let supportsPower: Bool = types.contains(HomeKitTypes.Characteristic.powerState)
            || types.contains(HomeKitTypes.Characteristic.active)

        let supportsBrightness: Bool = types.contains(HomeKitTypes.Characteristic.brightness)

        let supportsColor: Bool = types.contains(HomeKitTypes.Characteristic.hue)
            && types.contains(HomeKitTypes.Characteristic.saturation)

        let supportsColorTemperature: Bool = types.contains(HomeKitTypes.Characteristic.colorTemperature)

        let supportsPosition: Bool = types.contains(HomeKitTypes.Characteristic.targetPosition)

        let supportsTilt: Bool = types.contains(HomeKitTypes.Characteristic.targetHorizontalTiltAngle)
            || types.contains(HomeKitTypes.Characteristic.targetVerticalTiltAngle)
            || types.contains(HomeKitTypes.Characteristic.targetTiltAngle)

        return .init(supportsPower: supportsPower,
                     supportsBrightness: supportsBrightness,
                     supportsColor: supportsColor,
                     supportsColorTemperature: supportsColorTemperature,
                     supportsPosition: supportsPosition,
                     supportsTilt: supportsTilt)
    }

    /// Derives app-facing service capability values from HomeKit characteristic type identifiers
    static func serviceValues(from valuesByType: [String: Any]) -> ServiceValues {

        let powerState: Bool? = CharacteristicValue.bool(
            valuesByType[HomeKitTypes.Characteristic.powerState]
        )

        let active: Bool? = CharacteristicValue.bool(
            valuesByType[HomeKitTypes.Characteristic.active]
        )

        let brightness: Double? = CharacteristicValue.double(
            valuesByType[HomeKitTypes.Characteristic.brightness]
        )

        let currentPosition: Double? = CharacteristicValue.double(
            valuesByType[HomeKitTypes.Characteristic.currentPosition]
        )

        let currentTemperature: Double? = CharacteristicValue.double(
            valuesByType[HomeKitTypes.Characteristic.currentTemperature]
        )

        return .init(isOn: powerState ?? active,
                     brightness: brightness,
                     position: currentPosition,
                     temperature: currentTemperature)
    }
}

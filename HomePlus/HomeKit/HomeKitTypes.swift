//
//  HomeKitTypes.swift
//  HomePlus
//
//  Created by Brandon Thomas on 6/13/26.
//

// TIP: Empty enums can be used as pseudo-namespace-containers
enum HomeKitTypes {
    enum Service {
        static let lightbulb: String = "00000043-0000-1000-8000-0026BB765291"
        static let switchLike: String = "00000049-0000-1000-8000-0026BB765291"
        static let outlet: String = "00000047-0000-1000-8000-0026BB765291"
        static let thermostat: String = "0000004A-0000-1000-8000-0026BB765291"
        static let heaterCooler: String = "000000BC-0000-1000-8000-0026BB765291"
        static let lock: String = "00000045-0000-1000-8000-0026BB765291"
        static let windowCovering: String = "0000008C-0000-1000-8000-0026BB765291"
        static let door: String = "00000081-0000-1000-8000-0026BB765291"
        static let window: String = "0000008B-0000-1000-8000-0026BB765291"
        static let garageDoorOpener: String = "00000041-0000-1000-8000-0026BB765291"
        static let temperatureSensor: String = "0000008A-0000-1000-8000-0026BB765291"
        static let humiditySensor: String = "00000082-0000-1000-8000-0026BB765291"
        static let contactSensor: String = "00000080-0000-1000-8000-0026BB765291"
        static let motionSensor: String = "00000085-0000-1000-8000-0026BB765291"
        static let fan: String = "00000040-0000-1000-8000-0026BB765291"
        static let fanV2: String = "000000B7-0000-1000-8000-0026BB765291"
        static let occupancySensor: String = "00000086-0000-1000-8000-0026BB765291"
        static let leakSensor: String = "00000083-0000-1000-8000-0026BB765291"
        static let smokeSensor: String = "00000087-0000-1000-8000-0026BB765291"
        static let carbonMonoxideSensor: String = "0000007F-0000-1000-8000-0026BB765291"
        static let carbonDioxideSensor: String = "00000097-0000-1000-8000-0026BB765291"
        static let humidifierDehumidifier: String = "000000BD-0000-1000-8000-0026BB765291"
        static let airPurifier: String = "000000BB-0000-1000-8000-0026BB765291"
        static let valve: String = "000000D0-0000-1000-8000-0026BB765291"
        static let faucet: String = "000000D7-0000-1000-8000-0026BB765291"
        static let slat: String = "000000B9-0000-1000-8000-0026BB765291"
        static let securitySystem: String = "0000007E-0000-1000-8000-0026BB765291"
    }

    enum Characteristic {
        static let powerState: String = "00000025-0000-1000-8000-0026BB765291"
        static let outletInUse: String = "00000026-0000-1000-8000-0026BB765291"
        static let brightness: String = "00000008-0000-1000-8000-0026BB765291"
        static let hue: String = "00000013-0000-1000-8000-0026BB765291"
        static let saturation: String = "0000002F-0000-1000-8000-0026BB765291"
        static let colorTemperature: String = "000000CE-0000-1000-8000-0026BB765291"
        static let currentTemperature: String = "00000011-0000-1000-8000-0026BB765291"
        static let targetTemperature: String = "00000035-0000-1000-8000-0026BB765291"
        static let heatingCoolingState: String = "0000000F-0000-1000-8000-0026BB765291"
        static let targetHeatingCoolingState: String = "00000033-0000-1000-8000-0026BB765291"
        static let lockCurrentState: String = "0000001D-0000-1000-8000-0026BB765291"
        static let lockTargetState: String = "0000001E-0000-1000-8000-0026BB765291"
        static let currentPosition: String = "0000006D-0000-1000-8000-0026BB765291"
        static let targetPosition: String = "0000007C-0000-1000-8000-0026BB765291"
        static let currentHorizontalTiltAngle: String = "0000006C-0000-1000-8000-0026BB765291"
        static let targetHorizontalTiltAngle: String = "0000007B-0000-1000-8000-0026BB765291"
        static let currentVerticalTiltAngle: String = "0000006E-0000-1000-8000-0026BB765291"
        static let targetVerticalTiltAngle: String = "0000007D-0000-1000-8000-0026BB765291"
        static let positionState: String = "00000072-0000-1000-8000-0026BB765291"
        static let currentRelativeHumidity: String = "00000010-0000-1000-8000-0026BB765291"
        static let motionDetected: String = "00000022-0000-1000-8000-0026BB765291"
        static let active: String = "000000B0-0000-1000-8000-0026BB765291"
        static let currentHeaterCoolerState: String = "000000B1-0000-1000-8000-0026BB765291"
        static let targetHeaterCoolerState: String = "000000B2-0000-1000-8000-0026BB765291"
        static let coolingThresholdTemperature: String = "0000000D-0000-1000-8000-0026BB765291"
        static let heatingThresholdTemperature: String = "00000012-0000-1000-8000-0026BB765291"
        static let rotationSpeed: String = "00000029-0000-1000-8000-0026BB765291"
        static let rotationDirection: String = "00000028-0000-1000-8000-0026BB765291"
        static let targetFanState: String = "000000BF-0000-1000-8000-0026BB765291"
        static let currentFanState: String = "000000AF-0000-1000-8000-0026BB765291"
        static let swingMode: String = "000000B6-0000-1000-8000-0026BB765291"
        static let currentDoorState: String = "0000000E-0000-1000-8000-0026BB765291"
        static let targetDoorState: String = "00000032-0000-1000-8000-0026BB765291"
        static let obstructionDetected: String = "00000024-0000-1000-8000-0026BB765291"
        static let contactSensorState: String = "0000006A-0000-1000-8000-0026BB765291"
        static let occupancyDetected: String = "00000071-0000-1000-8000-0026BB765291"
        static let leakDetected: String = "00000070-0000-1000-8000-0026BB765291"
        static let smokeDetected: String = "00000076-0000-1000-8000-0026BB765291"
        static let carbonMonoxideDetected: String = "00000069-0000-1000-8000-0026BB765291"
        static let carbonDioxideDetected: String = "00000092-0000-1000-8000-0026BB765291"
        static let currentHumidifierDehumidifierState: String = "000000B3-0000-1000-8000-0026BB765291"
        static let targetHumidifierDehumidifierState: String = "000000B4-0000-1000-8000-0026BB765291"
        static let humidifierThreshold: String = "000000CA-0000-1000-8000-0026BB765291"
        static let dehumidifierThreshold: String = "000000C9-0000-1000-8000-0026BB765291"
        static let waterLevel: String = "000000B5-0000-1000-8000-0026BB765291"
        static let currentAirPurifierState: String = "000000A9-0000-1000-8000-0026BB765291"
        static let targetAirPurifierState: String = "000000A8-0000-1000-8000-0026BB765291"
        static let inUse: String = "000000D2-0000-1000-8000-0026BB765291"
        static let valveType: String = "000000D5-0000-1000-8000-0026BB765291"
        static let setDuration: String = "000000D3-0000-1000-8000-0026BB765291"
        static let remainingDuration: String = "000000D4-0000-1000-8000-0026BB765291"
        static let securitySystemCurrentState: String = "00000066-0000-1000-8000-0026BB765291"
        static let securitySystemTargetState: String = "00000067-0000-1000-8000-0026BB765291"
        static let currentTiltAngle: String = "000000C1-0000-1000-8000-0026BB765291"
        static let targetTiltAngle: String = "000000C2-0000-1000-8000-0026BB765291"
        static let slatType: String = "000000C0-0000-1000-8000-0026BB765291"
        static let currentSlatState: String = "000000AA-0000-1000-8000-0026BB765291"

        /// Which Characteristics need notifications?
        ///
        /// Currently matches what is possible to store in ServiceValues
        static let observedTypes: Set<String> = [ // Set rather than [] for efficient/unique .contains() lookup
            Characteristic.powerState,
            Characteristic.active,
            Characteristic.brightness,
            Characteristic.currentPosition,
            Characteristic.currentTemperature
        ]
    }
}

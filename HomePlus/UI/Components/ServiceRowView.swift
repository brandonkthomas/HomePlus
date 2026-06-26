//
//  ServiceRowView.swift
//  HomePlus
//
//  Created by Brandon Thomas on 6/24/26.
//

import SwiftUI

/// A control should be enabled only when all of these are true:
///
/// - The accessory/service is reachable
/// - The service supports that capability
/// - We have a current value to display
/// - A command/write path exists for that capability
struct ServiceRowView: View {

    let service: ServiceModel

    // MARK: Properties (Private)

    // TODO: Modify symbols based on service state
    private var serviceImage: Image {
        switch service.kind {
        case .switchLike:
            return Image(systemName: service.values.isOn ?? false
                         ? "switch.fill"
                         : "switch")
        case .outlet:
            return Image(systemName: service.values.isOn ?? false
                         ? "poweroutlet.type.b.fill"
                         : "poweroutlet.type.b")
        case .blind:
            return Image(systemName: service.values.hasOpenPosition
                         ? "blinds.horizontal.open"
                         : "blinds.horizontal.closed")
        case .garageDoor:
            return Image(systemName: "door.garage.closed")
        case .lock:
            return Image(systemName: "lock.fill")
        case .thermostat:
            return Image(systemName: "thermometer.variable")
        case .door:
            return Image(systemName: "door.left.hand.closed")
        case .window:
            return Image(systemName: "window.vertical.closed")
        case .fan:
            return Image(systemName: "fan.desk.fill")
        case .humidifierDehumidifier:
            return Image(systemName: "humidifier.fill")
        case .airPurifier:
            return Image(systemName: "air.purifier.fill")
        case .valve, .faucet:
            return Image(systemName: "spigot.fill")
        case .slat:
            return Image(systemName: "blinds.vertical.closed")
        case .securitySystem:
            return Image(systemName: "shield.lefthalf.filled")
        case .sensor:
            return Image(systemName: "sensor.fill")
        case .light, .unsupported:
            return Image(systemName: service.values.isOn ?? false
                         ? "lightbulb.fill"
                         : "lightbulb")
        }
    }

    /// Computed status text for all values
    private var statusTexts: [String] {
        var texts: [String] = []

        // Power
        if let powerText = powerText {
            texts.append(powerText)
        }

        // Brightness
        if let brightnessText = brightnessText {
            texts.append(brightnessText)
        }

        // Position
        if let positionText = positionText {
            texts.append(positionText)
        }

        return texts
    }

    /// Computed text for value of service.values.isOn
    private var powerText: String? {
        switch service.values.isOn {
        case true:
            return "On"
        case false:
            return "Off"
        case nil:
            return nil
        }
    }

    /// Computed text for value of service.values.brightness
    private var brightnessText: String? {
        switch service.values.brightness {
        case nil:
            return nil
        default:
            guard let brightness = service.values.brightness else {
                return nil
            }
            return "\(Int(brightness.rounded()))%"
        }
    }

    /// Computed text for value of service.values.position
    private var positionText: String? {
        switch service.values.position {
        case nil:
            return nil
        default:
            guard let position = service.values.position else {
                return nil
            }
            return "\(Int(position.rounded()))%"
        }
    }

    /// Have we met all required prerequisitites to be able to save Power changes?
    private var canWritePower: Bool {
        false // TODO
    }

    /// Have we met all required prerequisitites to be able to save Brightness changes?
    private var canWriteBrightness: Bool {
        false // TODO
    }

    /// Have we met all required prerequisitites to be able to save Position changes?
    private var canWritePosition: Bool {
        false // TODO
    }

    // MARK: Views

    /// ServiceRowView: icon/text/controls for a ServiceModel of any .type
    var body: some View {
        HStack(spacing: 12) { // spacing between components
            Group {
                serviceImage
                    .frame(width: 20) // fixed width for alignment's sake

                // most of the time, accessoryName and serviceName are identical
                // in some cases an accessory may have a motion sensor, light, camera... we should
                // show the service names given this behavior
                Text(service.name)
            }
            .foregroundStyle(service.isReachable ? .primary : .secondary)

            Spacer()

            if service.isReachable {
                // Brightness
                if service.capabilities.supportsBrightness
                    && service.values.isOn ?? false {
                    ValueBarView(value: service.values.brightness ?? 0,
                                 label: "Brightness",
                                 color: service.values.displayColor ?? .blue,
                                 isEnabled: canWriteBrightness)
                    .frame(width: 100) // slider takes up as much as it can; need to limit
                }

                // Position
                if service.capabilities.supportsPosition {
                    ValueBarView(value: service.values.position ?? 0,
                                 label: "Position",
                                 color: service.values.displayColor ?? .blue,
                                 isEnabled: canWritePosition)
                    .frame(width: 100) // slider takes up as much as it can; need to limit
                }

                // Power
                if service.capabilities.supportsPower {
                    ToggleView(isOn: service.values.isOn ?? false,
                               label: "Power",
                               color: service.values.displayColor ?? .blue,
                               isEnabled: canWritePower)
                    .frame(width: 64)
                }
            } else {
                Image(systemName: "wifi.slash")
                    .foregroundStyle(.secondary)
            }
        }
    }
}

// MARK: Xcode Canvas Previews

#Preview("Populated") {
    let store = PreviewFixtures.makeStore(homeKitLoadState: .ready)

    List {
        ForEach(store.services, id: \.id) { service in
            ServiceRowView(service: service)
        }
    }
    .frame(width: 430)
}

#Preview("Unreachable") {
    let room = PreviewFixtures.livingRoom()
    let accessory = PreviewFixtures.floorLampAccessory(roomID: room.id)
    let service = PreviewFixtures.unreachableLightService(roomID: room.id,
                                                          accessory: accessory)

    List {
        ServiceRowView(service: service)
    }
    .frame(width: 430)
}

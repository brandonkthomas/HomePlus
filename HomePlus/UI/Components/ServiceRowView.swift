//
//  ServiceRowView.swift
//  HomePlus
//
//  Created by Brandon Thomas on 6/24/26.
//

import SwiftUI

struct ServiceRowView: View {

    let service: ServiceModel

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

    /// Computed status text for all
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

    // MARK: Views

    /// ServiceRowView: icon/text/controls for a ServiceModel of any .type
    var body: some View {
        HStack {
            serviceImage
                .frame(width: 20)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 5))

            // most of the time, accessoryName and serviceName are identical
            // in some cases an accessory may have a motion sensor, light, camera... we should
            // show the service names given this behavior
            Text(service.name)
                .foregroundStyle(service.isReachable ? .primary : .secondary)

            Spacer()

            if service.isReachable {
                // TODO: replace w/ Toggle
                if !statusTexts.isEmpty {
                    Text(statusTexts.joined(separator: " • "))
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

    ForEach(store.services, id: \.id) { service in
        ServiceRowView(service: service)
    }
}

#Preview("Unreachable") {
    let room = PreviewFixtures.livingRoom()
    let accessory = PreviewFixtures.floorLampAccessory(roomID: room.id)
    let service = PreviewFixtures.unreachableLightService(roomID: room.id,
                                                          accessory: accessory)
    ServiceRowView(service: service)
}

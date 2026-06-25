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
            return Image(systemName: service.values.position ?? 0 > 0
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

    /// ServiceRowView: icon/text/controls for a ServiceModel of any .type
    var body: some View {
        HStack {
            serviceImage
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 5))

            Text(service.accessoryName)
                .foregroundStyle(service.isReachable ? .primary : .secondary)

            Spacer()

            // TODO: replace w/ Toggle
            if let isOn = service.values.isOn {
                Text(isOn ? "On" : "Off")
            }
        }
    }
}

// MARK: Xcode Canvas Previews

#Preview("Populated") {
    let room = PreviewFixtures.livingRoom()
    let accessory = PreviewFixtures.floorLampAccessory(roomID: room.id)
    let service = PreviewFixtures.floorLampService(roomID: room.id,
                                                   accessory: accessory)
    ServiceRowView(service: service)
}

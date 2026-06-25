//
//  PreviewFixtures.swift
//  HomePlus
//
//  Created by Brandon Thomas on 6/24/26.
//

import Foundation

enum PreviewFixtures {

    // MARK: Store

    /// Create a dummy HomeStore for use in Xcode Canvas Previews
    static func makeStore(homeKitLoadState: HomeKitLoadState,
                          addHomes: Bool = true,
                          addRooms: Bool = true,
                          addAccessories: Bool = true,
                          addServices: Bool = true) -> HomeStore {
        let store = HomeStore()

        let home1 = HomeModel(id: UUID(), name: "My Home")
        let home2 = HomeModel(id: UUID(), name: "Vacation Home")

        let room1 = livingRoom()
        let room2 = RoomModel(id: UUID(), name: "Kitchen")
        let room3 = RoomModel(id: UUID(), name: "Bedroom")

        let accessory1 = floorLampAccessory(roomID: room1.id)
        let accessory2 = blindsAccessory(roomID: room1.id)

        let service1 = lightService(roomID: room1.id,
                                    accessory: accessory1)
        let service2 = blindService(roomID: room1.id,
                                    accessory: accessory2)

        if addHomes {
            store.homes = [home1, home2]
        }

        if addHomes && addRooms {
            store.rooms = [room1, room2, room3]
        }

        if addHomes && addRooms && addAccessories {
            store.accessories = [accessory1, accessory2]
        }

        if addHomes && addRooms && addAccessories && addServices {
            store.services = [service1, service2]
        }

        store.selectedHome = store.homes.first
        store.homeKitLoadState = homeKitLoadState

        return store
    }

    // MARK: Rooms

    /// Returns dummy RoomModel: Living Room
    static func livingRoom() -> RoomModel {
        .init(id: UUID(), name: "Living Room")
    }

    // MARK: Accessories

    /// Returns dummy AccessoryModel: Floor Lamp
    static func floorLampAccessory(roomID: RoomModel.ID) -> AccessoryModel {
        .init(id: UUID(),
              name: "Floor Lamp",
              roomID: roomID,
              isReachable: true)
    }

    /// Returns dummy AccessoryModel: Blinds
    static func blindsAccessory(roomID: RoomModel.ID) -> AccessoryModel {
        .init(id: UUID(),
              name: "Blinds",
              roomID: roomID,
              isReachable: true)
    }

    // MARK: Services

    /// Returns dummy ServiceModel: Power
    static func lightService(roomID: RoomModel.ID,
                                 accessory: AccessoryModel) -> ServiceModel {
        .init(id: UUID(),
              accessoryID: accessory.id,
              roomID: roomID,
              name: "Power",
              accessoryName: accessory.name,
              kind: ServiceKind.light,
              isReachable: true,
              capabilities: .init(supportsPower: true,
                                  supportsBrightness: true,
                                  supportsColorTemperature: true),
              values: .init(isOn: true,
                            brightness: 70,
                            temperature: 3500))
    }

    /// Returns dummy ServiceModel: Power
    static func unreachableLightService(roomID: RoomModel.ID,
                                        accessory: AccessoryModel) -> ServiceModel {
        .init(id: UUID(),
              accessoryID: accessory.id,
              roomID: roomID,
              name: "Power",
              accessoryName: accessory.name,
              kind: ServiceKind.light,
              isReachable: false,
              capabilities: .init(supportsPower: true,
                                  supportsBrightness: true,
                                  supportsColorTemperature: true),
              values: .init(isOn: nil,
                            brightness: nil,
                            temperature: nil))
    }

    /// Returns dummy ServiceModel: Position
    static func blindService(roomID: RoomModel.ID,
                             accessory: AccessoryModel) -> ServiceModel {
        .init(id: UUID(),
              accessoryID: accessory.id,
              roomID: roomID,
              name: "Position",
              accessoryName: accessory.name,
              kind: ServiceKind.blind,
              isReachable: true,
              capabilities: .init(supportsPosition: true),
              values: .init(position: 45))
    }
}

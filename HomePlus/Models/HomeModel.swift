//
//  HomeModel.swift
//  HomePlus
//
//  Created by Brandon Thomas on 6/13/26.
//
//  Mapping for HMHome
//  Map depth:
//   HomeKitRepository owns HMHomeManager / HMHome / HMRoom / HMAccessory
//   HomeModel / RoomModel / ServiceModel
//   SwiftUI views
//

import Foundation

struct HomeModel: Identifiable, Equatable {
    let id: UUID
    var name: String
//    var isPrimary: Bool // primaryHome deprecated in iOS 16.1
}

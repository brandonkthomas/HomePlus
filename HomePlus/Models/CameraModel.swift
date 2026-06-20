//
//  CameraModel.swift
//  HomePlus
//
//  Created by Brandon Thomas on 6/13/26.
//

import Foundation

struct CameraModel: Identifiable, Equatable {
    let id: UUID
    var name: String
    let accessoryID: UUID
    var roomID: UUID?
    var hasMotionSensor: Bool
}

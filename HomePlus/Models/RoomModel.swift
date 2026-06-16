//
//  RoomModel.swift
//  HomePlus
//
//  Created by Brandon Thomas on 6/13/26.
//

import Foundation

/// Mapping for HMRoom
/// TODO: type safety: eventually we should create "struct RoomID: Hashable, Codable { let rawValue: UUID }"
///  ... then modify all callers to use "let roomID: RoomID"
struct RoomModel: Identifiable, Equatable {
    let id: UUID
    var name: String
}

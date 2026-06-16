//
//  SceneModel.swift
//  HomePlus
//
//  Created by Brandon Thomas on 6/13/26.
//

import Foundation

/// Mapping for HMActionSet (aka Scene)
struct SceneModel: Identifiable, Equatable {
    let id: UUID
    var name: String
    /// isActive will eventually be inferred by checking whether current accessory values match
    ///  scene's target actions (i.e. this is calculated & NOT persisted anywhere)
    var isActive: Bool
}

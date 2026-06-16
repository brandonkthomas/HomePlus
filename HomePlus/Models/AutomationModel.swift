//
//  AutomationModel.swift
//  HomePlus
//
//  Created by Brandon Thomas on 6/13/26.
//

import Foundation

/// App-facing summary of a HomeKit automation/trigger
/// Loose mapping of HMTrigger + action sets
struct AutomationModel: Identifiable, Equatable {
    let id: UUID
    var name: String
    var isEnabled: Bool
    var summary: String
}

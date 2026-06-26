//
//  ToggleView.swift
//  HomePlus
//
//  Created by Brandon Thomas on 6/25/26.
//

import SwiftUI

/// Simple on/off Toggle w/ optional color
///
/// Created for use in ServiceRowView
struct ToggleView: View {

    // MARK: Properties

    /// Is this Toggle switched on?
    @State var isOn = false

    /// Required for accessibility (not visible)
    var label: String

    /// What color is this Toggle tinted as?
    var color: Color = .blue

    /// Is this Toggle enabled (interactible)?
    var isEnabled: Bool = true

    // MARK: Views

    /// ToggleView primary body
    var body: some View {
        Toggle(label, isOn: $isOn)
        .labelsHidden()
        .tint(color)
        .disabled(!isEnabled)
    }
}

// MARK: Xcode Canvas Previews

#Preview("test") {
    ToggleView(isOn: false,
               label: "Power",
               color: .blue)
    ToggleView(isOn: true,
               label: "Power",
               color: .yellow)
    ToggleView(isOn: true,
               label: "Power",
               color: .yellow,
               isEnabled: false)
}

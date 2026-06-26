//
//  ValueBarView.swift
//  HomePlus
//
//  Created by Brandon Thomas on 6/25/26.
//

import SwiftUI

/// Simple Slider w/ optional color & step
struct ValueBarView: View {

    // MARK: Properties

    /// What is the value of this Slider (0-100)?
    @State var value = 0.0

    /// Required for accessibility (not visible)
    var label: String

    /// What color is this Slider tinted as?
    var color: Color = .blue

    /// Is this Slider enabled (interactible)?
    var isEnabled: Bool = true

    /// What is the step setting for this Slider (if any)?
    /// TODO: FUTURE IMPLEMENTATION
//    var step: Double = 0

    // MARK: Properties (Private)

    /// Are we currently dragging this Slider?
    @State private var isEditing = false

    // MARK: Views

    /// Primary view
    var body: some View {
        Slider(value: $value,
               in: 0 ... 100,
//               step: 25,
               label: {
                   Text(label)
               },
               onEditingChanged: { editing in
                   isEditing = editing
               })
        .labelsHidden()
        .tint(color)
        .disabled(!isEnabled)
    }
}

// MARK: Xcode Canvas Previews

#Preview("test") {
    ValueBarView(value: 20.0,
                 label: "Brightness",
                 color: .blue)
        .padding(20)
    ValueBarView(value: 50.0,
                 label: "Brightness",
                 color: .green)
        .padding(80)
    ValueBarView(value: 50.0,
                 label: "Brightness",
                 color: .green,
                 isEnabled: false)
        .padding(80)
    ValueBarView(value: 80.0,
                 label: "Brightness",
                 color: .yellow)
        .padding(160)
}

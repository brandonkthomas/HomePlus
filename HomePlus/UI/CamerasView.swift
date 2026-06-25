//
//  CameraView.swift
//  HomePlus
//
//  Created by Brandon Thomas on 6/24/26.
//

import SwiftUI

struct CamerasView: View {
    var body: some View {
        ContentUnavailableView {
            Label("Coming Soon", systemImage: "clock.fill")
        } description: {
            Text("Cameras will be available here in a future release.")
        }
    }
}

// MARK: Xcode Canvas Previews

#Preview("Ready") {
    CamerasView()
}

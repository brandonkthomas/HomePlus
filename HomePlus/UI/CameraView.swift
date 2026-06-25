//
//  CameraView.swift
//  HomePlus
//
//  Created by Brandon Thomas on 6/24/26.
//

import SwiftUI

struct CamerasTabView: View {
    var body: some View {
        VStack {
            Image(systemName: "clock.fill")
                .font(.system(size: 24, weight: .medium))
                .padding(8)
            Text("Coming Soon")
                .font(.system(size: 12, weight: .medium))
        }
    }
}

// MARK: Xcode Canvas Preview

#Preview("Ready") {
    CamerasTabView()
}

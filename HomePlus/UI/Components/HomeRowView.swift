//
//  HomeRowView.swift
//  HomePlus
//
//  Created by Brandon Thomas on 6/24/26.
//

import SwiftUI

/// View: Row for a specific Home w/ Selected status
struct HomeRowView: View {

    let home: HomeModel
    let isSelected: Bool

    var body: some View {
        HStack {
            Text(home.name)
            Spacer()

            if isSelected {
                Image(systemName: "checkmark")
            }
        }
    }
}

// MARK: Xcode Canvas Previews

#Preview("Selected") {
    let home = HomeModel(id: UUID(), name: "My Home")

    HomeRowView(home: home,
                isSelected: true)
}

#Preview("Unselected") {
    let home = HomeModel(id: UUID(), name: "My Home")

    HomeRowView(home: home,
                isSelected: false)
}

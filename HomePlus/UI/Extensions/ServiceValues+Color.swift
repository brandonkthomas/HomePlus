//
//  ServiceValues+Color.swift
//  HomePlus
//
//  Created by Brandon Thomas on 6/25/26.
//

import SwiftUI

/// ServiceValues extensions using SwiftUI for Color
extension ServiceValues { // extensions allow computed props but not stored props

    /// Normalizes/calculates hue/saturation/brightness properties to a cohesive Color type
    var displayColor: Color? {
        let normalizedHue = (hue ?? 0) / 360
        let normalizedSaturation = (saturation ?? 0) / 100
        let normalizedBrightness = (brightness ?? 0) / 100

        // Hue + Saturation exist; use HSB
        if hue != nil,
           let saturation,
           saturation > 0 {

            return .init(hue: normalizedHue,
                         saturation: normalizedSaturation,
                         brightness: normalizedBrightness)

        } else if let colorTemperature {
            let mireds = colorTemperature
            let kelvin = 1000000 / mireds
            return color(from: kelvin)
        }

        return .blue
    }

    /// Try to convert colorTemperature to Kelvin
    private func color(from kelvinTemperature: CGFloat) -> Color {
        // Clamp the temperature range (Standard range: 1000K - 40000K)
        let temp = max(1000, min(40000, kelvinTemperature)) / 100

        var red: CGFloat
        var green: CGFloat
        var blue: CGFloat

        // Simplified Black-Body Approximation
        if temp <= 66 {
            red = 1.0
            green = 0.39 * log(temp) - 0.15
        } else {
            red = 1.29 * pow(temp - 60, -0.13)
            green = 1.12 * pow(temp - 60, -0.07)
        }

        if temp >= 66 {
            blue = 1.0
        } else if temp <= 19 {
            blue = 0.0
        } else {
            blue = 0.54 * log(temp - 10) - 0.11
        }

        return Color(
            red: Double(max(0, min(1, red))),
            green: Double(max(0, min(1, green))),
            blue: Double(max(0, min(1, blue)))
        )
    }
}

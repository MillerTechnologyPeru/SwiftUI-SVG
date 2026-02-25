//
//  CSS.swift
//  SwiftSVG
//
//  Created by cmiller11 on 2/25/26.
//

import Foundation
import RegexBuilder

internal extension SVGData {
    
    func resolveSVGStyles() -> String {
        guard #available(iOS 16.0, *) else {
            return rawValue
        }
        // Parse style block classes
        let stylePattern = /\.(\w+)\{fill:([^}]+)\}/
        var classColors: [String: String] = [:]
        
        for match in rawValue.matches(of: stylePattern) {
            classColors[String(match.1)] = String(match.2).trimmingCharacters(in: .whitespaces)
        }
        
        guard !classColors.isEmpty else { return rawValue }
        
        // Replace class="stX" with fill="color" on each path
        var result = rawValue
        for (className, color) in classColors {
            let classPattern = try! Regex(#"class="\#(className)""#)
            result = result.replacing(classPattern, with: #"fill="\#(color)""#)
        }
        
        return result
    }
}

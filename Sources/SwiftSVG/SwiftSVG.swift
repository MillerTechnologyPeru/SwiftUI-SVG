//
//  SwiftSVG.swift
//  SwiftSVG
//
//  Created by Alsey Coleman Miller on 2/24/26.
//

import Foundation
import CoreGraphics

/// SVG Data
public struct SVGData: Equatable, Hashable, Sendable {
    
    internal let rawValue: String
    
    public init?(_ string: String) {
        // Validate that the string contains SVG content
        guard Self.isValidSVG(string) else {
            return nil
        }
        self.rawValue = string
    }
    
    /// Check if the string has proper SVG prefix or tag
    internal static func isValidSVG(_ string: String) -> Bool {
        let trimmed = string.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Check for common SVG prefixes
        return trimmed.hasPrefix("<?xml") || // XML declaration
               trimmed.hasPrefix("<svg") ||  // SVG root element
               trimmed.contains("<svg")      // SVG tag somewhere in the content
    }
}

public extension SVGData {
    
    init?(data: Data) {
        guard let svgString = String(data: data, encoding: .utf8) else {
            return nil
        }
        self.init(svgString)
    }
}

/// SVG Renderer
public protocol SVGRenderer {
    
    func render(_ svg: SVGData, size: CGSize)
}

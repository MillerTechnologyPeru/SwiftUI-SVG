//
//  SwiftSVG.swift
//  SwiftSVG
//
//  Created by Alsey Coleman Miller on 2/24/26.
//

import Foundation
import CoreGraphics

#if canImport(svgnative)
import svgnative
#endif

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
    
    /// Get the intrinsic size defined in the SVG data
    /// - Returns: The intrinsic size if available, or nil if the SVG doesn't define dimensions
    var intrinsicSize: CGSize? {
        #if canImport(svgnative)
        guard let context = svg_native_create(SVG_RENDERER_UNKNOWN, rawValue) else {
            return nil
        }
        defer {
            svg_native_destroy(context)
        }
        let width = svg_native_canvas_width(context)
        let height = svg_native_canvas_height(context)
        
        // Check if dimensions are valid (non-zero and not NaN)
        guard width > 0 && height > 0 && !width.isNaN && !height.isNaN else {
            return nil
        }
        
        return CGSize(width: CGFloat(width), height: CGFloat(height))
        #else
        return nil
        #endif
    }
}

/// SVG Renderer
public protocol SVGRenderer {
    
    func render(_ svg: SVGData, size: CGSize)
}

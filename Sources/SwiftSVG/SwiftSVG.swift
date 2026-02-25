//
//  SwiftSVG.swift
//  SwiftSVG
//
//  Created by Alsey Coleman Miller on 2/24/26.
//

import Foundation
import CoreGraphics
import SVGNative

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
        SVGNative(string) != nil
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
        guard let document = SVGNative(rawValue) else {
            return nil
        }
        return document.intrinsicSize.flatMap { CGSize(width: CGFloat($0.width), height: CGFloat($0.height)) }
    }
}

/// SVG Renderer
public protocol SVGRenderer {
    
    func render(_ svg: SVGData, size: CGSize)
}

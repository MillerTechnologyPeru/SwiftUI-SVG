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
    
    public init(_ string: String) {
        self.rawValue = string
    }
}

/// SVG Renderer
public protocol SVGRenderer {
    
    func render(_ svg: SVGData, size: CGSize)
}

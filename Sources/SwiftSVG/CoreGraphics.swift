//
//  CoreGraphics.swift
//  SwiftSVG
//
//  Created by Alsey Coleman Miller on 2/24/26.
//

#if canImport(CoreGraphics)
import Foundation
import CoreGraphics
import SVGNative

extension CGContext: SVGRenderer {
    
    public func render(_ svg: SVGData, size: CGSize) {
        guard let svgDocument = SVGNative(svg.rawValue) else {
            return
        }
        svgDocument.setRenderer(self)
        svgDocument.render((Float(size.width), Float(size.height)))
    }
}

#endif

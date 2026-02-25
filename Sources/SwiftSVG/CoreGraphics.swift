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
        let svgString = svg.resolveSVGStyles()
        guard let svgDocument = SVGNative(svgString) else {
            return
        }
        svgDocument.setRenderer(self)
        svgDocument.render((Float(size.width), Float(size.height)))
    }
}

#endif

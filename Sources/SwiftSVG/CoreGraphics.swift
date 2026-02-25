//
//  CoreGraphics.swift
//  SwiftSVG
//
//  Created by Alsey Coleman Miller on 2/24/26.
//

#if canImport(CoreGraphics)
import Foundation
import CoreGraphics
import svgnative

extension CGContext: SVGRenderer {
    
    public func render(_ svg: SVGData, size: CGSize) {
        let svgString = svg.rawValue
        guard let context = svg_native_create(SVG_RENDERER_CG, svgString) else {
            return
        }
        defer {
            svg_native_destroy(context)
        }
        svg_native_set_renderer(context, Unmanaged.passUnretained(self).toOpaque())
        svg_native_render_size(context, Float(size.width), Float(size.height))
    }
}

#endif

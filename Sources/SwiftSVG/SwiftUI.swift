//
//  SwiftUI.swift
//  SwiftSVG
//
//  Created by Alsey Coleman Miller on 2/24/26.
//

#if canImport(SwiftUI)
import Foundation
import SwiftUI

/// A SwiftUI view that renders SVG content using Canvas
public struct SVGView: View {
    
    public let svg: SVGData
    
    public init(_ svg: SVGData) {
        self.svg = svg
    }
    
    public var body: some View {
        Group {
            if #available(macOS 12.0, *) {
                CanvasView(svg: svg)
            } else {
                
            }
        }
    }
}

@available(macOS 12.0, *)
internal extension SVGView {
    
    struct CanvasView: View {

        let svg: SVGData
        
        var body: some View {
            Canvas { context, size in
                context.render(svg, size: size)
            }
        }
    }
}

@available(macOS 12.0, *)
extension GraphicsContext: SVGRenderer {
    
    public func render(_ svg: SVGData, size: CGSize) {
        self.withCGContext { context in
            context.render(svg, size: size)
        }
    }
}

#endif

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
            if #available(macOS 12.0, iOS 15.0, *) {
                CanvasView(svg: svg)
            } else {
                ImageView(svg: svg)
            }
        }
    }
}

@available(macOS 12.0, iOS 15.0, *)
internal extension SVGView {
    
    struct CanvasView: View {

        let svg: SVGData
        
        var body: some View {
            if let intrinsicSize = svg.intrinsicSize {
                Canvas { context, size in
                    context.render(svg, size: size)
                }
                .frame(width: intrinsicSize.width, height: intrinsicSize.height)
            } else {
                Canvas { context, size in
                    context.render(svg, size: size)
                }
            }
        }
    }
}

internal extension SVGView {
    
    struct ImageView: View {
        
        let svg: SVGData
        
        var body: some View {
            Group {
                if let size = svg.intrinsicSize {
                    Image(svg: svg, size: size)
                } else {
                    GeometryReader { geometry in
                        Image(svg: svg, size: geometry.size)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    }
                }
            }
        }
    }
}

@available(macOS 12.0, iOS 15.0, *)
extension GraphicsContext: SVGRenderer {
    
    public func render(_ svg: SVGData, size: CGSize) {
        self.withCGContext { context in
            context.render(svg, size: size)
        }
    }
}

#Preview {
    VStack {
        if #available(iOS 15.0, *) {
            SVGView.CanvasView(svg: SVGData("""
        <svg width="100" height="200" xmlns="http://www.w3.org/2000/svg">
            <rect width="100" height="200" fill="red"/>
        </svg>
        """)!)
            
            SVGView.CanvasView(svg: SVGData("""
        <svg xmlns="http://www.w3.org/2000/svg">
            <rect width="50" height="50" fill="red"/>
        </svg>
        """)!)
            .frame(width: 50, height: 50)
        }
        
        SVGView.ImageView(svg: SVGData("""
    <svg width="100" height="200" xmlns="http://www.w3.org/2000/svg">
        <rect width="100" height="200" fill="red"/>
    </svg>
    """)!)
        
        SVGView.ImageView(svg: SVGData("""
    <svg xmlns="http://www.w3.org/2000/svg">
        <rect width="50" height="50" fill="red"/>
    </svg>
    """)!)
    }
}

#endif

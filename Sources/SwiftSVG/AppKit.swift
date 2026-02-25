//
//  AppKit.swift
//  SwiftSVG
//
//  Created by Alsey Coleman Miller on 2/24/26.
//

#if canImport(AppKit)
import Foundation
import AppKit
import CoreGraphics
import svgnative

extension NSGraphicsContext: SVGRenderer {
    
    public func render(_ svg: SVGData, size: CGSize) {
        self.cgContext.render(svg, size: size)
    }
}

public extension NSImage {
    
    static func svg(_ svg: SVGData, size: CGSize) -> NSImage {
        let image = NSImage(size: size)
        image.lockFocus()
        NSGraphicsContext.current?.render(svg, size: size)
        image.unlockFocus()
        return image
    }
}

#endif

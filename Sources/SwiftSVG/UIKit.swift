//
//  UIKit.swift
//  SwiftSVG
//
//  Created by Alsey Coleman Miller on 2/24/26.
//

#if canImport(UIKit)
import Foundation
import UIKit
import CoreGraphics

extension UIGraphicsRendererContext: SVGRenderer {
    
    public func render(_ svg: SVGData, size: CGSize) {
        cgContext.render(svg, size: size)
    }
}

public extension UIImage {
    
    static func svg(_ svg: SVGData, size: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        let image = renderer.image { context in
            context.render(svg, size: size)
        }
        return image
    }
}

#endif

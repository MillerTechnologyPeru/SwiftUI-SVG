//
//  Image.swift
//  SwiftSVG
//
//  Created by Alsey Coleman Miller on 2/24/26.
//

#if canImport(SwiftUI)
import Foundation
import SwiftUI
#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

public extension SwiftUI.Image {
    
    init(svg: SVGData, size: CGSize = CGSize(width: 100, height: 100)) {
        #if canImport(UIKit)
        let image = UIImage.svg(svg, size: size)
        self.init(uiImage: image)
        #elseif canImport(AppKit)
        let image = NSImage.svg(svg, size: size)
        self.init(nsImage: image)
        #endif
    }
}
#endif


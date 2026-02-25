//
//  CSS.swift
//  SwiftSVG
//
//  Created by cmiller11 on 2/25/26.
//

import Foundation
import RegexBuilder

internal extension SVGData {
    
    func resolveSVGStyles() -> String {
        guard #available(iOS 16.0, macOS 13.0, *) else {
            return rawValue
        }
        
        // Extract all CSS class definitions from <style> blocks
        let classStyles = extractCSSClasses(from: rawValue)
        guard !classStyles.isEmpty else { 
            return rawValue 
        }
        
        // Apply CSS classes to elements with class attributes
        var result = rawValue
        
        // Find all elements with class attributes - match the opening tag
        let classAttrPattern = /<([a-zA-Z][a-zA-Z0-9]*)\s+([^>]*?)class="([^"]+)"([^>]*?)>/
        
        // Process matches in reverse order to maintain correct positions
        let matches = Array(result.matches(of: classAttrPattern).reversed())
        
        for match in matches {
            let tagName = String(match.1)
            let beforeClass = String(match.2)
            let classNames = String(match.3).split(separator: " ").map(String.init)
            let afterClass = String(match.4)
            
            // Accumulate all styles from all classes
            var combinedStyles: [String: String] = [:]
            for className in classNames {
                if let styles = classStyles[className] {
                    combinedStyles.merge(styles) { _, new in new }
                }
            }
            
            if !combinedStyles.isEmpty {
                // Convert CSS properties to direct SVG attributes (not style attribute)
                // SVGNative doesn't support style attributes, but does support direct attributes
                let attributeString = combinedStyles
                    .map { "\($0.key)=\"\($0.value)\"" }
                    .joined(separator: " ")
                
                // Build the replacement tag with direct attributes instead of class
                let replacement = "<\(tagName) \(beforeClass)\(attributeString)\(afterClass)>"
                
                // Replace this specific match
                result.replaceSubrange(match.range, with: replacement)
            }
        }
        
        // Remove <style> blocks since we've inlined everything
        result = removeStyleBlocks(from: result)
        
        return result
    }
    
    @available(iOS 16.0, macOS 13.0, *)
    private func extractCSSClasses(from svg: String) -> [String: [String: String]] {
        var classStyles: [String: [String: String]] = [:]
        
        // Match CSS class definitions: .className { property: value; ... }
        let classPattern = /\.([a-zA-Z0-9_-]+)\s*\{([^}]+)\}/
        
        for match in svg.matches(of: classPattern) {
            let className = String(match.1)
            let styleBlock = String(match.2)
            
            // Parse individual CSS properties
            let properties = parseCSSProperties(styleBlock)
            classStyles[className] = properties
        }
        
        return classStyles
    }
    
    @available(iOS 16.0, macOS 13.0, *)
    private func parseCSSProperties(_ cssBlock: String) -> [String: String] {
        var properties: [String: String] = [:]
        
        // Split by semicolons and parse each property
        let declarations = cssBlock.split(separator: ";")
        for declaration in declarations {
            let parts = declaration.split(separator: ":", maxSplits: 1)
            guard parts.count == 2 else { continue }
            
            let property = parts[0].trimmingCharacters(in: .whitespacesAndNewlines)
            let value = parts[1].trimmingCharacters(in: .whitespacesAndNewlines)
            
            if !property.isEmpty && !value.isEmpty {
                properties[property] = value
            }
        }
        
        return properties
    }
    
    @available(iOS 16.0, macOS 13.0, *)
    private func removeStyleBlocks(from svg: String) -> String {
        // Remove <style>...</style> blocks
        var result = svg
        // Use .dotMatchesNewlines to match across newlines
        let styleBlockPattern = Regex {
            "<style"
            ZeroOrMore(.reluctant) {
                CharacterClass.anyOf(">").inverted
            }
            ">"
            ZeroOrMore(.reluctant) {
                CharacterClass.any
            }
            "</style>"
        }
        .dotMatchesNewlines()
        
        while let match = result.firstMatch(of: styleBlockPattern) {
            result.removeSubrange(match.range)
        }
        
        return result
    }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

#Preview {
    SVGView(SVGData("""
    <?xml version="1.0" encoding="utf-8"?>
    <!-- Generator: Adobe Illustrator 27.9.0, SVG Export Plug-In . SVG Version: 6.00 Build 0)  -->
    <svg version="1.1" id="Layer_1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px"
         viewBox="0 0 655.3 350.9" style="enable-background:new 0 0 655.3 350.9;" xml:space="preserve">
    <style type="text/css">
        .st0{fill:#0071CE;}
        .st1{fill:#D7282F;}
    </style>
    <path class="st0" d="M361.2,186.6c51.3,0,92.7-41.5,92.8-92.7c0-51.2-41.5-92.7-92.7-92.7c-51.2,0-92.7,41.5-92.7,92.6
        C268.5,145.1,310,186.6,361.2,186.6 M325.5,93.8c0-19.7,16-35.7,35.8-35.7c19.8,0,35.8,16,35.8,35.8c0,19.8-16,35.8-35.8,35.8
        C341.5,129.7,325.5,113.6,325.5,93.8"/>
    <path class="st0" d="M526.1,179.7c10.8,4.5,22.7,6.9,35.1,6.9c51.2,0,92.7-41.5,92.7-92.7c0-51.2-41.5-92.7-92.7-92.7
        c-51.2,0-92.7,41.5-92.7,92.7l-0.1,135c0.1,15.8,12.8,28.6,28.7,28.6c15.8,0,28.5-12.8,28.6-28.6l0-49.3H526.1z M525.5,93.9
        c0-19.7,16-35.8,35.8-35.7c19.7,0,35.7,16,35.7,35.8c0,19.7-16,35.7-35.7,35.7C541.5,129.6,525.5,113.6,525.5,93.9"/>
    <path class="st0" d="M56.3,29c0-15.5-12.6-28.1-28.1-28.1C12.7,0.9,0.2,13.4,0,29l0,129.6c0.1,15.5,12.6,28.1,28.2,28.1
        c15.5,0,28.1-12.5,28.1-28.1L56.3,29z"/>
    <path class="st0" d="M137.2,115.6l0,43c0,15.5-12.7,28.1-28.3,28.1c-15.5,0-28-12.6-28.1-28.1l0-129.6C80.9,13.4,93.4,0.9,109,0.9
        c15.5,0,28.2,12.6,28.2,28.1v38.1h56.2V29c0-15.5,12.8-28.1,28.3-28.1c15.5,0,28,12.6,28.1,28.1l0,129.6
        c-0.1,15.5-12.6,28.1-28.2,28.1c-15.5,0-28.3-12.6-28.3-28.1l0-42.9L137.2,115.6z"/>
    <path class="st1" d="M461.4,350.9c-41.3,0-80.8-11.7-114.4-33.9c-36.2-23.9-63.4-59.1-78.8-101.8c-2.5-7,1.1-14.7,8.1-17.2
        c7-2.5,14.7,1.1,17.2,8.1c13.4,37.2,37,67.7,68.3,88.5c29.1,19.3,63.5,29.5,99.5,29.5c36,0,70.4-10.2,99.5-29.5
        c31.3-20.7,54.9-51.3,68.3-88.5c2.5-7,10.2-10.6,17.2-8.1c7,2.5,10.6,10.2,8.1,17.2c-15.4,42.7-42.6,77.8-78.8,101.8
        C542.2,339.1,502.7,350.9,461.4,350.9"/>
    <path class="st0" d="M645.3,9.9c1.2,0,1.9-0.7,1.9-1.6V8.3c0-1.1-0.7-1.6-1.9-1.6h-2.4v3.2H645.3z M640.5,5.8c0-0.7,0.5-1.2,1.2-1.2
        h3.7c1.5,0,2.6,0.4,3.4,1.2c0.6,0.6,0.9,1.4,0.9,2.4v0.1c0,1.7-0.9,2.8-2.2,3.3l1.8,2.2c0.2,0.3,0.3,0.5,0.3,0.8
        c0,0.7-0.5,1.2-1.1,1.2c-0.5,0-0.7-0.1-1-0.5l-2.5-3.2h-2v2.5c0,0.7-0.6,1.2-1.2,1.2c-0.7,0-1.2-0.5-1.2-1.2V5.8z M653.9,10.4
        L653.9,10.4c0-5.1-3.9-9.2-9.1-9.2c-5.2,0-9.2,4.1-9.2,9.2v0.1c0,5.1,3.9,9.2,9.1,9.2C649.9,19.6,653.9,15.4,653.9,10.4 M634.4,10.4
        L634.4,10.4C634.4,4.7,639,0,644.8,0c5.8,0,10.3,4.7,10.3,10.3v0.1c0,5.6-4.6,10.4-10.4,10.4C638.9,20.7,634.4,16.1,634.4,10.4"/>
    </svg>
    """)!).frame(width: 150, height: 150)
    
    SVGView(SVGData("""
    <svg viewBox='0 0 105 93' xmlns='http://www.w3.org/2000/svg'>
    <path d='M66,0h39v93zM38,0h-38v93zM52,35l25,58h-16l-8-18h-18z' fill='#ED1C24'/>
    </svg>
    """)!).frame(width: 150, height: 150)
}

#endif

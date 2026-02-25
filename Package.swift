// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "SwiftSVG",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15),
        .tvOS(.v13),
        .watchOS(.v6)
    ],
    products: [
        .library(
            name: "SwiftSVG",
            targets: ["SwiftSVG"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/MillerTechnologyPeru/svgnative-swift.git",
            branch: "feature/swift-6"
        )
    ],
    targets: [
        .target(
            name: "SwiftSVG",
            dependencies: [
                .product(
                    name: "SVGNative",
                    package: "svgnative-swift"
                )
            ],
        ),
        .testTarget(
            name: "SwiftSVGTests",
            dependencies: ["SwiftSVG"]
        )
    ]
)

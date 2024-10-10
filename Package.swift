// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "TunnelKit",
    platforms: [
        .iOS(.v15),
        .macOS(.v12),
        .tvOS(.v17)
    ],
    products: [
        .library(
            name: "TunnelKit",
            targets: ["TunnelKit"]
        ),
        .library(
            name: "TunnelKitOpenVPN",
            targets: ["TunnelKitOpenVPN"]
        ),
        .library(
            name: "TunnelKitOpenVPNAppExtension",
            targets: ["TunnelKitOpenVPNAppExtension"]
        ),
        .library(
            name: "TunnelKitWireGuard",
            targets: ["TunnelKitWireGuard"]
        ),
        .library(
            name: "TunnelKitWireGuardAppExtension",
            targets: ["TunnelKitWireGuardAppExtension"]
        ),
        .library(
            name: "TunnelKitLZO",
            targets: ["TunnelKitLZO"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/SwiftyBeaver/SwiftyBeaver", from: "1.9.0"),
        .package(url: "https://github.com/krzyzanowskim/OpenSSL-Package.git", from: "3.3.2000"),
        .package(url: "https://github.com/passepartoutvpn/wireguard-apple", revision: "b79f0f150356d8200a64922ecf041dd020140aa0")
    ],
    targets: [
        .target(
            name: "TunnelKit",
            dependencies: [
                "TunnelKitCore",
                "TunnelKitManager"
            ]
        ),
        .target(
            name: "TunnelKitCore",
            dependencies: [
                "__TunnelKitUtils",
                "CTunnelKitCore",
                "SwiftyBeaver"
            ]
        ),
        .target(
            name: "TunnelKitManager",
            dependencies: [
                "SwiftyBeaver"
            ]
        ),
        .target(
            name: "TunnelKitAppExtension",
            dependencies: [
                "TunnelKitCore"
            ]
        ),
        .target(
            name: "TunnelKitOpenVPN",
            dependencies: [
                "TunnelKitOpenVPNCore",
                "TunnelKitOpenVPNManager"
            ]
        ),
        .target(
            name: "TunnelKitOpenVPNCore",
            dependencies: [
                "TunnelKitCore",
                "CTunnelKitOpenVPNCore",
                "CTunnelKitOpenVPNProtocol"
            ]
        ),
        .target(
            name: "TunnelKitOpenVPNManager",
            dependencies: [
                "TunnelKitManager",
                "TunnelKitOpenVPNCore"
            ]
        ),
        .target(
            name: "TunnelKitOpenVPNProtocol",
            dependencies: [
                "TunnelKitOpenVPNCore",
                "CTunnelKitOpenVPNProtocol",
                .product(name: "OpenSSL", package: "OpenSSL-Package") // Correct product reference
            ]
        ),
        .target(
            name: "TunnelKitOpenVPNAppExtension",
            dependencies: [
                "TunnelKitAppExtension",
                "TunnelKitOpenVPNCore",
                "TunnelKitOpenVPNManager",
                "TunnelKitOpenVPNProtocol"
            ]
        ),
        .target(
            name: "TunnelKitWireGuard",
            dependencies: [
                "TunnelKitWireGuardCore",
                "TunnelKitWireGuardManager"
            ]
        ),
        .target(
            name: "TunnelKitWireGuardCore",
            dependencies: [
                "__TunnelKitUtils",
                "TunnelKitCore",
                .product(name: "WireGuardKit", package: "wireguard-apple"),
                "SwiftyBeaver"
            ]
        ),
        .target(
            name: "TunnelKitWireGuardManager",
            dependencies: [
                "TunnelKitManager",
                "TunnelKitWireGuardCore"
            ]
        ),
        .target(
            name: "TunnelKitWireGuardAppExtension",
            dependencies: [
                "TunnelKitWireGuardCore",
                "TunnelKitWireGuardManager"
            ]
        ),
        .target(
            name: "TunnelKitLZO",
            dependencies: [],
            exclude: [
                "lib/COPYING",
                "lib/Makefile",
                "lib/README.LZO",
                "lib/testmini.c"
            ]
        ),
        .target(
            name: "CTunnelKitCore",
            dependencies: []
        ),
        .target(
            name: "CTunnelKitOpenVPNCore",
            dependencies: []
        ),
        .target(
            name: "CTunnelKitOpenVPNProtocol",
            dependencies: [
                "CTunnelKitCore",
                "CTunnelKitOpenVPNCore",
                .product(name: "OpenSSL", package: "OpenSSL-Package") // Ensure OpenSSL is referenced properly
            ]
        ),
        .target(
            name: "__TunnelKitUtils",
            dependencies: []
        ),
        .testTarget(
            name: "TunnelKitCoreTests",
            dependencies: [
                "TunnelKitCore"
            ],
            exclude: [
                "RandomTests.swift",
                "RawPerformanceTests.swift",
                "RoutingTests.swift"
            ]
        ),
        .testTarget(
            name: "TunnelKitOpenVPNTests",
            dependencies: [
                "TunnelKitOpenVPNCore",
                "TunnelKitOpenVPNAppExtension",
                "TunnelKitLZO"
            ],
            exclude: [
                "DataPathPerformanceTests.swift",
                "EncryptionPerformanceTests.swift"
            ],
            resources: [
                .process("Resources")
            ]
        ),
        .testTarget(
            name: "TunnelKitLZOTests",
            dependencies: [
                "TunnelKitCore",
                "TunnelKitLZO"
            ]
        )
    ]
)

// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "rapier_physics",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(name: "rapier-physics", targets: ["rapier_physics"])
    ],
    dependencies: [
        .package(name: "FlutterFramework", path: "../FlutterFramework")
    ],
    targets: [
        .target(
            name: "rapier_physics",
            dependencies: [
                "rapier_ffi",
                .product(name: "FlutterFramework", package: "FlutterFramework")
            ],
            linkerSettings: [
                // Rapier (Rust) links against the C++ standard library
                .linkedLibrary("c++"),
                // Force-load all symbols from the static lib so Dart FFI
                // can resolve them at runtime even in release builds.
                // Note: unsafeFlags makes this package unsafe for direct SPM
                // dependency use, which is acceptable for Flutter plugins.
                .unsafeFlags(["-all_load"]),
            ]
        ),
        .binaryTarget(
            name: "rapier_ffi",
            path: "rapier_ffi.xcframework"
        ),
    ]
)

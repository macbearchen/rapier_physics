// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "rapier_physics",
    platforms: [
        .macOS(.v10_15)
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
                // -all_load on the SPM target ensures the static lib symbols
                // survive SPM's own link step. The Runner project also adds
                // -force_load librapier_ffi_macos.a via OTHER_LDFLAGS so that
                // DEAD_CODE_STRIPPING=YES cannot strip Rust FFI symbols that
                // are only resolved at runtime by Dart's DynamicLibrary.process().
                .unsafeFlags(["-all_load"]),
            ]
        ),
        .binaryTarget(
            name: "rapier_ffi",
            path: "rapier_ffi.xcframework"
        ),
    ]
)

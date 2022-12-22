// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Platform",
    products: [
        .library(
            name: "LampNetwork",
            targets: ["LampNetwork"]
        ),
        .library(
            name: "AuthManager",
            targets: ["AuthManager"]
        ),
        .library(
            name: "LanguageManager",
            targets: ["LanguageManager"]
        ),
        .library(
            name: "HapticManager",
            targets: ["HapticManager"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", branch: "master")
    ],
    targets: [
        .target(
            name: "LampNetwork",
            dependencies: [
                "Alamofire",
                "AuthManager",
                "LanguageManager"
            ]
        ),
        .target(
            name: "AuthManager",
            dependencies: []
        ),
        .target(
            name: "LanguageManager",
            dependencies: []
        ),
        .target(
            name: "HapticManager",
            dependencies: []
        )
    ]
)

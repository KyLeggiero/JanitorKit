// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription



let package = Package(
    name: "JanitorKit",
    
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13),
        .tvOS(.v13),
        .watchOS(.v6),
    ],
    
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "JanitorKit",
            targets: ["JanitorKit"]),
    ],
    
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(name: "FunctionTools", url: "https://github.com/RougeWare/Swift-Function-Tools", from: "1.2.0"),
        .package(name: "PropertyWrapperProtocol", url: "https://github.com/RougeWare/Swift-PropertyWrapper-Protocol.git", from: "2.0.0"),
        .package(url: "https://github.com/RougeWare/Swift-Lazy-Patterns.git", from: "4.0.0"),
        .package(url: "https://github.com/RougeWare/Swift-Safe-Pointer.git", from: "2.0.0"),
        .package(url: "https://github.com/RougeWare/Swift-Cross-Kit-Types.git", from: "1.0.0"),
        .package(url: "https://github.com/RougeWare/Swift-Rectangle-Tools.git", from: "2.5.0"),
        .package(url: "https://github.com/BenLeggiero/Swift-Drawing-Tools.git", from: "1.1.1"),
        .package(url: "https://github.com/RougeWare/AttributedStringBuilder.git", .branch("develop")),
        .package(url: "https://github.com/RougeWare/Swift-TODO.git", from: "1.1.0"),
        .package(url: "https://github.com/RougeWare/Swift-Atomic.git", from: "0.0.0"),
        .package(name: "SimpleLogging", url: "https://github.com/RougeWare/Swift-Simple-Logging.git", .upToNextMinor(from: "0.4.4")),
    ],
    
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "JanitorKit",
            dependencies: [
                "FunctionTools",
                "PropertyWrapperProtocol",
                "SimpleLogging"
            ]),
        .testTarget(
            name: "JanitorKitTests",
            dependencies: ["JanitorKit"]),
    ]
)

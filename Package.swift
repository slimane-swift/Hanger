import PackageDescription

let package = Package(
    name: "Hanger",
    dependencies: [
        .Package(url: "https://github.com/noppoMan/Suv.git", majorVersion: 0, minor: 5),
        .Package(url: "https://github.com/noppoman/HTTPParser", majorVersion: 0, minor: 8),
        .Package(url: "https://github.com/noppoMan/HTTP.git", majorVersion: 0, minor: 7)
    ]
)

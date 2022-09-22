import Foundation

// MARK: - WelcomeElement
struct Model: Codable {
    let name: String
    let photo: String
}

typealias Welcome = [Model]

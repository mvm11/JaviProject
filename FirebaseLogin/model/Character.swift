import Foundation

// MARK: - WelcomeElement
struct Character: Codable {
    let name: String
    let photo: String
}

typealias CharacterList = [Character]

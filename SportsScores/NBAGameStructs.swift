// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let gameDecodable = try? newJSONDecoder().decode(GameDecodable.self, from: jsonData)

import Foundation

// MARK: - GameDecodable
struct PlayoffGameDecodable: Codable {
    let competitions: [Competition] //needed
    let status: Status //needed
}

// MARK: - Competition
struct Competition: Codable {
    let competitors: [CompetitionCompetitor] //needed
    let notes: [Note] //needed]
}

// MARK: - CompetitionCompetitor
struct CompetitionCompetitor: Codable {
    let team: Team
    let score: String
}
// MARK: - Team
struct Team: Codable {
    let shortDisplayName: String
    let logo: String
}

// MARK: - Note
struct Note: Codable {
    let type, headline: String
}

// MARK: - Status
struct Status: Codable {
    let displayClock: String
    let period: Int
    let type: StatusType
}

// MARK: - StatusType
struct StatusType: Codable {
    let completed: Bool
    let typeDescription, shortDetail: String

    enum CodingKeys: String, CodingKey {
        case completed
        case typeDescription = "description"
        case shortDetail
    }
}

//
//  NFLData.swift
//  SportsScores
//
//  Created by Kazim Walji on 7/28/21.
//

import Foundation

struct NFLData {
    static func getData(date: Date) throws -> [PlayoffGameDecodable]? {
        do {
            var month = String(date.get(Calendar.Component.month))
            if date.get(Calendar.Component.month) < 10 {
                month = "0" + month
            }
            var day = String(date.get(Calendar.Component.day))
            if date.get(Calendar.Component.day) < 10 {
                day = "0" + day
            }
            guard let url = URL(string: "http://site.api.espn.com/apis/site/v2/sports/basketball/nba/scoreboard?dates=" + String(date.get(Calendar.Component.year)) + month + day) else { throw ErrorType.invalidURL}
            let data = try Data(contentsOf: url)
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                if let object = json as? [String : Any], let events = object["events"] as? [[String:Any]] {
                    var games: [PlayoffGameDecodable] = []
                    for event in events {
                        if let id = event["id"] as? String, let game = getGame(id: id) {
                            if !(game.status.type.typeDescription.lowercased() == "postponed") {
                            games.append(game)
                            }
                        }
                    }
                    return games
                }
            } else {
                throw ErrorType.json
            }
            throw ErrorType.unkown
    }
    catch {
    print("catch", error)
    throw error
    }
}
}

//
//  NbaData.swift
//  SportsScores
//
//  Created by Kazim Walji on 6/22/21.
//

import Foundation

enum ErrorType: Error {
    case invalidURL
    case json
    case unkown
}

struct Links {
    static let nba = "http://site.api.espn.com/apis/site/v2/sports/basketball/nba/scoreboard?dates="
    static let nbaGame = "http://site.api.espn.com/apis/site/v2/sports/basketball/nba/scoreboard/"
    static let nfl = "http://site.api.espn.com/apis/site/v2/sports/football/nfl/scoreboard?dates="
    static let nflGame = "http://site.api.espn.com/apis/site/v2/sports/football/nfl/scoreboard/"
    static let nflWeek = "http://site.api.espn.com/apis/site/v2/sports/football/nfl/scoreboard?week="
}

struct APIData {
    static func getNbaData(date: Date) throws -> [PlayoffGameDecodable]? {
        do {
            var month = String(date.get(Calendar.Component.month))
            if date.get(Calendar.Component.month) < 10 {
                month = "0" + month
            }
            var day = String(date.get(Calendar.Component.day))
            if date.get(Calendar.Component.day) < 10 {
                day = "0" + day
            }
            guard let url = URL(string: Links.nba + String(date.get(Calendar.Component.year)) + month + day) else {
                print("invalid url")
                throw ErrorType.invalidURL}
            
            let data = try Data(contentsOf: url)
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            guard let object = json as? [String : Any], let events = object["events"] as? [[String:Any]] else { throw ErrorType.json }
            var games: [PlayoffGameDecodable] = []
            for event in events {
                guard let id = event["id"] as? String, let game = getGame(id: id, urlString: Links.nbaGame) else {
                    throw ErrorType.json
                }
                if !(game.status.type.typeDescription.lowercased() == "postponed") {
                    games.append(game)
                }
            }
            return games
        }
        catch {
            print("catch", error.localizedDescription, error)
            throw error
        }
    }
    
    static func getNFLData(week: Int) -> [PlayoffGameDecodable]? {
            let urlString = Links.nflWeek + String(week)
            guard let url = URL(string: urlString) else {
                print("invalid url")
                return nil}
            
        guard let data = try? Data(contentsOf: url) else { return nil }
            let json = try? JSONSerialization.jsonObject(with: data, options: [])
            guard let object = json as? [String : Any], let events = object["events"] as? [[String:Any]] else { return nil }
            var games: [PlayoffGameDecodable] = []
            for event in events {
                guard let id = event["id"] as? String, let game = getGame(id: id, urlString: Links.nflGame) else {
                    return nil
                }
                if !(game.status.type.typeDescription.lowercased() == "postponed") {
                    games.append(game)
                }
            }
            return games
    }
    static func getGame(id: String, urlString: String) -> PlayoffGameDecodable? {
        let domain = urlString + id
        guard let url = URL(string: domain) else {
            return nil }
        guard let data = try? Data(contentsOf: url) else {
            return nil}
        do {
            let game = try JSONDecoder().decode(PlayoffGameDecodable.self, from: data)
            return game
        } catch {
            print("cant parse game", error.localizedDescription)
        }
        return nil
    }
    
    static func getNBACalendar() throws -> [Date]? {
        do {
            guard let url = URL(string: Links.nba) else { throw ErrorType.invalidURL}
            let data = try Data(contentsOf: url)
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                if let object = json as? [String : Any], let leagues = object["leagues"] as? [[String:Any]] {
                    if let calendar = leagues[0]["calendar"] as? [String] {
                        var dateCalendar: [Date] = []
                        for date in calendar {
                            guard let index = date.lastIndex(of: "T") else {throw ErrorType.json}
                            let newDate: String? = String(date.prefix(upTo: index))
                            if let dateFromString = getDate(dateString:  newDate ?? "") {
                                dateCalendar.append(dateFromString)
                            }
                        }
                        return dateCalendar
                    }
                }
            } else {
                throw ErrorType.json
            }
            throw ErrorType.unkown
        }
        catch {
            print("catch", error.localizedDescription)
            throw error
        }
    }
    
    static func getWeek() -> Int {
        do {
        guard let url = URL(string: Links.nfl) else { throw ErrorType.invalidURL}
        let data = try Data(contentsOf: url)
        if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
            if let object = json as? [String : Any], let week = object["week"] as? [String:Int] {
                return week["number"] ?? 1
            }
        }
        }
        catch {
            return 1
        }
        return 1
    }
    
    static func getNFLCalendar() throws -> [Date]? {
        do {
            guard let url = URL(string: Links.nfl) else { throw ErrorType.invalidURL}
            let data = try Data(contentsOf: url)
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                if let object = json as? [String : Any], let leagues = object["leagues"] as? [[String:Any]] {
                    if let regularSeason = leagues[0]["calendar"] as? [[String:Any]], let entries = regularSeason[1]["entries"] as? [[String:Any]] {
                        var dateCalendar: [Date] = []
                        for entry in entries {
                            guard let date: String = entry["startDate"] as? String else { throw ErrorType.json }
                            guard let index = date.lastIndex(of: "T") else {throw ErrorType.json}
                            let newDate: String? = String(date.prefix(upTo: index))
                            if let dateFromString = getDate(dateString:  newDate ?? "") {
                                dateCalendar.append(dateFromString)
                            }
                        }
                        return dateCalendar
                    }
                }
            } else {
                throw ErrorType.json
            }
            throw ErrorType.unkown
        }
        catch {
            print("catch", error.localizedDescription)
            throw error
        }
    }
    
    static func getDate(dateString: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current
        return dateFormatter.date(from: dateString)
    }
}

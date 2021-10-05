////
////  Game.swift
////  SportsScores
////
////  Created by Kazim Walji on 6/22/21.
////
//
import Foundation
import UIKit


public struct LeagueModel {
    var games: [PlayoffGameDecodable] = []
    var calendar: [Date] = []
    var nba: Bool
    
    init(nba: Bool) {
        self.nba = nba
        getDates()
        getGames(date: Date())
    }
    
    mutating func getDates() {
        do {
            if nba {
                if let newCalendar = try APIData.getNBACalendar() {
                    self.calendar = newCalendar
                }
            } else {
                if let newCalendar = try APIData.getNFLCalendar() {
                    self.calendar = newCalendar
                }
            } }
        catch {
            print("error", error.localizedDescription)
        }
    }
    
    mutating func getGames(date: Date) {
        do {
            if (nba) {
            if let allGames = try APIData.getNbaData(date: date) {
                self.games = allGames
            }
            } else {
                if let allGames = APIData.getNFLData(week: APIData.getWeek()) {
                    self.games = allGames
                }
            }
        }
        catch {
            print("error", error.localizedDescription)
        }
    }
    
    mutating func getGames(week: Int) {
            if let allGames = APIData.getNFLData(week: week) {
                    self.games = allGames
                }
    }
    
    mutating func getGames() {
        if let allGames = APIData.getNFLData(week: APIData.getWeek()) {
                    self.games = allGames
                }
    }
}
public class Game {
    var homeImageView = UIImageView()
    var awayImageView = UIImageView()
    var homeScore = "0"
    var awayScore = "0"
    var playoffDescription = ""
    var homeName = ""
    var awayName = ""
    var quarter = 0
    var inProgress = false
    var description = ""
    var postponed = false
    var ended = false
    var time = -1.0
    init(game: PlayoffGameDecodable) {
        let competitors = game.competitions[0].competitors
        let homeTeam = competitors[0].team
        let awayTeam = competitors[1].team
        self.homeImageView.downloaded(from: homeTeam.logo)
        self.awayImageView.downloaded(from: awayTeam.logo)
        let notes = game.competitions[0].notes
        if notes.count > 0 {
            self.playoffDescription = notes[0].headline
        }
        self.homeName = homeTeam.shortDisplayName
        self.awayName = awayTeam.shortDisplayName
        self.homeScore = competitors[0].score
        self.awayScore = competitors[1].score
        self.quarter = game.status.period
        if self.quarter > 0 && !game.status.type.completed {
            self.inProgress = true
            self.description = ""
            self.time = Double(game.status.displayClock) ?? -1.0
        } else {
            if self.quarter >= 4 {
                self.description = game.status.type.typeDescription
                self.ended = true
            } else {
                var description = game.status.type.shortDetail
                if description.firstIndex(of: "-") != nil {
                    description = String(description.suffix(from: description.firstIndex(of: "-")!))
                    description = String(description.suffix(from: String.Index(utf16Offset: 2, in: description)))
                    description = String(description.prefix(upTo: description.lastIndex(of: " ")!))
                } else if description == "Postponed" {
                    self.postponed = true
                }
                self.description = description
                self.time = -1.0
            }
        }
        
    }
    
}

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {  // for swift 4.2 syntax just use ===> mode: UIView.ContentMode
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                var image = UIImage(data: data)
            else { return }
            DispatchQueue.main.async() {
                image = image.scalePreservingAspectRatio(targetSize: CGSize(width: 60, height: 60))
                self.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {  // for swift 4.2 syntax just use ===> mode: UIView.ContentMode
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}

extension Date {
    func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
        return calendar.dateComponents(Set(components), from: self)
    }
    
    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }
}

class createDate {
    
    class func from(year: Int, month: Int, day: Int) -> Date {
        let gregorianCalendar = NSCalendar(calendarIdentifier: .gregorian)!
        
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        
        let date = gregorianCalendar.date(from: dateComponents)!
        return date
    }
}


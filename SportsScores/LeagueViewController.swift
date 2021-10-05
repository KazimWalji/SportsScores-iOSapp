//
//  LeagueViewController.swift
//  SportsScores
//
//  Created by Kazim Walji on 8/3/21.
//

import Foundation
import UIKit

open class LeagueViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var viewModel: LeagueModel
    var calendarView: UICollectionView! = nil
    var tableView: UITableView! = nil
    var loaded = false
    var selectedIndex = 0
    
    override open func viewDidLoad() {
        super.viewDidLoad()
    
        let layout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .horizontal
        
        calendarView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        calendarView.showsHorizontalScrollIndicator = false
        calendarView.isPagingEnabled = true
        calendarView.isDirectionalLockEnabled = true
        calendarView.delegate = self
        calendarView.dataSource = self
        calendarView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "MyCell")
        calendarView.backgroundColor = .white
        self.view.addSubview(calendarView)
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        let calendarConstraints = [calendarView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0), calendarView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 10), calendarView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -10), calendarView.heightAnchor.constraint(equalToConstant: 45)]
        NSLayoutConstraint.activate(calendarConstraints)
        selectedIndex = viewModel.calendar.count/2
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        let tableViewConstraints = [tableView.topAnchor.constraint(equalTo: calendarView.bottomAnchor), tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -100), tableView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0), tableView.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: 0)]
        NSLayoutConstraint.activate(tableViewConstraints)
    }
    
    public init(viewModel: LeagueModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.games.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        let game = Game(game: viewModel.games[indexPath.row])
        
        let homeImageView = game.homeImageView
        cell.addSubview(homeImageView)
        homeImageView.translatesAutoresizingMaskIntoConstraints = false
        
        if game.playoffDescription != "" {
            let descriptionLabel = UILabel()
            descriptionLabel.text = game.playoffDescription
            descriptionLabel.font = UIFont(name: "Avenir-Medium", size: 15)
            descriptionLabel.textColor = .black
            
            descriptionLabel.textAlignment = .center
            cell.addSubview(descriptionLabel)
            descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
            let descriptionConstraints = [descriptionLabel.topAnchor.constraint(equalTo: cell.topAnchor,constant: 10), descriptionLabel.centerXAnchor.constraint(equalTo: cell.centerXAnchor), descriptionLabel.widthAnchor.constraint(equalTo: cell.widthAnchor), descriptionLabel.heightAnchor.constraint(equalToConstant: 20)]
            NSLayoutConstraint.activate(descriptionConstraints)
            
            let homeImageConstraints = [homeImageView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 10), homeImageView.widthAnchor.constraint(equalToConstant: 60), homeImageView.heightAnchor.constraint(equalToConstant: 60), homeImageView.leadingAnchor.constraint(equalTo: cell.leadingAnchor, constant: 40)]
            NSLayoutConstraint.activate(homeImageConstraints)
        } else {
            let homeImageConstraints = [homeImageView.topAnchor.constraint(equalTo: cell.topAnchor, constant: 30), homeImageView.widthAnchor.constraint(equalToConstant: 60), homeImageView.heightAnchor.constraint(equalToConstant: 60), homeImageView.leadingAnchor.constraint(equalTo: cell.leadingAnchor, constant: 40)]
            NSLayoutConstraint.activate(homeImageConstraints)
        }
        let homeTeamLabel = UILabel()
        homeTeamLabel.text = game.homeName
        homeTeamLabel.font = UIFont(name: "Avenir-Medium", size: 15)
        homeTeamLabel.textAlignment = .center
        homeTeamLabel.textColor = .black
        homeTeamLabel.baselineAdjustment = .alignCenters
        cell.addSubview(homeTeamLabel)
        homeTeamLabel.translatesAutoresizingMaskIntoConstraints = false
        let homeTeamLabelConstraints = [homeTeamLabel.topAnchor.constraint(equalTo: homeImageView.bottomAnchor, constant: 5), homeTeamLabel.centerXAnchor.constraint(equalTo: homeImageView.centerXAnchor), homeTeamLabel.widthAnchor.constraint(equalToConstant: 140), homeTeamLabel.heightAnchor.constraint(equalToConstant: 20)]
        NSLayoutConstraint.activate(homeTeamLabelConstraints)
        
        let awayImageView = game.awayImageView
        cell.addSubview(awayImageView)
        awayImageView.translatesAutoresizingMaskIntoConstraints = false
        let awayImageConstraints = [awayImageView.topAnchor.constraint(equalTo: homeImageView.topAnchor), awayImageView.widthAnchor.constraint(equalToConstant: 60), awayImageView.heightAnchor.constraint(equalToConstant: 60), awayImageView.trailingAnchor.constraint(equalTo: cell.trailingAnchor, constant: -40)]
        NSLayoutConstraint.activate(awayImageConstraints)
        
        let awayTeamLabel = UILabel()
        awayTeamLabel.text = game.awayName
        awayTeamLabel.font = UIFont(name: "Avenir-Medium", size: 15)
        awayTeamLabel.textAlignment = .center
        awayTeamLabel.textColor = .black
        awayTeamLabel.baselineAdjustment = .alignCenters
        cell.addSubview(awayTeamLabel)
        awayTeamLabel.translatesAutoresizingMaskIntoConstraints = false
        let awayTeamLabelConstraints = [awayTeamLabel.topAnchor.constraint(equalTo: awayImageView.bottomAnchor, constant: 5), awayTeamLabel.centerXAnchor.constraint(equalTo: awayImageView.centerXAnchor), awayTeamLabel.widthAnchor.constraint(equalToConstant: 140), awayTeamLabel.heightAnchor.constraint(equalToConstant: 20)]
        NSLayoutConstraint.activate(awayTeamLabelConstraints)
        
        if !game.ended {
            let timeLabel = UILabel()
            timeLabel.font = UIFont(name: "Arial-BoldMT", size: 30)
            timeLabel.textColor = .black
            timeLabel.text = ESTToLocal(dateStr: game.description)
            timeLabel.textAlignment = .center
            cell.addSubview(timeLabel)
            timeLabel.translatesAutoresizingMaskIntoConstraints = false
            let timeConstraints = [timeLabel.centerXAnchor.constraint(equalTo: cell.centerXAnchor), timeLabel.widthAnchor.constraint(equalToConstant: 150), timeLabel.centerYAnchor.constraint(equalTo: homeImageView.centerYAnchor), timeLabel.heightAnchor.constraint(equalToConstant: 35)]
            NSLayoutConstraint.activate(timeConstraints)
        } else {
            let homeTeamScore = UILabel()
            homeTeamScore.font = UIFont(name: "Arial-BoldMT", size: 30)
            homeTeamScore.textColor = .black
            homeTeamScore.text = String(game.homeScore)
            homeTeamScore.textAlignment = .center
            cell.addSubview(homeTeamScore)
            homeTeamScore.translatesAutoresizingMaskIntoConstraints = false
            let homeScoreConstraints = [homeTeamScore.leadingAnchor.constraint(equalTo: homeImageView.trailingAnchor, constant: 0), homeTeamScore.widthAnchor.constraint(equalToConstant: 65), homeTeamScore.centerYAnchor.constraint(equalTo: homeImageView.centerYAnchor), homeTeamScore.heightAnchor.constraint(equalToConstant: 35)]
            NSLayoutConstraint.activate(homeScoreConstraints)
            
            let awayTeamScore = UILabel()
            awayTeamScore.font = UIFont(name: "Arial-BoldMT", size: 30)
            awayTeamScore.textColor = .black
            awayTeamScore.text = String(game.awayScore)
            awayTeamScore.textAlignment = .center
            cell.addSubview(awayTeamScore)
            awayTeamScore.translatesAutoresizingMaskIntoConstraints = false
            let awayScoreConstraints = [awayTeamScore.trailingAnchor.constraint(equalTo: awayImageView.leadingAnchor, constant: 0), awayTeamScore.widthAnchor.constraint(equalToConstant: 65), awayTeamScore.centerYAnchor.constraint(equalTo: awayImageView.centerYAnchor), awayTeamScore.heightAnchor.constraint(equalToConstant: 35)]
            NSLayoutConstraint.activate(awayScoreConstraints)
            
            if !game.inProgress {
                let finalLabel = UILabel()
                finalLabel.text = game.description
                finalLabel.font = UIFont(name: "PingFangSC-Regular", size: 15)
                finalLabel.textAlignment = .center
                finalLabel.textColor = .black
                cell.addSubview(finalLabel)
                finalLabel.translatesAutoresizingMaskIntoConstraints = false
                let finalLabelConstraints = [finalLabel.leadingAnchor.constraint(equalTo: homeTeamScore.trailingAnchor), finalLabel.trailingAnchor.constraint(equalTo: awayTeamScore.leadingAnchor), finalLabel.centerYAnchor.constraint(equalTo: homeTeamScore.centerYAnchor), finalLabel.heightAnchor.constraint(equalToConstant: 20)]
                NSLayoutConstraint.activate(finalLabelConstraints)
            } else {
                let finalLabel = UILabel()
                finalLabel.text = "Q " + String(game.quarter) + String(game.time)
                finalLabel.font = UIFont(name: "PingFangSC-Regular", size: 15)
                finalLabel.textAlignment = .center
                finalLabel.textColor = .black
                cell.addSubview(finalLabel)
                finalLabel.translatesAutoresizingMaskIntoConstraints = false
                let finalLabelConstraints = [finalLabel.leadingAnchor.constraint(equalTo: homeTeamScore.trailingAnchor), finalLabel.trailingAnchor.constraint(equalTo: awayTeamScore.leadingAnchor), finalLabel.centerYAnchor.constraint(equalTo: homeTeamScore.centerYAnchor), finalLabel.heightAnchor.constraint(equalToConstant: 20)]
                NSLayoutConstraint.activate(finalLabelConstraints)
            }
        }
        cell.backgroundColor = .white
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (self.viewModel.nba) {
        return viewModel.calendar.count
        } else {
            return 18
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCell", for: indexPath)
        for view in cell.subviews {
            view.removeFromSuperview()
        }
        
        let timeLabel = UILabel()
        if (self.viewModel.nba) {
        timeLabel.text =  DateFormatter().monthSymbols[viewModel.calendar[indexPath.row].get(Calendar.Component.month) - 1].prefix(3) + " " + String(viewModel.calendar[indexPath.row].get(Calendar.Component.day))
        } else {
            timeLabel.text = "Week " + String(indexPath.row + 1)
        }
        if viewModel.nba {
        timeLabel.font = UIFont(name: "Arial-BoldMT", size: 15)
        } else {
            timeLabel.font = UIFont(name: "Arial-BoldMT", size: 13)
        }
        timeLabel.textAlignment = .center
        cell.addSubview(timeLabel)
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        let timeLabelConstraints = [timeLabel.centerYAnchor.constraint(equalTo: cell.centerYAnchor), timeLabel.centerXAnchor.constraint(equalTo: cell.centerXAnchor), timeLabel.widthAnchor.constraint(equalTo: cell.widthAnchor), timeLabel.heightAnchor.constraint(equalTo: cell.heightAnchor)]
        NSLayoutConstraint.activate(timeLabelConstraints)
        cell.frame.size = CGSize(width: 60.0, height: 50.0)
        return cell
    }
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if selectedIndex != indexPath.row {
            selectedIndex = indexPath.row
            if (viewModel.nba) {
            let date = createDate.from(year: viewModel.calendar[indexPath.row].get(Calendar.Component.year), month: viewModel.calendar[indexPath.row].get(Calendar.Component.month), day: viewModel.calendar[indexPath.row].get(Calendar.Component.day))
            viewModel.getGames(date: date)
            } else {
                viewModel.getGames(week: indexPath.row + 1)
            }
            self.tableView.reloadData()
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if !loaded {
            loaded = true
            if (self.viewModel.nba) {
            let today = Date()
            var found = false
            for (i, date) in viewModel.calendar.enumerated() {
                if date.get(Calendar.Component.month) == today.get(Calendar.Component.month) && date.get(Calendar.Component.day) == today.get(Calendar.Component.day){
                    found = true
                    selectedIndex = i
                    calendarView.scrollToItem(at: IndexPath(row: i, section: 0), at: .left, animated: false)
                    self.tableView.reloadData()
                }
                break
            }
            if !found {
                if let closestDate = viewModel.calendar.sorted().first(where: {$0.timeIntervalSinceNow > 0}) {
                    selectedIndex = viewModel.calendar.lastIndex(of: closestDate) ?? 0
                    calendarView.scrollToItem(at: IndexPath(row: selectedIndex, section: 0), at: .left, animated: false)
                } else {
                    selectedIndex = viewModel.calendar.count - 1
                    print(index)
                    calendarView.scrollToItem(at: IndexPath(row: selectedIndex, section: 0), at: .left, animated: false)
                }
                    let closestDate = viewModel.calendar[selectedIndex]
                        viewModel.getGames(date: closestDate)
                        self.tableView.reloadData()
            }
            } else {
                calendarView.scrollToItem(at: IndexPath(row: APIData.getWeek()-1, section: 0), at: .left, animated: false)
                self.tableView.reloadData()
            }
        }
    }
    
    func ESTToLocal(dateStr: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        dateFormatter.calendar = Calendar.current
        dateFormatter.timeZone = TimeZone(abbreviation: "EST")
        
        if let date = dateFormatter.date(from: dateStr) {
            dateFormatter.timeZone = TimeZone.current
            dateFormatter.dateFormat = "h:mm a"
            
            return dateFormatter.string(from: date)
        }
        return nil
    }
    
}

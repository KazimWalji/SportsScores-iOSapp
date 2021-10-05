//
//  TestViewController.swift
//  SportsScores
//
//  Created by Kazim Walji on 8/3/21.
//

import UIKit

class TestViewController: LeagueViewController {

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let games = APIData.getNFLData(week: indexPath.row + 1) {
            super.viewModel.games = games
            super.tableView.reloadData()
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCell", for: indexPath)
        for view in cell.subviews {
            view.removeFromSuperview()
        }
        
        let timeLabel = UILabel()
        timeLabel.text = "Week " + String(indexPath.row + 1)
        
        timeLabel.font = UIFont(name: "Arial-BoldMT", size: 15)
        timeLabel.textAlignment = .center
        cell.addSubview(timeLabel)
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        let timeLabelConstraints = [timeLabel.centerYAnchor.constraint(equalTo: cell.centerYAnchor), timeLabel.centerXAnchor.constraint(equalTo: cell.centerXAnchor), timeLabel.widthAnchor.constraint(equalTo: cell.widthAnchor), timeLabel.heightAnchor.constraint(equalTo: cell.heightAnchor)]
        NSLayoutConstraint.activate(timeLabelConstraints)
        cell.frame.size = CGSize(width: 60.0, height: 50.0)
        return cell
    }
}

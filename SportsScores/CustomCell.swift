//
//  CustomCellCollectionViewCell.swift
//  SportsScores
//
//  Created by Kazim Walji on 6/26/21.
//

import UIKit

class CustomCell: UICollectionViewCell {
    static let id = "CustomCell"
    
    private var dateLabel: UILabel {
        let timeLabel = UILabel()
        timeLabel.text = ""
        timeLabel.text = "12" + String(Int.random(in: 0...3))
        timeLabel.font = UIFont(name: "Arial-BoldMT", size: 15)
        timeLabel.textAlignment = .center
        return timeLabel
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .gray
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        dateLabel.frame = CGRect(x: 5, y: contentView.frame.size.height - 30, width: contentView.frame.size.height - 10, height: 30)
    }
    required init?(coder: NSCoder) {
        fatalError("hi")
    }
}

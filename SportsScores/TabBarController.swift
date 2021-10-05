//
//  ViewController.swift
//  SportsScores
//
//  Created by Kazim Walji on 6/22/21.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        let nba = LeagueViewController(viewModel: LeagueModel(nba: true))
        let nfl = LeagueViewController(viewModel: LeagueModel(nba: false))
        let size = CGSize(width: 25, height: 25)
        let nbaLogo = UIImage(named: "nba")?.scalePreservingAspectRatio(targetSize: size)
        let nflLogo = UIImage(named: "nfl")?.scalePreservingAspectRatio(targetSize: size)
        nba.tabBarItem = UITabBarItem(title: "NBA", image: nbaLogo, selectedImage: nbaLogo)
        nfl.tabBarItem = UITabBarItem(title: "NFL", image: nflLogo, selectedImage: nflLogo)
        self.viewControllers = [nba, nfl]
    }

}

extension UIImage {
    func scalePreservingAspectRatio(targetSize: CGSize) -> UIImage {
        // Determine the scale factor that preserves aspect ratio
        let widthRatio = targetSize.width / size.width
        let heightRatio = targetSize.height / size.height
        
        let scaleFactor = min(widthRatio, heightRatio)
        
        // Compute the new image size that preserves aspect ratio
        let scaledImageSize = CGSize(
            width: size.width * scaleFactor,
            height: size.height * scaleFactor
        )

        // Draw and return the resized UIImage
        let renderer = UIGraphicsImageRenderer(
            size: scaledImageSize
        )

        let scaledImage = renderer.image { _ in
            self.draw(in: CGRect(
                origin: .zero,
                size: scaledImageSize
            ))
        }
        
        return scaledImage
    }
}


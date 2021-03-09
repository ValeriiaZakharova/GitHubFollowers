//
//  FollowerItemViewController.swift
//  GitHubFollowers
//
//  Created by Valeriia Zakharova on 09.03.2021.
//

import UIKit

class FollowerItemViewController: ItemInfoViewController {
    enum Constants {
        static let buttonTitle: String = "GitHub Followers"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}

private extension FollowerItemViewController {

    func setupUI() {
        setupContent()
        setupActionButton()
    }

    func setupContent() {
        itemInfoViewOne.set(itemInfoType: .followers, withCount: user.followers)
        itemInfoViewTwo.set(itemInfoType: .following, withCount: user.following)
    }

    func setupActionButton() {
        actionButton.set(backgroundColor: .systemGreen, title: Constants.buttonTitle)
    }
}

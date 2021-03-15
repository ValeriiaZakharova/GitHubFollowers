//
//  FollowerItemViewController.swift
//  GitHubFollowers
//
//  Created by Valeriia Zakharova on 09.03.2021.
//

import UIKit

protocol FollowerItemViewControllerDelegate: class {
    func didTapGetFollowers(for user: User)
}

class FollowerItemViewController: ItemInfoViewController {
    enum Constants {
        static let buttonTitle: String = "GitHub Followers"
    }

    weak var delegate: FollowerItemViewControllerDelegate!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    init(user: User, delegate: FollowerItemViewControllerDelegate) {
        super.init(user: user)
        self.delegate = delegate
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func actionButtonTapped() {
        delegate.didTapGetFollowers(for: user)
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

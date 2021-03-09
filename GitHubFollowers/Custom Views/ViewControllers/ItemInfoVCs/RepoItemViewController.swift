//
//  RepoItemViewController.swift
//  GitHubFollowers
//
//  Created by Valeriia Zakharova on 09.03.2021.
//

import UIKit

class RepoItemViewController: ItemInfoViewController {
    enum Constants {
        static let buttonTitle: String = "GitHub Profile"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func actionButtonTapped() {
        delegate.didTapGitHubProfile(for: user)
    }
}

// MARK: - Private
private extension RepoItemViewController {
    func setupUI() {
        setupContent()
        setupActionButton()
    }

    func setupContent() {
        itemInfoViewOne.set(itemInfoType: .repos, withCount: user.publicRepos)
        itemInfoViewTwo.set(itemInfoType: .gists, withCount: user.publicGists)
    }

    func setupActionButton() {
        actionButton.set(backgroundColor: .systemPurple, title: Constants.buttonTitle)
    }
}

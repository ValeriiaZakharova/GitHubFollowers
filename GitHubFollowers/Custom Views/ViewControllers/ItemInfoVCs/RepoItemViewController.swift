//
//  RepoItemViewController.swift
//  GitHubFollowers
//
//  Created by Valeriia Zakharova on 09.03.2021.
//

import UIKit

protocol RepoItemViewControllerDelegate: class {
    func didTapGitHubProfile(for user: User)
}

class RepoItemViewController: ItemInfoViewController {
    enum Constants {
        static let buttonTitle: String = "GitHub Profile"
    }

    weak var delegate: RepoItemViewControllerDelegate!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    init(user: User, delegate: RepoItemViewControllerDelegate) {
        super.init(user: user)
        self.delegate = delegate
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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

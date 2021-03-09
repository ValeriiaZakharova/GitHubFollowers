//
//  UserInfoViewController.swift
//  GitHubFollowers
//
//  Created by Valeriia Zakharova on 04.03.2021.
//

import UIKit

protocol UserInfoViewControllerDelegate: class {
    func didTapGitHubProfile(for user: User)
    func didTapGetFollowers(for user: User)
}

class UserInfoViewController: UIViewController {

    enum Constants {
        static let padding: CGFloat = 20
        static let itemHeight: CGFloat = 140
        static let labelHeight: CGFloat = 18
    }

    //holders for child viewControllers - UserInfoHeaderViewController, RepoItemViewController, FollowerItemViewController
    private let headerView = UIView()
    private let itemViewOne = UIView()
    private let itemViewTwo = UIView()
    private let dateLabel = GFBodyLabel(textAlignment: .center)

    private var itemViews: [UIView] = []

    var username: String!
    weak var delegate: FollowerListViewControllerDelegate!

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        getUserInfo()
    }

    @objc func dismissVC() {
        dismiss(animated: true)
    }

    private func getUserInfo() {
        NetworkManager.shared.getUserInfo(for: username) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let user):
                DispatchQueue.main.async {
                    self.setupUIElements(with: user)
                }
            case .failure(let error):
                self.presentAlertViewController(title: "Something went wrong", message: error.rawValue, buttonTitle: "ok")
            }
        }
    }

    private func add(childVC: UIViewController, to containerView: UIView) {
        addChild(childVC)
        containerView.addSubview(childVC.view)
        childVC.view.frame = containerView.bounds
        childVC.didMove(toParent: self)
    }

    private func setupUIElements(with user: User) {
        let repoItemViewController = RepoItemViewController(user: user)
        repoItemViewController.delegate = self

        let followerItemViewController = FollowerItemViewController(user: user)
        followerItemViewController.delegate = self

        //add childviewcontrollers to our holdersView - headerView, itemViewOne, itemViewTwo
        self.add(childVC: UserInfoHeaderViewController(user: user), to: self.headerView)
        self.add(childVC: repoItemViewController, to: self.itemViewOne)
        self.add(childVC: followerItemViewController, to: self.itemViewTwo)
        self.dateLabel.text = "GitHub since \(user.createdAt.convertToDisplayFormat())"
    }
}

// MARK: - Private
private extension UserInfoViewController {

    func setup() {
        configureViewController()
        setupUI()
    }

    func configureViewController() {
        view.backgroundColor = .systemBackground
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
        navigationItem.rightBarButtonItem = doneButton
    }

    func setupUI() {
        itemViews = [headerView, itemViewOne, itemViewTwo, dateLabel]

        for itemView in itemViews {
            view.addSubview(itemView)
            itemView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                itemView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.padding),
                itemView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.padding)
            ])
        }

        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 180),

            itemViewOne.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: Constants.padding),
            itemViewOne.heightAnchor.constraint(equalToConstant: Constants.itemHeight),

            itemViewTwo.topAnchor.constraint(equalTo: itemViewOne.bottomAnchor, constant: Constants.padding),
            itemViewTwo.heightAnchor.constraint(equalToConstant: Constants.itemHeight),

            dateLabel.topAnchor.constraint(equalTo: itemViewTwo.bottomAnchor, constant: Constants.padding),
            dateLabel.heightAnchor.constraint(equalToConstant: Constants.labelHeight)
        ])
    }
}

// MARK: - UserInfoViewControllerDelegate
extension UserInfoViewController: UserInfoViewControllerDelegate {
    func didTapGitHubProfile(for user: User) {
        //show safariview controller
        guard let url = URL(string: user.htmlUrl) else {
            presentAlertViewController(title: "Invalid URL", message: "The url attached to this user is invalid.", buttonTitle: "OK")
            return
        }
        presentSafariViewController(with: url)
    }

    func didTapGetFollowers(for user: User) {
        //dismiss
        //tell follower list screen the new user

        //check if user has any followers, if not show an alert
        guard user.followers != 0 else {
            presentAlertViewController(title: "No followers", message: "This user fas no followers. What a shame 😕", buttonTitle: "So sad")
            return
        }
        delegate.didRquestFollowers(for: user.login)
        dismissVC()
    }
}

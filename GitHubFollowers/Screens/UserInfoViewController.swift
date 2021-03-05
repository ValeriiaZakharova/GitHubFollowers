//
//  UserInfoViewController.swift
//  GitHubFollowers
//
//  Created by Valeriia Zakharova on 04.03.2021.
//

import UIKit

class UserInfoViewController: UIViewController {

    enum Constants {
        static let padding: CGFloat = 20
        static let itemHeight: CGFloat = 140
    }

    //holder for child viewController - UserInfoHeaderViewController
    private let headerView = UIView()
    private let itemViewOne = UIView()
    private let itemViewTwo = UIView()

    private var itemViews: [UIView] = []

    var username: String!

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
                //add UserInfoHeaderViewController to our headerView
                DispatchQueue.main.async {
                    self.add(childVC: UserInfoHeaderViewController(user: user), to: self.headerView)
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
        itemViews = [headerView, itemViewOne, itemViewTwo]

        for itemView in itemViews {
            view.addSubview(itemView)
            itemView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                itemView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.padding),
                itemView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.padding)
            ])
        }

        itemViewOne.backgroundColor = .systemPink
        itemViewTwo.backgroundColor = .systemRed

        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 180),

            itemViewOne.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: Constants.padding),
            itemViewOne.heightAnchor.constraint(equalToConstant: Constants.itemHeight),

            itemViewTwo.topAnchor.constraint(equalTo: itemViewOne.bottomAnchor, constant: Constants.padding),
            itemViewTwo.heightAnchor.constraint(equalToConstant: Constants.itemHeight)
        ])
    }
}

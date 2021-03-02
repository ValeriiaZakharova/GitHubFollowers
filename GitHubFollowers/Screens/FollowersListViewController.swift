//
//  FollowersListViewController.swift
//  GitHubFollowers
//
//  Created by Valeriia Zakharova on 31.12.2020.
//

import UIKit

class FollowersListViewController: UIViewController {

    var username: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.prefersLargeTitles = true

        NetworkManager.shared.getFollowers(for: username!, page: 1) { (follwers, errorMessage) in
            guard let follwers = follwers else {
                self.presentAlertViewController(title: "Bad stuff happened", message: errorMessage!, buttonTitle: "ok")
                return
            }

            print("Followers.count = \(follwers.count)")
            print(follwers)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
}

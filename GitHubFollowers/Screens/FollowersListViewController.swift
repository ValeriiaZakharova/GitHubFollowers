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
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
}

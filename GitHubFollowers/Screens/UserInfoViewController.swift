//
//  UserInfoViewController.swift
//  GitHubFollowers
//
//  Created by Valeriia Zakharova on 04.03.2021.
//

import UIKit

class UserInfoViewController: UIViewController {

    var username: String!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
        navigationItem.rightBarButtonItem = doneButton

    }

    @objc func dismissVC() {
        dismiss(animated: true)
    }

}

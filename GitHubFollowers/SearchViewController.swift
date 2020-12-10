//
//  SearchViewController.swift
//  GitHubFollowers
//
//  Created by Valeriia Zakharova on 02.12.2020.
//

import UIKit

class SearchViewController: UIViewController {

    // MARK: - Constants

    private enum Constants {
        static let buttonTitle = "Get Follovers"
        static let imageName = "gh-logo"
    }

    // MARK: - Private properties

    private let logoImageView = UIImageView()

    private let usernameTextfield = GFTextField()

    private let getUsersButton = GFButton(backgroundColor: UIColor.systemGreen, title: Constants.buttonTitle)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
}

// MARK: - Private

private extension SearchViewController {

    func setupUI() {
        setupViewHierarhy()
        setupContent()
        setupConstraints()
    }

    func setupViewHierarhy() {
        view.addSubview(logoImageView)
        view.addSubview(usernameTextfield)
        view.addSubview(getUsersButton)
    }

    func setupContent() {
        logoImageView.image = UIImage(named: Constants.imageName)!
    }

    func setupConstraints() {
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: 200),
            logoImageView.widthAnchor.constraint(equalToConstant: 200)
        ])

        NSLayoutConstraint.activate([
            usernameTextfield.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 48),
            usernameTextfield.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            usernameTextfield.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            usernameTextfield.heightAnchor.constraint(equalToConstant: 50)
        ])

        NSLayoutConstraint.activate([
            getUsersButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            getUsersButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            getUsersButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            getUsersButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}

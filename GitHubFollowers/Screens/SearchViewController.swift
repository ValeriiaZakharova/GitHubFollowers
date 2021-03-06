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
    }

    var isUsernameEntered: Bool {
        return !usernameTextfield.text!.isEmpty
    }

    // MARK: - Private properties
    private let logoImageView = UIImageView()
    private let usernameTextfield = GFTextField()
    private let getUsersButton = GFButton(backgroundColor: UIColor.systemGreen, title: Constants.buttonTitle)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        createDismissKeyboardTapGesture()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        usernameTextfield.text = ""
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
}

// MARK: - Private
private extension SearchViewController {

    func setupUI() {
        setupViewHierarhy()
        setupContent()
        setupConstraints()
        didTapActionButton()
        usernameTextfield.delegate = self
    }

    func setupViewHierarhy() {
        view.addSubviews(logoImageView, usernameTextfield, getUsersButton)
    }

    func setupContent() {
        logoImageView.image = Images.ghLogo
    }

    func setupConstraints() {
        let topConstraintConstant: CGFloat = DeviceTypes.isiPhoneSE || DeviceTypes.isiPhone8Zoomed ? 20 : 80
        logoImageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: topConstraintConstant),
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

    func createDismissKeyboardTapGesture() {
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }

    func didTapActionButton() {
        getUsersButton.addTarget(self, action: #selector(pushFollowerListVC), for: .touchUpInside)
    }

    @objc func pushFollowerListVC() {
        guard isUsernameEntered else {
            presentAlertViewController(title: "Empty Username", message: "Please enter a username. We need to know who to look for", buttonTitle: "Ok")
            return
        }
        usernameTextfield.resignFirstResponder()

        let followerListVc = FollowersListViewController(username: usernameTextfield.text!)
        navigationController?.pushViewController(followerListVc, animated: true)
    }
}

// MARK: - TextField delegate
extension SearchViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        pushFollowerListVC()
        return true
    }
}

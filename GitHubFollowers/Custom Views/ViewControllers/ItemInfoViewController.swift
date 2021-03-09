//
//  ItemInfoViewController.swift
//  GitHubFollowers
//
//  Created by Valeriia Zakharova on 09.03.2021.
//

import UIKit

class ItemInfoViewController: UIViewController {
    enum Constants {
        static let radius: CGFloat = 18
        static let padding: CGFloat = 20
        static let stackViewHeight: CGFloat = 50
        static let buttonHeight: CGFloat = 44
    }

    private let stackView = UIStackView()
    private let itemInfoViewOne = ItemInfoView()
    private let itemInfoViewTwo = ItemInfoView()
    private let actionButton = GFButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}

private extension ItemInfoViewController {
    func setupUI() {
        configureBackgroundView()
        setupViewHierarchy()
        setupConstaints()
    }

    func configureBackgroundView() {
        view.layer.cornerRadius = Constants.radius
        view.backgroundColor = .secondaryLabel
    }

    func setupViewHierarchy() {
        view.addSubview(stackView)
        view.addSubview(actionButton)
        stackView.addArrangedSubview(itemInfoViewOne)
        stackView.addArrangedSubview(itemInfoViewTwo)
    }

    func setupConstaints() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: Constants.padding),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.padding),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Constants.padding),
            stackView.heightAnchor.constraint(equalToConstant: Constants.stackViewHeight),

            actionButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -Constants.padding),
            actionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.padding),
            actionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.padding),
            actionButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight)
        ])

        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
    }
}

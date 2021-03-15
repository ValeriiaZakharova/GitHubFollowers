//
//  FavoriteCell.swift
//  GitHubFollowers
//
//  Created by Valeriia Zakharova on 09.03.2021.
//

import UIKit

class FavoriteCell: UITableViewCell {
    enum Constants {
        static let padding: CGFloat = 12
        static let widthHeight: CGFloat = 60
    }

    static let reuseID = "FavoriteCell"

    let avatarImageView = AvatarImageView(frame: .zero)
    let usernameLabel = GFTitleLabel(textAlignment: .left, fontSize: 26)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func set(favorite: Follower) {
        usernameLabel.text = favorite.login
        NetworkManager.shared.downloadImage(from: favorite.avatarUrl) { [weak self] image in
            guard let self = self else { return }
            DispatchQueue.main.async { self.avatarImageView.image = image }
        }
    }
}

private extension FavoriteCell {
    func setupUI() {
        setupViewHierarchy()
        setupConstaints()

        accessoryType = .disclosureIndicator
    }

    func setupViewHierarchy() {
        addSubviews(avatarImageView, usernameLabel)
    }

    func setupConstaints() {
        NSLayoutConstraint.activate([
            avatarImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            avatarImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constants.padding),
            avatarImageView.widthAnchor.constraint(equalToConstant: Constants.widthHeight),
            avatarImageView.heightAnchor.constraint(equalToConstant: Constants.widthHeight),

            usernameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            usernameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 24),
            usernameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Constants.padding),
            usernameLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}

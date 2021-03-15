//
//  FollowerCell.swift
//  GitHubFollowers
//
//  Created by Valeriia Zakharova on 02.03.2021.
//

import UIKit

class FollowerCell: UICollectionViewCell {

    // MARK: - Constants
    enum Constants {
        static let padding: CGFloat = 8
    }

    static let reuseID = "FollowerCell"

    private let avatarImageView = AvatarImageView(frame: .zero)
    private let usernameLabel = GFTitleLabel(textAlignment: .center, fontSize: 16)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func set(follower: Follower) {
        avatarImageView.downloadImage(fromUrl: follower.avatarUrl)
        usernameLabel.text = follower.login
    }
}

// MARK: - Private
private extension FollowerCell {
    func configure() {
        addSubviews(avatarImageView, usernameLabel)

        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.padding),
            avatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.padding),
            avatarImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.padding),
            avatarImageView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor),

            usernameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 12),
            usernameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.padding),
            usernameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.padding),
            usernameLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
}

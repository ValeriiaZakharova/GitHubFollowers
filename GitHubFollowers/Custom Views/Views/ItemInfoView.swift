//
//  ItemInfoView.swift
//  GitHubFollowers
//
//  Created by Valeriia Zakharova on 07.03.2021.
//

import UIKit

enum ItemInfoType {
    case repos, gists, followers, following
}

class ItemInfoView: UIView {

    private let symbolImageView = UIImageView()
    private let titleLebel = GFTitleLabel(textAlignment: .left, fontSize: 14)
    private let countLevel = GFTitleLabel(textAlignment: .center, fontSize: 14)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func set(itemInfoType: ItemInfoType, withCount count: Int) {
        switch itemInfoType {
        case .repos:
            symbolImageView.image = SFSymbols.repos
            titleLebel.text = "Public repos"
        case .gists:
            symbolImageView.image = SFSymbols.gists
            titleLebel.text = "Public Gists"
        case .followers:
            symbolImageView.image = SFSymbols.followers
            titleLebel.text = "Followers"
        case .following:
            symbolImageView.image = SFSymbols.following
            titleLebel.text = "Following"
        }
        countLevel.text = String(count)
    }
}

private extension ItemInfoView {
    func setupUI() {
        setupViewHierarchy()
        setupConstaints()
    }

    func setupViewHierarchy() {
        addSubviews(symbolImageView, titleLebel, countLevel)
    }

    func setupConstaints() {
        symbolImageView.translatesAutoresizingMaskIntoConstraints = false
        symbolImageView.contentMode = .scaleAspectFill
        symbolImageView.tintColor = .label

        NSLayoutConstraint.activate([
            symbolImageView.topAnchor.constraint(equalTo: self.topAnchor),
            symbolImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            symbolImageView.widthAnchor.constraint(equalToConstant: 20),
            symbolImageView.heightAnchor.constraint(equalToConstant: 20),

            titleLebel.centerYAnchor.constraint(equalTo: symbolImageView.centerYAnchor),
            titleLebel.leadingAnchor.constraint(equalTo: symbolImageView.trailingAnchor, constant: 12),
            titleLebel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            titleLebel.heightAnchor.constraint(equalToConstant: 18),

            countLevel.topAnchor.constraint(equalTo: symbolImageView.bottomAnchor, constant: 4),
            countLevel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            countLevel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            countLevel.heightAnchor.constraint(equalToConstant: 18)
        ])
    }
}

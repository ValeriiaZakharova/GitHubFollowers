//
//  FollowersListViewController.swift
//  GitHubFollowers
//
//  Created by Valeriia Zakharova on 31.12.2020.
//

import UIKit

class FollowersListViewController: UIViewController {

    var username: String?
    var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureCollectionview()
        getfollowers()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    func configureViewController() {
        view.backgroundColor = .systemBackground
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    func configureCollectionview() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UICollectionViewFlowLayout())
        view.addSubview(collectionView)
        collectionView.backgroundColor = .systemPink
        collectionView.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.reuseID)
    }

    func getfollowers() {
        NetworkManager.shared.getFollowers(for: username!, page: 1) { result in

            switch result {
            case .success(let followers):
                print("Followers.count = \(followers.count)")
                print(followers)

            case .failure(let error):
                self.presentAlertViewController(title: "Bad stuff happened", message: error.rawValue, buttonTitle: "ok")
            }
        }
    }
}

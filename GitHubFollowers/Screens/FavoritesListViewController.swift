//
//  FavoritesListViewController.swift
//  GitHubFollowers
//
//  Created by Valeriia Zakharova on 02.12.2020.
//

import UIKit

class FavoritesListViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBlue

        PersistenceManager.retriveFavorites { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let favorites):
                print(favorites)
            case .failure(_):
                break
            }
        }
    }
}

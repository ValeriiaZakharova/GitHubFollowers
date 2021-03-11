//
//  FavoritesListViewController.swift
//  GitHubFollowers
//
//  Created by Valeriia Zakharova on 02.12.2020.
//

import UIKit

class FavoritesListViewController: UIViewController {

    enum Constants {
        static let title = "Favorites"
    }

    private let tableView = UITableView()

    var favorites: [Follower] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getFavorites()
    }

    private func getFavorites() {
        PersistenceManager.retriveFavorites { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let favorites):
                if favorites.isEmpty {
                    self.showEmptyStateView(with: "No Favorites?\nAdd one on the follower screen.", in: self.view)
                } else {
                    self.favorites = favorites
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        self.view.bringSubviewToFront(self.tableView)
                    }
                }
            case .failure(let error):
                self.presentAlertViewController(title: "Something went wrong", message: error.rawValue, buttonTitle: "Ok.")
            }
        }
    }
}

// MARK: - UITableViewDataSource
extension FavoritesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteCell.reuseID) as! FavoriteCell
        cell.set(favorite: favorites[indexPath.row])
        return cell
    }
}

// MARK: - Mark NameUITableViewDelegate
extension FavoritesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let favorite = favorites[indexPath.row]
        let viewcontroller = FollowersListViewController(username: favorite.login)

        navigationController?.pushViewController(viewcontroller, animated: true)
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }

        let favorite = favorites[indexPath.row]
        favorites.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .left)

        //delete from userDelaults
        PersistenceManager.updateWith(favorite: favorite, actionType: .remove) { [weak self] error in
            guard let self = self else { return }
            guard let error = error else { return }

            self.presentAlertViewController(title: "Unable to remove", message: error.rawValue, buttonTitle: "Ok.")
        }
    }
}

private extension FavoritesListViewController {
    func setupUI() {
        configureViewController()
        configureTableView()
    }

    func configureViewController() {
        view.backgroundColor = .systemBackground
        title = Constants.title
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    func configureTableView() {
        view.addSubview(tableView)

        tableView.frame = view.bounds
        tableView.rowHeight = 80

        tableView.delegate = self
        tableView.dataSource = self

        tableView.register(FavoriteCell.self, forCellReuseIdentifier: FavoriteCell.reuseID)
    }
}

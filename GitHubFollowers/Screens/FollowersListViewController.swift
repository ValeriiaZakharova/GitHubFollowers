//
//  FollowersListViewController.swift
//  GitHubFollowers
//
//  Created by Valeriia Zakharova on 31.12.2020.
//

import UIKit

protocol FollowerListViewControllerDelegate: class {
    func didRquestFollowers(for username: String)
}

class FollowersListViewController: DataLoadingViewController {
    enum Section { case main }

    var username: String!

    var followers: [Follower] = []

    var filtredFollowers: [Follower] = []

    var page = 1
    var hasMoreFollowers = true
    //show us if we searching thrue followers or not, false by defults
    var isSearching = false

    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Follower>!

    init(username: String) {
        super.init(nibName: nil, bundle: nil)
        self.username = username
        title = username
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureCollectionview()
        getfollowers(username: username, page: page)
        configureDataSource()
        configureSearchController()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
}

// MARK: - Private
private extension FollowersListViewController {
    func configureViewController() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true

        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addButton
    }

    func configureCollectionview() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createThreeColumnFlowLayout(in: view))
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        collectionView.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.reuseID)
    }

    func configureSearchController() {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search for a username"
        searchController.obscuresBackgroundDuringPresentation = false
        //add our search controller to navigation bar
        navigationItem.searchController = searchController
    }

    func getfollowers(username: String, page: Int) {
        //show spinner
        showLoadingView()
        NetworkManager.shared.getFollowers(for: username, page: page) { [weak self] result in
            guard let self = self else { return }
            self.dismissLoadingView()
            switch result {
            case .success(let followers):
                //one network call get's us 100 followers per one call, if followers<100 we switch hasMoreFollowers into false
                //when we will scroll to the buttom, func "scrollViewDidEndDragging" would'n make any more network call
                if followers.count < 100 { self.hasMoreFollowers = false }
                //every time we make a network call, we append next 100 followers into our array self.followers
                self.followers.append(contentsOf: followers)

                //for users with 0 followers
                if self.followers.isEmpty {
                    let message = "This user doesn't have any followers. Go follow them 😀"
                    DispatchQueue.main.async {
                        self.showEmptyStateView(with: message, in: self.view)
                        return
                    }
                }
                self.updateData(on: self.followers)

            case .failure(let error):
                self.presentAlertViewController(title: "Bad stuff happened", message: error.rawValue, buttonTitle: "ok")
            }
        }
    }

    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Follower>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, follower) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FollowerCell.reuseID, for: indexPath) as! FollowerCell
            cell.set(follower: follower)
            return cell
        })
    }

    func updateData(on followers: [Follower]) {
        //create snapshot
        var snapshot = NSDiffableDataSourceSnapshot<Section, Follower>()
        //added our section to snapshot
        snapshot.appendSections([.main])
        //added our followers to snapshot
        snapshot.appendItems(followers)
        // apply snapshot to our dataSourse
        DispatchQueue.main.async {
            self.dataSource.apply(snapshot, animatingDifferences: true)
        }
    }

    @objc func addButtonTapped() {
        showLoadingView()

        NetworkManager.shared.getUserInfo(for: username) { [weak self] result in
            guard let self = self else { return }
            self.dismissLoadingView()

            switch result {
            case .success(let user):
                //create follower object to get a login and an avatarUrl for fovorite user
                let favorite = Follower(login: user.login, avatarUrl: user.avatarUrl)

                //add the user to the favorite, save to the userDefoults
                //if the error is nil we are gonna present success
                PersistenceManager.updateWith(favorite: favorite, actionType: .add) { [weak self] error in
                    guard let error = error else {
                        self?.presentAlertViewController(title: "Success!", message: "You have succesfully favorited this user 🎉", buttonTitle: "Ok")
                        return
                    }
                    //if error is not nil
                    self?.presentAlertViewController(title: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
                }

            case .failure(let error):
                self.presentAlertViewController(title: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }
}

// MARK: - UICollectionViewDelegate
extension FollowersListViewController: UICollectionViewDelegate {
    //it's waiting for us to end dragging and then calls
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height

        if offsetY > contentHeight - height {
            //if user has more followers then we go on and continue, if no return
            guard hasMoreFollowers else { return }
            page += 1
            getfollowers(username: username, page: page)
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //detect which array we should use when we tapped on the follower
        let activeArray = isSearching ? filtredFollowers : followers
        let follower = activeArray[indexPath.item]

        let viewController = UserInfoViewController()
        viewController.username = follower.login
        viewController.delegate = self
        let navigationController = UINavigationController(rootViewController: viewController)
        present(navigationController, animated: true)
    }
}

// MARK: - UISearchResultsUpdating
extension FollowersListViewController: UISearchResultsUpdating {
    //if I change something in search bar it's letting me now
    func updateSearchResults(for searchController: UISearchController) {
        //check if we have text in search bar and it's not empty
        guard let filter = searchController.searchBar.text, !filter.isEmpty else {
            filtredFollowers.removeAll()
            updateData(on: followers)
            isSearching = false
            return
        }
        //if we have filter we start searching
        isSearching = true
        //$0 - each item in the followers array (one follower)
        //check if followers array contains our filter and put it in a filtredFollowers array
        filtredFollowers = followers.filter { $0.login.lowercased().contains(filter.lowercased())}
        updateData(on: filtredFollowers)
    }
}

// MARK: - FollowerListViewControllerDelegate
extension FollowersListViewController: FollowerListViewControllerDelegate {
    func didRquestFollowers(for username: String) {
        // reset the screen with new user
        self.username = username
        title = username
        page = 1
        followers.removeAll()
        filtredFollowers.removeAll()
        //return collection view to the top
        collectionView.setContentOffset(.zero, animated: true)
        //create network call for new user
        getfollowers(username: username, page: page)
    }
}

// Delegate & Protocol - communication one-to-one - setting communication pattern beetwen 2 views
// Notifications & Observers - communication one-to-many

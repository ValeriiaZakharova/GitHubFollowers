//
//  FollowersListViewController.swift
//  GitHubFollowers
//
//  Created by Valeriia Zakharova on 31.12.2020.
//

import UIKit

class FollowersListViewController: UIViewController {

    enum Section { case main }

    var username: String!
    var followers: [Follower] = []
    var page = 1
    var hasMoreFollowers = true

    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Follower>!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureCollectionview()
        getfollowers(username: username, page: page)
        configureDataSource()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    func configureViewController() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    func configureCollectionview() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createThreeColumnFlowLayout(in: view))
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        collectionView.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.reuseID)
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
                self.updateData()

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

    func updateData() {
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
}

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
}


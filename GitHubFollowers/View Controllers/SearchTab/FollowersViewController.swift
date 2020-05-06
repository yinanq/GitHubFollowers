//
//  FollowersViewController.swift
//  GitHubFollowers
//
//  Created by Yinan Qiu on 3/21/20.
//  Copyright © 2020 Yinan. All rights reserved.
//

import UIKit

class FollowersViewController: GHFStatesVC {
    
    enum Section {
        case main
    }
    
    var username: String!
    var followers: [Follower ] = []
    var followersSearched: [Follower] = []
    var page = 1
    var hasMoreFollowers = true
    var isSearching = false
    var isLoadingMoreFollowers = false
    
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
        configureCollectionView()
        configureSearchController()
        getFollowers(username: username, page: page)
        configureDataSource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func configureViewController() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        let favBtn = UIBarButtonItem(image: SFSymbols.fav, style: .plain, target: self, action: #selector(saveUserToFav))
        navigationItem.rightBarButtonItem = favBtn
    }
    
    func configureCollectionView() {
        //        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createFlowLayout())
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: Helper.createFlowLayout(in: view))
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        collectionView.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.reuseID)
    }
    
    func configureSearchController() {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search a username"
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
    }
    
    func getFollowers(username: String, page: Int) {
        showLoadingView()
        isLoadingMoreFollowers = true
        NetworkManager.shared.getFollowers(for: username, page: page) { [weak self] result in
            guard let self = self else { return }
            self.dismissLoadingView()
            switch result {
            case .failure(let error):
                self.presentGHFAlertOnMainThread(title: "Oops", message: error.rawValue, buttonText: "Dang")
            case .success(let followers):
                self.update(with: followers)
            }
            self.isLoadingMoreFollowers = false
        }
    }
    
    func update(with followers: [Follower]) {
        if followers.count < 100 { self.hasMoreFollowers = false }
        self.followers.append(contentsOf: followers)
        if self.followers.isEmpty {
            let message = "This user doesn't have any followers. Go follow them!"
            DispatchQueue.main.async { self.showEmptyStateView(with: message, in: self.view) }
            return
        }
        self.updateData(on: self.followers)
    }
    
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Follower>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, follower) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FollowerCell.reuseID, for: indexPath) as! FollowerCell
            cell.set(follower: follower)
            return cell
        })
    }
    
    func updateData(on followers: [Follower]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Follower>()
        snapshot.appendSections([.main])
        snapshot.appendItems(followers)
        DispatchQueue.main.async {
            self.dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
    
    @objc func saveUserToFav() {
        showLoadingView()
        NetworkManager.shared.getFollowerInfo(for: username) { [weak self] result in
            guard let self = self else { return }
            self.dismissLoadingView()
            switch result {
            case .success(let user):
                self.updateFavsWith(newFav: user)
            case .failure(let error):
                self.presentGHFAlertOnMainThread(title: "Something wrong", message: error.rawValue, buttonText: "OK")
            }
        }
    }
    
    func updateFavsWith(newFav user: User) {
        let fav = Follower(login: user.login, avatar_url: user.avatar_url)
        PersistenceManager.updateWith(fav: fav, actionType: .add) { [weak self] error in
            guard let self = self else { return }
            guard let error = error else {
                self.presentGHFAlertOnMainThread(title: "Favorited", message: "You just saved this user to your favorites!", buttonText: "Yay")
                return
            }
            self.presentGHFAlertOnMainThread(title: "Oops", message: error.rawValue, buttonText: "OK")
        }
    }
    
}

extension FollowersViewController: UICollectionViewDelegate {
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.size.height
        if offsetY > contentHeight - frameHeight {
            guard hasMoreFollowers, !isLoadingMoreFollowers else { return }
            page += 1
            getFollowers(username: username, page: page)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let followers = isSearching ? followersSearched : self.followers
        let follower = followers[indexPath.item]
        
        let followerInfoVC = FollowerInfoViewController()
        followerInfoVC.username = follower.login
        followerInfoVC.delegate = self
        let navController = UINavigationController(rootViewController: followerInfoVC)
        present(navController, animated: true)
    }
    
}

extension FollowersViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text, !searchText.isEmpty else {
            followersSearched.removeAll()
            updateData(on: followers)
            isSearching = false
            return
        }
        isSearching = true
        followersSearched = followers.filter { $0.login.lowercased().contains(searchText.lowercased()) }
        updateData(on: followersSearched)
    }
}

extension FollowersViewController: FollowerInfoVCDelegate {
    func didRequestFollowers(of user: String) {
        username = user
        title = user
        followers.removeAll()
        followersSearched.removeAll()
        page = 1
        collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
        getFollowers(username: user, page: page)
    }
}

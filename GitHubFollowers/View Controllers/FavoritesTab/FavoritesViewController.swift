//
//  FavoritesViewController.swift
//  GitHubFollowers
//
//  Created by Yinan Qiu on 3/20/20.
//  Copyright © 2020 Yinan. All rights reserved.
//

import UIKit

class FavoritesViewController: GHFStatesVC {
    
    let tableView = UITableView()
    var favs: [Follower] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateFavs()
    }
    
    func configureVC() {
        view.backgroundColor = .systemBackground
        title = "Favorites"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.rowHeight = 80
        tableView.register(FavCell.self, forCellReuseIdentifier: FavCell.reuseID)
        tableView.removeExcessCells()
    }
    
    func updateFavs() {
        PersistenceManager.retrieveFavs { [weak self] results in
            guard let self = self else { return }
            switch results {
            case .success(let favs):
                if favs.isEmpty {
                    self.showEmptyStateView(with: "No favorites?\nAdd one on the follower screen.", in: self.view)
                } else {
                    self.favs = favs
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        self.view.bringSubviewToFront(self.tableView)
                    }
                }
            case .failure(let error):
                self.presentGHFAlertOnMainThread(title: "Something wrong...", message: error.rawValue, buttonText: "OK")
            }
        }
    }

}

extension FavoritesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FavCell.reuseID) as! FavCell
        let fav = favs[indexPath.row]
        cell.set(fav: fav)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let fav = favs[indexPath.row]
        let followersVC = FollowersViewController(username: fav.login)
        navigationController?.pushViewController(followersVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        PersistenceManager.updateWith(fav: favs[indexPath.row], actionType: .remove) { [weak self] error in
            guard let self = self else { return }
            guard let error = error else {
                self.favs.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .left)
                return
            }
            self.presentGHFAlertOnMainThread(title: "Unable to remove", message: error.rawValue, buttonText: "OK")
        }
    }
    
}

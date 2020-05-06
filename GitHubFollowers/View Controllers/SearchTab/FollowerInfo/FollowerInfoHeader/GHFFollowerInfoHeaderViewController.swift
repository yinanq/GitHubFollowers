//
//  GHFFollowerInfoHeaderViewController.swift
//  GitHubFollowers
//
//  Created by Yinan Qiu on 5/3/20.
//  Copyright © 2020 Yinan. All rights reserved.
//

import UIKit

class GHFFollowerInfoHeaderViewController: UIViewController {
    
    let avatarImageView = GHFAvatarImageView(frame: .zero)
    let usernameLabel = GHFTitleLabel(textAlignment: .left, fontSize: 34)
    let nameLabel = GHFSubtitleLabel(fontSize: 18)
    let locationImageView = UIImageView()
    let locationLabel = GHFSubtitleLabel(fontSize: 18)
    let bioLabel = GHFBodyLabel(textAlignment: .left)
    
    var user: User!
    
    init(user: User) {
        super.init(nibName: nil, bundle: nil)
        self.user = user
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        view.addSubviews(avatarImageView, usernameLabel, nameLabel, locationImageView, locationLabel, bioLabel)
        layout()
    }
    
    func configure() {
        downloadAvatarImage()
        usernameLabel.text = user.login
        nameLabel.text = user.name ?? ""
        locationImageView.image = SFSymbols.location
        locationImageView.tintColor = .secondaryLabel
        locationLabel.text = user.location ?? "no location info"
        bioLabel.text = user.bio ?? ""
        bioLabel.numberOfLines = 3
    }
    
    func downloadAvatarImage() {
//        avatarImageView.downloadAvatarImage(from: user.avatar_url)
        NetworkManager.shared.downloadImage(from: user.avatar_url) { [weak self] image in
            guard let self = self else { return }
            DispatchQueue.main.async { self.avatarImageView.image = image }
        }
    }
    
    func layout() {
        let padding: CGFloat = 20
        let gap: CGFloat = 12
        locationImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: padding),
            avatarImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            avatarImageView.widthAnchor.constraint(equalToConstant: 90),
            avatarImageView.heightAnchor.constraint(equalToConstant: 90),
            usernameLabel.topAnchor.constraint(equalTo: avatarImageView.topAnchor),
            usernameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: gap),
            usernameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            usernameLabel.heightAnchor.constraint(equalToConstant: 38),
            nameLabel.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: usernameLabel.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: usernameLabel.trailingAnchor),
            nameLabel.heightAnchor.constraint(equalToConstant: 20),
            locationImageView.bottomAnchor.constraint(equalTo: avatarImageView.bottomAnchor),
            locationImageView.leadingAnchor.constraint(equalTo: usernameLabel.leadingAnchor),
            locationImageView.widthAnchor.constraint(equalToConstant: 20),
            locationImageView.heightAnchor.constraint(equalToConstant: 20),
            locationLabel.centerYAnchor.constraint(equalTo: locationImageView.centerYAnchor),
            locationLabel.leadingAnchor.constraint(equalTo: locationImageView.trailingAnchor, constant: 5),
            locationLabel.trailingAnchor.constraint(equalTo: usernameLabel.trailingAnchor),
            locationLabel.heightAnchor.constraint(equalToConstant: 20),
            bioLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: gap),
            bioLabel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor),
            bioLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bioLabel.heightAnchor.constraint(equalToConstant: 90)
        ])
    }
    
}

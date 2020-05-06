//
//  GHFCardSectionView.swift
//  GitHubFollowers
//
//  Created by Yinan Qiu on 5/3/20.
//  Copyright © 2020 Yinan. All rights reserved.
//

import UIKit

enum infoType {
    case repos, gists, followers, following
}

class GHFCardSectionView: UIView {
    
    let iconImageView = UIImageView()
    let titleLabel = GHFTitleLabel(textAlignment: .left, fontSize: 14)
    let countLabel = GHFTitleLabel(textAlignment: .center, fontSize: 14)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        addSubviews(iconImageView, titleLabel, countLabel)
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.contentMode = .scaleAspectFill
        iconImageView.tintColor = .label
        let labelHeight: CGFloat = 18
        NSLayoutConstraint.activate([
            iconImageView.topAnchor.constraint(equalTo: self.topAnchor),
            iconImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 20),
            iconImageView.heightAnchor.constraint(equalTo: iconImageView.widthAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: iconImageView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: labelHeight),
            countLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 4),
            countLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            countLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            countLabel.heightAnchor.constraint(equalToConstant: labelHeight)
        ])
    }
    
    func set(infoType: infoType, count: Int) {
        switch infoType {
        case .repos:
            iconImageView.image = SFSymbols.repos
            titleLabel.text = "Public Repos"
        case .gists:
            iconImageView.image = SFSymbols.gists
            titleLabel.text = "Public Gists"
        case .followers:
            iconImageView.image = SFSymbols.followers
            titleLabel.text = "Followers"
        case .following:
            iconImageView.image = SFSymbols.following
            titleLabel.text = "Following"
        }
        countLabel.text = String(count)
    }
    
}

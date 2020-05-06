//
//  FollowerInfoViewController.swift
//  GitHubFollowers
//
//  Created by Yinan Qiu on 5/2/20.
//  Copyright © 2020 Yinan. All rights reserved.
//

import UIKit

protocol FollowerInfoVCDelegate: class {
    func didRequestFollowers(of user: String)
}

class FollowerInfoViewController: UIViewController {
    // scroll view:
    let scrollView = UIScrollView()
    let contentView = UIView()
    // header (directly in view for dynamic height layout):
    let headerAvatarImageView = GHFAvatarImageView(frame: .zero)
    let headerUsernameLabel = GHFTitleLabel(textAlignment: .left, fontSize: 34)
    let headerNameLabel = GHFSubtitleLabel(fontSize: 18)
    let headerLocationImageView = UIImageView()
    let headerLocationLabel = GHFSubtitleLabel(fontSize: 18)
    let headerBioLabel = GHFBodyLabel(textAlignment: .left)
    // info cards in container views:
    let card1View = UIView()
    let card2View = UIView()
    // date label in container view:
    let dateLabel = GHFBodyLabel(textAlignment: .center)
    
    var username: String!
    
    weak var delegate: FollowerInfoVCDelegate!    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        configureScrollView()
        addUserInfo()
        contentView.addSubviews(
            headerAvatarImageView,
            headerUsernameLabel,
            headerNameLabel,
            headerLocationImageView,
            headerLocationLabel,
            headerBioLabel,
            card1View,
            card2View,
            dateLabel
        )
        layout()
    }
    
    func configureVC() {
        view.backgroundColor = .systemBackground
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
        navigationItem.rightBarButtonItem = doneBtn
    }
    @objc func dismissVC() {
        dismiss(animated: true)
    }
    
    func configureScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubviews(contentView)
        scrollView.pinToEdges(of: view)
        contentView.pinToEdges(of: scrollView)
        NSLayoutConstraint.activate([
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.heightAnchor.constraint(equalToConstant: 660)
        ])
    }
    
    // download user info from GitHub:
    func addUserInfo() {
        NetworkManager.shared.getFollowerInfo(for: username) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let user):
                DispatchQueue.main.async {
                    self.downloadHeaderAvatarImageOf(user)
                    self.addInfoOf(user)
                }
            case .failure(let error):
                self.presentGHFAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonText: "OK")
            }
        }
    }
    func downloadHeaderAvatarImageOf(_ user: User) {
        NetworkManager.shared.downloadImage(from: user.avatar_url) { [weak self] image in
            guard let self = self else { return }
            DispatchQueue.main.async { self.headerAvatarImageView.image = image }
        }
    }
    // put downloaded user info to use:
    func addInfoOf(_ user: User) {
        // 1/3 header:
        configureHeaderWithInfoOf(user)
        // 2/3 two cards:
        self.add(childVC: GHFRepoCardVC(user: user, delegate: self), to: self.card1View)
        self.add(childVC: GHFFollowerCardVC(user: user, delegate: self), to: self.card2View)
        // 3/3 date label:
        self.dateLabel.text = "GitHub since \(user.created_at.convertToMonthYearFormat())"
    }
    func configureHeaderWithInfoOf(_ user: User) {
        headerUsernameLabel.text = user.login
        headerNameLabel.text = user.name ?? ""
        headerLocationImageView.image = SFSymbols.location
        headerLocationImageView.tintColor = .secondaryLabel
        headerLocationLabel.text = user.location ?? "no location info"
        headerBioLabel.text = user.bio ?? ""
        headerBioLabel.numberOfLines = 0
    }
    func add(childVC: UIViewController, to containerView: UIView) {
        addChild(childVC)
        containerView.addSubview(childVC.view)
        childVC.view.frame = containerView.bounds
        childVC.didMove(toParent: self)
    }
    // layout all (header, two cards, date label):
    func layout() {
        let padding: CGFloat = 20
        let cardHeight: CGFloat = 140
        headerLocationImageView.translatesAutoresizingMaskIntoConstraints = false
        card1View.translatesAutoresizingMaskIntoConstraints = false
        card2View.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            headerAvatarImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            headerAvatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            headerAvatarImageView.widthAnchor.constraint(equalToConstant: 90),
            headerAvatarImageView.heightAnchor.constraint(equalToConstant: 90),
            
            headerUsernameLabel.topAnchor.constraint(equalTo: headerAvatarImageView.topAnchor, constant: -5),
            headerUsernameLabel.leadingAnchor.constraint(equalTo: headerAvatarImageView.trailingAnchor, constant: 15),
            headerUsernameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            headerUsernameLabel.heightAnchor.constraint(equalToConstant: 38),
            headerNameLabel.centerYAnchor.constraint(equalTo: headerAvatarImageView.centerYAnchor, constant: 5),
            headerNameLabel.leadingAnchor.constraint(equalTo: headerUsernameLabel.leadingAnchor),
            headerNameLabel.trailingAnchor.constraint(equalTo: headerUsernameLabel.trailingAnchor, constant: -padding),
            headerNameLabel.heightAnchor.constraint(equalToConstant: 20),
            headerLocationImageView.bottomAnchor.constraint(equalTo: headerAvatarImageView.bottomAnchor),
            headerLocationImageView.leadingAnchor.constraint(equalTo: headerUsernameLabel.leadingAnchor),
            headerLocationImageView.widthAnchor.constraint(equalToConstant: 20),
            headerLocationImageView.heightAnchor.constraint(equalToConstant: 20),
            headerLocationLabel.centerYAnchor.constraint(equalTo: headerLocationImageView.centerYAnchor),
            headerLocationLabel.leadingAnchor.constraint(equalTo: headerLocationImageView.trailingAnchor, constant: 5),
            headerLocationLabel.trailingAnchor.constraint(equalTo: headerUsernameLabel.trailingAnchor),
            headerLocationLabel.heightAnchor.constraint(equalToConstant: 20),
            
            headerBioLabel.topAnchor.constraint(equalTo: headerAvatarImageView.bottomAnchor, constant: 10),
            headerBioLabel.leadingAnchor.constraint(equalTo: headerAvatarImageView.leadingAnchor),
            headerBioLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            headerBioLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 0),
            
            card1View.topAnchor.constraint(equalTo: headerBioLabel.bottomAnchor, constant: padding*2),
            card1View.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            card1View.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            card1View.heightAnchor.constraint(equalToConstant: cardHeight),
            card2View.topAnchor.constraint(equalTo: card1View.bottomAnchor, constant: padding),
            card2View.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            card2View.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            card2View.heightAnchor.constraint(equalToConstant: cardHeight),
            dateLabel.topAnchor.constraint(equalTo: card2View.bottomAnchor, constant: padding),
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            dateLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
}

extension FollowerInfoViewController: GHFRepoCardVCDelegate {
    func didTapGitHubProfileBtn(of user: User) {
        guard let url = URL(string: user.html_url) else {
            presentGHFAlertOnMainThread(title: "No user profile", message: "No user profile", buttonText: "What?!")
            return
        }
        presentSafariVC(with: url)
    }
}

extension FollowerInfoViewController: GHFFollowerCardVCDelegate {
    func didTapSeeFollowersBtn(of user: User) {
        guard user.followers != 0 else {
            presentGHFAlertOnMainThread(title: "ZERO", message: "This user has no followers...", buttonText: ":(")
            return
        }
        delegate.didRequestFollowers(of: user.login)
        dismissVC()
    }
}

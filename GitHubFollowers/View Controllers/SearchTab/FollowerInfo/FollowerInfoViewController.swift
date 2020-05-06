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
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    let headerView = UIView()
    let card1View = UIView()
    let card2View = UIView()
    let dateLabel = GHFBodyLabel(textAlignment: .center)
    
    var containerViews: [UIView] = []
    
    var username: String!
    
    weak var delegate: FollowerInfoVCDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        configureScrollView()
        addContainerViews()
        addUserInfo()
    }
    
    func configureVC() {
        view.backgroundColor = .systemBackground
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissVC))
        navigationItem.rightBarButtonItem = doneBtn
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
    
    func addUserInfo() {
        NetworkManager.shared.getFollowerInfo(for: username) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let user):
                DispatchQueue.main.async { self.add(user) }
            case .failure(let error):
                self.presentGHFAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonText: "OK")
            }
        }
    }
    
    func add(_ user : User) {
        self.add(childVC: GHFRepoCardVC(user: user, delegate: self), to: self.card1View)
        self.add(childVC: GHFFollowerCardVC(user: user, delegate: self), to: self.card2View)
        self.add(childVC: GHFFollowerInfoHeaderViewController(user: user), to: self.headerView)
        self.dateLabel.text = "GitHub since \(user.created_at.convertToMonthYearFormat())"
    }
    
    func addContainerViews() {
        containerViews = [headerView, card1View, card2View, dateLabel]
        let padding: CGFloat = 20
        for containerView in containerViews {
            contentView.addSubview(containerView)
            containerView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
                containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            ])
        }
        let cardHeight: CGFloat = 140
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 210),
            card1View.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: padding),
            card1View.heightAnchor.constraint(equalToConstant: cardHeight),
            card2View.topAnchor.constraint(equalTo: card1View.bottomAnchor, constant: padding),
            card2View.heightAnchor.constraint(equalToConstant: cardHeight),
            dateLabel.topAnchor.constraint(equalTo: card2View.bottomAnchor, constant: padding),
            dateLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func add(childVC: UIViewController, to containerView: UIView) {
        addChild(childVC)
        containerView.addSubview(childVC.view)
        childVC.view.frame = containerView.bounds
        childVC.didMove(toParent: self)
    }
    
    @objc func dismissVC() {
        dismiss(animated: true)
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

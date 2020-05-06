//
//  GHFRepoCardVC.swift
//  GitHubFollowers
//
//  Created by Yinan Qiu on 5/3/20.
//  Copyright © 2020 Yinan. All rights reserved.
//

import UIKit

protocol GHFRepoCardVCDelegate: class {
    func didTapGitHubProfileBtn(of user: User)
}

class GHFRepoCardVC: GHFFollowerInfoCardViewController {
    
    weak var delegate: GHFRepoCardVCDelegate!
    
    init(user: User, delegate: GHFRepoCardVCDelegate) {
        super.init(user: user)
        self.delegate = delegate
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCardSections()
    }
    
    private func setCardSections() {
        cardSectionView1.set(infoType: .repos, count: user.public_repos)
        cardSectionView2.set(infoType: .gists, count: user.public_gists)
        button.set(bgColor: .systemGreen, title: "GitHub Profile")
    }
    
    override func buttonTapped() {
        delegate.didTapGitHubProfileBtn(of: user)
    }
}

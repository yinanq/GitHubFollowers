//
//  GHFFollowerCardVC.swift
//  GitHubFollowers
//
//  Created by Yinan Qiu on 5/3/20.
//  Copyright © 2020 Yinan. All rights reserved.
//

import UIKit

protocol GHFFollowerCardVCDelegate: class {
    func didTapSeeFollowersBtn(of user: User)
}

class GHFFollowerCardVC: GHFFollowerInfoCardViewController {
    
    weak var delegate: GHFFollowerCardVCDelegate!
    
    init(user: User, delegate: GHFFollowerCardVCDelegate) {
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
        cardSectionView1.set(infoType: .followers, count: user.followers)
        cardSectionView2.set(infoType: .following, count: user.following)
        button.set(bgColor: .systemGreen, title: "See Followers")
    }
    
    override func buttonTapped() {
        delegate.didTapSeeFollowersBtn(of: user)
    }
}

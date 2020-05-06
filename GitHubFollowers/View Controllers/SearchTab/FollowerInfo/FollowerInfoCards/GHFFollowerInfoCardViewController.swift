//
//  GHFFollowerInfoCardViewController.swift
//  GitHubFollowers
//
//  Created by Yinan Qiu on 5/3/20.
//  Copyright © 2020 Yinan. All rights reserved.
//

import UIKit

protocol GHFFollowerInfoCardVCDelegate: class {
    func didTapGitHubProfileBtn(of user: User)
    func didTapSeeFollowersBtn(of user: User)
}

class GHFFollowerInfoCardViewController: UIViewController {
    
    let stackView = UIStackView()
    let cardSectionView1 = GHFCardSectionView()
    let cardSectionView2 = GHFCardSectionView()
    let button = GHFButton()
    
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
        setBackground()
        addSubviews()
        setStackView()
        setButton()
    }
    
    private func setBackground() {
        view.layer.cornerRadius = 18
        view.backgroundColor = .secondarySystemBackground
    }
    
    private func addSubviews() {
        view.addSubviews(stackView, button)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        let padding: CGFloat = 20
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: padding),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            stackView.heightAnchor.constraint(equalToConstant: 50),
            button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -padding),
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            button.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    private func setStackView() {
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.addArrangedSubview(cardSectionView1)
        stackView.addArrangedSubview(cardSectionView2)
    }
    
    private func setButton() {
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    @objc func buttonTapped() {}

}

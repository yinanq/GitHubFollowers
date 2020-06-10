//
//  SearchViewController.swift
//  GitHubFollowers
//
//  Created by Yinan Qiu on 3/20/20.
//  Copyright © 2020 Yinan. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    let logoImageView = UIImageView()
    let usernameTextField = GHFTextField()
    let ctaButton = GHFButton(backgroundColor: .systemGreen, title: "See Followers")

    var isUsernameEntered: Bool { return !usernameTextField.text!.isEmpty }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Search"
        view.backgroundColor = .systemBackground
        view.addSubviews(logoImageView, usernameTextField, ctaButton)
        configureLogoImageView()
        configureTextField()
        configureCTAButton()
        createDimissKeyboardTapRecognizer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
        usernameTextField.text = ""
    }
    
    func createDimissKeyboardTapRecognizer() {
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    @objc func pushFollowersViewController() {
        guard isUsernameEntered else {
            presentGHFAlertOnMainThread(title: "No Username", message: "Please enter a username. Come on. Anyone's username.", buttonText: "OK")
            return
        }
        usernameTextField.resignFirstResponder()
        let followersViewController = FollowersViewController(username: usernameTextField.text!)
        navigationController?.pushViewController(followersViewController, animated: true)
    }
    
    func configureLogoImageView() {
        logoImageView.image = Images.ghLogo
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        
        let topGap: CGFloat = DeviceTypes.isiPhoneSE1 || DeviceTypes.isiPhone8Zoomed ? 20 : 80
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: topGap),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: 200),
            logoImageView.widthAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    func configureTextField() {
        usernameTextField.delegate = self
        NSLayoutConstraint.activate([
            usernameTextField.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 48),
            usernameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            usernameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            usernameTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func configureCTAButton() {
        ctaButton.addTarget(self, action: #selector(pushFollowersViewController), for: .touchUpInside)
        NSLayoutConstraint.activate([
            ctaButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            ctaButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            ctaButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            ctaButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
}


extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        pushFollowersViewController()
        return true
    }
}

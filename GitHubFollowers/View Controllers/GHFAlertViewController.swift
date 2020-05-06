//
//  GHFAlertViewController.swift
//  GitHubFollowers
//
//  Created by Yinan Qiu on 3/21/20.
//  Copyright © 2020 Yinan. All rights reserved.
//

import UIKit

class GHFAlertViewController: UIViewController {

    let alertView = GHFAlertView()
    let padding: CGFloat = 20
    
    let titleLabel = GHFTitleLabel(textAlignment: .center, fontSize: 20)
    let messageLabel = GHFBodyLabel(textAlignment: .center)
    let actionButton = GHFButton(backgroundColor: .systemPink, title: "OK")
    
    var alertTitle: String?
    var alertMessage: String?
    var alertButtonText: String?
    
    init(title: String, message: String, buttonText: String) {
        super.init(nibName: nil, bundle: nil)
        self.alertTitle = title
        self.alertMessage = message
        self.alertButtonText = buttonText
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.75)
        configureContainerView()
        configureTitleLabel()
        configureActionButton()
        configureMessageLabel()
    }
    
    func configureContainerView() {
        view.addSubview(alertView)
        NSLayoutConstraint.activate([
            alertView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            alertView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            alertView.widthAnchor.constraint(equalToConstant: 280),
            alertView.heightAnchor.constraint(equalToConstant: 220)
        ])
    }
    
    func configureTitleLabel() {
        alertView.addSubview(titleLabel)
        titleLabel.text = alertTitle ?? "Something went wrong"
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: alertView.topAnchor, constant: padding),
            titleLabel.leadingAnchor.constraint(equalTo: alertView.leadingAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: alertView.trailingAnchor, constant: -padding),
            titleLabel.heightAnchor.constraint(equalToConstant: 28)
        ])
    }
    
    func configureActionButton() {
        alertView.addSubview(actionButton)
        actionButton.setTitle(alertButtonText ?? "OK OK !!", for: .normal)
        actionButton.addTarget(self, action: #selector(dismissSelf), for: .touchUpInside)
        NSLayoutConstraint.activate([
            actionButton.bottomAnchor.constraint(equalTo: alertView.bottomAnchor, constant: -padding),
            actionButton.leadingAnchor.constraint(equalTo: alertView.leadingAnchor, constant: padding),
            actionButton.trailingAnchor.constraint(equalTo: alertView.trailingAnchor, constant: -padding),
            actionButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    @objc func dismissSelf() {
        dismiss(animated: true)
    }
    
    func configureMessageLabel() {
        alertView.addSubview(messageLabel)
        messageLabel.text = alertMessage ?? "Something went wrong, very very wrong..."
        messageLabel.numberOfLines = 4
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            messageLabel.bottomAnchor.constraint(equalTo: actionButton.topAnchor, constant: -12),
            messageLabel.leadingAnchor.constraint(equalTo: alertView.leadingAnchor, constant: padding),
            messageLabel.trailingAnchor.constraint(equalTo: alertView.trailingAnchor, constant: -padding)
        ])
    }

}

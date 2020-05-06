//
//  UIViewController+Ext.swift
//  GitHubFollowers
//
//  Created by Yinan Qiu on 3/21/20.
//  Copyright © 2020 Yinan. All rights reserved.
//

import UIKit
import SafariServices

extension UIViewController {
    
    func presentSafariVC(with url: URL) {
        let safariVC = SFSafariViewController(url: url)
        safariVC.preferredControlTintColor = .systemGreen
        present(safariVC, animated: true)
    }
    
    func presentGHFAlertOnMainThread(title: String, message: String, buttonText: String) {
        DispatchQueue.main.async {
            let alertVC = GHFAlertViewController(title: title, message: message, buttonText: buttonText)
            alertVC.modalPresentationStyle = .overFullScreen
            alertVC.modalTransitionStyle = .crossDissolve
            self.present(alertVC, animated: true)
        }
    }
}

//
//  GHFAlertView.swift
//  GitHubFollowers
//
//  Created by Yinan Qiu on 5/4/20.
//  Copyright © 2020 Yinan. All rights reserved.
//

import UIKit

class GHFAlertView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .systemBackground
        layer.cornerRadius = 16
        layer.borderWidth = 2
        layer.borderColor = UIColor.white.cgColor
    }
    
}

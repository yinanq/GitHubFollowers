//
//  GHFTextField.swift
//  GitHubFollowers
//
//  Created by Yinan Qiu on 3/21/20.
//  Copyright © 2020 Yinan. All rights reserved.
//

import UIKit

class GHFTextField: UITextField {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .tertiarySystemBackground
        layer.cornerRadius = 10
        layer.borderWidth = 2
        layer.borderColor = UIColor.systemGray4.cgColor
        textAlignment = .center
        textColor = .label
        tintColor = .label
        font = UIFont.preferredFont(forTextStyle: .title2)
        adjustsFontSizeToFitWidth = true
        minimumFontSize = 12
        autocorrectionType = .no
        autocapitalizationType = .none
        returnKeyType = .go
        placeholder = "enter a GitHub username"
//        clearButtonMode = .whileEditing
    }
    
}

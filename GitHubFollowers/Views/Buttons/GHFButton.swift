//
//  GHFButton.swift
//  GitHubFollowers
//
//  Created by Yinan Qiu on 3/20/20.
//  Copyright © 2020 Yinan. All rights reserved.
//

import UIKit

class GHFButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(backgroundColor: UIColor, title: String) {
        self.init(frame: .zero)
        self.backgroundColor = backgroundColor
        self.setTitle(title, for: .normal)
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = 10
        titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
//        setTitleColor(.white, for: .normal) //not needed in this case since default is white
    }
    
    func set(bgColor: UIColor, title: String) {
        backgroundColor = bgColor
        setTitle(title, for: .normal)
    }
    
}

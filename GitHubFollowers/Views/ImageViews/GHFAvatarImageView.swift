//
//  GHFAvatarImageView.swift
//  GitHubFollowers
//
//  Created by Yinan Qiu on 3/24/20.
//  Copyright © 2020 Yinan. All rights reserved.
//

import UIKit

class GHFAvatarImageView: UIImageView {
    
    let placeholderImage = Images.placeholder
    let cache = NetworkManager.shared.cache
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        layer.cornerRadius = 10
        clipsToBounds = true
        image = placeholderImage
        translatesAutoresizingMaskIntoConstraints = false
    }
    
//    // replaced by func downloadImage() in NetworkManager:
//    func downloadAvatarImage(from urlString: String) {
//        let cacheKey = NSString(string: urlString)
//        // if image already in cache:
//        if let image = cache.object(forKey: cacheKey) {
//            self.image = image
//            return
//        }
//        // if image not already in cache:
//        guard let url = URL(string: urlString) else { return }
//        let task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
//            guard let self = self else { return }
//            if error != nil { return }
//            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { return }
//            guard let data = data else { return }
//            guard let image = UIImage(data: data) else { return }
//            self.cache.setObject(image, forKey: cacheKey)
//            DispatchQueue.main.async { self.image = image }
//        }
//        task.resume()
//    }
    
}

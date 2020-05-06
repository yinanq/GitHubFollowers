//
//  NetworkManager.swift
//  GitHubFollowers
//
//  Created by Yinan Qiu on 3/22/20.
//  Copyright © 2020 Yinan. All rights reserved.
//

import UIKit

class NetworkManager {
    
    static let shared = NetworkManager()
    private let baseURL = "https://api.github.com/"
    let cache = NSCache<NSString, UIImage>()
    
    private init() {}
    
    //    func getFollowers(for username: String, page: Int, completed: @escaping ([Follower]?, ErrorMessage?) -> Void) {
    func getFollowers(for username: String, page: Int, completed: @escaping (Result<[Follower], GHFError>) -> Void) {
        
        let endpoint = baseURL + "users/\(username)/followers?per_page=100&page=\(page)"
        
        guard let url = URL(string: endpoint) else {
            //            completed(nil, .usernameInvalid)
            completed(.failure(.usernameInvalid))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let _ = error {
                //                completed(nil, .unableToComplete)
                completed(.failure(.unableToComplete))
                return
            }
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                //                completed(nil, .responseInvalid)
                completed(.failure(.responseInvalid))
                return
            }
            guard let data = data else {
                //                completed(nil, .dataInvalid)
                completed(.failure(.dataInvalid))
                return
            }
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .useDefaultKeys
                let followers = try decoder.decode([Follower].self, from: data)
                //                completed(followers, nil)
                completed(.success(followers))
            } catch {
                //                completed(nil, .dataCannotDecode)
                completed(.failure(.dataCannotDecode))
            }
        }
        task.resume()
        
    }
    
    func getFollowerInfo(for followerName: String, completed: @escaping (Result<User, GHFError>) -> Void) {
        
        let endpoint = baseURL + "users/\(followerName)"
        
        guard let url = URL(string: endpoint) else {
            completed(.failure(.usernameInvalid))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let _ = error {
                completed(.failure(.unableToComplete))
                return
            }
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.responseInvalid))
                return
            }
            guard let data = data else {
                completed(.failure(.dataInvalid))
                return
            }
            do {
                let decoder = JSONDecoder()
                //                    decoder.keyDecodingStrategy = .useDefaultKeys
                //                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                decoder.dateDecodingStrategy = .iso8601
                let follower = try decoder.decode(User.self, from: data)
                completed(.success(follower))
            } catch {
                completed(.failure(.dataCannotDecode))
            }
        }
        task.resume()
        
    }
    
    func downloadImage(from urlString: String, completed: @escaping (UIImage?) -> Void) {
        let cacheKey = NSString(string: urlString)
        // if image already in cache:
        if let image = cache.object(forKey: cacheKey) {
            completed(image)
            return
        }
        // if image not already in cache:
        // if no image to download:
        guard let url = URL(string: urlString) else {
            completed(nil)
            return
        }
        // download image:
        let task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let self = self,
                error == nil,
                let response = response as? HTTPURLResponse, response.statusCode == 200,
                let data = data,
                let image = UIImage(data: data) else {
                    completed(nil)
                    return
            }
            self.cache.setObject(image, forKey: cacheKey)
            completed(image)
        }
        task.resume()
    }
    
}

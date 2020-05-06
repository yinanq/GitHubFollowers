//
//  PersistenceManager.swift
//  GitHubFollowers
//
//  Created by Yinan Qiu on 5/3/20.
//  Copyright © 2020 Yinan. All rights reserved.
//

import Foundation

enum PersistenceActionType {
    case add, remove
}

enum PersistenceManager {
    
    static private let defaults = UserDefaults.standard
    
    enum Keys {
        static let favs = "favs"
    }
    
    static func updateWith(fav: Follower, actionType: PersistenceActionType, completed: @escaping (GHFError?) -> Void) {
        retrieveFavs { result in
            switch result {
            case .success(var favs):
                switch actionType {
                case .add:
                    guard !favs.contains(fav) else {
                        completed(.alreadyInFavs)
                        return
                    }
                    favs.append(fav)
                case .remove:
                    favs.removeAll{ $0.login == fav.login }
                }
                completed(save(favs: favs))
            case .failure(let error):
                completed(error)
            }
        }
    }
    
    static func retrieveFavs(completed: @escaping (Result<[Follower], GHFError>) -> Void) {
        guard let favsData = defaults.object(forKey: Keys.favs) as? Data else {
            completed(.success([]))
            return
        }
        do {
            let decoder = JSONDecoder()
            let favs = try decoder.decode([Follower].self, from: favsData)
            completed(.success(favs))
        } catch {
            completed(.failure(.unableToFav))
        }
    }
    
    static func save(favs: [Follower]) -> GHFError? {
        do {
            let encoder = JSONEncoder()
            let encodedFavs = try encoder.encode(favs)
            defaults.set(encodedFavs, forKey: Keys.favs)
            return nil
        } catch {
            return .unableToFav
        }
    }
    
}

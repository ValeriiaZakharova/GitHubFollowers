//
//  PersistenceManager.swift
//  GitHubFollowers
//
//  Created by Valeriia Zakharova on 09.03.2021.
//

import Foundation

enum PersistenceActionType {
    case add, remove
}

enum PersistenceManager {
    enum Keys {
        static let favorites = "favorites"
    }

    static private let defaults = UserDefaults.standard

    static func updateWith(favorite: Follower, actionType: PersistenceActionType, completion: @escaping(ErrorMessage?) -> Void) {
        retriveFavorites { result in
            switch result {
            case .success(var favorites):

                switch actionType {
                case .add:
                    //check if retrievedFavorites contains favorite
                    guard !favorites.contains(favorite) else {
                        completion(.alreadyInFavorites)
                        return
                    }
                    favorites.append(favorite)
                case .remove:
                    //itereing throw an array and if element's login equals favorite.login we remove it
                    favorites.removeAll { $0.login == favorite.login }
                }
                completion(save(favorites: favorites))

            case .failure(let error):
                completion(error)
            }
        }
    }

    //decoding
    static func retriveFavorites(completion: @escaping (Result<[Follower], ErrorMessage>) -> Void) {
        //get favorites data from userdefoults if its not there-we did't save it yet, returns an empty array
        //swift knows there is object but he did't know what type, we nned to cast it to Date
        guard let favoritesData = defaults.object(forKey: Keys.favorites) as? Data else {
            completion(.success([]))
            return
        }

        do {
            let decoder = JSONDecoder()
            let favorites = try decoder.decode([Follower].self, from: favoritesData)
            completion(.success(favorites))
        } catch {
            completion(.failure(.unableToFavorite))
        }
    }

    //encoding
    static func save(favorites: [Follower]) -> ErrorMessage? {
        do {
            let encoder = JSONEncoder()
            let encodedFavorites = try encoder.encode(favorites)
            defaults.setValue(encodedFavorites, forKey: Keys.favorites)
            return nil
        } catch {
            return .unableToFavorite
        }
    }
}

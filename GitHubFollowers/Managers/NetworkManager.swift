//
//  NetworkManager.swift
//  GitHubFollowers
//
//  Created by Valeriia Zakharova on 02.03.2021.
//

import UIKit

class NetworkManager {
    static let shared = NetworkManager()

    private let baseURL = "https://api.github.com/users/"
    // cache holder
    let cache = NSCache<NSString, UIImage>()

    private init() {}

    //page - for network call from API
    //Result - enum that returns 2 cases - success or failure
    func getFollowers(for username: String, page: Int, completion: @escaping (Result<[Follower], ErrorMessage>) -> Void) {
        let endpoint = baseURL + "\(username)/followers?per_page=100&page=\(page)"

        guard let url = URL(string: endpoint) else {
            completion(.failure(.invalidUsername))
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            //usually this error come from bad internet connection, if something wrong with the network call you will get an error in response
            if let _ = error {
                completion(.failure(.unabletoComplete))
            }

            guard let response = response  as? HTTPURLResponse, response.statusCode == 200 else {
                completion(.failure(.invalidResponse))
                return
            }

            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }

            do {
                let decoder = JSONDecoder()
                //convert our variable from snakecase
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let followers = try decoder.decode([Follower].self, from: data)
                completion(.success(followers))
            } catch {
                completion(.failure(.invalidData))
            }
        }
        task.resume()
    }

    func getUserInfo(for username: String, completion: @escaping (Result<User, ErrorMessage>) -> Void) {
        let endpoint = baseURL + "\(username)"

        guard let url = URL(string: endpoint) else {
            completion(.failure(.invalidUsername))
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            //usually this error come from bad internet connection, if something wrong with the network call you will get an error in response
            if let _ = error {
                completion(.failure(.unabletoComplete))
            }

            guard let response = response  as? HTTPURLResponse, response.statusCode == 200 else {
                completion(.failure(.invalidResponse))
                return
            }

            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }

            do {
                let decoder = JSONDecoder()
                //convert our variable from snakecase
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let user = try decoder.decode(User.self, from: data)
                completion(.success(user))
            } catch {
                completion(.failure(.invalidData))
            }
        }
        task.resume()
    }
}

//escaping means that the closure lives longer then the function - when its escaping you need to menege its reference count, that's why we have to use weak self to prevent two objects point strong references to each other
//non escaping - by defoult it means it does't outlive the function

//
//  NetworkManager.swift
//  GitHubFollowers
//
//  Created by Valeriia Zakharova on 02.03.2021.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    let baseURL = "https://api.github.com/users/"

    private init() {}

    //page - for network call from API
    func getFollowers(for username: String, page: Int, completion: @escaping ([Follower]?, ErrorMessage?) -> Void) {
        let endpoint = baseURL + "\(username)/followers?per_page=100&\(page)"

        guard let url = URL(string: endpoint) else {
            completion(nil, .invalidUsername)
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            //usually this error come from bad internet connection, if something wrong with the network call you will get an error in response
            if let _ = error {
                completion(nil, .unabletoComplete)
            }

            guard let response = response  as? HTTPURLResponse, response.statusCode == 200 else {
                completion(nil, .invalidResponse)
                return
            }

            guard let data = data else {
                completion(nil, .invalidData)
                return
            }

            do {
                let decoder = JSONDecoder()
                //convert our variable from snakecase
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let followers = try decoder.decode([Follower].self, from: data)
                completion(followers, nil)
            } catch {
                completion(nil, .invalidData)
            }
        }

        task.resume()
    }
}

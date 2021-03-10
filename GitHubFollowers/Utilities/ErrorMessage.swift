//
//  ErrorMessage.swift
//  GitHubFollowers
//
//  Created by Valeriia Zakharova on 02.03.2021.
//

import Foundation

enum ErrorMessage: String, Error {
    case invalidUsername = "This username created an invalid request. Please try again."
    case unabletoComplete = "Unable to complete your request. Please check your internet connection."
    case invalidResponse = "Invalid response from the server. Please try again."
    case invalidData = "The data received from the server was invalid. Please try again."
    case unableToFavorite = "There was an error favoriting this user. Please try again."
    case alreadyInFavorites = "You've already favorited this user. You must Really like them."
}

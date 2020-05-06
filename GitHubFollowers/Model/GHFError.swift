//
//  GHFError.swift
//  GitHubFollowers
//
//  Created by Yinan Qiu on 3/24/20.
//  Copyright © 2020 Yinan. All rights reserved.
//

import Foundation

//enum ErrorMessage: String {
//    case usernameInvalid = "This username is not found. Please try again."
//    case unableToComplete = "Unable to complete your request. Please check your internet connection."
//    case responseInvalid = "Response from the server was invalid. Please try again."
//    case dataInvalid = "Data from the server was invalid. Please try again."
//    case dataCannotDecode = "Data from the server cannot be decoded. Please try again."
//}

enum GHFError: String, Error {
    case usernameInvalid = "This username is not found. Please try again."
    case unableToComplete = "Unable to complete your request. Please check your internet connection."
    case responseInvalid = "Response from the server was invalid. Please try again."
    case dataInvalid = "Data from the server was invalid. Please try again."
    case dataCannotDecode = "Data from the server cannot be decoded. Please try again."
    case unableToFav = "Unable to save this user to favs. Please try again."
    case alreadyInFavs = "This user is already in your favs."
}

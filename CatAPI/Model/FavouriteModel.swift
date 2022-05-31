//
//  FavouriteModel.swift
//  CatAPI
//
//  Created by motor on 2022/5/27.
//

import UIKit

struct FavoriteModel: Decodable {
    let id: Int
    let image: Image
}
struct Image: Decodable {
    let id: String
    let url: URL
}

enum CatApiError: Error, LocalizedError {
   case favoritesNotFound
}

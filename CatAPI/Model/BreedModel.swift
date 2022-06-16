//
//  BreedModel.swift
//  CatAPI
//
//  Created by motor on 2022/5/19.
//

import UIKit

struct BreedModel: Codable {
    let id: String
    let name: String
    let temperament: String
    let breedExplaination: String
    let energyLevel: Double
    let adaptability: Double
    let childFriendly: Double
    let dogFriendly: Double
    let intelligence: Double
    let healthIssues: Double
    let strangerFriendly: Double
    let wikipediaUrl: String?
    let isHairless: Bool
    let image: BreedImage?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case temperament
        case breedExplaination = "description"
        case energyLevel = "energy_level"
        case adaptability
        case childFriendly = "child_friendly"
        case dogFriendly = "dog_friendly"
        case intelligence
        case healthIssues = "health_issues"
        case strangerFriendly = "stranger_friendly"
        case wikipediaUrl = "wikipedia_url"
        case isHairless = "hairless"
        case image
    }
    
    //MARK: - Change isHairless from Int to Bool
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try values.decode(String.self, forKey: .id)
        name = try values.decode(String.self, forKey: .name)
        temperament = try values.decode(String.self, forKey: .temperament)
        breedExplaination = try values.decode(String.self, forKey: .breedExplaination)
        energyLevel = try values.decode(Double.self, forKey: .energyLevel)
        adaptability = try values.decode(Double.self, forKey: .adaptability)
        childFriendly = try values.decode(Double.self, forKey: .childFriendly)
        dogFriendly = try values.decode(Double.self, forKey: .dogFriendly)
        intelligence = try values.decode(Double.self, forKey: .intelligence)
        healthIssues = try values.decode(Double.self, forKey: .healthIssues)
        strangerFriendly = try values.decode(Double.self, forKey: .strangerFriendly)
        wikipediaUrl = try? values.decode(String.self, forKey: .wikipediaUrl)
        let hairless = try values.decode(Int.self, forKey: .isHairless)
        isHairless = hairless == 1
        image = try values.decodeIfPresent(BreedImage.self, forKey: .image)
    }
}

struct BreedImage: Codable {
    let height: Int?
    let id: String?
    let url: URL?
    let width: Int?
}


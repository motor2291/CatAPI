//
//  BreedModel.swift
//  CatAPI
//
//  Created by motor on 2022/5/19.
//

import Foundation
import UIKit

struct BreedModel: Codable {
    let id: String
    let name: String
    let temperament: String
    let breedExplaination: String
    let energyLevel: Int
    let isHairless: Bool
    let image: BreedImage?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case temperament
        case breedExplaination = "description"
        case energyLevel = "energy_level"
        case isHairless = "hairless"
        case image
    }
    
    var energyImage: String {
        switch energyLevel {
        case 1:
            return "1.square.fill"
        case 2:
            return "2.square.fill"
        case 3:
            return "3.square.fill"
        case 4:
            return "4.square.fill"
        case 5:
            return "5.square.fill"
        default:
            return "multiply"
        }
    }
    
    //MARK: - Change isHairless from Int to Bool
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try values.decode(String.self, forKey: .id)
        name = try values.decode(String.self, forKey: .name)
        temperament = try values.decode(String.self, forKey: .temperament)
        breedExplaination = try values.decode(String.self, forKey: .breedExplaination)
        let energyImage = try values.decode(Int.self, forKey: .energyLevel)
        energyLevel = energyImage
        let hairless = try values.decode(Int.self, forKey: .isHairless)
        isHairless = hairless == 1
        image = try values.decodeIfPresent(BreedImage.self, forKey: .image)
    }
}

struct BreedImage: Codable {
    let height: Int?
    let id: String?
    let url: String?
    let width: Int?
}


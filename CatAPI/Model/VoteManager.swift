//
//  VoteManage.swift
//  CatAPI
//
//  Created by motor on 2022/5/22.
//

import Foundation
import UIKit

protocol VoteManagerDelegate {
    func didUpdataImage(vote: VoteModel)
    func saveFavData(vote: VoteModel)
    func didFailWithError(error: Error)
}

struct VoteManager {
    
    var delegate: VoteManagerDelegate?
    let baseURL = "https://api.thecatapi.com/v1/images/search"
    let apiKey = "3135a0e2-1fb4-4739-bac9-3cca33874ff0"
    
    func performSaveFav() {
        let urlString = "\(baseURL)?apikey=\(apiKey)"
        if let url = URL(string: urlString) {
            URLSession(configuration: .default).dataTask(with: url) { data, response, error in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let vote = self.parseJSON(safeData) {
                        self.delegate?.saveFavData(vote: vote)
                        self.delegate?.didUpdataImage(vote: vote)
                    }
                }
            }.resume()
        }
    }
    
    func performRequest() {
        let urlString = "\(baseURL)?apikey=\(apiKey)"
        if let url = URL(string: urlString) {
            URLSession(configuration: .default).dataTask(with: url) { data, response, error in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let vote = self.parseJSON(safeData) {
                        self.delegate?.didUpdataImage(vote: vote)
                    }
                }
            }.resume()
        } 
    }
    
    func parseJSON(_ voteData: Data) -> VoteModel? {
        do {
            let decodeData = try JSONDecoder().decode([VoteData].self, from: voteData)
            let url = decodeData[0].url
            let id = decodeData[0].id
            let voteModel = VoteModel(id: id, url: url)
            return voteModel
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}


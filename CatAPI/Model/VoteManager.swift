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
    func didFailWithError(error: Error)
}

struct VoteManager {
    
    var delegate: VoteManagerDelegate?
    
    let baseURL = "https://api.thecatapi.com/v1/images/search"
    let apiKey = "3135a0e2-1fb4-4739-bac9-3cca33874ff0"
    
    func fetchCatData() {
        //let urlString = "https://api.thecatapi.com/v1/images/search?mime_types=gif"
        let urlString = "\(baseURL)?apikey=\(apiKey)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let vote = self.parseJSON(safeData) {
                        self.delegate?.didUpdataImage(vote: vote)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ voteData: Data) -> VoteModel? {
        let decoder = JSONDecoder()
        do {
            let decodeData = try decoder.decode([VoteData].self, from: voteData)
            let url = decodeData[0].url
            let voteModel = VoteModel(url: url)
            return voteModel
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}


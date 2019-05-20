//
//  MarvelServiceCalls.swift
//  Marvel
//
//  Created by Vikas on 5/19/19.
//  Copyright © 2019 Vikas. All rights reserved.
//


import Foundation

class MarvelServiceCalls: NSObject {
    
    //MARK: Variable declarations
    static var shared = MarvelServiceCalls()
    private let apiClient = APIProvider.client
    
    
    //MARK: Marvel character list API
    func getCharactersList(limit: Int, offset: Int, completionHandler: @escaping ((_ token: CharactersData?, _ error: Error?)->()) ) {
        if NetworkManager.shared.isNetworkReachable() {
            apiClient.request(.getCharactersList(limit: limit, offset: offset), completion: { (result) in
                do {
                    let characters =  try APIProvider.getAPIResponse(forType: CharactersData.self, result: result)
                    completionHandler(characters,nil)
                } catch _ {
                    completionHandler(nil,MError.apiError("Unable to load records"))
                }
            })
        }
        else {
            completionHandler(nil, MError.networkNotReachable)
        }
    }
    
    //MARK: Marvel character details API
    func getCharactersDetails(charID: Int, completionHandler: @escaping ((_ token: CharactersData?, _ error: Error?)->()) ) {
        if NetworkManager.shared.isNetworkReachable() {
            let charIDStr = "\(charID)"
            apiClient.request(.getCharactersDetail(charcterID: charIDStr), completion: { (result) in
                do {
                    let resultObj =  try APIProvider.getAPIResponse(forType: CharactersData.self, result: result)
                    completionHandler(resultObj,nil)
                } catch _ {
                    completionHandler(nil,MError.apiError("Unable to load records"))
                }
            })
        }
        else {
            completionHandler(nil, MError.networkNotReachable)
        }
    }
}




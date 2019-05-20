//
//  APIProvider.swift
//  Marvel
//
//  Created by Vikas on 5/19/19.
//  Copyright © 2019 Vikas. All rights reserved.
//

import Foundation
import Moya
import enum Result.Result
import Alamofire

class APIProvider {
    
    static let client = MoyaProvider<APIClient>(plugins: [NetworkLoggerPlugin(verbose: true)])
    
    static func getAPIError(error: MoyaError) -> MError {
        
        let defaultErrorString = "Unable to load data"
        guard let response = error.response else { return MError.apiError(defaultErrorString) }
        let decoder = JSONDecoder()
        if let apiResponse = try? decoder.decode(APIResponse<String>.self, from: response.data) {
            return MError.apiError(apiResponse.errorMessage)
        } else {
            return MError.apiError(defaultErrorString)
        }
    }
    
    static func getAPIResponse<T:Decodable>(forType type: T.Type, result: Result<Moya.Response, MoyaError>) throws -> T {
        switch result {
        case .success(let response):
            let decoder = JSONDecoder()
            let apiResponse = try decoder.decode(APIResponse<T>.self, from: response.data)
            if apiResponse.code == 200 {
                guard let data = apiResponse.data else { throw MError.apiError(apiResponse.errorMessage) }
                return data
            } else {
                throw MError.apiError(apiResponse.errorMessage)
            }
        case .failure(let error):
            throw getAPIError(error: error)
        }
    }
    
    static func ensureNetworkReachability() throws {
        if NetworkManager.shared.isNetworkReachable() {
            throw MError.networkNotReachable
        }
    }

}

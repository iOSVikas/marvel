//
//  Server.swift
//  Marvel
//
//  Created by Vikas on 5/19/19.
//  Copyright © 2019 Vikas. All rights reserved.
//

import Foundation

enum Server {
    
    case development
    case production
    
    func baseURL() -> String {
        switch self {
        case .development:
            return "https://gateway.marvel.com:443/v1/public/"
        case .production:
            return "https://gateway.marvel.com:443/v1/public/"
        }
    }
    
    var displayName: String {
        switch self {
        case .development: return "development"
        case .production: return "production"
        }
    }
}

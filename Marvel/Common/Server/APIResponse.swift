//
//  APIResponse.swift
//  Marvel
//
//  Created by Vikas on 5/19/19.
//  Copyright © 2019 Vikas. All rights reserved.
//

import Foundation

public struct APIResponse<T:Decodable> : Decodable {
    
    public let code: Int
    public let status: String
    public let errorMessage: String
    public let data: T?
    
    enum CodingKeys: String, CodingKey {
        case code = "code"
        case status = "status"
        case errorMessage = "attributionText"
        case data = "data"
    }
    
    public init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.code = try container.decode(Int.self, forKey: .code)
        self.status = try container.decode(String.self, forKey: .status)
        self.errorMessage = try container.decode(String.self, forKey: .errorMessage)
        if self.code == 200 {
            self.data = try container.decode(T.self, forKey: .data)
        } else {
            self.data = nil
        }
    }
}

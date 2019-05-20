//
//  APIClient.swift
//  Marvel
//
//  Created by Vikas on 5/19/19.
//  Copyright © 2019 Vikas. All rights reserved.
//

import Foundation
import Moya
import CommonCrypto

enum APIClient {

    case getCharactersList(limit: Int, offset: Int)
    case getCharactersDetail(charcterID: String)

}

extension APIClient: TargetType {
    
    private static let publicKey = "2c622ba178741d22590b6a94bc764b9e"
    private static let privateKey = "8e20bb8f30ef5a51b6ba92c14bdbdeb8ff06515a"
    
    var baseURL: URL {
        return URL(string: NetworkManager.shared.getInstanceUrl())!
    }
    
    var path: String {
        switch self {
        case .getCharactersList: return "characters"
        case .getCharactersDetail(charcterID: let charID): return "characters/\(charID)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getCharactersList, .getCharactersDetail:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .getCharactersList, .getCharactersDetail:
            return .requestParameters(parameters: parameters ?? [:], encoding: URLEncoding.default)
        }
    }
    
    var sampleData: Data {
        switch self {
        default:
            return "{}".data(using: .utf8)! //TODO: Put Response stub in file
        }
    }
    
    var headers: [String:String]? {
        return [
            "Content-type": "application/json"
        ]
    }

    var parameters: [String:Any]? {
        switch self {
        case .getCharactersList(limit: let limit, offset: let offset) :
            let hashData = getHashKey()
            return ["limit": limit, "offset": offset,
                "apikey": APIClient.publicKey, "hash": hashData.hash, "ts" : hashData.ts
                    ]
        case .getCharactersDetail:
            let hashData = getHashKey()
            return ["apikey": APIClient.publicKey, "hash": hashData.hash, "ts" : hashData.ts]
        }
    }
    
    var validationType: ValidationType {
        switch self {
        default:
            return .successCodes
        }
    }
    
    private func getHashKey() -> (hash: String, ts: String) {
        let ts = "\(NSDate().timeIntervalSince1970)"
        let keys = ts + APIClient.privateKey + APIClient.publicKey
        let md5Data = MD5(string:keys)
        let md5Hex =  md5Data.map { String(format: "%02hhx", $0) }.joined()
        return (md5Hex, ts)
    }
    
    private func MD5(string: String) -> Data {
        let length = Int(CC_MD5_DIGEST_LENGTH)
        let messageData = string.data(using:.utf8)!
        var digestData = Data(count: length)
        
        _ = digestData.withUnsafeMutableBytes { digestBytes -> UInt8 in
            messageData.withUnsafeBytes { messageBytes -> UInt8 in
                if let messageBytesBaseAddress = messageBytes.baseAddress, let digestBytesBlindMemory = digestBytes.bindMemory(to: UInt8.self).baseAddress {
                    let messageLength = CC_LONG(messageData.count)
                    CC_MD5(messageBytesBaseAddress, messageLength, digestBytesBlindMemory)
                }
                return 0
            }
        }
        return digestData
    }
}

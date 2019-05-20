//
//  MError.swift
//  Marvel
//
//  Created by Vikas on 5/19/19.
//  Copyright © 2019 Vikas. All rights reserved.
//

import Foundation

enum MError : Error {
    case apiError(String)
    case networkNotReachable

    var errorTitle: String {
        switch self {
        case .apiError:
            return NSLocalizedString("Something went wrong", comment: "")
        case .networkNotReachable:
            return NSLocalizedString("No Internet Connection", comment: "")
        }
    }
    
    var localizedDescription: String {
        switch self {
        case .apiError(let string):
            return NSLocalizedString(string, comment: "")
        case .networkNotReachable:
            return NSLocalizedString("Please ensure that you are connected to the internet and try again.", comment: "")
            
        }
    }
}

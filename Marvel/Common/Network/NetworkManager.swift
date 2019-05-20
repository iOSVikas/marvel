//
//  NetworkManager.swift
//  Marvel
//
//  Created by Vikas on 5/19/19.
//  Copyright © 2019 Vikas. All rights reserved.
//

import Foundation
import Alamofire

final class NetworkManager {
    //MARK: Variable declarations
    public static let shared = NetworkManager()
    private let reachabilityManager = Alamofire.NetworkReachabilityManager()
    private var server: Server!

    //MARK: API and network methods
    public func set(server: Server) {
        self.server = server
        listenForReachability()
    }
    
    public func getInstanceUrl() -> String {
        return self.server!.baseURL()
    }
    
    private func listenForReachability() {
        self.reachabilityManager?.listener = { status in
            print("Network status changed: \(status)")
        }
        self.reachabilityManager?.startListening()
    }
    
    public func isNetworkReachable() -> Bool {
        return reachabilityManager?.isReachable ?? false
    }
}

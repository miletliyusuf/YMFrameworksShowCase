//
//  NetworkManager.swift
//  PersonalFrameworkTester
//
//  Created by Yusuf Miletli on 13.04.2020.
//  Copyright © 2020 Miletli. All rights reserved.
//

import Foundation
import YMNetwork

enum NetworkEnvironment {

    case qa
    case production
    case staging

    var baseURL: String {
        switch NetworkManager.environment {
        case .production: return "https://api.themoviedb.org/3/movie/"
        case .qa: return "https://qa.themoviedb.org/3/movie/"
        case .staging: return "https://staging.themoviedb.org/3/movie/"
        }
    }
}


// MARK: - NetworkManager

struct NetworkManager {

    static let environment: NetworkEnvironment = .production
    static let shared = NetworkManager()

    private let manager = YMNetworkManager(
        configuration: YMNetworkConfiguartion(
            baseURL: environment.baseURL,
            headers: [:]
        )
    )

    func request<T: CodableResponse>(
        request: YMRequest,
        completion: @escaping (_ response: T?, _ error: String?) -> ()
    ) {

        manager.request(request) { (response, result: Result<T>, error) in

            if error != nil {
                completion(nil, "Please check your network connection")
            }

            switch result {
            case .success(let data):
                completion(data, nil)
            case .failure(let error):
                completion(nil, error.rawValue)
            }
        }
    }
}

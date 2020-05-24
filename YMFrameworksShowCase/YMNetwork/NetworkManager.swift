//
//  NetworkManager.swift
//  YMFrameworksShowCase
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
    case download
    case upload

    var baseURL: String {
        switch NetworkManager.environment {
        case .download: return "https://speed.hetzner.de/"
        case .upload: return "https://httpbin.org/"
        case .production: return "https://api.themoviedb.org/3/movie/"
        case .qa: return "https://qa.themoviedb.org/3/movie/"
        case .staging: return "https://staging.themoviedb.org/3/movie/"
        }
    }
}


// MARK: - NetworkManager

class NetworkManager {

    static let environment: NetworkEnvironment = .production
    static let shared = NetworkManager()

    private let manager = YMNetworkManager(
        configuration: YMNetworkConfiguration(
            baseURL: environment.baseURL,
            headers: [:]
        )
    )

    func request<T: YMResponse>(
        request: YMRequest,
        completion: @escaping (_ response: T?, _ error: String?) -> ()
    ) {

        manager.request(request) { (response, result: YMResult<T>, error) in

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

    func startDownload(request: inout YMDownloadRequest?) throws {

        try? manager.download(with: &request)
    }

    func cancelDownload(request: YMDownloadRequest) {

        manager.cancelDownloadTask(of: request)
    }

    func pauseDownload(request: YMDownloadRequest) {

        manager.pauseDownloadTask(of: request)
    }

    func resumeDownload(
        request: YMDownloadRequest,
        completion: @escaping (_ status: Bool, _ error: String?) -> ()
    ) {

        manager.resumeDownloadTask(of: request) { (status, error) in
            completion(status, error)
        }
    }
}

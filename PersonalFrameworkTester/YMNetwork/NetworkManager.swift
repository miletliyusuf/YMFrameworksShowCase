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
}

public enum MovieAPI {

    case recommended(id: Int)
    case popular(page: Int)
    case newMovies(page: Int)
    case video(id: Int)
}

extension MovieAPI: EndPointType {

    var environmentBaseURL : String {
        switch NetworkManager.environment {
        case .production: return "https://api.themoviedb.org/3/movie/"
        case .qa: return "https://qa.themoviedb.org/3/movie/"
        case .staging: return "https://staging.themoviedb.org/3/movie/"
        }
    }

    public var baseURL: URL {
        guard let url = URL(string: environmentBaseURL) else {
            fatalError("baseURL could not be configured.")
        }
        return url
    }

    public var path: String {
        switch self {
        case .recommended(let id):
            return "\(id)/recommendations"
        case .popular:
            return "popular"
        case .newMovies:
            return "now_playing"
        case .video(let id):
            return "\(id)/videos"
        }
    }

    public var httpMethod: HTTPMethod {
        return .get
    }

    public var task: HTTPTask {
        switch self {
        case .newMovies(let page):
            return .requestParameters(
                bodyParameters: nil,
                urlParameters: ["page": page, "api_key": NetworkManager.APIKey]
            )
        default:
            return .request
        }
    }

    public var headers: HTTPHeaders? {
        return nil
    }
}

// MARK: - NetworkManager

struct NetworkManager {

    static let environment: NetworkEnvironment = .production
    static let APIKey = "e9d9dcae84d9a94aedc5412e5e521fc7"
    private let manager = YMNetworkManager<MovieAPI>()

    fileprivate func handleNetworkResponse(_ response: HTTPURLResponse) -> Result<String> {

        switch response.statusCode {
        case 200...299:
            return .success
        case 401...500:
            return .failure(NetworkResponse.authenticationError.rawValue)
        case 501...599:
            return .failure(NetworkResponse.badRequest.rawValue)
        case 600:
            return .failure(NetworkResponse.outdated.rawValue)
        default:
            return .failure(NetworkResponse.failed.rawValue)
        }
    }

    func getNewMovies(page: Int, completion: @escaping (_ movie: [Movie]?, _ error: String?) -> ()) {

        manager.request(.newMovies(page: page)) { (data, response, error) in

            if error != nil {
                completion(nil, "Please check your network connection")
            }

            if let response = response as? HTTPURLResponse {

                let result = self.handleNetworkResponse(response)
                switch result {
                case .success:
                    guard let responseData = data else {
                        completion(nil, NetworkResponse.noData.rawValue)
                        return
                    }
                    do {
                        let apiResponse = try JSONDecoder().decode(
                            MovieResponse.self,
                            from: responseData
                        )
                        completion(apiResponse.movies, nil)
                    } catch {
                        completion(nil, NetworkResponse.unableToDecode.rawValue)
                    }
                case .failure(let error):
                    completion(nil, error)
                }
            }
        }
    }
}

enum NetworkResponse: String {

    case success
    case authenticationError = "You need to be authenticated first."
    case badRequest = "Bad Request"
    case outdated = "The url you requested is outdated."
    case failed = "Network requst failed."
    case noData = "Response returned with no data to decode."
    case unableToDecode = "We could not decode the response."
}

enum Result<String> {

    case success
    case failure(String)
}

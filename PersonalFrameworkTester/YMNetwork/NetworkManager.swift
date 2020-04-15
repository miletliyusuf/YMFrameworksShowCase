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

    fileprivate func handleNetworkResponse<T: CodableResponse>(_ response: Response) -> Result<T> {

        switch response.response?.statusCode ?? -1 {
        case 200...299:
            do {
                guard let data = response.data else { return .failure(NetworkResponse.failed) }
                let apiResponse = try JSONDecoder().decode(T.self, from: data)
                return Result.success(apiResponse)
            } catch {
                return .failure(NetworkResponse.failed)
            }

        case 401...500:
            return .failure(NetworkResponse.authenticationError)
        case 501...599:
            return .failure(NetworkResponse.badRequest)
        case 600:
            return .failure(NetworkResponse.outdated)
        default:
            return .failure(NetworkResponse.failed)
        }
    }

    func getNewMovies<T: CodableResponse>(page: Int, completion: @escaping (_ response: T?, _ error: String?) -> ()) {

        manager.request(.newMovies(page: page)) { (data, response, error) in

            if error != nil {
                completion(nil, "Please check your network connection")
            }

            if let response = response as? HTTPURLResponse {

                let result: Result<T> = self.handleNetworkResponse(
                    Response(
                        response: response,
                        data: data
                    )
                )
                switch result {
                case .success(let data):
                    completion(data, nil)
                case .failure(let error):
                    completion(nil, error.rawValue)
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

enum Result<Value> {

    case success(Value)
    case failure(NetworkResponse)
}

public struct Response {

    let response: HTTPURLResponse?
    let data: Data?
}

// Codable response protocol that conforms to Codable
public protocol CodableResponse: Codable {}

extension CodableResponse {

    public func encode(to encoder: Encoder) throws {}
}

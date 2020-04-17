//
//  MovieRequest.swift
//  PersonalFrameworkTester
//
//  Created by Yusuf Miletli on 17.04.2020.
//  Copyright © 2020 Miletli. All rights reserved.
//

import Foundation
import YMNetwork

//["api_key": "e9d9dcae84d9a94aedc5412e5e521fc7"]

protocol BaseRequest: YMRequest {

    var apiKey: Parameters? { get }
}
extension BaseRequest {

    var apiKey: Parameters? {
        return ["api_key": "e9d9dcae84d9a94aedc5412e5e521fc7"]
    }
}

struct MovieRequest: BaseRequest {

    var path: String = "now_playing"
    var urlParameters: Parameters?

    init(page: Int) {

        urlParameters = apiKey
        urlParameters?["page"] = page
    }
}

//
//  MovieRequest.swift
//  PersonalFrameworkTester
//
//  Created by Yusuf Miletli on 17.04.2020.
//  Copyright © 2020 Miletli. All rights reserved.
//

import Foundation
import YMNetwork

protocol BaseRequest: YMRequest {}
extension BaseRequest {


}

struct MovieRequest: YMRequest {

    var path: String = "now_playing"
    var urlParameters: Parameters?

    init(page: Int) {

        urlParameters = [:]
        urlParameters?["api_key"] = "e9d9dcae84d9a94aedc5412e5e521fc7"
        urlParameters?["page"] = page
    }
}

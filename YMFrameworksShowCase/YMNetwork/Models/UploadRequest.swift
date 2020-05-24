//
//  UploadRequest.swift
//  YMFrameworksShowCase
//
//  Created by Yusuf Miletli on 5.05.2020.
//  Copyright © 2020 Miletli. All rights reserved.
//

import Foundation
import YMNetwork
import UIKit

struct DownloadUploadResponse: YMResponse {}

struct UploadRequest: YMUploadRequest {

    var fileURL: URL? = Bundle.main.url(forResource: "cat", withExtension: "jpg")
    var path: String = "post"
}

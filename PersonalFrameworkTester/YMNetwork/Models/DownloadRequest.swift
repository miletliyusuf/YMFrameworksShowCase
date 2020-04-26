//
//  DownloadRequest.swift
//  PersonalFrameworkTester
//
//  Created by Yusuf Miletli on 20.04.2020.
//  Copyright © 2020 Miletli. All rights reserved.
//

import Foundation
import YMNetwork

struct DownloadRequest: YMDownloadRequest {

    var path: String
    var task: HTTPTaskType = .download
    var isDownloading: Bool = false
    var delegate: YMNetworkManagerDownloadDelegate?
    var progress: Float = 0.0
    var resumeData: Data?
    var downloadTask: URLSessionDownloadTask?

    init(path: String, delegate: YMNetworkManagerDownloadDelegate? = nil) {

        self.path = path
        self.delegate = delegate
    }
}

//
//  ViewController.swift
//  PersonalFrameworkTester
//
//  Created by Yusuf Miletli on 13.04.2020.
//  Copyright © 2020 Miletli. All rights reserved.
//

import UIKit
import YMNetwork

class ViewController: UIViewController {

    var downloadRequest: YMDownloadRequest?

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Actions

    @IBAction private func didTapOnTestNetworkRequest(_ sender: UIButton) {

        let request = MovieRequest(page: 1)
        NetworkManager.shared.request(
            request: request
        ) { [weak self] (response: MovieResponse?, error) in
            if let err = error {
                print(err)
            }
            if let test = response {
                print(test)
            }
        }
    }


    // MARK: Upload

    @IBAction private func didTapOnUploadRequest(_ sender: UIButton) {

        let request = UploadRequest()
        NetworkManager.shared.request(request: request) { (response: DownloadUploadResponse?, error) in
            if let err = error {
                print(err)
            }
            if let test = response {
                print(test)
            }
        }
    }

    // MARK: Download

    @IBAction private func didTapOnResumeDownloadRequest(_ sender: UIButton) {

        if let req = downloadRequest {
            NetworkManager.shared.resumeDownload(request: req, completion: { (status, error) in

                if let err = error {
                    print(err)
                }
                print("Resume download status -> \(status)")
            })
        }
    }

    @IBAction private func didTapOnStartDownloadRequest(_ sender: UIButton) {

        if downloadRequest == nil {
            downloadRequest = YMDownloadRequest(path: "100MB.bin", delegate: self)
        }

        try? NetworkManager.shared.startDownload(request: &downloadRequest)
    }

    @IBAction private func didTapOnPauseDownloadRequest(_ sender: UIButton) {

        if let req = downloadRequest {
            NetworkManager.shared.pauseDownload(request: req)
        }
    }

    @IBAction private func didTapOnCancelDownloadRequest(_ sender: UIButton) {

        if let req = downloadRequest {
            NetworkManager.shared.cancelDownload(request: req)
        }
    }
}

// MARK: - YMNetworkManagerDownloadDelegate

extension ViewController: YMNetworkManagerDownloadDelegate {

    func ymNetworkManager(_ manager: YMNetworkManager, request: YMDownloadRequest?, downloadTask: URLSessionDownloadTask) {

        print("is it? -> \(String(describing: downloadRequest?.isEqual(to: request))) ")
        print("Download Progress -> \(String(format: "%.2f", arguments: [request?.progress ?? 0.0]))")
        print("Download Progress of DownloadRequest -> \(String(format: "%.2f", arguments: [downloadRequest?.progress ?? 0.0]))")
    }
}

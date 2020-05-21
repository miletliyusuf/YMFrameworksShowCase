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

    var request: YMDownloadRequest {
        return DownloadRequest(path: "100MB.bin", delegate: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
        NetworkManager.shared.request(request: request) { (response: CoreResponse?, error) in
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

        NetworkManager.shared.resumeDownload(
            request: request,
            completion: { (status, error) in
                if let err = error {
                    print(err)
                }
                print("Resume download status -> \(status)")
        })
    }

    @IBAction private func didTapOnStartDownloadRequest(_ sender: UIButton) {

        NetworkManager.shared.request(request: request) { (response: CoreResponse?, error) in
            if let err = error {
                print(err)
            }
            if let test = response {
                print(test)
            }
        }
    }

    @IBAction private func didTapOnPauseDownloadRequest(_ sender: UIButton) {

        NetworkManager.shared.pauseDownload(request: request)
    }

    @IBAction private func didTapOnCancelDownloadRequest(_ sender: UIButton) {

        NetworkManager.shared.cancelDownload(request: request)
    }

    // MARK: -
}

extension ViewController: YMNetworkManagerDownloadDelegate {

    func ymNetworkManager(_ manager: YMNetworkManager, request: YMDownloadRequest?, downloadTask: URLSessionDownloadTask) {

        print("Download Progress -> \(String(format: "%.2f", arguments: [request?.progress ?? 0.0]))")
    }
}

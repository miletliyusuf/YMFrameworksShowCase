//
//  VisionDetectViewController.swift
//  YMFrameworksShowCase
//
//  Created by Yusuf Miletli on 24.05.2020.
//  Copyright © 2020 Miletli. All rights reserved.
//

import Foundation
import UIKit
import VisionDetect

class VisionDetectViewController: UIViewController {

    @IBOutlet private weak var imageView: UIImageView!

    var vDetect = VisionDetect(
        cameraPosition: .FaceTimeCamera,
        optimizeFor: .HigherPerformance
    )

    override func viewDidLoad() {

        super.viewDidLoad()

        vDetect.delegate = self
        vDetect.onlyFireNotificatonOnStatusChange = false
        vDetect.beginFaceDetection()

        vDetect.addTakenImageChangeHandler { (image) in
            self.imageView.image = image
            self.vDetect.saveTakenImageToPhotos()
        }

        self.view.addSubview(vDetect.visageCameraView)
        self.view.bringSubviewToFront(imageView)
    }

}

// MARK: - VisionDetectDelegate

extension VisionDetectViewController: VisionDetectDelegate {


    func didLeftEyeClosed() {

        vDetect.takeAPicture()
    }
}

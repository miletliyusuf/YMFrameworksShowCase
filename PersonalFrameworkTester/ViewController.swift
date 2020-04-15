//
//  ViewController.swift
//  PersonalFrameworkTester
//
//  Created by Yusuf Miletli on 13.04.2020.
//  Copyright © 2020 Miletli. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        // - Network Test
        testNetwork()
    }


    func testNetwork() {

        let manager = NetworkManager()
        manager.getNewMovies(page: 1) { (movies, error) in
            if let err = error {
                print(err)
            }
            if let films = movies {
                print(films)
            }
        }
    }
}


//
//  YMCirclePickerViewController.swift
//  YMFrameworksShowCase
//
//  Created by Yusuf Miletli on 1.06.2020.
//  Copyright © 2020 Miletli. All rights reserved.
//

import Foundation
import UIKit
import YMCirclePickerView

class CirclePickerModel: YMCirclePickerModel {

    override init() {

        super.init()
    }

    convenience init(image: UIImage, title: String) {

        self.init()
        self.image = image
        self.title = title
    }
}

class YMCirclePickerViewController: UIViewController {

    @IBOutlet private weak var stackView: UIStackView!
    @IBOutlet private weak var circlePickerView: YMCirclePickerView!
    @IBOutlet private weak var circlePickerView2: YMCirclePickerView!
    @IBOutlet private weak var circlePickerView3: YMCirclePickerView!

    var data: [CirclePickerModel] = [
        CirclePickerModel(image: UIImage(named: "1")!, title: "Gizmo"),
        CirclePickerModel(image: UIImage(named: "2")!, title: "Nyrana"),
        CirclePickerModel(image: UIImage(named: "3")!, title: "Mahad"),
        CirclePickerModel(image: UIImage(named: "4")!, title: "Flame"),
        CirclePickerModel(image: UIImage(named: "5")!, title: "Mimi"),
        CirclePickerModel(image: UIImage(named: "6")!, title: "Spike"),
        CirclePickerModel(image: UIImage(named: "7")!, title: "Loki"),
        CirclePickerModel(image: UIImage(named: "8")!, title: "IAteUrCookie"),
        CirclePickerModel(image: UIImage(named: "9")!, title: "Hoppy")
    ]

    override func viewDidLoad() {

        super.viewDidLoad()
        configurePickerView()
    }

    private func configurePickerView() {

        circlePickerView.delegate = self
        circlePickerView.dataSource = self
        circlePickerView.presentation = .default
        circlePickerView2.dataSource = self
        circlePickerView2.presentation = YMCirclePickerViewPresentation(
            layoutPresentation: YMCirclePickerViewLayoutPresentation(
                itemSize: CGSize(width: 100.0, height: 100.0),
                unselectedItemSize: CGSize(width: 60.0, height: 60.0),
                spacing: 5.0,
                initialIndex: 3
            ),
            stylePresentation: YMCirclePickerViewStylePresentation(
                selectionColor: .red,
                selectionLineWidth: 4.0,
                titleLabelDistance: 3.0
            )
        )
        circlePickerView3.dataSource = self
        circlePickerView3.presentation = YMCirclePickerViewPresentation(
            layoutPresentation: YMCirclePickerViewLayoutPresentation(
                itemSize: CGSize(width: 140.0, height: 140.0),
                unselectedItemSize: CGSize(width: 90.0, height: 90.0),
                spacing: 15.0
            ),
            stylePresentation: YMCirclePickerViewStylePresentation(
                selectionColor: .yellow,
                selectionLineWidth: 10.0,
                titleLabelFont: .systemFont(ofSize: 24.0, weight: .thin),
                titleLabelTextColor: .white,
                titleLabelDistance: 3.0
            )
        )

        let circlePickerView4 = YMCirclePickerView()
        circlePickerView4.backgroundColor = .red
        circlePickerView4.dataSource = self
        circlePickerView4.presentation = YMCirclePickerViewPresentation(
            layoutPresentation: YMCirclePickerViewLayoutPresentation(
                itemSize: CGSize(width: 75.0, height: 75.0),
                unselectedItemSize: CGSize(width: 30.0, height: 30.0),
                spacing: 15.0
            ),
            stylePresentation: YMCirclePickerViewStylePresentation(
                selectionColor: .clear,
                selectionLineWidth: 3.0,
                titleLabelFont: .systemFont(ofSize: 12.0, weight: .thin),
                titleLabelTextColor: .white,
                titleLabelDistance: 3.0
            )
        )
        stackView.addArrangedSubview(circlePickerView4)
    }
}

// MARK: - YMCirclePickerViewDataSource

extension YMCirclePickerViewController: YMCirclePickerViewDataSource {

    func ymCirclePickerView(ymCirclePickerView: YMCirclePickerView, itemForIndex index: Int) -> YMCirclePickerModel? {

        let model = data[index] as CirclePickerModel
        return model
    }

    func ymCirclePickerViewNumberOfItemsInPicker(ymCirclePickerView: YMCirclePickerView) -> Int {
        return data.count
    }
}

// MARK: - YMCirclePickerViewDelegate

extension YMCirclePickerViewController: YMCirclePickerViewDelegate {

    func ymCirclePickerView(ymCirclePickerView: YMCirclePickerView, didSelectItemAt index: Int) {

        print("Selected index -> \(index)")
    }
}

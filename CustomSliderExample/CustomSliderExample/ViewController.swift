//
//  ViewController.swift
//  CustomSliderExample
//
//  Created by Maksim Nosov on 07/01/2019.
//  Copyright © 2019 Maksim Nosov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let rangeSlider = RangeSlider(frame: CGRect.zero)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        rangeSlider.backgroundColor = UIColor.red
        view.addSubview(rangeSlider)
    }
    
    override func viewDidLayoutSubviews() {
        let margin: CGFloat = 20.0
        let width = view.bounds.width - 2.0 * margin
        rangeSlider.frame = CGRect(x: margin,
                                   y: margin + self.view.safeAreaInsets.top,
                                   width: width,
                                   height: 31.0)
    }


}


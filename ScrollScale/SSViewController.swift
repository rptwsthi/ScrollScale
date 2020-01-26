//
//  ViewController.swift
//  ScrollScale
//
//  Created by Arpit on 1/8/20.
//  Copyright © 2020 Arpit. All rights reserved.
//

import UIKit

class ViewController: UITableViewController, RPTScaleViewDelegate {
    @IBOutlet var scaleView: RPTScaleView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        scaleView.delegate = self
    }

    //RPTScaleViewDelegate
    func scale(view:RPTScaleView, scale:String, value:Int) {
        print("scale = ", value, scale)
    }
    
    func selectedValue(view:RPTScaleView, scale:String) -> Int? {
        return 62
    }
}


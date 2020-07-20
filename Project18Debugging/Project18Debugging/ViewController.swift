//
//  ViewController.swift
//  Project18Debugging
//
//  Created by Connor Lee on 20/07/2020.
//  Copyright © 2020 Connor Lee. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        print("Some message", terminator: "")
        print(1, 2, 3, 4, 5, separator: "-")
        
        assert(1 == 1, "Math failure!")
        //assert(1 == 2, "Math failure!")
        //assert(myReallySlowMethod() == true, "The slow method returned false.")
        
        for i in 1...100 {
            print("Got number \(i).")
        }
    }


}


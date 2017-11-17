//
//  ViewController.swift
//  ResponseButton
//
//  Created by Heinz on 2017/11/16.
//  Copyright © 2017年 Heinz. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let button: RSButton = {
        let color = UIColor.init(red: 25/255,
                                 green: 191/255,
                                 blue: 114/255,
                                 alpha: 1)
        let frame = CGRect.init(x: 0, y: 0, width: 160, height: 50)
        let button = RSButton.init(style: .count, standColor: color, frame: frame)
        button.setTitlesFor(normal: "normal", waiting: "waiting", disable: "disable")
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.addSubview(button)
        button.center = self.view.center
        button.backgroundColor = UIColor.orange
        button.addTarget(self, action: #selector(buttonTap), for: .touchUpInside)
        button.layer.cornerRadius = 2
        button.clipsToBounds = true
        button.setTimeOut(10) {
            print("button time out")
            //self.button.rsState = .disable
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func buttonTap(sender: RSButton) {
        sender.rsState = .runing
    }
    
    @IBAction func left(_ sender: UIButton) {
        button.rsState = .normal
    }
    
    @IBAction func center(_ sender: UIButton) {
        button.rsState = .disable
    }
    
    @IBAction func rigth(_ sender: UIButton) {
        button.rsState = .waiting
    }
    

}


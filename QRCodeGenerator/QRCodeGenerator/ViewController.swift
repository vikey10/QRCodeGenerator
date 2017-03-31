//
//  ViewController.swift
//  QRCodeGenerator
//
//  Created by Vikey Wang on 17/3/31.
//  Copyright © 2017年 Vikey Wang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let url = "http://www.baidu.com"
    
    @IBOutlet weak var nativeImage: UIImageView!
    @IBOutlet weak var orangeImage: UIImageView!
    @IBOutlet weak var patternedImageView: UIImageView!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var greenLogoImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let image =  GenerateQRCode.generateQRCode(url, size: 50)
        self.nativeImage.image = image
        self.orangeImage.image = GenerateQRCode.generateColorfulQRCode(url, size: 100, changeBlackColor: UIColor.orange, changeWhiteColor: UIColor.white)
        self.patternedImageView.image = GenerateQRCode.generateColorfulQRCode(url, size: 80, changeBlackColor: UIColor.clear, changeWhiteColor: UIColor.init(white: 1, alpha: 0.9))
        self.logoImageView.image = GenerateQRCode.generateQRCodeWithLogo(url, size: 100, logo: UIImage.init(named: "service_choose"))
        self.greenLogoImage.image = GenerateQRCode.generateQRCodeWithLogo(url, size: 100, logo: UIImage.init(named: "service_choose"), andChangedBlackColor: UIColor.yellow, changedWhiteColor: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


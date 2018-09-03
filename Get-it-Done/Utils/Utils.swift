//
//  Utils.swift
//  Get-it-Done
//
//  Created by Tory Adderley on 9/3/18.
//  Copyright © 2018 Tory Adderley. All rights reserved.
//

import UIKit

class Utils {
    
    
    class func insertGradientIntoTableView(viewController: UIViewController, tableView: UITableView) {
        let gradientLayer = CAGradientLayer()
        let color1 = hexStringToUIColor(hex: "fa709a")
        let color2 = hexStringToUIColor(hex: "fee140")
        gradientLayer.frame.size = viewController.view.frame.size
        gradientLayer.colors = [color1.cgColor, color2.cgColor]
        
        let bgView = UIView.init(frame: tableView.frame)
        bgView.layer.insertSublayer(gradientLayer, at: 0)
        tableView.backgroundView = bgView
    }
    
    
    class func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    class func navBarClear ( viewController: UIViewController){
        viewController.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        viewController.navigationController?.navigationBar.shadowImage = UIImage()
        viewController.navigationController?.navigationBar.isTranslucent = true
    }




}

//
//  ColorExtension.swift
//  ZohoDeskUIKit
//
//  Created by Rajeshkumar Lingavel on 17/05/18.
//  Copyright © 2018 rajesh-2098. All rights reserved.
//

import UIKit
internal extension UIColor{
    func hexStringFromColor() -> String {
        if self == UIColor.white{return "#ffffff"}
        if self == UIColor.black{return "#000000"}
        let components = self.cgColor.components
        let r: Float =  Float(components![0])
        let g: Float = Float(components![1])
        let b: Float = Float(components![2])
        return String(format: "%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255))
    }
    
   class func getColor(red:CGFloat,green:CGFloat,blue:CGFloat,alpha:CGFloat = 1.0) -> UIColor{
        return UIColor (red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: alpha)
    }
}

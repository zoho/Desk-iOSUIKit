//
//  ZDTheme.swift
//  ZohoDeskUIKit
//
//  Created by Rajeshkumar Lingavel on 15/05/18.
//  Copyright © 2018 rajesh-2098. All rights reserved.
//

import UIKit
internal enum ZDTheme{
    case white
}

@objc internal class ZDStyle:NSObject{
   internal  static var selectedTheme = ZDTheme.white
    
    internal static var primaryColor:UIColor {
        switch ZDStyle.selectedTheme {
        case .white:
            return .black
        }
    }
    internal static var secondaryColor:UIColor {
        switch ZDStyle.selectedTheme {
        case .white:
            return UIColor(white: 85.0 / 255.0, alpha: 1.0)
        }
    }
}

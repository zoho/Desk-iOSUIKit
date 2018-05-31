//
//  File.swift
//  ZohoDeskUIKit
//
//  Created by Rajeshkumar Lingavel on 10/05/18.
//  Copyright © 2018 rajesh-2098. All rights reserved.
//

import UIKit
class FontConstant {
    
    static let iconFontName = "icomoon"
    
    static let proximaNovaRegular = "ProximaNova-Regular"
    static let proximaNovaBold = "ProximaNova-Bold"
    static let proximaNovaSemibold = "ProximaNova-Semibold"
    static let proximaNovaLight = "ProximaNova-Light"
    static let proximaNovaItalics = "ProximaNova-RegularIt"
    
}

extension UIFont{
    
    class func getIconFont(size:CGFloat) -> UIFont{
        return UIFont(name: FontConstant.iconFontName, size: size)!
    }
    class func getProximaNovaRegularFont(size:CGFloat) -> UIFont{
        return UIFont(name: FontConstant.proximaNovaRegular, size: size)!
    }
    class func getProximaNovaLightFont(size:CGFloat) -> UIFont{
        return UIFont(name: FontConstant.proximaNovaLight, size: size)!
    }
    class func getProximaNovaSemibold(size:CGFloat) -> UIFont{
        return UIFont(name: FontConstant.proximaNovaSemibold, size: size)!
    }
    class func getProximaNovaBold(size:CGFloat) -> UIFont{
        return UIFont(name: FontConstant.proximaNovaBold, size: size)!
    }
    class func getProximaNovaItalic(size:CGFloat) -> UIFont {
        return UIFont(name: FontConstant.proximaNovaItalics, size: size)!
    }
    
    /// Register font you need to use in this framework.
    ///
    /// - Parameters:
    ///   - filenameString: filename of the font
    ///   - bundleIdentifierString: bundleIdentifierString of the module
    internal static func registerFontWithFilenameString(_ filenameString: String, bundleIdentifierString: String) {
        guard let bundle = Bundle(identifier: bundleIdentifierString) else {
            "UIFont+:  Failed to register font - bundle identifier invalid.".makeLog()
            return
        }
        
        guard let pathForResourceString = bundle.path(forResource: filenameString, ofType: nil) else {
            "UIFont+:  Failed to register font - path for resource not found.".makeLog()
            return
        }
        
        guard let fontData = try? Data(contentsOf: URL(fileURLWithPath: pathForResourceString)) else {
            "UIFont+:  Failed to register font - font data could not be loaded.".makeLog()
            return
        }
        
        guard let dataProvider = CGDataProvider(data: fontData as CFData) else {
            "UIFont+:  Failed to register font - data provider could not be loaded.".makeLog()
            return
        }
        #if swift(>=4)
        guard let font = CGFont(dataProvider) else {
            print("Error loading font. Could not create CGFont from CGDataProvider.")
            return
        }
        #else
        let font = CGFont(dataProvider)
        #endif
        
        var errorRef: Unmanaged<CFError>? = nil
        if (CTFontManagerRegisterGraphicsFont(font, &errorRef) == false) {
            "UIFont+:  Failed to register font - register graphics font failed - this font may have already been registered in the main bundle.".makeLog()
        }
    }
    
}

//
//  File.swift
//  ZohoDeskUIKit
//
//  Created by Rajeshkumar Lingavel on 10/05/18.
//  Copyright © 2018 rajesh-2098. All rights reserved.
//

import UIKit
@objc public class ZohoDeskUIKit:NSObject{
    
    internal static var configuration = ZohoDeskUIConfiguration()
    
    @discardableResult public override init() {
        super.init()
        registerCustomFonts()
    }
    
    internal func registerCustomFonts(){
        
        UIFont.registerFont(bundle: ZDUtility.getBundle()!, fontName: FontConstant.iconFontName, fontExtension: "ttf")
        UIFont.registerFont(bundle: ZDUtility.getBundle()!, fontName: "ProximaNovaBold", fontExtension: "otf")
        UIFont.registerFont(bundle: ZDUtility.getBundle()!, fontName: "ProximaNovaReg", fontExtension: "otf")
        UIFont.registerFont(bundle: ZDUtility.getBundle()!, fontName: "ProximaNovaSbold", fontExtension: "otf")
    }
    
    /// This method should call on logout. This method will delete all user data saved by ZohoDeskUIKit
    @objc public static func flushUserData(){
        ZDCacheManager.shared.cache.removeAllObjects()
        FileManager.ZDclearAllFiles()
    }
}


internal class ZohoDeskUIConfiguration {
    internal var isFontRegistered = false
}


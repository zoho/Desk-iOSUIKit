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
        
        UIFont.registerFontWithFilenameString(FontConstant.iconFontName+".ttf", bundleIdentifierString:"com.zoho.deskSDKUIKit")
        UIFont.registerFontWithFilenameString("ProximaNovaBold.otf", bundleIdentifierString:"com.zoho.deskSDKUIKit")
        UIFont.registerFontWithFilenameString("ProximaNovaReg.otf", bundleIdentifierString:"com.zoho.deskSDKUIKit")
        UIFont.registerFontWithFilenameString("ProximaNovaSbold.otf", bundleIdentifierString:"com.zoho.deskSDKUIKit")
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


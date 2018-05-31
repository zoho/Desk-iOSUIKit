//
//  Utility.swift
//  DeskSDKUIKit
//
//  Created by Rajeshkumar Lingavel on 10/05/18.
//  Copyright © 2018 rajesh-2098. All rights reserved.
//

import UIKit
import ZohoDeskSDK
internal class ZDUtility{
        
    internal static func getBundle() -> Bundle? {
        var bundle: Bundle?
        let sdkBundle = Bundle(for: ZohoDeskUIKit.self)
        if let bundleURL = sdkBundle.url(forResource: "ZohoDeskUIKit", withExtension: "bundle"){
            bundle = Bundle(url: bundleURL)
        }
        return bundle
    }
    
//    internal static func getBundle() -> Bundle? {
//        var bundle: Bundle?
//        if let urlString = Bundle.main.path(forResource:"ZohoDeskUIKit", ofType: "framework", inDirectory: "Frameworks"){
//            bundle = (Bundle(url: URL(fileURLWithPath: urlString)))
//        }
//        return bundle
//    }
    
    
    internal static func getFileIcon(fileName:String) -> String{
        var imageFileName = "unknown.pdf"
        guard let pathExtention = URL(string: fileName.encodeFileName())?.pathExtension.lowercased() else{return imageFileName}
        switch pathExtention {
        case "png","jpg","jpeg","exif","tiff","gif","bmb","ppm","pgm","pbm","pnm","heif","bat","bpg":
            imageFileName = "image.pdf"
        case "3g2","3gp","avi","flv","h264","m4v","mkv","mov","mp4","mpg","mpeg","rm","swf","vob","wmv":
            imageFileName = "video.pdf"
        case "aif","cda","mid","midi","mp3","mpa","ogg","wav","wma","wpl","acc":
            imageFileName = "music.pdf"
        case "doc","odt","docx","rtf","tex","wks","txt","wps","wpd":
            imageFileName = "text.pdf"
        case "7z","arj","deb","pkg","rar","rpm","zip","z","tar","gz":
            imageFileName = "zip.pdf"
        case "pdf":
            imageFileName = "pdf.pdf"
        default:
            break
        }
        return imageFileName
    }
    
    internal static func getXIb(name:String,index:Int = 0) -> UIView?{
        return  ZDUtility.getBundle()?.loadNibNamed(name, owner: nil, options: nil)![index] as? UIView
    }
    
    internal static func getTopViewController() -> UIViewController?{
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            return topController
        }
        return nil
    }
    
    internal static func downloadImage(imageURLString:String,header:Headers = Headers(),param:Parameters = Parameters(),onComplition:@escaping ((Data?)->())) -> Void{
        if let imageData = ZDCacheManager.shared.fetch(forKey: imageURLString)?.object as? Data {
            onComplition(imageData)
            return
        }
        guard let imageURL = URL(string: imageURLString) else{return}
        ZDAPIExtension.makeAPIRequest(url: imageURL, method: "GET", paramType: "path", parameters: param, header: header) { (responceData, error, statusCode) in
            DispatchQueue.main.async {
                ZDCacheManager.shared.saveObject(responceData as AnyObject, forKey: imageURLString, forMinutes: 30)
                onComplition(responceData)
            }
        }
    }
    
}

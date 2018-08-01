//
//  FileManagerExtention.swift
//  ZohoDeskSDK
//
//  Created by rajeshkumar.l on 09/03/17.
//  Copyright © 2017 rajesh-2098. All rights reserved.
//

import UIKit

internal extension FileManager {
    
    internal class  func tempDirectoryPath() -> String {
        
        let path = NSURL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true).path.toString() + "/\(ZDConstant.FolderNames.rootFolderName)"

        self.createDirectory(path)
        return path
    }
    
    internal class func ZDclearAllFiles() {
        try? self.default.removeItem(atPath: tempDirectoryPath())
    }
    
    @discardableResult internal class  func createDirectory(_ folderFullPath: String) -> Bool {
        
        do {
            try self.default.createDirectory(atPath: folderFullPath, withIntermediateDirectories: false, attributes: nil)
            return true
        } catch {
            return false
        }
    }

    internal class func saveFile(subFolder:String,fileName:String,fileData:Data) -> URL?{
        let folderPath = tempDirectoryPath() + "/" + subFolder
        let fullFilePath = ZDConstant.FolderNames.fileScheme + folderPath + "/" + fileName.encodeFileName()
        
        createDirectory(folderPath)
        
        guard let url = URL(string: fullFilePath) else{return nil}
        do{
            try fileData.write(to: url, options: [.atomic])
            return url
        }
        catch let error{
            error.localizedDescription.makeLog()
            return nil
        }

    }
    
    internal class func isFileExist(subFolder:String,fileName:String) -> URL?{
        let folderPath = tempDirectoryPath() + "/" + subFolder
        let fullFilePath = folderPath + "/" + fileName.encodeFileName()
        
        if !self.default.fileExists(atPath: fullFilePath){return nil}
        guard let url = URL(string: ZDConstant.FolderNames.fileScheme + fullFilePath) else{return nil}
        return url
    }
    
     
    
}

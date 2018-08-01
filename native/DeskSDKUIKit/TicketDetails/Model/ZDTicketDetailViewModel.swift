//
//  ZDTicketDetailViewModel.swift
//  ZohoDeskUIKit
//
//  Created by Rajeshkumar Lingavel on 16/05/18.
//  Copyright © 2018 rajesh-2098. All rights reserved.
//

import UIKit
import ZohoDeskSDK
internal extension ZDTicketDetail{
    
    func getDatedescription() -> String{
        return self.createdTime.stringToDate().feedDateToString()
    }
    
    func getSingleName() -> String{
        let dotString =  " .  "
        let firstName = self.contact?.firstName  ?? ""
        let lastName = self.contact?.lastName  ?? ""
        
        return dotString + (!lastName.isEmpty  ? lastName : ( firstName.isEmpty ? "" : firstName))
    }
    
    func getAccountName() -> String{
        let accountName =  (self.contact?.account?.accountName).toString()
        return accountName.isEmpty ? "" : " . \(accountName)"
    }
    
    func getPriority() -> String{
        if let priority = self.priority, !priority.isEmpty {
            return " \(priority)"
        }
        return "-"
    }
    
    func getDueDate() -> String{
        if self.dueDate == nil{
            let (date,_) =  self.dueDate.toString().stringToDate().timeAgoSinceDate(Date(), numericDates: true)
            return date
        }
        return "-"
    }
    
    func getTitle() -> String{
        return "#\(self.ticketNumber) \(self.subject)"
    }
    
    func getChannelImage() -> UIImage{
        let defaultImage =  UIImage(named: "web.pdf", in:ZDUtility.getBundle()!, compatibleWith: nil)!
        let iconKey = (self.channel.toString() + (self.lastThread?.direction ?? "")).lowercased()
        return  UIImage(named: iconKey + ".pdf", in:ZDUtility.getBundle()!, compatibleWith: nil) ?? defaultImage
    }
    
}

internal extension ZDConverstaion{
    func getContent(isOpen:Bool) -> String{
        var content = ""
        switch self.type {
        case .thread:
            let thread = (self as! ZDThread)
            if let threadDetail = thread.threadDetails, isOpen{
                content =   threadDetail.content
            }
            else{
                content =  (self as! ZDThread).summary
            }
        case .comment:
            content = (self as! ZDTicketComment).content
        }
        return content
    }
    
    func getTitle() -> String{
        let name = self.author.name
        return name.isEmpty ? "deskSDKUI.ticketDetails.user".localized : name
    }
    
    func getUserImageURL() -> String{
        return self.author.photoURL.toString()
    }
    
    func getSubTitle() -> String{
        var createdTime = ""
        var isprivate = false
        var canAddDot = false
        switch self.type {
        case .thread:
            createdTime = (self as! ZDThread).createdTime.stringToDate().feedDateToString()
            isprivate   = (self as! ZDThread).visibity == "public"
            canAddDot = self.hasAttach && (self as! ZDThread).threadDetails != nil
        case .comment:
            createdTime = (self as! ZDTicketComment).commentedTime.stringToDate().feedDateToString()
            isprivate   = !(self as! ZDTicketComment).isPublic
            canAddDot = self.hasAttach
        }
        
        let isPrivateText = isprivate ? "deskSDKUI.ticketDetails.private".localized : "deskSDKUI.ticketDetails.public".localized
        return "\(createdTime) . \(isPrivateText)" + (canAddDot ? " ." : "")
        
    }
    
    func getChannelIcon() -> String{
        var iconName = ""
        switch self.type {
        case .thread:
            iconName = (self as! ZDThread).direction  == "in" ? "threadin.pdf": "threadout.pdf"
        case .comment:
            iconName = "comment.pdf"
        }
        return iconName
    }
    
    
    func getAttchments() -> [ZDAttachment]?{
        var attachments:[ZDAttachment]?
        switch self.type {
        case .thread:
            attachments = (self as! ZDThread).threadDetails?.attachments
        case .comment:
            attachments = (self as! ZDTicketComment).attachments
        }
        return attachments
    }
    
    func getAttachCountText() -> String{
        if let attachments = getAttchments() {
            return  attachments.count > 0 ? attachments.count.description : ""
        }
        return ""
    }
    
    func toAddress() -> [String]{
        if type == .thread{
            return ((self as!ZDThread).to.toString().components(separatedBy: ",")).filter({ return !$0.isEmpty})
        }
        return []
    }
    
    func ccAddress() -> [String]{
        if type == .thread{
            return ((self as!ZDThread).cc.toString().components(separatedBy: ",")).filter({ return !$0.isEmpty})
        }
        return []
    }
    
    func bccAddress() -> [String]{
        if type == .thread{
            return ((self as!ZDThread).bcc.toString().components(separatedBy: ",")).filter({ return !$0.isEmpty})
        }
        return []
    }
    
    func getFromAddress() -> String{
        if type == .thread{
            return ((self as!ZDThread).fromEmailAddress.toString().extractEmailAddress().first ?? "")
        }
        return ""
    }
    
    func getTotalSenderAddress() -> Int{
        return toAddress().count + ccAddress().count
    }
    
    func getSenderInfoSelectionText() -> String{
        let count = getTotalSenderAddress()
        switch count {
        case 0:
            return ""
        case 1:
            return String(format: "deskSDKUI.senderInfo.ActionButtonToOnly".localized,toAddress().first!.extractEmailAddress().first ?? "")
        case 2:
            return String(format: "deskSDKUI.senderInfo.ActionButtonOther".localized,toAddress().first!.extractEmailAddress().first ?? "")
        default:
            return String(format: "deskSDKUI.senderInfo.ActionButtonOthers".localized,toAddress().first!.extractEmailAddress().first ?? "",count - 1)
        }
    }
}

extension ZDAttachment{
    
    func showAttachment(){
        if let url = getFileURL(){
            let previewController = ZDQLPreviewController(files: [url])
            previewController.showPreview()
        }
    }
    
    func getFileURL() -> URL?{
        var fileURL:URL?
        if let url =  FileManager.isFileExist(subFolder: id, fileName:name){
            fileURL = url
        }
        else{
            guard let attachData = data else{return nil}
            fileURL =  FileManager.saveFile(subFolder: id, fileName: name, fileData: attachData)
        }
        return fileURL
    }
    func getDataFromLocalURL() -> Data?{
        return FileManager.default.contents(atPath: (getFileURL()?.path).toString())
    }
    
}

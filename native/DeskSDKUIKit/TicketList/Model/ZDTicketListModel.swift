//
//  ZDTicketListModel.swift
//  ZohoDeskUIKit
//
//  Created by Rajeshkumar Lingavel on 10/05/18.
//  Copyright © 2018 rajesh-2098. All rights reserved.
//

import UIKit
import ZohoDeskSDK
extension ZDTicket{
    func getTitle() -> String{
        return "#\(self.ticketNumber) \(self.subject)"
    }
    
    func getAccountName() -> String{
        return (self.contact?.account?.accountName).toString()
    }
    
    func getSingleName() -> String{
        let singleName = getAccountName().isEmpty ? "" : " .  "
        let firstName = self.contact?.firstName  ?? ""
        let lastName = self.contact?.lastName  ?? ""
        
        return singleName + (!lastName.isEmpty  ? lastName :firstName)
    }
    
    
    func getCreatedDate() ->  String{
        var dateString = ""
        if self.closedTime != nil{
            dateString = createdTime.stringToDate().feedDateToString()
        }
        else if self.dueDate != nil{
            let (date,_) =  self.dueDate.toString().stringToDate().timeAgoSinceDate(Date(), numericDates: true)
            dateString = date
        }
        else{
            dateString = createdTime.stringToDate().feedDateToString()
        }
        return "\(dateString) ."
    }
    
    func getdueDateImageAndColor() -> (String,UIColor){
        var icon = ("",ZDStyle.secondaryColor)
        if self.closedTime != nil{
            icon = ("\u{e900}",ZDStyle.secondaryColor)
        }
        else if self.dueDate != nil{
            if self.dueDate!.stringToDate() < Date(){
                icon = ("\u{e902}",ZDStyle.ZDTicketListCellTheme.highPriorityColor)
            }
            else{
                icon = ("\u{e902}",ZDStyle.secondaryColor)
            }
        }
        else{
            icon = ("\u{e901}",ZDStyle.secondaryColor)
        }
        
        return icon
    }
    
    func canShowPaidUserIcon() -> Bool{
        return (self.contact?.type).toString() == "Paid user"
    }
    
    func getChannelImage() -> UIImage{
        let defaultImage =  UIImage(named: "web.pdf", in:ZDUtility.getBundle()!, compatibleWith: nil)!
        let iconKey = (self.channel.toString() + (self.lastThread?.direction ?? "")).lowercased()
        return  UIImage(named: iconKey + ".pdf", in:ZDUtility.getBundle()!, compatibleWith: nil) ?? defaultImage
    }
    
    
    func getPriorityText() -> String{
        return self.priority != nil ?  "\(priority.toString())" : ""
    }
    func getPriorityAttributedString() -> NSMutableAttributedString{
        let priorityAttributedString = NSMutableAttributedString()
        
        let priorityColor = ["high":ZDStyle.ZDTicketListCellTheme.highPriorityColor,"medium":ZDStyle.ZDTicketListCellTheme.mediumPriorityColor,"low":ZDStyle.ZDTicketListCellTheme.lowPriorityColor]
        
        let priority = getPriorityText()
        
        let selectedPriorityColor = priorityColor[priority.lowercased()] ?? ZDStyle.secondaryColor
        
        #if swift(>=4)
        if !priority.isEmpty{
        priorityAttributedString.append(NSAttributedString(string: " .  ", attributes: [.foregroundColor : ZDStyle.secondaryColor]))
        priorityAttributedString.append(NSAttributedString(string: priority, attributes: [.foregroundColor : selectedPriorityColor]))
        }
        #else
        if !priority.isEmpty{
            priorityAttributedString.append(NSAttributedString(string: " .  ", attributes: ["NSColor" : ZDStyle.secondaryColor] as [String:AnyObject]))
            priorityAttributedString.append(NSAttributedString(string: priority, attributes: ["NSColor" : selectedPriorityColor] as [String:AnyObject]))
        }
        #endif
        
        
        
        
        return priorityAttributedString
    }
}

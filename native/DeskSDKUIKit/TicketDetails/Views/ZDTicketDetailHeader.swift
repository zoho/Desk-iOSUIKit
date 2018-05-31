//
//  ZDTicketDetailHeader.swift
//  ZohoDeskUIKit
//
//  Created by Rajeshkumar Lingavel on 16/05/18.
//  Copyright © 2018 rajesh-2098. All rights reserved.
//

import UIKit
import ZohoDeskSDK
internal enum ZDTicketDetailFilter{
    case ZDConversation,ZDThreads,ZDComments
}

internal class ZDTicketDetailsHeader:UIView{
    
    //MARK:- Properties
    
    //closures define
    var updateFilter:((ZDTicketDetailListingType) -> Void)?

    ///IBOutlets
    @IBOutlet weak var channelIcon:UIImageView?
    @IBOutlet weak var titleLabel:UILabel?
    
    @IBOutlet weak var descLabel1:UILabel?
    @IBOutlet weak var descLabel2:UILabel?
    @IBOutlet weak var descLabel3:UILabel?

    @IBOutlet weak var statusLabel:UILabel?
    @IBOutlet weak var statusDescriptionLabel:UILabel?
    
    @IBOutlet weak var priorityLabel:UILabel?
    @IBOutlet weak var priorityDescriptionLabel:UILabel?
    
    @IBOutlet weak var dueDateLabel:UILabel?
    @IBOutlet weak var dueDateDescriptionLabel:UILabel?
    
    @IBOutlet weak var userImage:UIImageView?
    
    @IBOutlet weak var filerHolderView:UIView?
    @IBOutlet weak var filterButton:UIButton?
    
    let priorityColor = ["high":ZDStyle.ZDTicketListCellTheme.highPriorityColor,"medium":ZDStyle.ZDTicketListCellTheme.mediumPriorityColor,"low":ZDStyle.ZDTicketListCellTheme.lowPriorityColor]

    
    ///Data Properties
    internal var selectedListingType = ZDTicketDetailListingType.ZDConversation{
        didSet{
            filterButton?.setTitle(String(format: getHeaderTitle(type:selectedListingType), getHeaderCount(type: selectedListingType)).uppercased(), for: .normal)
        }
    }

    var rowHeights = [IndexPath:CGFloat]()
    
    internal let filters = ["deskSDKUI.ticketDetails.conversationFilter".localized,
                            "deskSDKUI.ticketDetails.threadFilter".localized,
                            "deskSDKUI.ticketDetails.commentFilter".localized]
    
    ///Data Model Object
    var dataModel:ZDTicketDetail?{
        didSet{
            updateData()
        }
    }
    
    //MARK:- Methods
    override func awakeFromNib() {
        applyFontandTheme()
        initialConfiguration()
    }
    
    ///Will update views based on data model.
    internal func updateData() -> Void{
        guard let modelData = dataModel else{return}
        self.channelIcon?.image = modelData.getChannelImage()
        self.titleLabel?.text = modelData.getTitle()
        self.descLabel1?.text = modelData.getDatedescription()
        self.descLabel2?.text = modelData.getSingleName()
        self.descLabel3?.text = modelData.getAccountName()
        
        self.priorityLabel?.text = "deskSDKUI.ticketDetails.priority".localized
        self.statusLabel?.text = "deskSDKUI.ticketDetails.status".localized
        self.dueDateLabel?.text = "deskSDKUI.ticketDetails.duedate".localized
        
        self.statusDescriptionLabel?.text = modelData.status
        self.priorityDescriptionLabel?.text = modelData.getPriority()
        self.dueDateDescriptionLabel?.text = modelData.getDueDate()
        

        if modelData.assignee == nil{
            userImage?.image = UIImage(named:"unassigned.pdf", in:ZDUtility.getBundle()!, compatibleWith: nil)
            userImage?.contentMode = .scaleAspectFit
            return
        }
        
        userImage?.image = UIImage(named:"default.pdf", in:ZDUtility.getBundle()!, compatibleWith: nil)
        userImage?.contentMode = .scaleAspectFill
        ZDUtility.downloadImage(imageURLString: (modelData.assignee?.photoURL.toString())!,header:["orgId":modelData.orgId]) { [weak self](imageData) in
            guard let image = imageData else{return}
            guard let selfObject = self else{return}
            print("comming")
            selfObject.userImage?.image = UIImage(data: image)
        }
        self.priorityDescriptionLabel?.textColor = priorityColor[modelData.priority.toString().lowercased()] ?? ZDStyle.secondaryColor
        
    }
    
    ///This will call only when initialize.
    func initialConfiguration(){
        
        userImage?.layer.masksToBounds = true
        userImage?.layer.cornerRadius = userImage!.bounds.size.width * 0.50
        
    }
    

    ///This will call apply colors and font.
    fileprivate func applyFontandTheme() -> Void {

        filerHolderView?.backgroundColor = ZDStyle.ZDTicketDetailCellTheme.tableBGColor
        filterButton?.titleLabel?.font = UIFont.getProximaNovaBold(size: 14)
        filterButton?.setTitleColor(ZDStyle.ZDTicketDetailCellTheme.filterButtonText, for: UIControlState.normal)

        self.titleLabel?.font  = UIFont.getProximaNovaBold(size: 20)
        self.titleLabel?.textColor  = ZDStyle.primaryColor
        
        _ = [self.descLabel1,self.descLabel2,self.descLabel3].map({$0?.font = UIFont.getProximaNovaRegularFont(size: 16)})
     
        _ = [self.priorityLabel,self.statusLabel,self.dueDateLabel].map({$0?.font = UIFont.getProximaNovaSemibold(size: 14)})

        _ = [self.statusDescriptionLabel,self.dueDateDescriptionLabel,self.priorityDescriptionLabel].map({$0?.font = UIFont.getProximaNovaSemibold(size: 16)})
        

        
    }
    
    
    /// This method will show actions sheet pop for listing filter.
    @IBAction func showFilters(){
        var actions:[[String:UIAlertActionStyle]] = []
        
        
        actions.append([String(format: "deskSDKUI.ticketDetails.conversationFilter".localized,getHeaderCount(type: .ZDConversation)): UIAlertActionStyle.default])
        
        if Int(getHeaderCount(type: .ZDThreads))! > 0{
            actions.append([String(format:"deskSDKUI.ticketDetails.threadFilter".localized, getHeaderCount(type: .ZDThreads)):   UIAlertActionStyle.default])
        }
        
        if Int(getHeaderCount(type: .ZDComments))! > 0{
            actions.append([String(format:"deskSDKUI.ticketDetails.commentFilter".localized,getHeaderCount(type: .ZDComments)): UIAlertActionStyle.default])
        }

        actions.append(["deskSDKUI.common.cancel".localized: UIAlertActionStyle.cancel])
        
        self.showActionsheet(title: "deskSDKUI.ticketDetails.filterTitle".localized, message:"deskSDKUI.ticketDetails.filterMessage".localized, actions: actions) { [weak self] (index, selectedTitle) in
            if selectedTitle == "deskSDKUI.common.cancel".localized  {return}
            
             guard let selfObject = self else{return}
            
            var selectedFilter = selfObject.selectedListingType
            switch selectedTitle{
                case String(format:"deskSDKUI.ticketDetails.threadFilter".localized, selfObject.getHeaderCount(type: .ZDThreads)):
                selectedFilter = .ZDThreads
            case String(format:"deskSDKUI.ticketDetails.commentFilter".localized,selfObject.getHeaderCount(type: .ZDComments)):
                selectedFilter = .ZDComments
            case String(format: "deskSDKUI.ticketDetails.conversationFilter".localized,selfObject.getHeaderCount(type: .ZDConversation)):
                selectedFilter = .ZDConversation
                default:
                break
            }
            if selectedFilter == selfObject.selectedListingType {return}
            selfObject.selectedListingType = selectedFilter
            selfObject.updateFilter?(selfObject.selectedListingType)

        }
    }
    
}

//MARK:- Data Helper Methods
extension ZDTicketDetailsHeader{
    
    /// To get Title of the filter button
    ///
    /// - Parameter type: current Filter type
    /// - Returns: Will return filter title.
    fileprivate func getHeaderTitle(type:ZDTicketDetailListingType) -> String{
        switch type {
        case .ZDConversation:
            return "deskSDKUI.ticketDetails.conversationFilter".localized
        case .ZDThreads:
            return "deskSDKUI.ticketDetails.threadFilter".localized
        case .ZDComments:
            return "deskSDKUI.ticketDetails.commentFilter".localized
        }
    }
    
    
    /// To get Filter count of the filter button
    ///
    /// - Parameter type: current Filter type
    /// - Returns: Will return filter count.
    fileprivate func getHeaderCount(type:ZDTicketDetailListingType) -> String{
        guard let modelData = dataModel else{return ""}
        var rowCount = ""
        switch type {
        case .ZDConversation:
            rowCount = (Int(modelData.threadCount).toInt() + Int(modelData.commentCount).toInt()).description
        case .ZDThreads:
            rowCount =  modelData.threadCount
        case .ZDComments:
            rowCount =  modelData.commentCount
        }
        return rowCount
    }
}

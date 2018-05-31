//
//  ZDTicketListCell.swift
//  DeskSDKUIKit
//
//  Created by Rajeshkumar Lingavel on 10/05/18.
//  Copyright © 2018 rajesh-2098. All rights reserved.
//

import UIKit
import ZohoDeskSDK
internal class ZDTicketListCell: UITableViewCell {

    @IBOutlet weak var ticketTitle: UILabel!
    
    @IBOutlet weak var contactNameLabel: UILabel!
    @IBOutlet weak var accountNameLabel: UILabel!
    @IBOutlet weak var paidUserImage: UIImageView!

    @IBOutlet weak var dueDateImage: UILabel!
    @IBOutlet weak var createdDate: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var priorityLabel: UILabel!

    @IBOutlet weak var channelIcon: UIImageView!
    @IBOutlet weak var userAvatar: UIImageView!
    

    var dataModel: ZDTicket?{
        didSet{
            updateData(dataModel: dataModel)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layoutMargins = UIEdgeInsets.zero
        self.selectionStyle = .none
        applyFontAndTheme()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    internal func updateData(dataModel:ZDTicket?){
        guard let model = dataModel else {return}
        
        self.channelIcon.image = model.getChannelImage()
        self.ticketTitle.text = model.getTitle()
        self.contactNameLabel.text = model.getAccountName()
        self.accountNameLabel.text = model.getSingleName()
        
        self.paidUserImage.isHidden = !model.canShowPaidUserIcon()
        self.dueDateImage.text = model.getdueDateImageAndColor().0
        self.dueDateImage.textColor = model.getdueDateImageAndColor().1
        self.createdDate.text = model.getCreatedDate()
        self.statusLabel.text = model.status
        self.priorityLabel.attributedText = model.getPriorityAttributedString()
        
        if model.assignee == nil{
            userAvatar.image = UIImage(named:"unassigned.pdf", in:ZDUtility.getBundle()!, compatibleWith: nil)
            userAvatar.contentMode = .scaleAspectFit
            return
        }
        
        userAvatar.image = UIImage(named:"default.pdf", in:ZDUtility.getBundle()!, compatibleWith: nil)
        userAvatar.contentMode = .scaleAspectFill
        ZDUtility.downloadImage(imageURLString: (model.assignee?.photoURL.toString())!,header:["orgId":model.orgId]) { [weak self](imageData) in
            guard let image = imageData else{return}
            guard let selfObject = self else{return}
            print("comming")
            selfObject.userAvatar.image = UIImage(data: image)
        }
        
        self.updateConstraintsIfNeeded()
        
    }
    
    internal func applyFontAndTheme(){
        
        userAvatar.layer.masksToBounds = true
        userAvatar.layer.cornerRadius = userAvatar.bounds.size.width * 0.50
        
        self.ticketTitle.textColor = ZDStyle.primaryColor
        self.dueDateImage.font = UIFont.getIconFont(size: 14)

        _ = [accountNameLabel,contactNameLabel,createdDate,statusLabel,priorityLabel].map { (label) -> Void in
            label?.font = UIFont.getProximaNovaRegularFont(size: 16)
            label?.textColor = ZDStyle.secondaryColor
        }
    }
}

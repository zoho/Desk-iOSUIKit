//
//  SenderDetailMethods.swift
//  ZohoDeskUIKit
//
//  Created by Rajeshkumar Lingavel on 24/05/18.
//  Copyright © 2018 rajesh-2098. All rights reserved.
//

import UIKit

internal extension ZDConversationCell{
    
    func updateSenderDetails() -> Void {
        guard let model = dataModel else {return}
        if model.type == .comment {
            senderContainerHeightConstrain.constant = 0
            senderDetailContainer.isHidden = true
            senderSelectionButton.isHidden = true
            return
        }
        fromLabel.text = "deskSDKUI.common.from".localized
        toLabel.text = "deskSDKUI.common.to".localized
        ccLabel.text = "deskSDKUI.common.cc".localized
        bccLabel.text = "deskSDKUI.common.bcc".localized
    
        let title = cellConfig.isSenderDetailisOpen ? "deskSDKUI.ticketDetails.hidedetails".localized : "deskSDKUI.ticketDetails.showdetails".localized
        
        
        senderSelectionButton.setTitle(title, for: UIControlState.normal)
        fromButton.setTitle(model.getFromAddress(), for: UIControlState.normal)
        
        fromButton.setTitleColor(ZDStyle.secondaryColor, for: UIControlState.normal)
        fromButton.titleLabel?.font = UIFont.getProximaNovaRegularFont(size: 13)
        addToAddressButtons()
        addCcButtons()
        addBccButtons()
        
        toLabel.isHidden = toContainer.subviews.count <= 0
        toLabel.isHidden = ccContainer.subviews.count <= 0
        bccLabel.isHidden = bccContainer.subviews.count <= 0
        
        toContainerHeightConstrain.constant = CGFloat(toContainer.subviews.count * 30)
        ccContainerHeightConstrain.constant = CGFloat(ccContainer.subviews.count * 30)
        bccContainerHeightConstrain.constant = CGFloat(bccContainer.subviews.count * 30)
    
        senderContainerHeightConstrain.constant = getPossibleTotalHeightOfCell()

        self.updateConstraintsIfNeeded()
    }
    
    func getPossibleTotalHeightOfCell() -> CGFloat{
        guard let model = dataModel else {return 0}
        if model.type == .comment{senderSelectionButton.isHidden = true;return 0}
        
        
        let fromAddressButtonHeight:CGFloat = model.getFromAddress().isEmpty ? 0 : 40
        let showHideButtonHeight:CGFloat = model.getFromAddress().isEmpty ? 0 : 30
        
        senderSelectionButton.isHidden = showHideButtonHeight == 0

        if !cellConfig.isSenderDetailisOpen{
            senderDetailContainer.isHidden = true
            return showHideButtonHeight
        }
        
        senderDetailContainer.isHidden = false
        return CGFloat(toContainer.subviews.count * 30) + CGFloat(ccContainer.subviews.count * 30) + CGFloat(bccContainer.subviews.count * 30) + fromAddressButtonHeight + showHideButtonHeight + 10
    }
    
    func addToAddressButtons(){
        _ = toContainer.arrangedSubviews.map({$0.removeFromSuperview()})
        guard let model = dataModel else {return}
        _ = model.toAddress().map { (emailWithDetails) -> Void in
            if !emailWithDetails.isEmpty{
                let email = emailWithDetails.extractEmailAddress().first ?? ""
                toContainer.addArrangedSubview(getButtons(title: email))
            }
        }
    }
    func addCcButtons(){
        _ = ccContainer.arrangedSubviews.map({$0.removeFromSuperview()})
        guard let model = dataModel else {return}
        _ = model.ccAddress().map { (emailWithDetails) -> Void in
            if !emailWithDetails.isEmpty{
                let email = emailWithDetails.extractEmailAddress().first ?? ""
                ccContainer.addArrangedSubview(getButtons(title: email))
            }
        }
    }
    func addBccButtons(){
        _ = bccContainer.arrangedSubviews.map({$0.removeFromSuperview()})
        guard let model = dataModel else {return}
        _ = model.bccAddress().map { (emailWithDetails) -> Void in
            if !emailWithDetails.isEmpty{
                let email = emailWithDetails.extractEmailAddress().first ?? ""
                bccContainer.addArrangedSubview(getButtons(title: email))
            }
        }
    }
    
    func getButtons(title:String) -> UIButton{
        let button = UIButton()
        button.widthAnchor.constraint(equalToConstant: toContainer.frame.width).isActive = true
        button.heightAnchor.constraint(equalToConstant: 30).isActive = true
        button.setTitleColor(ZDStyle.secondaryColor, for: UIControlState.normal)
        button.contentHorizontalAlignment = .left
        button.titleLabel?.font = UIFont.getProximaNovaRegularFont(size: 13)
        button.setTitle(title, for: UIControlState.normal)
        return button
    }
    
    @IBAction func showHideDetails(){
        cellConfig.isSenderDetailisOpen.toggle()
        let title = cellConfig.isSenderDetailisOpen ? "deskSDKUI.ticketDetails.hidedetails".localized : "deskSDKUI.ticketDetails.showdetails".localized
        senderSelectionButton.setTitle(title, for: UIControlState.normal)
        senderDetailContainer.isHidden = !cellConfig.isSenderDetailisOpen
        reloadCellWithConfig()
    }
    
    
}

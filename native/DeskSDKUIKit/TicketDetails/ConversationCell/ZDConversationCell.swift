//
//  ZDConversationCell.swift
//  ZohoDeskUIKit
//
//  Created by Rajeshkumar Lingavel on 17/05/18.
//  Copyright © 2018 rajesh-2098. All rights reserved.
//

import UIKit
import WebKit
import ZohoDeskSDK

internal struct ThreadCellConfig{
    
    var isOpen = false
    var isblockOpen = false
    var isSenderDetailisOpen = false
    
    var totalCellHeight:CGFloat = 0
    
    var webViewHeightWithAttachment:CGFloat = 0
    var senderDetailHeight:CGFloat = 0
    
    init() {}
}

internal class ZDConversationCell: UITableViewCell {
    
    var reload: ((ThreadCellConfig) -> Void)?
    var refresh: ((ThreadCellConfig) -> Void)?

    var cellConfig:ThreadCellConfig!
    
    //Xib Properties
    @IBOutlet weak var cellContainerView: UIView?

    @IBOutlet weak var userImage:UIImageView?
    @IBOutlet weak var channelImage:UIImageView?
    @IBOutlet weak var titleLabel:UILabel?
    @IBOutlet weak var subtitleLabel:UILabel?
    @IBOutlet weak var attachImage:UIImageView?
    @IBOutlet weak var attachCountLabel:UILabel?
    
    @IBOutlet weak var headerView: UIView?
    @IBOutlet weak var webContainer: UIView?
    @IBOutlet weak var threadWebView:UIWebView?
    @IBOutlet weak var webContainerHeightConstrain: NSLayoutConstraint!
    
    @IBOutlet weak var attachmentContainer: UIView?
    @IBOutlet weak var attachmentCollectionView: UICollectionView?
    @IBOutlet weak var attachmentViewHeightConstrain: NSLayoutConstraint!
    
    
    @IBOutlet weak var senderSelectionButton:UIButton!
    @IBOutlet weak var fromButton:UIButton!

    @IBOutlet weak var senderDetailContainer:UIView!
    @IBOutlet weak var labelContainer:UIView!
    @IBOutlet weak var dataContainer:UIView!

    
    @IBOutlet weak var fromLabel:UILabel!
    @IBOutlet weak var toLabel:UILabel!
    @IBOutlet weak var ccLabel:UILabel!
    @IBOutlet weak var bccLabel:UILabel!
    
    @IBOutlet weak var toContainer:UIStackView!
    @IBOutlet weak var ccContainer:UIStackView!
    @IBOutlet weak var bccContainer:UIStackView!
    
    @IBOutlet weak var senderContainerHeightConstrain:NSLayoutConstraint!
    
    @IBOutlet weak var toContainerHeightConstrain:NSLayoutConstraint!
    @IBOutlet weak var ccContainerHeightConstrain:NSLayoutConstraint!
    @IBOutlet weak var bccContainerHeightConstrain:NSLayoutConstraint!
    
    
    @IBOutlet weak var progressView:UIView?

    //Data Config Properties
    let attachmentCellHeight:CGFloat = 100
    let attachmentCellwidth:CGFloat = 75
    let progressBarHeight:CGFloat = 5
    
    var isProgressRunning = false
    
    var dataModel: ZDConverstaion?{
        didSet{updateData()}
    }
    
    //#MARK:- Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        layoutMargins = UIEdgeInsets.zero
        self.selectionStyle = .none
        configWebView()
        applyFontAndTheme()
        setupAttachmentCollectionView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        threadWebView?.delegate = nil
        loadHtmlContent(content:"")
        self.stopProgressAnimation()
        self.progressView?.isHidden = true
    }
    
    func updateData(){
        self.progressView?.isHidden = true
        guard let modelObject = dataModel else{return}
        threadWebView?.delegate = self
        
        loadHtmlContent(content:modelObject.getContent(isOpen: cellConfig.isOpen))
        
        titleLabel?.text = modelObject.getTitle()
        subtitleLabel?.text = modelObject.getSubTitle()
        
        channelImage?.image = UIImage(named: modelObject.getChannelIcon(), in:ZDUtility.getBundle()!, compatibleWith: nil)!
        attachImage?.isHidden = modelObject.getAttachCountText().isEmpty
        attachCountLabel?.text = modelObject.getAttachCountText()
        attachmentCollectionView?.reloadData()
        
        userImage?.image = UIImage(named:"default.pdf", in:ZDUtility.getBundle()!, compatibleWith: nil)
        ZDUtility.downloadImage(imageURLString: modelObject.getUserImageURL(),header:["orgId":modelObject.orgId]) { [weak self](imageData) in
            guard let image = imageData, let selfObject = self ,let userImage = UIImage(data: image) else{return}
            selfObject.userImage?.image = userImage
        }
        
        updateSenderDetails()
    }
    
    func configWebView(){
        threadWebView?.scrollView.isScrollEnabled = false
    }
    
    func loadHtmlContent(content:String){
       threadWebView?.loadHTMLString(headerString(content), baseURL: nil)
    }
    
    func reloadCellWithConfig(){
        self.stopProgressAnimation()
        senderContainerHeightConstrain.constant = getPossibleTotalHeightOfCell()
        cellConfig.totalCellHeight = getPossibleTotalHeightOfCell() + cellConfig.webViewHeightWithAttachment
        self.setNeedsLayout()
        reload?(cellConfig)
    }
    
    func getAttachmentHeight() -> CGFloat{
        let attachementCount = (dataModel?.getAttchments()?.count).toInt()
        let attachHeight = cellConfig.isOpen ? (CGFloat(Int(attachementCount / 2) + Int(attachementCount % 2)) * attachmentCellHeight) + CGFloat(attachementCount * 7) : 0
        attachmentViewHeightConstrain.constant = attachHeight
        return attachHeight
    }
    
    
    func applyFontAndTheme(){
        
        senderDetailContainer.layer.cornerRadius = 10
        senderDetailContainer.layer.masksToBounds = true
        senderDetailContainer.backgroundColor = ZDStyle.ZDTicketDetailCellTheme.tableBGColor
        
        senderSelectionButton.setTitleColor(ZDStyle.ZDTicketDetailCellTheme.detailOpenButtonTextColor, for: UIControlState.normal)
        self.cellContainerView?.layer.masksToBounds = true
        self.cellContainerView?.layer.cornerRadius = 5
        
        self.contentView.backgroundColor = ZDStyle.ZDTicketDetailCellTheme.tableBGColor
        
        userImage?.layer.masksToBounds = true
        userImage?.layer.cornerRadius = userImage!.bounds.size.width * 0.50
        
        progressView?.backgroundColor = ZDStyle.ZDTicketDetailCellTheme.detailOpenButtonTextColor
        
        channelImage?.layer.masksToBounds = true
        channelImage?.layer.cornerRadius = channelImage!.bounds.size.width * 0.50
        
        self.titleLabel?.font = UIFont.getProximaNovaBold(size: 18)
        self.subtitleLabel?.font = UIFont.getProximaNovaRegularFont(size: 14)
        
        _ = [fromLabel,toLabel,ccLabel,bccLabel,attachCountLabel].map { (label) -> Void in
            label?.font = UIFont.getProximaNovaRegularFont(size: 14)
            label?.textColor = ZDStyle.secondaryColor
        }
        
    }
    
    fileprivate func headerString(_ content:String) -> String {
        
        var htmlString = content
        htmlString = content.replacingOccurrences(of: "<blockquote", with: "|BREAK STR FOR BLOCKQUOTE|<blockquote")
        let array = htmlString.components(separatedBy: "|BREAK STR FOR BLOCKQUOTE|")
        
        let repilyContent = array.count > 0 ? array[0] : ""
        let blockQuoteContent = array.count > 1 ? array[1] : ""
        
        var finalContent = ""
        
        if blockQuoteContent.isEmpty {
            finalContent =  "<!DOCTYPE html><head><meta name='viewport' content='width=device-width,height=device-height,target-densitydpi=device-dpi,maximum-scale=1,user-scalable=yes,maximum-scale=3.0'/><style>body{color:#\(ZDStyle.primaryColor.hexStringFromColor());font-family:\("sans-serif");margin-top:0px; margin-right: 0px; margin-bottom:5px; margin-left: 0px;} img{max-width: 100% !important;} table, td, tr, td div, td span{ background-color:#\(UIColor.white.hexStringFromColor()) !important; border:none !important; color:#\(ZDStyle.primaryColor.hexStringFromColor()) !important;} font,span, p, body, head, div, table, pre{font-size: 15px !important;line-height: 140% !important;white-space: normal !important; background-color:#\(ZDStyle.primaryColor.hexStringFromColor()) !important;} div { display: block; word-wrap: break-word important; visibility: visible;} table { width: 100% !important; -webkit-transform: scale(1, 1);} div, p, a, li, td { -webkit-text-size-adjust: none;}</style></head><div style='word-wrap: break-word;'>\(repilyContent)</div></html>"
        }else{
            finalContent =  "<!DOCTYPE html><script>function showOrHideBlockContent() { window.location = 'moreKeyPressed://';}</script><head><meta name='viewport' content='width=device-width,height=device-height,target-densitydpi=device-dpi,maximum-scale=1,user-scalable=yes,maximum-scale=3.0'/><style>body{color:#\(ZDStyle.primaryColor.hexStringFromColor());font-family:\("sans-serif");margin-top:0px; margin-right: 0px; margin-bottom:5px; margin-left: 0px;} img{max-width: 100% !important;} table, td, tr, td div, td span{ background-color:#\(ZDStyle.primaryColor.hexStringFromColor()) !important; border:none !important; color:#\(ZDStyle.primaryColor.hexStringFromColor()) !important;} font,span, p, body, head, div, table, pre{font-size: 15px !important;line-height: 140% !important;white-space: normal !important; background-color:#\(UIColor.white.hexStringFromColor()) !important;} div { display: block; word-wrap: break-word important; visibility: visible;} table { width: 100% !important; -webkit-transform: scale(1, 1);} div, p, a, li, td { -webkit-text-size-adjust: none;}</style></head><div style='word-wrap: break-word;'><div id='mailcontentid' style='display: block; position: relative; background-color: white; padding: 0px; marign-top: 1px' class='content'>\(repilyContent)</div> <div id='msgviewoption' style='display: block; width : 25px; color:#\(ZDStyle.primaryColor.hexStringFromColor()) !important; 'class='dotoption' onclick='showOrHideBlockContent()'>• • •</div> <div id='blockcontent' style='display: \(cellConfig.isblockOpen ? "block" : "none")';>\(cellConfig.isblockOpen ? blockQuoteContent : "")</div></div></html>"
        }
        
        return finalContent
        
    }
}

//#MARK:- WebView delegate Methods.
extension ZDConversationCell : UIWebViewDelegate{
    
    func webViewDidStartLoad(_ webView: UIWebView){}
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        let components = request.url?.absoluteString.components(separatedBy: ":")
        if components?[0] == "morekeypressed" {
            cellConfig.isblockOpen = !cellConfig.isblockOpen
            loadHtmlContent(content:dataModel?.getContent(isOpen: cellConfig.isOpen) ?? "")
        }

        return true
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView){
        if webView.isLoading {return}
        self.stopProgressAnimation()

        if let height = NumberFormatter().number(from: webView.stringByEvaluatingJavaScript(from: "document.body.offsetHeight;") ?? "0") {
            let attachHeight = getAttachmentHeight()
            
            //80 - Header + 40 - Additional for web
            let  totalHeight = CGFloat(truncating: height) + 80 + 40 + attachHeight
            attachmentViewHeightConstrain.constant = attachHeight
            
            webContainerHeightConstrain.constant = CGFloat(truncating: height)
            if totalHeight != cellConfig.webViewHeightWithAttachment{
                cellConfig.webViewHeightWithAttachment = totalHeight
                attachmentViewHeightConstrain.constant = attachHeight
                webContainerHeightConstrain.constant = CGFloat(truncating: height)
                self.updateConstraintsIfNeeded()
                reloadCellWithConfig()
                return
            }
        }
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error){}
    
}

//Progress Animator
extension ZDConversationCell{
    func startProgressAnimation(){
        isProgressRunning = true
        configureAnimation()
    }
    
    func stopProgressAnimation(){
        isProgressRunning = false
        self.progressView?.isHidden = true
    }
    
    fileprivate func configureAnimation() {
        let yPosition = cellContainerView!.bounds.height - self.progressView!.bounds.height
        self.progressView?.frame = CGRect(origin: CGPoint(x: 0, y :yPosition), size: CGSize(width: 0, height: progressBarHeight))
        
        progressView?.isHidden = false
        UIView.animateKeyframes(withDuration: 2, delay: 0, options: [], animations: {
            
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5, animations: {
                self.progressView?.frame = CGRect(x: 0, y: yPosition, width: self.cellContainerView!.frame.width * 0.7, height: self.progressBarHeight)
            })
            
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5, animations: {
                self.progressView?.frame = CGRect(x: self.cellContainerView!.frame.width, y: yPosition, width: 0, height: self.progressBarHeight)
                
            })
            
        }) { (completed) in
            if self.isProgressRunning{
                self.configureAnimation()
            }
        }
    }
}

//#MARK:- Network Methods
extension ZDConversationCell {
    
    func loadThreadDetails(){
        guard let modelObject = dataModel else{return}
        if modelObject.type == .comment{return}
        
        self.startProgressAnimation()
        if let _ = (modelObject as! ZDThread).threadDetails{
            updateData()
            return
        }
        
        (modelObject as! ZDThread).getThreadDetail { [weak self] (threadDetail, error, statusCode) in
            DispatchQueue.main.async {
                guard let selfObject = self else{return}
//                selfObject.subtitleLabel?.text = modelObject.getSubTitle()
//                selfObject.loadHtmlContent(content:selfObject.dataModel?.getContent(isOpen: selfObject.cellConfig.isOpen) ?? "")
                selfObject.updateData()
                selfObject.attachmentCollectionView?.reloadData()
            }
        }
        
    }
}

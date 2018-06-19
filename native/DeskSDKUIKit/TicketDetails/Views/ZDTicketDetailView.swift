
//  ZDTicketDetails.swift
//  ZohoDeskUIKit
//
//  Created by Rajeshkumar Lingavel on 15/05/18.
//  Copyright © 2018 rajesh-2098. All rights reserved.
//

import UIKit
import ZohoDeskSDK
@objc public protocol ZDTicketdetailViewDelegate: class {
    
    func shouldLoadMoreData(ticketdetail:ZDTicketDetailView) -> Bool
    func didBeginLoadingData(ticketdetail:ZDTicketDetailView) -> Void
    func didEndLoadingData(ticketdetail:ZDTicketDetailView,error:Error?,statusCode:Int) -> Void
}

@objc public enum ZDTicketDetailListingType:Int{
    case ZDConversation,ZDThreads,ZDComments
}

@objcMembers public class ZDTicketDetailViewConfiguration:NSObject{
    
    ///Unique ID of the Organization
    public var orgId = ""
    
    ///Unique ID of the ticket
    public var ticketId = ""

    /// From index
    public var from = 0
    
    /// No. of tickets to fetch
    public var limit = 50{
        didSet{
            if limit > 99{
                limit = 99
            }
        }
    }
    
    public var ticketObject:ZDTicket?
    
    public var listingType:ZDTicketDetailListingType = .ZDConversation
    
    public init(orgId:String,ticketId:String) {
        super.init()
        self.orgId = orgId
        self.ticketId = ticketId
    }
    
    public convenience init(ticketObject:ZDTicket) {
        self.init(orgId: ticketObject.orgId, ticketId: ticketObject.id)
        self.ticketObject = ticketObject
    }
}

@objc public class ZDTicketDetailView: UIView {
    
    public var delegate:ZDTicketdetailViewDelegate?{
        didSet{
            delegate?.didBeginLoadingData(ticketdetail: self)
        }
    }
    
    internal var tableView:UITableView?
    internal var footerView:UIView?
    internal var msgLabel:UILabel?
    internal var ticketHeader:ZDTicketDetailsHeader?
    internal let cellReuseIdentifier = "ZDConversationCell"
    internal var sectionCount = 0

    var configuration: ZDTicketDetailViewConfiguration!{
        didSet{
            getTicketDetails(ticketId: configuration.ticketId)
        }
    }
    
    internal var ticketDetail:ZDTicketDetail?{
        didSet{
            sectionCount = 1
            self.tableView?.reloadData()
            updateHeaderDetails(ticketDetail: ticketDetail)
            self.loadListDetails(from: 0, ticketId: configuration.ticketId)
            self.tableView?.tableFooterView = getFooterView()

        }
    }
    
    internal var dataSourceConversation:[ZDConverstaion]?
    internal var dataSourceComments:[ZDTicketComment]?
    internal var dataSourceThreads:[ZDThread]?
    internal lazy var cellConfig = [IndexPath:ThreadCellConfig]()
    
    //MARK:- Methods
    public init(frame: CGRect,configuration:ZDTicketDetailViewConfiguration) {
        super.init(frame: frame)
        ZohoDeskUIKit()
        configureTableView()
        self.configuration = configuration
        getTicketDetails(ticketId: self.configuration.ticketId)
    }
    
    @objc public func updateConfig(configuration:ZDTicketDetailViewConfiguration){
        self.configuration = configuration
        self.msgLabel?.isHidden = true
        self.ticketDetail = nil
        self.dataSourceConversation = nil
        self.dataSourceThreads = nil
        self.dataSourceComments = nil
        self.tableView?.reloadData()
        self.getTicketDetails(ticketId: self.configuration.ticketId)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
//MARK:- TableViewDelegate Methods
extension ZDTicketDetailView:UITableViewDataSource,UITableViewDelegate {
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return sectionCount
    }
    // number of rows in table view
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getRowCount()
    }
    
    // create a cell for each table view row
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as? ZDConversationCell else{return UITableViewCell()}
        
        cell.cellConfig = getRowHeightValue(indexPath: indexPath)
        cell.dataModel = self.getDataModel(indexPath: indexPath)
        cell.reload = { [weak self] (config) -> Void in
             guard let selfObject = self else{return}
            DispatchQueue.main.async {
                selfObject.cellConfig[indexPath] = config
                if #available(iOS 11.0, *) {
                    tableView.performBatchUpdates({}, completion: nil)
                } else {
                    tableView.beginUpdates()
                    tableView.endUpdates()
                }
            }
        }
        return cell
    }
    
    // method to run when table view cell is tapped
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var cellConfigObject = getRowHeightValue(indexPath: indexPath)
        cellConfigObject.isOpen = !cellConfigObject.isOpen
        cellConfig[indexPath] = cellConfigObject
        guard let cell = tableView.cellForRow(at: indexPath) as? ZDConversationCell else {
            "Something went wrong in cell selection".makeLog()
            return
        }
        cell.cellConfig = cellConfigObject
        cell.loadThreadDetails()
    }
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == getRowCount() - 1{
            guard let delegateObject = delegate else{loadMoreData();return}
            
            if  isNextPageAvailable() && delegateObject.shouldLoadMoreData(ticketdetail: self){
                loadMoreData()
            }
        }
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return getRowHeightValue(indexPath: indexPath).totalCellHeight
    }
    
    public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return getRowHeightValue(indexPath: indexPath).totalCellHeight
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section != 0{ return nil}
        
        if ticketHeader == nil{
            ticketHeader = ZDUtility.getXIb(name: ZDConstant.ticketDetailNIBName,index:1) as? ZDTicketDetailsHeader
        }
        ticketHeader?.updateFilter =  self.filterSelection(selectedFilter:)
        ticketHeader?.selectedListingType = configuration.listingType
        ticketHeader?.dataModel = self.ticketDetail
        return ticketHeader
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section != 0{ return 0 }
            return 210
    }
}

//MARK:- Helper methods
extension ZDTicketDetailView{
    
    /// Initial configuration of the tableView
    internal func configureTableView() -> Void{
        tableView = getTableView()
        tableView?.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.backgroundColor = ZDStyle.ZDTicketDetailCellTheme.tableBGColor
        tableView?.estimatedRowHeight = 44
        tableView?.rowHeight = UITableViewAutomaticDimension
        tableView?.tableFooterView = UIView()
        addSubview(self.tableView!)
        
        tableView?.register(UINib(nibName: "ZDConvserationCell", bundle: ZDUtility.getBundle()!), forCellReuseIdentifier: cellReuseIdentifier)
                
    }
    
    
    /// Gete tableview from Xib
    ///
    /// - Returns: TableView from Xib
    internal func getTableView() -> UITableView? {
        let tableview = ZDUtility.getXIb(name: ZDConstant.ticketDetailNIBName) as? UITableView
        tableview?.frame = self.bounds
        return tableview
    }
    
    
    /// This will update headerView Data for ticket
    ///
    /// - Parameter ticketDetail: TicketDetail Object
    internal func updateHeaderDetails(ticketDetail:ZDTicketDetail?){
        ticketHeader?.dataModel = ticketDetail
    }
    
    
    /// Get model object for particular indexpath
    ///
    /// - Parameter indexPath: indexpath value
    /// - Returns: Data model Object
    internal func getDataModel(indexPath:IndexPath) -> ZDConverstaion?{
        var dataModels:[ZDConverstaion]?
        switch self.configuration.listingType {
        case .ZDConversation:
            dataModels = self.dataSourceConversation
        case .ZDThreads:
            dataModels = self.dataSourceThreads
        case .ZDComments:
            dataModels = self.dataSourceComments
        }
        
        if let modelObjects = dataModels, modelObjects.count > indexPath.row {
            return dataModels![indexPath.row]
        }
        return nil
    }
    
    fileprivate func getRowHeightValue(indexPath:IndexPath) -> ThreadCellConfig{
        guard  let config = cellConfig[indexPath] else{
            cellConfig[indexPath] = ThreadCellConfig()
            return cellConfig[indexPath]!
        }
        return config
    }
    
    fileprivate func filterSelection(selectedFilter:ZDTicketDetailListingType){
        DispatchQueue.main.async {
            self.configuration.listingType = selectedFilter
            if self.getRowCount() == 0{self.loadListDetails(from: 0, ticketId: self.configuration.ticketId)}
            self.tableView?.reloadData()
        }
    }
    
    fileprivate func isNextPageAvailable() -> Bool{
        guard let ticketModelData = ticketDetail else{return false}
        switch configuration.listingType {
        case .ZDConversation:
             return (Int(ticketModelData.threadCount).toInt() + Int(ticketModelData.commentCount).toInt()) > (self.dataSourceConversation?.count).toInt()
        case .ZDThreads:
            return Int(ticketModelData.threadCount).toInt()  > (self.dataSourceThreads?.count).toInt()
        case .ZDComments:
            return Int(ticketModelData.commentCount).toInt() > (self.dataSourceComments?.count).toInt()
        }
        
    }
    
    fileprivate func getRowCount() -> Int{
        var rowCount = 0
        switch self.configuration.listingType {
        case .ZDConversation:
            rowCount = (self.dataSourceConversation?.count).toInt()
        case .ZDThreads:
            rowCount = (self.dataSourceThreads?.count).toInt()
        case .ZDComments:
            rowCount = (self.dataSourceComments?.count).toInt()
        }
//        if rowCount == 0{loadListDetails(from: 0, ticketId: configuration.ticketId)}
        return rowCount
    }
    
    func loadMoreData(){
            self.tableView?.tableFooterView = getFooterView()
            loadListDetails(from:getRowCount() + 1, ticketId: configuration.ticketId)
    }
    
    func getFooterView() -> UIView{
        if let loadingView = footerView{return loadingView}
        
        footerView = UIView(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: self.bounds.width, height: 50)))
        footerView?.autoresizingMask = [.flexibleRightMargin,.flexibleLeftMargin,.flexibleWidth,.flexibleHeight]
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        activityIndicator.center = footerView!.center
        activityIndicator.startAnimating()
        footerView?.addSubview(activityIndicator)
        
        return footerView!
    }
    
    fileprivate func showMsgLabel(msg:String){
        if msgLabel == nil{
            msgLabel = UILabel(frame: CGRect(x: 0, y: 0, width: bounds.width, height: 50))
        }
        msgLabel?.center = center
        msgLabel?.textAlignment = .center
        msgLabel?.isHidden = false
        msgLabel?.font = UIFont.getProximaNovaRegularFont(size: 18)
        msgLabel?.text = msg
        addSubview(msgLabel!)
        bringSubview(toFront: msgLabel!)
    }
}

//MARK:- Network Methods
extension ZDTicketDetailView{
    /// This method will get the Ticket details for the given ticket ID
    ///
    /// - Parameter ticketId: User provided ticket Id.
    internal func getTicketDetails(ticketId:String) -> Void{
        if configuration.ticketId.isEmpty || configuration.orgId.isEmpty {return}
        delegate?.didBeginLoadingData(ticketdetail: self)
        ZDTicketAPIHandler.getTicketDetails(configuration.orgId, ticketId: configuration.ticketId, include: "contacts,products,assignee") { [weak self] (ticketDetailObject,json, error, statusCode) in
            guard let selfObject = self else{return}
            DispatchQueue.main.async {
                selfObject.ticketDetail =   ticketDetailObject
                selfObject.delegate?.didEndLoadingData(ticketdetail: selfObject, error: error, statusCode: statusCode)
            }
        }
    }
    
    func loadListDetails(from:Int,ticketId:String){
        self.tableView?.tableFooterView = getFooterView()
        switch configuration.listingType {
        case .ZDConversation:
            loadConversation(from: from, ticketId: ticketId)
        case .ZDThreads:
            loadThreads(from: from, ticketId: ticketId)
        case .ZDComments:
            loadComments(from: from, ticketId: ticketId)
        }
    }
    
    internal func loadConversation(from:Int,ticketId:String){
        if ticketId.isEmpty || configuration.orgId.isEmpty {return}
        ZDThreadAPIHandler.getAllConversation(configuration.orgId, ticketId: ticketId, from: from, limit: configuration.limit) { [weak self](conversation, error, status) in
            guard let selfObject = self else{return}
            //TODO:- Handle error empty data case.
            let conversationObjects = ZDThreadAPIHandler.conversationParser(orgId: selfObject.configuration.orgId, ticketId: ticketId, conversationJson: conversation)
            DispatchQueue.main.async {
                if from == 0{
                    selfObject.dataSourceConversation = conversationObjects
                    if error != nil{
                        selfObject.showMsgLabel(msg: "deskSDKUI.ticketDetails.Error".localized)
                    }
                    else if conversation == nil || conversation!.count == 0{
                        selfObject.showMsgLabel(msg: "deskSDKUI.ticketDetails.nodata".localized)
                    }
                }
                else{
                    selfObject.dataSourceConversation! = selfObject.dataSourceConversation! + conversationObjects!
                }
                selfObject.tableView?.tableFooterView = nil
                selfObject.tableView?.reloadData()
            }
        }
    }
    
    internal func loadThreads(from:Int,ticketId:String){
        if ticketId.isEmpty || configuration.orgId.isEmpty {return}
        ZDThreadAPIHandler.getAllThreads(configuration.orgId, from: from, limit: configuration.limit, ticketId: ticketId) { [weak self](threads, error, statusCode) in
            
            guard let selfObject = self else{return}
            //TODO:- Handle error empty data case.
            if from == 0{selfObject.dataSourceThreads = threads}
            else{
                selfObject.dataSourceThreads! = selfObject.dataSourceThreads! + threads!
            }
            DispatchQueue.main.async {
                selfObject.tableView?.tableFooterView = nil
                selfObject.tableView?.reloadData()
            }
        }
    }
    
    internal func loadComments(from:Int,ticketId:String){
        if ticketId.isEmpty || configuration.orgId.isEmpty {return}

        ZDTicketCommentsAPIHandler.getAllTicketComments(configuration.orgId, ticketID: ticketId, from: from, limit: configuration.limit) { [weak self] (ticketComment, error, statusCode) in
            
            guard let selfObject = self else{return}
            
            //TODO:- Handle error empty data case.
            if from == 0{selfObject.dataSourceComments = ticketComment}
            else{
                selfObject.dataSourceComments! = selfObject.dataSourceComments! + ticketComment!
            }
            DispatchQueue.main.async {
                selfObject.tableView?.tableFooterView = nil
                selfObject.tableView?.reloadData()
            }
        }

    }
}

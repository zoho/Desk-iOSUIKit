//
//  ZDTicketListView.swift
//  DeskSDKUIKit
//
//  Created by Rajeshkumar Lingavel on 09/05/18.
//  Copyright © 2018 rajesh-2098. All rights reserved.
//

import UIKit
import ZohoDeskSDK
@objc public protocol ZDTicketListViewDelegate: class {
    
    func shouldLoadMoreData(ticketList:ZDTicketListView) -> Bool
    
    func didBeginLoadingData(ticketList:ZDTicketListView,from:Int) -> Void
    func didEndLoadingData(ticketList:ZDTicketListView,error:Error?,statusCode:Int) -> Void

    func didSelectTicket(ticketList:ZDTicketListView,configuration:ZDTicketListConfiguration,ticketId:String,index:Int) -> Void
    
}

@objc public class ZDTicketListConfiguration:NSObject{
    
    ///Unique ID of the Organization
    public var orgId = ""
    
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
    
    //Unique Id of the View.
    public var viewId:String?
    
    ///    Department from which the tickets need to be queried
    public var departmentId:String?
    
    /// Filter by ticket assignee. Values allowed are Unassigned or valid asigneeIds. You can include multiple values by separating them with a comma.
    public var filterByAssignee:String?
    
    /// Filter by channel through which the tickets originated. You can include multiple values by separating them with a comma.
    public var filterByChannel:String?
    
    ///Filter by resolution status of the ticket. You can include multiple values by separating them with a comma
    public var filterByStatus:String?
    
    ///Sort by a specific attribute: dueDate or recentThread. The default sorting order is ascending. A - prefix denotes descending order of sorting.
    ///Ex: ("-recentThread" for Descending order of sorting.)
    ///Ex: ("recentThread" for Ascending order of sorting.)
    public var sortBy:String?
    
    ///Fetches recent tickets, based on customer response time. Values allowed are 15, 30 , 90.
    public var receivedInDays:Int?
    
    ///Allowed Values are : contacts, products. You can include both by separating them with a comma in the query param.
    internal var include = "contacts,products,assignee"
    
    //For next page request
    internal var nextPageAvailable = true
    
    
    /// Ticket List Configuration used to get custmized ticket list result in Ticket List View.
    ///
    /// - Parameter orgId: Unique ID of the Organization
    @objc public init(orgId:String) {
        super.init()
        self.orgId = orgId
    }
    
}

@objc public class ZDTicketListView: UIView {
    public var delegate:ZDTicketListViewDelegate?{
        didSet{
            if isLoadingData.0{
                delegate?.didBeginLoadingData(ticketList: self, from: isLoadingData.1)
            }
        }
    }
    
    internal var isLoadingData = (false,0)
    internal var tableView:UITableView?
    internal let cellReuseIdentifier = "TicketMetaCell"
    internal var dataSource:[ZDTicket]?
    
    internal var msgLabel:UILabel?
    
    var configuration: ZDTicketListConfiguration!
    
    /// This Table list component View.
    ///
    /// - Parameters:
    ///   - frame: Visible frame size of the Ticket list. Note: It having minimum Size.
    ///   - configuration: This configuration allowed to customize the listing based in given configuration.
    @objc public init(frame:CGRect,configuration:ZDTicketListConfiguration) {
        super.init(frame:frame)
        _ = ZohoDeskUIKit()
        self.configuration = configuration
        configureTableView()
        getDataFromServer(from: configuration.from, configuration: configuration)
    }
    
    @objc public func updateConfig(configuration:ZDTicketListConfiguration){
        self.configuration = configuration
        msgLabel?.isHidden = true
        self.dataSource = nil
        self.tableView?.reloadData()
        getDataFromServer(from: configuration.from,configuration: configuration)
        
    }

    /// Initial Configuration of the tabelView.
    internal func configureTableView() -> Void{
        self.backgroundColor = UIColor.red
        tableView = UITableView(frame: bounds)
        tableView?.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        tableView?.tableFooterView = UIView()
        tableView?.register(UINib(nibName: "ZDTicketList", bundle: ZDUtility.getBundle()!), forCellReuseIdentifier: cellReuseIdentifier)
        tableView?.separatorInset = UIEdgeInsetsMake(0, 50, 0, 50)
        if #available(iOS 11, *) {
            tableView?.separatorInsetReference = .fromAutomaticInsets
        }
        tableView?.delegate = self
        tableView?.dataSource = self
        addSubview(tableView!)
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
    
    
    /// System Method
    ///
    /// - Parameter aDecoder: aDecoder Object
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        "init(coder:) has not been implemented".makeLog()
    }
    
}

// MARK: - UITableViewDelegate,UITableViewDataSource implementation
extension ZDTicketListView : UITableViewDelegate,UITableViewDataSource{
    // number of rows in table view
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (dataSource?.count).toInt()
    }
    
    // create a cell for each table view row
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as? ZDTicketListCell else{return UITableViewCell()}
        cell.dataModel = self.getDataModel(indexPath: indexPath)
        return cell
    }
    
    // method to run when table view cell is tapped
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectedModel = getDataModel(indexPath: indexPath) else{return}
        delegate?.didSelectTicket(ticketList: self, configuration:self.configuration, ticketId: selectedModel.id, index: indexPath.row)
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 118
    }
    public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 118
    }
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cellLineConfigure(cell: cell)
        if indexPath.row == ((self.dataSource?.count).toInt()) - 1{
            guard let delegateObject = delegate else{loadMoreData();return}
            if  configuration.nextPageAvailable && delegateObject.shouldLoadMoreData(ticketList: self){
                loadMoreData()
            }
        }
    }
    
    
    
}

//MARK: - Network methods
internal extension ZDTicketListView{
    internal func getDataFromServer(from:Int,configuration:ZDTicketListConfiguration){
        delegate?.didBeginLoadingData(ticketList: self, from: from)
        isLoadingData = (true,from)
        var params:[String:AnyObject] = getPramValues(configuration: configuration)
        params["from"] = from as AnyObject
        params["limit"] = configuration.limit as AnyObject
        ZDTicketAPIHandler.getAllTickets(configuration.orgId,optionalParams:params) { [weak self] (tickets, error,statusCode) in
            guard let selfObject = self else{return}
            DispatchQueue.main.async {
                
                selfObject.isLoadingData = (false,from)
                selfObject.delegate?.didEndLoadingData(ticketList: selfObject, error: error, statusCode: statusCode)
                
                guard let ticketObject = tickets else{
                    if from == 0 && statusCode == 204{selfObject.showMsgLabel(msg: "deskSDKUI.ticketlist.nodata".localized)
                    }
                    return
                }
                if ticketObject.count < configuration.limit{
                    configuration.nextPageAvailable = false
                }
                if from == 0 {
                    selfObject.dataSource = ticketObject
                }
                else{
                    selfObject.tableView?.tableFooterView = nil;
                    selfObject.dataSource! = selfObject.dataSource! + ticketObject
                }
                selfObject.tableView?.reloadData()
            }
        }
    }
    
    func getPramValues(configuration:ZDTicketListConfiguration) -> [String:AnyObject]{
        
        var params = [String:AnyObject]()
        
        if let departmentID = configuration.departmentId {
            params["departmentId"] = departmentID as AnyObject
        }
        if let assignee = configuration.filterByAssignee{
            params["assignee"] = assignee as AnyObject
        }
        
        if let channel = configuration.filterByChannel{
            params["channel"] = channel as AnyObject
        }
        
        if let status = configuration.filterByStatus{
            params["status"] = status as AnyObject
        }
        
        if let viewId = configuration.viewId{
            params["viewId"] = viewId as AnyObject
        }
        
        if let sortBy = configuration.sortBy{
            params["sortBy"] = sortBy as AnyObject
        }
        if let receivedInDays = configuration.receivedInDays{
            params["receivedInDays"] = receivedInDays as AnyObject
        }
        params["include"] = configuration.include as AnyObject
        return params
    }
    
}

///HelperMethods
internal extension ZDTicketListView{
    
    
    func getDataModel(indexPath:IndexPath) -> ZDTicket?{
        if dataSource != nil && dataSource!.count > indexPath.row{
            return dataSource![indexPath.row]
        }
        return nil
    }
    
    func loadMoreData(){
        self.tableView?.tableFooterView = getFooterView()
        getDataFromServer(from: (self.dataSource?.count).toInt() + 1, configuration: self.configuration)
    }
    
    func getFooterView() -> UIView{
         let footerView = UIView(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: self.bounds.width, height: 50)))
        
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 30, height: 30)        
        activityIndicator.center = footerView.center
        activityIndicator.startAnimating()
        footerView.addSubview(activityIndicator)
        
        return footerView
    }
    
    func cellLineConfigure(cell:UITableViewCell){
        if cell.responds(to: #selector(setter: UITableViewCell.separatorInset)) {
            cell.separatorInset = UIEdgeInsets.zero
        }
        if cell.responds(to: #selector(setter: UITableViewCell.layoutMargins)) {
            cell.layoutMargins = UIEdgeInsets.zero
        }
        if cell.responds(to: #selector(setter: UITableViewCell.preservesSuperviewLayoutMargins)) {
            cell.preservesSuperviewLayoutMargins = false
        }
    }
    
}


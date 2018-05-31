//
//  Constant.swift
//  DeskSDKUIKit
//
//  Created by Rajeshkumar Lingavel on 10/05/18.
//  Copyright © 2018 rajesh-2098. All rights reserved.
//


internal struct ZDConstant {
    
    //XIB Constant
    static let ticketListCelNIBName = "ZDTicketList"
    static let ticketDetailNIBName = "ZDTicketDetail"
    
    //Font Constant
    struct  FontConstant{
        static let channelFilterIcon = ["Mail":"\u{e929}","Chat":"\u{e918}","Telephone":"\u{e93d}","Community":"\u{e925}","Facebook":"\u{e920}","Twitter":"\u{e921}","Others":"\u{e91a}","Forums":"\u{e925}","Web":"\u{e93a}","Phone":"\u{e93d}","All Channels":"\u{e92f}","Email":"\u{e929}"]

        static let channelFilterIconName = ["mail":"mail","chat":"chat","telephone":"phone","community":"\u{e925}","facebook":"facebook","twitter":"twitter","others":"web","forums":"\u{e925}","web":"web","phone":"phone","email":"mail",
                                            "chat_in":"chatin",
                                            "chat_out":"chatout",
                                            "community":"community",
                                            "community_in":"communityin",
                                            "draft":"draft",
                                            "facebook_in":"facebookin",
                                            "facebook_out":"facebookout",
                                            "mail_forward":"mailforward",
                                            "mail_in":"mailin",
                                            "mail_out":"mailout",
                                            "phone_out":"phoneout",
                                            "phone_in":"phonein",
                                            "reply":"reply",
                                            "smile_in":"smilein",
                                            "smile_out":"smileout",
                                            "twitter_in":"twitterin",
                                            "twitter_out":"twitterout",
                                            "web_in":"webin"]

    }
    
    

    //FolderName
    struct FolderNames {
        static let rootFolderName = "ZohoDeskSDKFiles"
        static let fileScheme = "file://"
    }
    
}

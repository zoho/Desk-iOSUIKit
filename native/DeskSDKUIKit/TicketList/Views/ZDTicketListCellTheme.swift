//
//  ZDTicketTheme.swift
//  ZohoDeskUIKit
//
//  Created by Rajeshkumar Lingavel on 15/05/18.
//  Copyright © 2018 rajesh-2098. All rights reserved.
//

import UIKit


extension ZDStyle{
    //ZDTicketCell StyleProperties
    internal struct ZDTicketListCellTheme {
    
        //SubTitle Color
        internal static var subTitleColor:UIColor {
            switch ZDStyle.selectedTheme {
            case .white:
                return .black
            }
        }
        //Description Color
        internal static var descriptionColor:UIColor {
            switch ZDStyle.selectedTheme {
            case .white:
                return .black
            }
        }
        
        internal static var highPriorityColor:UIColor {
            switch ZDStyle.selectedTheme {
            case .white:
                return UIColor(red:0.98, green:0.22, blue:0.32, alpha:1.00)
            }
        }
        internal static var mediumPriorityColor:UIColor {
            switch ZDStyle.selectedTheme {
            case .white:
                return UIColor(red:0.99, green:0.88, blue:0.13, alpha:1.00)
            }
        }
        
        internal static var lowPriorityColor:UIColor {
            switch ZDStyle.selectedTheme {
            case .white:
                return UIColor(red:0.57, green:0.87, blue:0.24, alpha:1.00)
            }
        }
    }
}

//
//  ZDTicketDetailTheme.swift
//  ZohoDeskUIKit
//
//  Created by Rajeshkumar Lingavel on 17/05/18.
//  Copyright © 2018 rajesh-2098. All rights reserved.
//

import UIKit

extension ZDStyle{
    
    internal struct ZDTicketDetailCellTheme {
        //tableBg Color
        internal static var tableBGColor:UIColor {
            switch ZDStyle.selectedTheme {
            case .white:
                return UIColor(red:0.97, green:0.97, blue:0.97, alpha:1.00)
            }
        }
        
        internal static var filterButtonText:UIColor {
            switch ZDStyle.selectedTheme {
            case .white:
                return UIColor(red:0.17, green:0.62, blue:0.89, alpha:1.00)
            }
        }
        internal static var detailOpenButtonTextColor:UIColor{
            switch ZDStyle.selectedTheme {
            case .white:
                return UIColor(red:0.30, green:0.68, blue:0.43, alpha:1.00)
            }
        }

        
    }
}

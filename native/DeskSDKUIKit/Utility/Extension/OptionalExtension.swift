//
//  OptionalExtention.swift
//  ZohoDeskUIKit
//
//  Created by Rajeshkumar Lingavel on 14/05/18.
//  Copyright © 2018 rajesh-2098. All rights reserved.
//

import UIKit
extension Optional where Wrapped == AnyObject{
    
    func toString() -> String{
        if let value = self{
            return "\(value)"
        }
        
        return ""
    }
    func toInt() -> Int{
        if let value = self as? Int{
            return value
        }
        return 0
        
    }
    
    func toBool() -> Bool{
        if let value = self as? Bool{
            return value
        }
        return false
        
    }
    
    func toCGFloat() -> CGFloat{
        if let value = self as? CGFloat{
            return value
        }
        return 0
    }
}

extension Optional where Wrapped == String{
    
    func toString() -> String{
        if let value = self{
            return "\(value)"
        }
        
        return ""
    }
}

extension Optional where Wrapped == Int{
    
    func toInt() -> Int{
        if let value = self{
            return value
        }
        return 0
        
    }
}

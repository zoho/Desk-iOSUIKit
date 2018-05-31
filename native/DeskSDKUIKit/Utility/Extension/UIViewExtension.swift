//
//  UIViewExtension.swift
//  ZohoDeskUIKit
//
//  Created by Rajeshkumar Lingavel on 17/05/18.
//  Copyright © 2018 rajesh-2098. All rights reserved.
//

import UIKit

extension UIView{
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    func showActionsheet(title: String, message:String,type:UIAlertControllerStyle = .actionSheet, actions: [[String:UIAlertActionStyle]], completion: @escaping (_ index: Int,_ selectedTitle:String) -> ()) {
        
        let alertViewController = UIAlertController(title:title, message: message, preferredStyle: type)
        for (index,action) in actions.enumerated() {
            for actionContent in action {
                let action = UIAlertAction(title: actionContent.key, style: actionContent.value) { (action) in
                    completion(index,actionContent.key)
                }
                alertViewController.addAction(action)
            }
        }
        ZDUtility.getTopViewController()?.present(alertViewController, animated: true, completion: nil)
    }
}

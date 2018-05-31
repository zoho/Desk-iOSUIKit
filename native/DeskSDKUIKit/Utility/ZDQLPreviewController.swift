//
//  ViewControllerExtension.swift
//  ZohoDeskUIKit
//
//  Created by Rajeshkumar Lingavel on 29/05/18.
//  Copyright © 2018 rajesh-2098. All rights reserved.
//

import UIKit
import QuickLook
internal class ZDQLPreviewController{
    var previewController:QLPreviewController!
    lazy var files = [URL]()
    init(files:[URL]) {
        self.files = files
        previewController = QLPreviewController()
        previewController.dataSource = self
    }
    
    func showPreview(){
        ZDUtility.getTopViewController()?.present(previewController, animated: true)
    }
}

extension ZDQLPreviewController : QLPreviewControllerDataSource{
     func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return files.count
    }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        return files[index] as QLPreviewItem
    }
    
}

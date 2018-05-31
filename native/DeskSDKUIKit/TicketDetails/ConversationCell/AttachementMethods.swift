//
//  ConversationCellExtension.swift
//  ZohoDeskUIKit
//
//  Created by Rajeshkumar Lingavel on 18/05/18.
//  Copyright © 2018 rajesh-2098. All rights reserved.
//

import UIKit
import ZohoDeskSDK
extension ZDConversationCell : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func setupAttachmentCollectionView(){
        //ZDAttachementCollectionCell
        self.attachmentCollectionView?.register(UINib(nibName: "ZDAttachmentCollectionCell", bundle: ZDUtility.getBundle()), forCellWithReuseIdentifier: "ZDAttachmentCollectionCell")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (dataModel?.getAttchments()?.count).toInt()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ZDAttachmentCollectionCell", for: indexPath) as! ZDAttachmentCollectionCell
        cell.attachementModel = getAttachement(index: indexPath.row)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        self.layoutIfNeeded()
        let fullWidth = (self.cellContainerView!.bounds.width - 20) - 20
        return  CGSize(width: fullWidth/2, height:attachmentCellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        getAttachement(index: indexPath.row)?.showAttachment()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left:5, bottom:5, right: 5)
    }
}
// MARK: - Helper methods
extension ZDConversationCell{
    func getAttachement(index:Int) -> ZDAttachment?{
        var attachements = dataModel?.getAttchments()
        if attachements != nil && attachements!.count > index{
            return attachements![index]
        }
        return nil
    }
}
class ZDAttachmentCollectionCell: UICollectionViewCell {
    
    var attachementModel:ZDAttachment? {
        didSet{
            updateData()
        }
    }
    
    @IBOutlet weak var containerView:UIView?
    @IBOutlet weak var iconImage:UIImageView?
    @IBOutlet weak var nameLabel:UILabel?
    @IBOutlet weak var imagePreview:UIImageView?

    override func awakeFromNib() {
        containerView?.layer.masksToBounds = true
        containerView?.layer.cornerRadius = 5
        containerView?.layer.borderWidth = 1
        containerView?.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        
        nameLabel?.font = UIFont.getProximaNovaBold(size: 16)
    }
    
    
    func updateData(){
        guard let modelObject = attachementModel else{return}
        nameLabel?.text = modelObject.name
        
        iconImage?.image = UIImage(named: ZDUtility.getFileIcon(fileName: modelObject.name), in: ZDUtility.getBundle()!, compatibleWith: nil)
        
        if let fileData = modelObject.getDataFromLocalURL(){
            previewData(downloadeddata: fileData)
            return
        }
        
        if  modelObject.data == nil{
            modelObject.downloadAttachement(onCompliton: { [weak self] (data, error, status) in
                guard let selfObject = self , let imageData = data else{return}
                modelObject.data = imageData
                DispatchQueue.main.async {
                    selfObject.previewData(downloadeddata: imageData)
                }
            })
        }
        else{
            previewData(downloadeddata: modelObject.data!)
        }
    }
    
    func previewData(downloadeddata:Data){
        
        if let image =  UIImage(data: downloadeddata){
            imagePreview?.image = image
            nameLabel?.isHidden = true
            iconImage?.isHidden = true
        }
        else{
            nameLabel?.isHidden = false
            iconImage?.isHidden = false
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        attachementModel = nil
    }

}

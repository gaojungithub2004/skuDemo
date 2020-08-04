//
//  UILable_extension.swift
//  xiachufang
//
//  Created by ford Gao on 2019/5/21.
//  Copyright © 2019 ford Gao. All rights reserved.
//

import UIKit

// MARK: - 圆角 边框
extension UIView {
    
    func setCornerRadius(radius: CGFloat){
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
    
    func setBorderStyle(width: CGFloat, color: UIColor){
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
    }
}

enum LabelAutoSize {
    case width
    case height
}

extension UILabel {
    
    func atuoLableRectWidth(rect: CGSize, fontSize: Int, type: LabelAutoSize = .width) -> CGRect{
        if let text = self.text{
            var size = rect
            if(type == .width){
                size.width = 0
            }else{
                size.height = 0
            }
            let tmpRect = (text as NSString).boundingRect(with: size, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: CGFloat(fontSize))], context: nil)
            return tmpRect
        }
        return CGRect.zero
    }
    
    static func atuoLableRectWidthWidthText(_ text: String,rect: CGSize, fontSize: Int, type: LabelAutoSize = .width) -> CGRect{
        var size = rect
        if(type == .width){
            size.width = 0
        }else{
            size.height = 0
        }
        let tmpRect = (text as NSString).boundingRect(with: size, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: CGFloat(fontSize))], context: nil)
        return tmpRect
    }
}

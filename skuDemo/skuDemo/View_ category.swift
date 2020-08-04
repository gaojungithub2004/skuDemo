//
//  View_ category.swift
//  skuDemo
//
//  Created by ford Gao on 2020/7/31.
//  Copyright © 2020 ford Gao. All rights reserved.
//

import UIKit

let ScreenWidth = UIScreen.main.bounds.size.width
let ScreenHeight = UIScreen.main.bounds.height

/*
    获取状态栏高度
 */
func getStatusBarHight() -> CGFloat {
    var statusBarHeight: CGFloat = 0
    
    if #available(iOS 13.0, *) {
        if let statusBarManager = UIApplication.shared.windows.first?.windowScene?.statusBarManager{
            statusBarHeight = statusBarManager.statusBarFrame.size.height
        }
    }else {
        statusBarHeight = UIApplication.shared.statusBarFrame.size.height;
    }
    return statusBarHeight
}

extension UIView{
    
    var x:CGFloat{
        get{
            return frame.origin.x
        }
        set(newVal){
            var temF :CGRect = frame
            temF.origin.x = newVal
            frame = temF
        }
    }
    
    var left: CGFloat {
        get{
            return x
        }
    }
    
    var y:CGFloat{
        get{
            return frame.origin.y
        }
        set(newVal){
            var temF :CGRect = frame
            temF.origin.y = newVal
            frame = temF
        }
    }
    
    var top: CGFloat {
        get {
            return y
        }
    }
    
    var size:CGSize{
        get{
            return self.frame.size
        }
        set(newVal){
            var temF :CGRect = frame
            temF.size = newVal
            frame = temF
        }
    }
    
    var width:CGFloat{
        get{
            return self.bounds.width
        }
        set(newVal){
            var temF :CGRect = frame
            temF.size.width = newVal
            frame = temF
        }
    }
    
    var right: CGFloat {
        get {
            return x + width
        }
    }
    
    var height:CGFloat{
        get{
            return self.bounds.height
        }
        set(newVal){
            var temF :CGRect = frame
            temF.size.height = newVal
            frame = temF
        }
    }
    
    var bottom: CGFloat {
        get {
            return y + height
        }
    }
    
}

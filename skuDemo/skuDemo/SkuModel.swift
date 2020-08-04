//
//  SkuModel.swift
//  skuDemo
//
//  Created by ford Gao on 2020/7/31.
//  Copyright © 2020 ford Gao. All rights reserved.
//

import UIKit
import HandyJSON

class SkuModel: HandyJSON{
    var specList: Array<SkuTopModel>?
    var specCombinationList: Array<SkuCondition>?
    var skuTopDict = NSMutableDictionary() //转换过后的顶点数据
    var skuConditionList = Array<Array<Int>>() //转换过后的条件数组
    
//    func mapping(mapper: HelpingMapper) {
//
//        mapper <<<
//        self.skuTopModelList <-- "specList"
//
//        mapper <<<
//        self.skuConditionList <-- "specCombinationList"
//    }
    
    required init() {
        
    }
}

class SkuTopModel: HandyJSON {
    var title: String? //顶点类别
    var list: Array<String>? //顶点数组
    required init(){}
}


//条件
class SkuCondition: HandyJSON {
    var id: String?
    var specs: Array<String>?
    var count: Int?
    
    required init(){}
}

class Condition {
    var x = 0
    required init(x: Int){
        self.x = x
    }
}

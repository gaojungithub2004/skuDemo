//
//  JsonUtils.swift
//  DiffableDataSource
//
//  Created by ford Gao on 2020/6/17.
//  Copyright © 2020 ford Gao. All rights reserved.
//

import UIKit

class JsonUtils: NSObject {

    // 读取本地JSON文件
    static func redJson(name: String) ->  Dictionary<String, Any>{
        let path = Bundle.main.path(forResource: name, ofType: "json")
        let url = URL(fileURLWithPath: path!)
        // 带throws的方法需要抛异常
        do {
                  /*
                     * try 和 try! 的区别
                     * try 发生异常会跳到catch代码中
                     * try! 发生异常程序会直接crash
                     */
                let data = try Data(contentsOf: url)
                let jsonData:Any = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)
            let jsonArr = jsonData as! Dictionary<String, Any>
                
            return jsonArr
        } catch let error as Error? {
            print("读取本地数据出现错误!",error ?? "")
            return Dictionary()
        }
    }

}

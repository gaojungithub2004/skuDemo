//
//  ViewController.swift
//  skuDemo
//
//  Created by ford Gao on 2020/7/31.
//  Copyright © 2020 ford Gao. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIGestureRecognizerDelegate {
    
    lazy var tableView: UITableView = {
        let table = UITableView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight), style: .plain)
        table.register(SkuCell.self, forCellReuseIdentifier: SkuCell.identifier)
        table.backgroundColor = UIColor.purple
        table.separatorStyle = .none
        return table;
    }()
    
    var skuCellHeight: CGFloat = 44
    
    var model: SkuModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        
        loadData()
    }
    


    
    func loadData(){
        let sku = JsonUtils.redJson(name: "sku")
        
        if let skuModel = SkuModel.deserialize(from: sku){
            //解析数据成功， 初始化顶点坐标， 和对应的可选条件顶点的坐标的x 数组
            if let specList = skuModel.specList {
                for(index, spec) in specList.enumerated(){
                    if let list = spec.list {
                        for(i, model) in list.enumerated(){
                            let point = CGPoint(x: i, y: index)
                            skuModel.skuTopDict.setValue(point, forKey: model)
                        }
                    }
                }
            }
            
            //去point.x 匹配条件数组
            if let specCombinationList = skuModel.specCombinationList {
                for(_, obj) in specCombinationList.enumerated() {
                    var tmpArr = [Int]()
                    if let specs = obj.specs {
                        for(_, model) in specs.enumerated(){
                            if(skuModel.skuTopDict[model] != nil){
                                let point: CGPoint = skuModel.skuTopDict[model] as! CGPoint
                                tmpArr.append(Int(point.x))
                            }
                        }
                    }
                    skuModel.skuConditionList.append(tmpArr)
                }
            }
            
            model = skuModel
            tableView.reloadData()
        }
    }
    
    
    
    

}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCell(withIdentifier: SkuCell.identifier, for: indexPath) as? SkuCell
        cell?.model = model
        cell?.heightConfrim = {[unowned self] height in
            self.skuCellHeight = height
            self.tableView.reloadRows(at: [indexPath], with: .none)
        }
        return cell!
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return skuCellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}


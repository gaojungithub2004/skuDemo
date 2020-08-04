//
//  SkuCell.swift
//  skuDemo
//
//  Created by ford Gao on 2020/7/31.
//  Copyright © 2020 ford Gao. All rights reserved.
//

import UIKit

typealias HeightConfirmBlock = (CGFloat)->(Void)

extension CGPoint: Hashable {
    
    public func hash(into hasher: inout Hasher){
        hasher.combine(self.x)
        hasher.combine(self.y)
    }
}

class SkuCell: UITableViewCell {
    
    static let identifier: String = "SkuCellIdentifier"
    var collection: UICollectionView?
    var heightConfrim: HeightConfirmBlock?
    var set: Set<String> = []
    var alreadys: Set<CGPoint> = []
    
    var model: SkuModel?{
        didSet{
            collection?.reloadData()
            
            DispatchQueue.main.async {
                print(self.collection!.collectionViewLayout.collectionViewContentSize.height, self.collection!.height)
                if(self.collection!.height != self.collection!.collectionViewLayout.collectionViewContentSize.height){
                    self.collection!.frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: self.collection!.collectionViewLayout.collectionViewContentSize.height)
                    if let callBack = self.heightConfrim {
                        callBack(self.collection!.collectionViewLayout.collectionViewContentSize.height)
                    }
                }
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 80, height: 40)
        layout.scrollDirection = .vertical
        collection = UICollectionView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: 100), collectionViewLayout: layout)
        collection?.register(SkuCollectionCell.self, forCellWithReuseIdentifier: SkuCollectionCell.identifier)
        collection?.register(SkuHeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SkuHeaderCell.identifier)
        collection?.backgroundColor = .white
        
//        self.collection?.addObserver(self, forKeyPath: #keyPath(UICollectionView.collectionViewLayout.collectionViewContentSize), options: [.new], context: nil)
//        self.collection?.observe(\UICollectionView.collectionViewLayout.collectionViewContentSize, changeHandler: {[unowned self] (collection, newValue) in
//            if(collection.superview == nil){
//
//            }
//
//        })
        collection?.dataSource = self
        collection?.delegate = self
        self.addSubview(collection!)
//        print(itemSize(title: "8888888888", height: 40).width)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func tapView(){
        
    }
    
//    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
//        if keyPath == #keyPath(UICollectionView.contentOffset) {
//            if let co = self.collection {
//                print(co.collectionViewLayout.collectionViewContentSize.height)
//            }
//        }
//    }
    
    deinit {
//        self.collection?.removeObserver(self, forKeyPath: #keyPath(UICollectionView.contentSize))
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
//        print(object_getClass(view))
         if let bool = (view?.isKind(of: UICollectionView.self)) {
                   if bool {
                       return self
                   }
               }
        return view
    }
    
}

extension SkuCell: UICollectionViewDelegateFlowLayout {
    
    func itemSize(title: String, height: CGFloat) ->CGSize{
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: height))
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = title
        label.textAlignment = .center
        label.sizeToFit()
        return CGSize(width: label.bounds.size.width + 10, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5)
    }
    //设定指定区内Cell的最小间距，也可以直接设置UICollectionViewFlowLayout的minimumInteritemSpacing属性
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat{
        return 10
    }
    //设定指定区内Cell的最小行距，也可以直接设置UICollectionViewFlowLayout的minimumLineSpacing属性
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    //设定指定Cell的尺寸
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let tmpModel = model?.specList?[indexPath.section]{
            if let title = tmpModel.list?[indexPath.item] {
                let size = itemSize(title: title, height: 40)
                if(size.width < 80){
                    return CGSize(width: 80, height: 40)
                }else{
                    return size
                }
            }
        }
        return CGSize(width: 80, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //获取顶点
        let title = model!.specList![indexPath.section].list![indexPath.item]
        let point = model!.skuTopDict[title] as! CGPoint
        // 选中的顶点不在可选顶点中，不可选
        if(!set.isEmpty && !set.contains(title)){
            //不可选
            return
        }
        //判断是否有相同类目的顶点
        if(hasSameTop(point)){
            //有相同类目的顶点
            deleteSameTop(point)
        }else{
            // 没有相同类目的顶点直接加入集合
            alreadys.insert(point)
        }
        
        //迭代所有的条件， 同时满足alreadys里面的顶点的交集
        set.removeAll()
        for (index, arr) in model!.skuConditionList.enumerated() {
            var b = true
            var tmpSet:Set<String> = []
            for already in alreadys {
                if arr[Int(already.y)] != Int(already.x){
                    b = false
                }
            }
            if(b){
                
                tmpSet = Set<String>(model!.specCombinationList![index].specs!)
                set = set.union(tmpSet)
            }
        }
        
        if(alreadys.count == 1){
            let point =  alreadys.first!
            for e in model!.specList![Int(point.y)].list!{
                set.insert(e)
            }
        }
        collection?.reloadData()
        if(alreadys.count == model!.skuConditionList.count){
            //选择完成
            for (index, arr) in model!.skuConditionList.enumerated() {
                var flag = true
                for already in alreadys {
                    if arr[Int(already.y)] != Int(already.x) {
                        flag = false
                    }
                }
                if flag {
                    let count = model!.specCombinationList![index].count
                    let id = model!.specCombinationList![index].id
                    print("选择完成： id:\(id)  剩余数量: + \(count)")
                }
            }
        }
    }
    
    //是否是同一个类目的顶点
    func hasSameTop(_ point: CGPoint) -> Bool{
        var flag = false
        for obj in alreadys {
            if point.y == obj.y{
                flag = true
            }
        }
        return flag
    }
    
    //处理相同顶点
    func deleteSameTop(_ point: CGPoint){
        if alreadys.contains(point){
            //选择的同一个顶点
            alreadys.remove(point)
        }else{
            //选择同一个类目不同的顶点， 先清空集合内同一个类目的顶点， 在加入选中的顶点
            for  (_, already) in  alreadys.enumerated() {
                if(already.y == point.y){
                    alreadys.remove(already)
                }
            }
            alreadys.insert(point)
        }
    }
    
}

extension SkuCell: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return model?.specList?.count ?? 0
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let tmpModel = model?.specList?[section]{
            if let list = tmpModel.list {
                return list.count
            }
        }
    
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: SkuCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: SkuCollectionCell.identifier, for: indexPath) as! SkuCollectionCell
        if let tmpModel = model {
            if let topModel = tmpModel.specList?[indexPath.section]{
                if let list = topModel.list {
                    cell.setName(title: list[indexPath.item])
                    if(alreadys.contains(model!.skuTopDict[list[indexPath.item]] as! CGPoint)){
                        cell.setStatus(status: .selected)
                    }else{
                        if(set.isEmpty || set.contains(list[indexPath.item])){
                            cell.setStatus(status: .normal)
                        }else{
                            cell.setStatus(status: .disable)
                        }
                    }
                }
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header: SkuHeaderCell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SkuHeaderCell.identifier, for: indexPath) as! SkuHeaderCell
        
        if let tmpModel = model {
            if let topModel = tmpModel.specList?[indexPath.section]{
                if let title = topModel.title {
                    header.label?.text = title
                }
            }
        }
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: ScreenWidth, height: 30)
    }
}

class SkuHeaderCell: UICollectionReusableView {
    
    static let identifier = "SkuHeaderCell"
    var label: UILabel?
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        label = UILabel(frame: CGRect(x: 10, y: 0, width: frame.width - 15, height: frame.height))
        label?.textColor = .black
        label?.font = UIFont.systemFont(ofSize: 13)
        addSubview(label!)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

enum SkuCellStatus {
    case normal
    case disable
    case selected
}


class SkuCollectionCell: UICollectionViewCell {
    
    static let identifier = "SkuCollectionCell"
    
    var name: UILabel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        name = UILabel(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        name?.numberOfLines = 0
        name?.font = UIFont.systemFont(ofSize: 14)
        name?.textColor = .black
        name?.textAlignment = .center
        contentView.addSubview(name!)
        setStatus(status: .normal)
    }
    
    func setStatus(status: SkuCellStatus){
        switch status {
        case .disable:
            name?.textColor = .gray
            name?.setBorderStyle(width: 1, color: .gray)
        case .selected:
            name?.textColor = .red
            name?.setBorderStyle(width: 1, color: .red)
        default:
            name?.textColor = .black
            name?.setBorderStyle(width: 1, color: .black)
        }
    }
    
    func setName(title: String){
        self.name?.text = title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
         if let bool = (view?.isKind(of: UICollectionView.self)) {
                   if bool {
                       return self
                   }
               }
        return view
    }
}


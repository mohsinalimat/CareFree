//
//  CFMineController.swift
//  CareFree
//
//  Created by 张驰 on 2019/7/25.
//  Copyright © 2019 张驰. All rights reserved.
//

import UIKit
import CollectionKit
import SnapKit
import SwiftyJSON
import HandyJSON

class CFMineController: CFBaseViewController {

    var emotionLayer: CAGradientLayer!
    
    fileprivate let dataSource = ArrayDataSource(data:[MineModel]())
    fileprivate lazy var collectionView = CollectionView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        congfigUI()
        configCV()
        configData()
    }
    

    func congfigUI() {
        self.Title.text = "我的"
        
        view.addSubview(collectionView)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        //collectionView.isScrollEnabled = false
        collectionView.alwaysBounceVertical = false
        collectionView.snp.makeConstraints{(make) in
            make.bottom.right.left.equalTo(view)
            make.top.equalTo(navigation.bar.snp.bottom).offset(0)
        }

    }
    
    var impliesAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
    public var duration = 0.3
    
    func configCV(){
        let viewSource = ClosureViewSource(viewUpdater: {(view:MineCell,data:MineModel,index:Int) in
            view.updateUI(with:data)
            
            DispatchQueue.main.async {
                let  emotionLayer = CAGradientLayer()
                emotionLayer.frame = view.emotionView.bounds
                emotionLayer.colors = [UIColor.init(r: 100, g: 176, b: 232).cgColor,UIColor.init(r: 83, g: 121, b: 255).cgColor]
                emotionLayer.cornerRadius = 25
                view.oneBackView.layer.addSublayer(emotionLayer)
            }
            
            let setTap = UITapGestureRecognizer(target: self, action: #selector(self.setEvent))
            let trashTap = UITapGestureRecognizer(target: self, action: #selector(self.trashEvent))
            let diaryChartTap = UITapGestureRecognizer(target: self, action: #selector(self.diaryChartEvnent))
            view.setView.addGestureRecognizer(setTap)
            view.trashView.addGestureRecognizer(trashTap)
            view.moodView.addGestureRecognizer(diaryChartTap)
            
            view.setView.layer.add(self.impliesAnimation, forKey: nil)
            
            
        })
        let sizeSource = {(index:Int,data:MineModel,collectionSize:CGSize) ->CGSize in
            return CGSize(width: collectionSize.width, height: 820)
        }
        
        let provider = BasicProvider(
            dataSource: dataSource,
            viewSource: viewSource,
            sizeSource:sizeSource
        )
        collectionView.provider = provider
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

}

extension CFMineController{
    
    @objc func trashEvent(){
        print("废纸篓页面跳转中...")
        let trashVC = TrashViewController()
        self.navigationController?.pushViewController(trashVC, animated: true)
    }
    
    @objc func setEvent(){
        
        impliesAnimation.values = [1.0 ,1.4, 0.9, 1.15, 0.95, 1.02, 1.0]
        impliesAnimation.duration = self.duration * 2
        impliesAnimation.calculationMode = CAAnimationCalculationMode.cubic
        print("设置页面跳转中...")
        let setVC = SetViewController()
        self.navigationController?.pushViewController(setVC, animated: true)
    }
    @objc func diaryChartEvnent(){
        print("心情报表页面跳转中...")
    }
    @objc func back(){
        
    }
    
}

// 请求数据

extension CFMineController {
    func configData(){
        //1 获取json文件路径
        let path = Bundle.main.path(forResource: "mine", ofType: "json")
        //2 获取json文件里面的内容,NSData格式
        let jsonData=NSData(contentsOfFile: path!)
        //3 解析json内容
        let json = JSON(jsonData!)
        if let mappedObject = JSONDeserializer<MineModel>.deserializeFrom(json: json["data"].description) {
            print("数据解析成功")
            dataSource.data.append(mappedObject)
            self.collectionView.reloadData()
        }
        

    }
}
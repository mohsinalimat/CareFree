//
//  CFDiaryViewController.swift
//  CareFree
//
//  Created by 张驰 on 2019/6/6.
//  Copyright © 2019 张驰. All rights reserved.
//

import UIKit
import SnapKit
import CollectionKit


class CFDiaryViewController: UIViewController {


    
    fileprivate let dataBodySource = ArrayDataSource(data:[diaryModel]())
    fileprivate let dataHeadSource = ArrayDataSource(data:[diaryModel]())
    
    fileprivate lazy var collectionView = CollectionView()
    
    fileprivate lazy var Title:UILabel = {
        let label = UILabel()
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configCV()
        configUI()
        configNavBar()
        configData()
    }
    
    func configNavBar(){
        
        self.navigation.bar.isShadowHidden = true
        self.navigation.bar.alpha = 0
        Title.frame = CGRect(x: 22.fitWidth_CGFloat, y: 50.fitHeight_CGFloat, width: 100.fitWidth_CGFloat, height: 40.fitHeight_CGFloat)
        Title.text = "日记"
        Title.font = UIFont(name: "PingFangSC-Semibold", size: 26)
        view.addSubview(Title)
        
    }

}

extension CFDiaryViewController{
    
    
    fileprivate func configData(){
        var model = diaryModel()
        model.content = "今天考试，准备了很久，希望能够得到好成绩"
        model.day = "24"
        model.value = 31
        model.week = "周五"
        model.yearMouth = "2019年5月"
        for _ in 1...6 {
            self.dataBodySource.data.append(model)
        }
        self.dataHeadSource.data.append(model)

        self.collectionView.reloadData()
    }
    
    func configUI(){
        //        tableView.delegate = self
        //        tableView.dataSource = self
        //        tableView = UITableView(frame: CGRect(x: 0, y: 88.fitHeight_CGFloat, width: 414.fitWidth_CGFloat, height: 725.fitHeight_CGFloat))
        //        tableView.separatorStyle = .none
        view.backgroundColor = UIColor.init(r: 248, g: 249, b: 254)
        
        view.addSubview(collectionView)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        //collectionView.isScrollEnabled = false
        collectionView.alwaysBounceVertical = false
        collectionView.snp.makeConstraints{(make) in
            make.bottom.right.left.equalTo(view)
            make.top.equalTo(navigation.bar.snp.bottom).offset(0)        }
    }
    
    fileprivate func configCV(){
        let viewBodySource = ClosureViewSource(viewUpdater: {(view:diaryCell,data:diaryModel,index:Int) in
            view.updateUI(with: data)
        })
        let sizeBodySource = {(index:Int,data:diaryModel,collectionSize:CGSize) -> CGSize in
            return CGSize(width: collectionSize.width, height: 170)
        }
        let providerBody = BasicProvider(
            dataSource: dataBodySource,
            viewSource: viewBodySource,
            sizeSource: sizeBodySource
        )
        
        let viewHeadSource = ClosureViewSource(viewUpdater: {(view:diaryWriteCell,data:diaryModel,index:Int) in

            
            DispatchQueue.main.async {
                view.writeBtn.addTarget(self, action: #selector(self.write), for: .touchUpInside)
                view.jump = {
                    let writeVC = diaryWriteController()
                    let emotionLayer = CAGradientLayer()
                    emotionLayer.frame = writeVC.view.bounds
                    switch $0 {
                    case 0:
                    emotionLayer.colors = [UIColor.init(r: 56, g: 213, b: 214).cgColor,UIColor.init(r: 63, g: 171, b: 213).cgColor]
                    case 1:
                    emotionLayer.colors = [UIColor.init(r: 118, g: 175, b: 227).cgColor,UIColor.init(r: 91, g: 123, b: 218).cgColor]
                    case 2:
                    emotionLayer.colors = [UIColor.init(r: 151, g: 136, b: 248).cgColor,UIColor.init(r: 160, g: 115, b: 218).cgColor]
                    case 3:
                    emotionLayer.colors = [UIColor.init(r: 43, g: 88, b: 118).cgColor,UIColor.init(r: 9, g: 32, b: 63).cgColor]
                    default: break
                    }
                    writeVC.emotionLayer = emotionLayer
                    self.present(writeVC, animated: true, completion: nil)
                }
            }

            view.updateUI(with: data)
        })
        let sizeHeadSource = {(index:Int,data:diaryModel,collectionSize:CGSize) -> CGSize in
            return CGSize(width: collectionSize.width, height: 170)
        }
        let providerHead = BasicProvider(
            dataSource: dataHeadSource,
            viewSource: viewHeadSource,
            sizeSource: sizeHeadSource
        )
        
        let finalProvider = ComposedProvider(sections:[providerHead,providerBody])
        
        providerBody.layout = FlowLayout(spacing: 30)
        providerHead.layout = FlowLayout(spacing: 30)
        finalProvider.layout = FlowLayout(spacing: 30)
        collectionView.provider = finalProvider
        collectionView.contentInset = UIEdgeInsets(top: 20, left: 20, bottom: 0, right: 20)
        
        providerBody.tapHandler = { context -> Void in
            let showDiaryVC = showDiaryController()
            
            let emotionLayer = CAGradientLayer()
            emotionLayer.colors = [UIColor.init(r: 155, g: 121, b: 255).cgColor,UIColor.init(r: 96, g: 114, b: 255).cgColor]
            showDiaryVC.emotionLayer = emotionLayer
            self.navigationController?.pushViewController(showDiaryVC, animated: true)
        }
        
        
    }
    
    @objc func write(){
        print("跳转写日记界面...")
        
        let writeVC = diaryWriteController()
        let emotionLayer = CAGradientLayer()
        emotionLayer.frame = writeVC.view.bounds
        emotionLayer.colors = [UIColor.white.cgColor,UIColor.white.cgColor]
        emotionLayer.cornerRadius = 30
        let topColor = UIColor.black
        let writeColor = UIColor.init(r: 127, g: 127, b: 127)
        writeVC.topColor = topColor
        writeVC.writeColor = writeColor
        writeVC.emotionLayer = emotionLayer

        self.present(writeVC, animated: true, completion: nil)
        //self.navigationController?.pushViewController(writeVC, animated: true)
        
    }
}

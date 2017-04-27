//
//  VolListViewController.swift
//  PlanDemo
//
//  Created by 王洋洋 on 2017/3/16.
//  Copyright © 2017年 wyy. All rights reserved.
//

import UIKit

class VolListViewController: UIViewController {

    var headImageV: UIImageView!
    var tableV: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "復元", style: .plain, target: self, action: #selector(restoreBarAction))
        
        initHeadImageV()
        initTableView()

    }
    
    func initHeadImageV() {
        
        headImageV = UIImageView(frame: CGRect(x: 0, y: 64, width: self.view.frame.width, height: 80))
        headImageV.image = UIImage(named: "headImage")
        view.addSubview(headImageV)
        
    }
    
    func initTableView() {
        
        tableV = UITableView(frame: CGRect(x: 0, y: 64 + headImageV.frame.size.height, width: self.view.frame.width, height: self.view.frame.height - 64 - headImageV.frame.size.height))
        tableV.backgroundColor = UIColor.white
        tableV.cellLayoutMarginsFollowReadableWidth = false
        tableV.delegate = self
        tableV.dataSource = self
        tableV.register(UINib(nibName: "VolListTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        view.addSubview(tableV)
        
    }
    
    //復元button
    func restoreBarAction() {
        
        print("restoreBarAction")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

}

extension VolListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 15
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tableV.dequeueReusableCell(withIdentifier: "cell") as! VolListTableViewCell
        
        cell.selectionStyle = .none
        
        cell.titleLbl.text = "Vol.\(indexPath.row)"
        cell.subTitleLbl.text = "this is text data. this is text data."
        
        cell.downloadBtn.addTarget(self, action: #selector(downloadAction(sender:)), for: .touchUpInside)
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let videoVC = BoardViewController()
        videoVC.title = "Vol.\(indexPath.row)"
        self.navigationController?.pushViewController(videoVC, animated: true)
        
    }
    
    func downloadAction(sender: UIButton) {
        
        print("downloadAction")
        
    }
    
}

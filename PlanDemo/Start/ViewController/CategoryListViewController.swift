//
//  CategoryListViewController.swift
//  PlanDemo
//
//  Created by 王洋洋 on 2017/3/16.
//  Copyright © 2017年 wyy. All rights reserved.
//

import UIKit

class CategoryListViewController: UIViewController {

    var tableV: UITableView!
    let titleArr: [String] = ["お知らせ", "ビデオ", "相談室", "セミナー"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "CATEGORY LIST"
        view.backgroundColor = UIColor.white

        initTableView()

    }
    
    func initTableView() {
        
        tableV = UITableView(frame: self.view.frame)
        tableV.backgroundColor = UIColor.white
        tableV.cellLayoutMarginsFollowReadableWidth = false
        tableV.delegate = self
        tableV.dataSource = self
        tableV.register(UINib(nibName: "CategoryListTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        view.addSubview(tableV)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

}

extension CategoryListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tableV.dequeueReusableCell(withIdentifier: "cell") as! CategoryListTableViewCell
        
        cell.selectionStyle = .none
        
        switch indexPath.row {
        case 0:
            cell.newLbl.isHidden = true
        case 1:
            cell.newLbl.isHidden = true
        case 3:
            cell.newLbl.isHidden = true
        default:
            break
        }
        
        cell.titleLbl.text = titleArr[indexPath.row]
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let volListVC = VolListViewController()
        volListVC.title = titleArr[indexPath.row]
        self.navigationController?.pushViewController(volListVC, animated: true)
        
    }
    
}

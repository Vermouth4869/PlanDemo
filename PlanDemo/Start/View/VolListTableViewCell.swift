//
//  VolListTableViewCell.swift
//  PlanDemo
//
//  Created by 王洋洋 on 2017/3/16.
//  Copyright © 2017年 wyy. All rights reserved.
//

import UIKit

class VolListTableViewCell: UITableViewCell {

    @IBOutlet weak var imageV: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var subTitleLbl: UILabel!
    @IBOutlet weak var downloadBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLbl.font = UIFont(name: "Helvetica-Bold", size: 22)        
        
        imageV.image = UIImage(named: "bgBlue")
        
        downloadBtn.setBackgroundImage(UIImage(named: "arrow"), for: .normal)
        downloadBtn.layer.masksToBounds = true
        downloadBtn.layer.cornerRadius = 24

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}

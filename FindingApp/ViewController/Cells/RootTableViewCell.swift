//
//  RootTableViewCell.swift
//  FindingApp
//
//  Created by Leandro Oliveira on 2019-01-20.
//  Copyright © 2019 OliveiraCode Technologies. All rights reserved.
//

import UIKit
import Cosmos

class RootTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imgBusiness: UIImageView!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbPrice: UILabel!
    @IBOutlet weak var lbDistance: UILabel!
    @IBOutlet weak var vRating: CosmosView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        initUI()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    private func initUI() {

        //image corner with some radius
        imgBusiness.layer.cornerRadius =  10
        imgBusiness.clipsToBounds = true
    }
    
}

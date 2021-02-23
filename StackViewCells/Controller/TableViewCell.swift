//
//  TableViewCell.swift
//  StackViewCells
//
//  Created by Benjamin Inemugha on 19/02/2021.
//  Copyright © 2021 Techelope. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {


    @IBOutlet weak var itemStack: UIStackView!
    @IBOutlet weak var tableViewLbl: UILabel!
    //@IBOutlet weak var itemStatus: UILabel!
    
    var data = ["Daddy", "Mummy", "Olans", "Tare", "Bomane", "Daniel", "Me"]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        SetupDisplay()
    }

    
    
    func SetupDisplay(){
        //itemStack.removeAllSubviews()
        for item in data{
            let itemView: OrderItems = Bundle.main.loadNibNamed("OrderItems", owner: self, options: nil)?.first as! OrderItems
            itemView.heightAnchor.constraint(greaterThanOrEqualToConstant: 64.0).isActive = true
            itemView.widthAnchor.constraint(lessThanOrEqualToConstant: itemStack.bounds.width).isActive = true
           
            
            
            itemView.firstTxt.text = item
            itemView.secondTxt.text = "Quantity: 90kg"
            
            
            itemView.pricetxt.text = "1000"
            
            itemView.mainTxt.text = "My Drugs"
            itemStack.addArrangedSubview(itemView)
        }

    }
    
}

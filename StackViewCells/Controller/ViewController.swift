//
//  ViewController.swift
//  StackViewCells
//
//  Created by Benjamin Inemugha on 18/02/2021.
//  Copyright © 2021 Techelope. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var data = ["Daddy", "Mummy", "Ben"]

    @IBOutlet weak var itemStack: UIStackView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        SetupDisplay()
    }
    
    func SetupDisplay(){
        //itemStack.removeAllSubviews()
        for item in data{
            let itemView: OrderItems = Bundle.main.loadNibNamed("OrderItems", owner: self, options: nil)?.first as! OrderItems
            itemView.heightAnchor.constraint(greaterThanOrEqualToConstant: 64.0).isActive = true
            itemView.widthAnchor.constraint(lessThanOrEqualToConstant: itemStack.bounds.width).isActive = true
           
            
            
            itemView.firstTxt.text = "Ben's drugs"
            itemView.secondTxt.text = "Quantity: 90kg"
            
            
            itemView.pricetxt.text = "1000"
            
            itemView.mainTxt.text = "My Drugs"
            itemStack.addArrangedSubview(itemView)
        }

    }
}

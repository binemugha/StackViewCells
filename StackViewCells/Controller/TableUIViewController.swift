//
//  TableUIVieiwController.swift
//  StackViewCells
//
//  Created by Benjamin Inemugha on 19/02/2021.
//  Copyright © 2021 Techelope. All rights reserved.
//

import UIKit

class TableUIViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    @IBOutlet weak var tableView: UITableView!
    //Change the table view data to match either of data, name or bigdata
    var data = ["Drugs", "Money"]
    var name = [["Paracetamol", "Dollars","Queens", ["Boys", "Men", "Children"]], ["Paracetamol1", "Dollars1","Queens1", ["Boys1", "Men1", "Children1"]], ["Paracetamol", "Dollars","Queens", ["Boys", "Men", "Children"]]]
    var bigdata = [(id: 1, name: "Emzor Pharmaceutical", email: "info@emzorpharma.com", phone: "+2347080606000", address: "Plot 3C, Block A, Aswani Market", city: "Isolo", state: "Lagos", country: "NG", longitude: "3.321724", latitude: "6.529160", pharmacy_items: [(id: 323, order: 204, product_name: "Paramax", product: 3, price: "500.0000", quantity: 1, fulfillment_status: "awaiting_pickup", get_fulfillment_status_display: "Awaiting Pickup", strength: "500", strength_measurement_unit: "mg", dosage_route: "oral/caplet")])]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "TableViewCell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //Uncomment the array you want to use
        
        //return data.count
        //return name.count
        //print(bigdata[0].pharmacy_items.count)
        return bigdata.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as? TableViewCell {
//            print("\(#function) --- section = \(indexPath.section), row = \(indexPath.row)")
            
            
            //Uncomment the arrays you want to use
            
            //cell.tableViewLbl.text = data[indexPath.row]
            //cell.tableViewLbl.text = name[indexPath.row][1] as? String
            cell.tableViewLbl.text = bigdata[indexPath.section].name
            //cell.itemStatus.text = bigdata[indexPath.section].pharmacy_items[indexPath.section].fulfillment_status
            return cell
        }
        return UITableViewCell()
    }
    
    
}

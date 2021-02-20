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
    
    var data = ["Drugs", "Money"]
    var name = [["Paracetamol", "Dollars","Queens", ["Boys", "Men", "Children"]], ["Paracetamol1", "Dollars1","Queens1", ["Boys1", "Men1", "Children1"]]]
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "TableViewCell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return name.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as? TableViewCell {
            print("\(#function) --- section = \(indexPath.section), row = \(indexPath.row)")
            cell.tableViewLbl.text = name[indexPath.row][2] as? String
            return cell
        }
        return UITableViewCell()
    }
    
    
}

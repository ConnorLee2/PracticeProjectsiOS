//
//  DetailViewController.swift
//  Project15.5
//
//  Created by Connor Lee on 14/07/2020.
//  Copyright © 2020 Connor Lee. All rights reserved.
//

import UIKit

class DetailViewController: UITableViewController {
    var facts = [String]()
    var detailItem: Country?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let detailItem = detailItem else { return }
        
        title = detailItem.country
        
        facts.append(detailItem.country)
        facts.append(detailItem.currency)
        facts.append(detailItem.language)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return facts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Detail", for: indexPath)
        cell.textLabel?.text = facts[indexPath.row]
        return cell
    }
    
}

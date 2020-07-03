//
//  ViewController.swift
//  Project7Json
//
//  Created by Connor Lee on 03/07/2020.
//  Copyright © 2020 Connor Lee. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    var petitions = [Petition]()
    var fullPetitionList = [Petition]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let urlString: String
            
        if navigationController?.tabBarItem.tag == 0 {
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else {
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
            //urlString = "https://api.whitehouse.gov/v1/petitions.json?signatureCountFloor=10000&limit=100"
        }
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(filterPetitions))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Credits", style: .plain, target: self, action: #selector(showCredits))
        
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                // ok to parse
                parse(json: data)
                return
            }
        }
        
        showError()
    }
    
    @objc func filterPetitions() {
        let ac = UIAlertController(title: "Filter", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) {
            [weak self, weak ac] action in
            guard let input = ac?.textFields?[0].text else { return }
            self?.filter(input)
        }
        
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    func filter(_ input: String) {
        let inputLower = input.lowercased()
        
        var filteredPetitions = [Petition]()
        
        for petition in fullPetitionList {
            if petition.title.lowercased().contains(inputLower) {
                filteredPetitions.append(petition)
            }
        }
        
        if filteredPetitions.isEmpty {
            petitions = fullPetitionList
        } else {
            petitions = filteredPetitions
        }
        
        tableView.reloadData()
    }
    
    @objc func showCredits() {
        let ac = UIAlertController(title: "Credits", message: "We The People API.", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        ac.addAction(action)
        
        present(ac, animated: true)
    }
    
    func showError() {
        let ac = UIAlertController(title: "Loading error", message: "There was a prolbem loading the feed: please check your connection and try again.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    func parse(json: Data) {
        let decoder = JSONDecoder()
        
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
            fullPetitionList = jsonPetitions.results
            tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return petitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let petition = petitions[indexPath.row]
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = petitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }

}


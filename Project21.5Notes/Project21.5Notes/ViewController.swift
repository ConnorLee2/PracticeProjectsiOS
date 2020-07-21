//
//  ViewController.swift
//  Project21.5Notes
//
//  Created by Connor Lee on 21/07/2020.
//  Copyright © 2020 Connor Lee. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    var notes = [Note]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        title = "Notes"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Delete", style: .plain, target: self, action: #selector(deleteTapped))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(composeTapped))
        
        // Load notes
        let defaults = UserDefaults.standard
        
        if let savedNotes = defaults.object(forKey: "notes") as? Data {
            let jsonDecoder = JSONDecoder()
            
            do {
                notes = try jsonDecoder.decode([Note].self, from: savedNotes)
            } catch {
                print("Failed to load notes")
            }
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = notes[indexPath.row].title
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.note = notes[indexPath.row]
            vc.vc = self
            vc.indexNum = indexPath.row
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func composeTapped() {
        let ac = UIAlertController(title: "Compose a new note", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) {
            [weak self, weak ac] _ in
            guard let noteName = ac?.textFields?[0].text else { return }
            self?.submit(noteName)
        }
        
        ac.addAction(submitAction)
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        ac.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        
        present(ac, animated: true)
    }
    
    @objc func deleteTapped() {
        let ac = UIAlertController(title: "Delete", message: nil, preferredStyle: .actionSheet)
        
        for (index, note) in notes.enumerated() {
            ac.addAction(UIAlertAction(title: "\(index): \(note.title)", style: .default, handler: deleteNote))
        }
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        ac.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        
        present(ac, animated: true)
    }
    
    func deleteNote(action: UIAlertAction) {
        // parse title
        let actionTitle = action.title!
        let bits = actionTitle.components(separatedBy: ":")
        let number = Int(bits[0]) ?? -1
        
        notes.remove(at: number)
        save()
        tableView.reloadData()
    }
    
    func submit(_ noteName: String) {
        let note = Note(title: noteName, note: "Lorem ipsum blah blah")
        notes.insert(note, at: 0)
        save()
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    func save() {
        let jsonDecoder = JSONEncoder()
        
        if let savedData = try? jsonDecoder.encode(notes) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "notes")
        } else {
            print("Failed to save notes")
        }
    }

}


//
//  ViewController.swift
//  Projekt7
//
//  Created by Patrick Abele on 26.10.21.
//

import UIKit

class ViewController: UITableViewController {
    
    var petitions = [Petition]()
    var petitions_orig = [Petition]()
    var petitions_filtered = [Petition]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        performSelector(inBackground: #selector(fetchJSON), with: nil)
    }
        
    @objc func fetchJSON() {
        
        let urlString: String
        
        if navigationController?.tabBarItem.tag == 0 {
              urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else {
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
        
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                parse(json: data)
                return
            }
        }
        performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
    }
    
    
    @objc func showCredits() {
        let ac = UIAlertController(title: "Credits", message: "All the credits go to the people that filed the Petitions", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Acknowledge", style: .default))
        present(ac, animated: true)
    }
    
    @objc func filter() {
        let ac = UIAlertController(title: "Enter search", message: nil, preferredStyle: .alert)
        ac.addTextField()

        let submitAction = UIAlertAction(title: "Submit", style: .default) { [unowned self, ac] action in
            let filterWord = ac.textFields![0].text!
            for petition in petitions {
                if petition.title.contains(filterWord) {
                    petitions_filtered.append(petition)
                }
            }
            
            reload(new_petitions: petitions_filtered)
        }

        ac.addAction(submitAction)

        present(ac, animated: true)
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
    
    func parse(json: Data) {
        let decoder = JSONDecoder()
        
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
            tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
        } else {
            performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
        }
    }
    
    func reload(new_petitions: [Petition]) {
        if !new_petitions.isEmpty {
            petitions = new_petitions
        } else {
            petitions = petitions_orig
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    @objc func showError() {
        
        DispatchQueue.main.async {
            let ac = UIAlertController(title: "Loading Error", message: "There was a problem loading the feed", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(ac, animated: true)
            
        }
    }
}


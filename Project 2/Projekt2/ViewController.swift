//
//  ViewController.swift
//  Projekt2
//
//  Created by Patrick Abele on 18.10.21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var flagBtn1: UIButton!
    @IBOutlet weak var flagBtn2: UIButton!
    @IBOutlet weak var flagBtn3: UIButton!
    
    var countries = [String]()
    var score = 0
    var correctAnswer = 0
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        flagBtn1.layer.borderWidth = 1
        flagBtn2.layer.borderWidth = 1
        flagBtn3.layer.borderWidth = 1
        
        flagBtn1.layer.borderColor = UIColor.lightGray.cgColor
        flagBtn2.layer.borderColor = UIColor.lightGray.cgColor
        flagBtn3.layer.borderColor = UIColor.lightGray.cgColor
                
        countries.append("estonia")
        countries.append("france")
        countries.append("germany")
        countries.append("ireland")
        countries.append("italy")
        countries.append("monaco")
        countries.append("nigeria")
        countries.append("poland")
        countries.append("russia")
        countries.append("spain")
        countries.append("uk")
        countries.append("us")
        countries.shuffle()
        
        askQuestion(action: nil)
    }

    func askQuestion(action: UIAlertAction!) {
        flagBtn1.setImage(UIImage(named: countries[0]), for: .normal)
        flagBtn2.setImage(UIImage(named: countries[1]), for: .normal)
        flagBtn3.setImage(UIImage(named: countries[2]), for: .normal)
        
        correctAnswer = Int.random(in: 0...2)
        title = countries[correctAnswer].uppercased()

    }
    @IBAction func buttonTapped(_ sender: UIButton) {
        
        var title: String
        
        if sender.tag == correctAnswer {
            title = "Correct"
            score += 1

        } else {
            title = "Wrong"
            score -= 1
        }
        
        let ac = UIAlertController(title: title, message: "Your score is \(score).", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
        present(ac, animated: true, completion: nil)
    }
}


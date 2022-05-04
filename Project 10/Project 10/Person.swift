//
//  Person.swift
//  Project 10
//
//  Created by Patrick Abele on 03.05.22.
//

import UIKit

class Person: NSObject {
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
    
    var name: String
    var image: String
}

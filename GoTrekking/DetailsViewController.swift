//
//  AppDelegate.swift
//  GoTrekking
//
//  Created by eazz on 9/6/2023.
//

import UIKit

class DetailsViewController: UIViewController {
    
    
    @IBOutlet weak var jsonResultsTextView: UITextView!
    
    var jsonResults = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        jsonResultsTextView.text = jsonResults
    }

}

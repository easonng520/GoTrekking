//
//  ViewController.swift
//  GoTrekking
//
//  Created by eazz on 9/6/2023.
//

import UIKit
import Foundation
struct Event:Codable{
    let name: String
    let date: String
}
func decodeAPI(){
    guard let url = URL(string: "https://b.easonng520.repl.co/api/events") else{return}

    let task = URLSession.shared.dataTask(with: url){
        data, response, error in
        
        let decoder = JSONDecoder()

        if let data = data{
            do{
                let tasks = try decoder.decode([Event].self, from: data)
                tasks.forEach{ i in
                    print(i.date)
                }
            }catch{
                print(error)
            }
        }
    }
    task.resume()

}


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        decodeAPI()
    }


}


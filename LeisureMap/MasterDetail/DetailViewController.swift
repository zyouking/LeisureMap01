//
//  DetailViewController.swift
//  LeisureMap
//
//  Created by stu1 on 2018/7/25.
//  Copyright © 2018年 tripim. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var selectedStore:Store?

    @IBAction func btnMapClicked(_ sender: Any) {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "moveToMapViewSegue", sender: self)
        }
        
    }
    
    @IBAction func btnWebClicked(_ sender: Any) {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "moveToNoteViewSegue", sender: self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title=selectedStore?.Name
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation    */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        switch segue.identifier {
        case "moveToMapViewSegue":
            
            break
        case "moveToNoteViewSegue":
            
            break
        default:
            break
        }
        
    }


}

//
//  MeetOthersViewController.swift
//  DatFace
//
//  Created by Foster Brown on 4/28/18.
//  Copyright © 2018 N. All rights reserved.
//

import UIKit

class MeetOthersViewController: UIViewController {
    
    var trainer = Trainer()
    var predictor = Predictor(image: "thing")
    var baseURL: String!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        trainer.setID(ID: baseURL)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonClicked(_ sender: Any) {
        predictor.predict()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

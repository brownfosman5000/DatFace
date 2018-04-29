//
//  UserViewController.swift
//  DatFace
//
//  Created by Foster Brown on 4/27/18.
//  Copyright © 2018 N. All rights reserved.
//

import UIKit

class UserViewController: UIViewController {

    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    
    var userName:String!
    var age:String!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getUserInfo(){
        if let userText = userNameTextField.text{
            userName = userText
        }
        if let ageText = ageTextField.text{
            age = ageText
        }
        print("username: \(userName!)_\(age!)")
    }
    
    @IBAction func nextButtonClicked(_ sender: Any) {
        getUserInfo()
        performSegue(withIdentifier: "goToCameraView", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let newVC = segue.destination as? CameraViewController{
            let destinationVC = newVC
            
            let photoURL = String("\(userName!).\(age!)")
            destinationVC.basePhotoURL = photoURL
            print(photoURL)
            

        }
    
    
        
        
    }
    
    //Closes keyboard on touch
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        userNameTextField.resignFirstResponder()
        ageTextField.resignFirstResponder()
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

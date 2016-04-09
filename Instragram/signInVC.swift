//
//  signInVC.swift
//  Instragram
//
//  Created by Pagers on 4/7/16.
//  Copyright © 2016 irahardianto. All rights reserved.
//

import UIKit
import Parse

class signInVC: UIViewController {

    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var usernameText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    @IBOutlet weak var signInBtn: UIButton!
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var forgotBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // font of label
        label.font = UIFont(name: "Pacifico", size: 25)
        
        // alignment
        label.frame = CGRectMake(10, 80, self.view.frame.size.width - 20, 50)
        usernameText.frame = CGRectMake(10, label.frame.origin.y + 70, self.view.frame.size.width - 20, 30)
        passwordText.frame = CGRectMake(10, usernameText.frame.origin.y + 40, self.view.frame.size.width - 20, 30)
        forgotBtn.frame = CGRectMake(10, passwordText.frame.origin.y + 30, self.view.frame.size.width - 20, 30)
        signInBtn.frame = CGRectMake(20, forgotBtn.frame.origin.y + 40, self.view.frame.size.width / 4, 30)
        signUpBtn.frame = CGRectMake(self.view.frame.size.width - self.view.frame.size.width / 4 - 20, signInBtn.frame.origin.y, self.view.frame.size.width / 4, 30)
        
        // tap to hide keyboard
        let hideTap = UITapGestureRecognizer(target: self, action: #selector(signInVC.hideKeyboard(_:)))
        hideTap.numberOfTapsRequired = 1
        self.view.userInteractionEnabled = true
        self.view.addGestureRecognizer(hideTap)
        
        // background
        let bg = UIImageView(frame: CGRectMake(0, 0, self.view.frame.width, self.view.frame.height))
        bg.image = UIImage(named: "background.jpg")
        bg.layer.zPosition = -1
        self.view.addSubview(bg)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func hideKeyboard(recognizer: UITapGestureRecognizer) {
        
        self.view.endEditing(true)
    }
    
    @IBAction func signInBtn_click(sender: AnyObject) {
        
        print("sign in btn click");
        
        self.view.endEditing(true)
        
        // if text fields are empy
        if usernameText.text!.isEmpty || passwordText.text!.isEmpty {
            
            // show alert
            let alert = UIAlertController(title: "PLEASE", message: "fill in the fields", preferredStyle: UIAlertControllerStyle.Alert)
            let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil)
            alert.addAction(ok)
            
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
        PFUser.logInWithUsernameInBackground(usernameText.text!, password: passwordText.text!) { (user:PFUser?, error:NSError?) in
            
            if error == nil {
                
                // remember user or save in App Memory did the user login or not
                NSUserDefaults.standardUserDefaults().setObject(user!.username, forKey: "username")
                NSUserDefaults.standardUserDefaults().synchronize()
                
                // call login func from AppDelegate.swift class
                let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                appDelegate.login()
            } else {
                
                // show alert
                let alert = UIAlertController(title: "Error", message: error!.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert)
                let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil)
                alert.addAction(ok)
                
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

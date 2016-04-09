//
//  resetPasswordVC.swift
//  Instragram
//
//  Created by Pagers on 4/7/16.
//  Copyright © 2016 irahardianto. All rights reserved.
//

import UIKit
import Parse

class resetPasswordVC: UIViewController {

    @IBOutlet weak var emailTxt: UITextField!
    
    @IBOutlet weak var resetBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // alignment
        emailTxt.frame = CGRectMake(10, 120, self.view.frame.size.width - 20, 30)
        resetBtn.frame = CGRectMake(20, emailTxt.frame.origin.y + 50, self.view.frame.size.width / 4, 30)
        cancelBtn.frame = CGRectMake(self.view.frame.size.width - self.view.frame.size.width / 4 - 20, resetBtn.frame.origin.y, self.view.frame.size.width / 4, 30)
        
        let bg = UIImageView(frame: CGRectMake(0, 0, self.view.frame.width, self.view.frame.height))
        bg.image = UIImage(named: "background.jpg")
        bg.layer.zPosition = -1
        self.view.addSubview(bg)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func resetBtn_click(sender: AnyObject) {
        
        self.view.endEditing(true)
        
        // if email textfield is empty
        if emailTxt.text!.isEmpty {
            
            let alert = UIAlertController(title: "Email field", message: "is empty", preferredStyle: UIAlertControllerStyle.Alert)
            let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil)
            alert.addAction(ok)
            
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
        // request for resetting password
        PFUser.requestPasswordResetForEmailInBackground(emailTxt.text!) { (success:Bool, error:NSError?) in
            
            if success {
                let alert = UIAlertController(title: "Email for resetting password", message: "has been sent to the texted email", preferredStyle: UIAlertControllerStyle.Alert)
                
                // if pressed OK call self.dismiss.. fucntion
                let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) in
                    
                    self.dismissViewControllerAnimated(true, completion: nil)
                })
                alert.addAction(ok)
                
                self.presentViewController(alert, animated: true, completion: nil)
            
            } else {
                
                print(error?.localizedDescription)
            }
        }
    }

    @IBAction func cancelBtn_click(sender: AnyObject) {
        
        self.view.endEditing(true)
        self.dismissViewControllerAnimated(true, completion: nil)
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

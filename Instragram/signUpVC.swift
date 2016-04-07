//
//  signUpVC.swift
//  Instragram
//
//  Created by Pagers on 4/7/16.
//  Copyright © 2016 irahardianto. All rights reserved.
//

import UIKit
import Parse

class signUpVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var avaImg: UIImageView!
    
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var repeatPassword: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    
    @IBOutlet weak var fullnameTxt: UITextField!
    @IBOutlet weak var bioTxt: UITextField!
    @IBOutlet weak var webTxt: UITextField!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var signUpBtn: UIScrollView!
    @IBOutlet weak var cancelBtn: UIButton!
    
    var scrollViewHeight : CGFloat = 0
    var keyboard = CGRect()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height)
        scrollView.contentSize.height = self.view.frame.height
        scrollViewHeight = scrollView.frame.size.height
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(signUpVC.showKeyboard(_:)), name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(signUpVC.hideKeyboard(_:)), name: UIKeyboardWillHideNotification, object: nil)
        
        let hideTap = UITapGestureRecognizer(target: self, action: #selector(signUpVC.hideKeyboardTap(_:)))
        hideTap.numberOfTapsRequired = 1
        self.view.userInteractionEnabled = true
        self.view.addGestureRecognizer(hideTap)
        
        // round ava
        avaImg.layer.cornerRadius = avaImg.frame.size.width / 2
        avaImg.clipsToBounds = true
        
        let avaTap = UITapGestureRecognizer(target: self, action: #selector(signUpVC.loadImg(_:)))
        avaTap.numberOfTapsRequired = 1
        avaImg.userInteractionEnabled = true
        avaImg.addGestureRecognizer(avaTap)
    }
    
    func loadImg(recognizer: UITapGestureRecognizer) {
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .PhotoLibrary
        picker.allowsEditing = true
        
        presentViewController(picker, animated: true, completion: nil)
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        avaImg.image = info[UIImagePickerControllerEditedImage] as? UIImage
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func hideKeyboardTap(recognizer: UITapGestureRecognizer){
        
        self.view.endEditing(true)
    }

    func showKeyboard(notification: NSNotification){
        
        keyboard = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey]!.CGRectValue())!
        
        UIView.animateWithDuration(0.4) { () -> Void in
            
            self.scrollView.frame.size.height = self.scrollViewHeight - self.keyboard.height
        }
    }
    
    func hideKeyboard(notification: NSNotification) {
        
        UIView.animateWithDuration(0.4) { () -> Void in
            
            self.scrollView.frame.size.height = self.view.frame.height
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func signUpBtn_click(sender: AnyObject) {
    
        print("signup")
        
        self.view.endEditing(true)
        
        // if fields are empty
        if usernameTxt.text!.isEmpty || passwordTxt.text!.isEmpty || repeatPassword.text!.isEmpty || emailTxt.text!.isEmpty || fullnameTxt.text!.isEmpty || bioTxt.text!.isEmpty || webTxt.text!.isEmpty {
            
            // alert message
            let alert = UIAlertController(title: "PLEASE", message: "fill all fields", preferredStyle: UIAlertControllerStyle.Alert)
            let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil)
            alert.addAction(ok)
            
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
        if passwordTxt.text != repeatPassword.text {
            
            let alert = UIAlertController(title: "PASSWORDS", message: "do not match", preferredStyle: UIAlertControllerStyle.Alert)
            let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil)
            alert.addAction(ok)
            
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
        // send data to server to related columns
        let user = PFUser()
        user.username = usernameTxt.text?.lowercaseString
        user.email = emailTxt.text?.lowercaseString
        user.password = passwordTxt.text?.lowercaseString
        user["fullname"] = fullnameTxt.text?.lowercaseString
        user["bio"] = bioTxt.text
        user["web"] = webTxt.text?.lowercaseString
        
        // in edit profile its gonna be assigned
        user["tel"] = ""
        user["gender"] = ""
        
        // convert our image for sending to server
        let avaData = UIImageJPEGRepresentation(avaImg.image!, 0.5)
        let avaFile = PFFile(name: "ava.jpg", data: avaData!)
        user["ava"] = avaFile
        
        user.signUpInBackgroundWithBlock { (success:Bool, error:NSError?) in
            
            if success {
                print("registered")
            } else {
                print(error?.localizedDescription)
            }
        }
    }
    
    @IBAction func cancelBtn_click(sender: AnyObject) {
        
        print("cancel")
    }
}

//
//  NewContactViewController.swift
//  ContactsApp
//
//  Created by Steven on 3/22/16.
//  Copyright © 2016 haroon. All rights reserved.
//

import UIKit
import CoreData

class NewContactViewController: UIViewController {
    
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var phoneField: UITextField!
    
    var appDel: AppDelegate = AppDelegate()
    var context: NSManagedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)

    override func viewDidLoad() {
        super.viewDidLoad()

        appDel = UIApplication.sharedApplication().delegate as! AppDelegate
        context = appDel.managedObjectContext
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func save(sender: AnyObject) {
        if firstNameField.text!.isEmpty || lastNameField.text!.isEmpty || emailField.text!.isEmpty || phoneField.text!.isEmpty {
            let alertController = UIAlertController(title: "Error", message: "All Text Fields Are Mandatory", preferredStyle: .Alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        } else {
            let newContact = NSEntityDescription.insertNewObjectForEntityForName("Contacts", inManagedObjectContext: context) as NSManagedObject
            newContact.setValue(firstNameField.text, forKey: "firstName")
            newContact.setValue(lastNameField.text, forKey: "lastName")
            newContact.setValue(emailField.text, forKey: "email")
            newContact.setValue(phoneField.text, forKey: "phone")
            
            do {
                try context.save()
                let alertController = UIAlertController(title: "Success", message: "Record Saved Successfully", preferredStyle: .Alert)
                alertController.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
                self.presentViewController(alertController, animated: true, completion: nil)
                firstNameField.text = ""
                lastNameField.text = ""
                emailField.text = ""
                phoneField.text = ""
                
            } catch {
                let alertController = UIAlertController(title: "Error", message: "Something went wrong while saving record", preferredStyle: .Alert)
                alertController.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        }
    }
}

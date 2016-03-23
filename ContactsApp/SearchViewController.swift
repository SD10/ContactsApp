//
//  SearchViewController.swift
//  ContactsApp
//
//  Created by Steven on 3/22/16.
//  Copyright © 2016 haroon. All rights reserved.
//

import UIKit
import CoreData

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var searchLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!

    var results: [AnyObject]?
    
    var appDel: AppDelegate = AppDelegate()
    var context: NSManagedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appDel = UIApplication.sharedApplication().delegate as! AppDelegate
        context = appDel.managedObjectContext
        
        tableView.delegate = self
        tableView.dataSource = self
        
        searchLabel.text = "0 Records Found"
        searchTextField.text = ""
        loadData(searchTextField.text!)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        loadData(searchTextField.text!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadData(search: String) {
        results = [AnyObject]()
        let request = NSFetchRequest(entityName: "Contacts")
        request.resultType = .DictionaryResultType
        if search != "" {
            request.predicate = NSPredicate(format: "firstName = %@", search)
        }
        
        let sort1 = NSSortDescriptor(key: "firstName", ascending: true)
        let sort2 = NSSortDescriptor(key: "lastName", ascending: true)
        request.sortDescriptors = [sort1, sort2]
        
        do {
            results = try context.executeFetchRequest(request)
        } catch {
            let alertController = UIAlertController(title: "Error", message: "All Text Fields Are Mandatory", preferredStyle: .Alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        
        tableView.reloadData()
        searchLabel.text = (results?.count)! > 1 ? "\((results?.count)!) records found" : "\((results?.count)!) record found"
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (results?.count)!
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! ContactTableViewCell
        let firstName: String = results![indexPath.row].valueForKey("firstName")! as! String
        let lastName: String = results![indexPath.row].valueForKey("lastName")! as! String
        let email: String = results![indexPath.row].valueForKey("email")! as! String
        let phone: String = results![indexPath.row].valueForKey("phone")! as! String
        
        cell.nameLabel.text = firstName + " " + lastName
        cell.emailLabel.text = email
        cell.phoneLabel.text = phone
        return cell
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func search(sender: AnyObject) {
        self.view.endEditing(true)
        loadData(searchTextField.text!)
    }
    
}

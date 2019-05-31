// Project:     Jiujitsu Techniques
// Author:      White
// Date:        5/7/19
// File:        MasterViewController.swft

//  Created by Casey White on 3/12/19.
//  Copyright © 2019 Carl Fowler. All rights reserved.
//

import UIKit
import CoreData

class MasterViewController: UITableViewController, NSFetchedResultsControllerDelegate
{
    //create reference to detailViewController
    var detailViewController: DetailViewController? = nil
   
    //to hold data
    var managedObjectContext: NSManagedObjectContext? = nil
    
    // get the standard default object
    let defaults = UserDefaults.standard
   
    // used for preferences
    var listOrder = true
    
    //Called after the controller's view is loaded into memory
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        navigationItem.leftBarButtonItem = editButtonItem
        
        //create add button
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
        navigationItem.rightBarButtonItem = addButton
        if let split = splitViewController
        {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        
        //get the list order
        listOrder = defaults.bool(forKey: "listOrder")
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnPreferences(_ sender: UIButton)
    {
        // get the standard user default object for perferences
        let defaults = UserDefaults.standard
        
        // create preferences action sheet
        let preferenceMenu = UIAlertController(
            title: "Preferences",
            message: "List Order",
            preferredStyle: .actionSheet)
        
        // create ascending action
        let ascendingAction = UIAlertAction(title: "Ascending", style: .default, handler:
        { (alertAction: UIAlertAction) in
            
            // set the preference to ascending order in the master line 269
            defaults.set(true, forKey: "listOrder")
            
            // get the navigationController
            let tNav = self.splitViewController?.viewControllers[0] as? UINavigationController
            print("tNav: \(tNav!)")
            
            // get the MasterViewController
            let master = tNav?.viewControllers[0] as? MasterViewController
            print("master: \(master!)")
            
            // set the listOrder to true for ascending
            master?.listOrder = true
            
            // delete the fetchResultsController cache so it will be recreated with ascending order
            NSFetchedResultsController<Technique>.deleteCache(withName: "Master")
            
            // delete the fetchedResultsController to force a new one to be created
            master?._fetchedResultsController = nil
            
            // reload the table
            master?.tableView.reloadData()
            
        })
        
        // create descending action
        let descendingAction = UIAlertAction(title: "Descending", style: .default, handler:
        { (alertAction: UIAlertAction) in
            
            // set the preference to descending order in the master
            defaults.set(false, forKey: "listOrder")
            
            // get the NavigationController
            let tNav = self.splitViewController?.viewControllers[0] as? UINavigationController
            print("tNav: \(tNav!)")
            
            // get the MasterViewController
            let master = tNav?.viewControllers[0] as? MasterViewController
            print("master: \(master!)")
            
            // set the listOrder to false for descending
            master?.listOrder = false
            
            // delete the fetchResultsController cache so it will be recreated with descending order
            NSFetchedResultsController<Technique>.deleteCache(withName: "Master")
            
            // delete the fetchedResultsController to force a new one to be created
            master?._fetchedResultsController = nil
            
            // reload the table
            master?.tableView.reloadData()
        })
        
        // cancel action, no handler
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        // add the actions to the alert action sheet
        preferenceMenu.addAction(ascendingAction)
        preferenceMenu.addAction(descendingAction)
        preferenceMenu.addAction(cancelAction)
        
        // display the action sheet
        self.present(preferenceMenu, animated: true, completion: nil)

    }
    
    // creates a managed object(event) to hold data
    @objc
    func insertNewObject(_ sender: Any)
    {
        
        //Modify the function insertNewObject to replace the Event with the Technique entity.
        //Assign values to Technique objects attributes. This will be replaced later with the add alertController.
        let context = self.fetchedResultsController.managedObjectContext
        
        // create an Alert with a textFields for name and phone
        let alertController = UIAlertController(title: "Add Technique",
                                                message: "",
                                                preferredStyle: UIAlertControllerStyle.alert)
        
        // add the textField to the Alert. Create a closuer to handle the configuration
        alertController.addTextField(configurationHandler: {(textField: UITextField!) in
            textField.placeholder="Position"
            textField.keyboardType=UIKeyboardType.default
        })
        alertController.addTextField(configurationHandler: {(textField: UITextField!) in
            textField.placeholder="Attack"
            textField.keyboardType=UIKeyboardType.default
        })
        alertController.addTextField(configurationHandler: {(textField: UITextField!) in
            textField.placeholder="Hours Trained"
            textField.keyboardType=UIKeyboardType.decimalPad
            
        })
        alertController.addTextField(configurationHandler: {(textField: UITextField!) in
            textField.placeholder="Rank"
            textField.keyboardType=UIKeyboardType.default
        })

        alertController.addTextField(configurationHandler: {(textField: UITextField!) in
            textField.placeholder="Date"
            textField.keyboardType=UIKeyboardType.default
        })
     
        // create a default action for the Alert
        // Must cast an element in the array from anyObject to UITextFiled pg. 322
        let defaultAction = UIAlertAction(
            title: "Ok",
            style: UIAlertActionStyle.default,
            handler: {(alertAction: UIAlertAction!) in
                // get the input from the alert controller
                let position: String = (alertController.textFields![0]).text!
                let attack: String = (alertController.textFields![1]).text!
                let hoursTrained: String = (alertController.textFields![2]).text!
                let rank: String = (alertController.textFields![3]).text!
                let date: String = (alertController.textFields![4]).text!
                
                
                //assign the input to new technique object
                let newTechnique = Technique(context: context)
                newTechnique.position = position
                newTechnique.attack = attack
                newTechnique.hoursTrained = hoursTrained
                newTechnique.rank = rank
                newTechnique.date = date
        })
        
        // cancel button
        let cancelAction = UIAlertAction(
            title: "Cancel",
            style: UIAlertActionStyle.cancel,
            handler:nil)
        
        // add the actions to the Alert
        alertController.addAction(defaultAction)
        alertController.addAction(cancelAction)
        
        // generate test data
        gernerateTestData(alertController: alertController)
        
        // display the Alert
        present(alertController, animated: true, completion: nil)
    }
    
    func gernerateTestData(alertController:UIAlertController)
    {
        // get the textfields and assign test data
        (alertController.textFields![0]).text = "Position"
        (alertController.textFields![1]).text = "Attack"
        (alertController.textFields![2]).text = "Hours Trained"
        (alertController.textFields![3]).text = "Rank"
        (alertController.textFields![4]).text = "Date"
    }
    
    //Notifies the view controller that a segue is about to be performed.
    // MARK: - Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "showDetail"
        {
            if let indexPath = tableView.indexPathForSelectedRow
            {
                let object = fetchedResultsController.object(at: indexPath)
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }
    
    
    // MARK: - Table View
    
    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return fetchedResultsController.sections?.count ?? 0
    }
    
    // fetchResultsController bridges the gap between coreData and tableView
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        let sectionInfo = fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }
    
    //passing the table view and indexpath
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let event = fetchedResultsController.object(at: indexPath)
        configureCell(cell, withEvent: event)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
//        if editingStyle == .delete
//        {
//            let context = fetchedResultsController.managedObjectContext
//            context.delete(fetchedResultsController.object(at: indexPath))
//
//            do
//            {
//                try context.save()
//            }
//            catch
//            {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                let nserror = error as NSError
//                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
//            }
//        }
    }

    
    //configureCell builds a cell that contains the description
    func configureCell(_ cell: UITableViewCell, withEvent event: Technique)
    {
        cell.textLabel!.text = event.position
    }
    
    // MARK: - Fetched results controller
    
    //Replace all occurrences of the Event entity with the Technique entity in the FetchResultsController.
    var fetchedResultsController: NSFetchedResultsController<Technique>
    {
        if _fetchedResultsController != nil
        {
            return _fetchedResultsController!
        }
        
        let fetchRequest: NSFetchRequest<Technique> = Technique.fetchRequest()
        
        // Set the batch size to a suitable number.
        fetchRequest.fetchBatchSize = 20
        
        //Change the sortDescriptor from timestamp to position and set ascending to listOrder for prefrence.
        let sortDescriptor = NSSortDescriptor(key: "position", ascending: listOrder)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext!, sectionNameKeyPath: nil, cacheName: "Master")
        aFetchedResultsController.delegate = self
        _fetchedResultsController = aFetchedResultsController
        
        do
        {
            try _fetchedResultsController!.performFetch()
        }
        catch
        {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
        return _fetchedResultsController!
    }
    var _fetchedResultsController: NSFetchedResultsController<Technique>? = nil
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>)
    {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType)
    {
        switch type
        {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
        default:
            return
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?)
    {
        switch type
        {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            configureCell(tableView.cellForRow(at: indexPath!)!, withEvent: anObject as! Technique)
        case .move:
            configureCell(tableView.cellForRow(at: indexPath!)!, withEvent: anObject as! Technique)
            tableView.moveRow(at: indexPath!, to: newIndexPath!)
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>)
    {
        tableView.endUpdates()
    }
    
    /*
     // Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed.
     
     func controllerDidChangeContent(controller: NSFetchedResultsController) {
         // In the simplest, most efficient, case, reload the table view.
         tableView.reloadData()
     }
     */
    
        //test for edit button
        override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]?
        {
    
            // action one
            let editAction = UITableViewRowAction(style: .normal, title: "Edit")
            {
                (rowAction, indexPath) in
                print("Edit")
                //call function to perform update
                self.editItem(indexPath: indexPath)
            }
            editAction.backgroundColor = UIColor.blue
    
            // action two
            let deleteAction = UITableViewRowAction(style: .default, title: "Delete")
            {
                (action, indexPath) in
                print("Delete")
               //call function to perform update
                self.deleteItem(indexPath: indexPath)
            }
            deleteAction.backgroundColor = UIColor.red
    
            return [editAction, deleteAction]
    }
    
    // function to delete item in entity
    func deleteItem(indexPath: IndexPath)
    {
        // Create the Alert Controller
        let alertController = UIAlertController(title: "Delete",
                                                message: "Delete Confirmation",
                                                preferredStyle: UIAlertControllerStyle.alert)
        
        // Create a default action
        let okAction = UIAlertAction(title: "OK",
                                     style: UIAlertActionStyle.default,
                                     handler:
            {(alertAction: UIAlertAction!) in
                self.managedObjectContext?.delete(self.fetchedResultsController.object(at: indexPath))
                do
                {
                    try self.managedObjectContext?.save()
                }
                catch
                {
                    let nserror = error as NSError
                    fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                }
        })
        
        // Alerts can only have one cancel action. It is bolded and always comes last
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: UIAlertActionStyle.cancel,
                                         handler: {(alertAction: UIAlertAction!) in
                                            print()
        })
        
        // Add the action to the Alert
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        // Present or display the Alert
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    func editItem(indexPath: IndexPath)
            {
            //Modify the function insertNewObject to replace the Event with the Technique entity.
            //Assign values to Technique objects attributes. This will be replaced later with the add alertController.
                let detailItem = self.fetchedResultsController.object(at: indexPath)
            
            // create an Alert with a textFields for name and phone
            let alertController = UIAlertController(title: "Edit Technique",
                                                    message: "",
                                                    preferredStyle: UIAlertControllerStyle.alert)
            
            // add the textField to the Alert. Create a closuer to handle the configuration
               alertController.addTextField(configurationHandler: {(textField: UITextField!) in
                textField.isUserInteractionEnabled = false
                textField.isEnabled = false
                textField.text=detailItem.position
                textField.keyboardType=UIKeyboardType.default
                })
            
            alertController.addTextField(configurationHandler: {(textField: UITextField!) in
                textField.text = detailItem.attack
                textField.keyboardType=UIKeyboardType.default
            })
            alertController.addTextField(configurationHandler: {(textField: UITextField!) in
                textField.text = detailItem.hoursTrained
                textField.keyboardType=UIKeyboardType.decimalPad
                
            })
            alertController.addTextField(configurationHandler: {(textField: UITextField!) in
                textField.text = detailItem.rank
                textField.keyboardType=UIKeyboardType.default
            })
            
            alertController.addTextField(configurationHandler: {(textField: UITextField!) in
                textField.text = detailItem.date
                textField.keyboardType=UIKeyboardType.default
            })
            
            // create a default action for the Alert
            // Must cast an element in the array from anyObject to UITextFiled pg. 322
            let defaultAction = UIAlertAction(
                title: "Ok",
                style: UIAlertActionStyle.default,
                handler: {(alertAction: UIAlertAction!) in
                    // get the input from the alert controller
                    
                    let attack: String = (alertController.textFields![1]).text!
                    let hoursTrained: String = (alertController.textFields![2]).text!
                    let rank: String = (alertController.textFields![3]).text!
                    let date: String = (alertController.textFields![4]).text!
                    
                    
                    //update the existing detailItem technique object
                    detailItem.attack = attack
                    detailItem.hoursTrained = hoursTrained
                    detailItem.rank = rank
                    detailItem.date = date
            })
            
            // cancel button
            let cancelAction = UIAlertAction(
                title: "Cancel",
                style: UIAlertActionStyle.cancel,
                handler:nil)
            
            // add the actions to the Alert
            alertController.addAction(defaultAction)
            alertController.addAction(cancelAction)
            
                //display the alertController
                present(alertController, animated: true, completion: nil)
        }
}


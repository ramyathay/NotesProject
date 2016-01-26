//
//  ViewController.swift
//  NotesClone
//
//  Created by Ramyatha Yugendernath on 1/25/16.
//  Copyright © 2016 Ramyatha Yugendernath. All rights reserved.
//

import UIKit

class NotesCloneViewController: UITableViewController,UISearchBarDelegate,UISearchResultsUpdating,BackButtonDelegate,HandleNotesDelegate{

    var searchController = UISearchController(searchResultsController: nil)
    var notes = [Notes]()  // For storing all the retreived records from the database
    var filteredNotes = [Notes]()  //For storing the results based on filter search
    var isEditMode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        notes = Notes.all()
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        filteredNotes = notes.filter { note in
            //return candy.name.lowercaseString.containsString(searchText.lowercaseString)
            return note.notesText.lowercaseString.containsString(searchText.lowercaseString)
        }
        
        tableView.reloadData()
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("NotesCell", forIndexPath: indexPath) as! NotesCell
        let note: Notes
        if searchController.active && searchController.searchBar.text != "" {
            note = filteredNotes[indexPath.row]
        } else {
            note = notes[indexPath.row]
        }
        cell.notesTextLabel.text = note.notesText
        
        let dateFormatter = NSDateFormatter()
        //the "M/d/yy, H:mm" is put together from the Symbol Table
        dateFormatter.dateFormat = "M-d-yy"
        let dateStringFormat = dateFormatter.stringFromDate(note.createdAt)
        cell.createdAtLabel.text = dateStringFormat
        return cell
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.active && searchController.searchBar.text != "" {
            return filteredNotes.count
        }
        return notes.count
    }
    
    override func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        print("entered function")
        performSegueWithIdentifier("HandleNotes", sender: tableView.cellForRowAtIndexPath(indexPath))
        isEditMode = true
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print("Preparing for segue")
        if !isEditMode {
            let navigationController = segue.destinationViewController as! UINavigationController
            let controller = navigationController.topViewController as! HandleNotesViewController
            controller.backButtonDelegate = self
            controller.delegate = self
        }
        else  {
            let navigationController = segue.destinationViewController as! UINavigationController
            let controller = navigationController.topViewController as! HandleNotesViewController
            controller.backButtonDelegate = self
            controller.delegate = self
            isEditMode = false
            if let indexPath = tableView.indexPathForCell(sender as! UITableViewCell) {
                controller.noteToEdit = notes[indexPath.row]
            }
        }
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        notes[indexPath.row].destroy()
        notes.removeAtIndex(indexPath.row)
        tableView.reloadData()
    }
    
//    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        performSegueWithIdentifier("HandleNotes", sender: tableView.cellForRowAtIndexPath(indexPath))
//        isEditMode = true
//    }
    
    func backButtonPressedFrom(controller: UIViewController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func handleNotesViewController(controller: HandleNotesViewController, didFinishGivingNotesDetails note: Notes) {
        dismissViewControllerAnimated(true, completion: nil)
        let dateFormatter = NSDateFormatter()
        //the "M/d/yy, H:mm" is put together from the Symbol Table
        dateFormatter.dateFormat = "H.mm"
        dateFormatter.stringFromDate(NSDate())
        note.save()
        notes = Notes.all()
        tableView.reloadData()
    }

}


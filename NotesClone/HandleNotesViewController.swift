//
//  HandleNotesData.swift
//  NotesClone
//
//  Created by Ramyatha Yugendernath on 1/25/16.
//  Copyright © 2016 Ramyatha Yugendernath. All rights reserved.
//

import Foundation
import UIKit

class HandleNotesViewController: UIViewController {
    
    var noteToEdit: Notes?
    weak var backButtonDelegate: BackButtonDelegate?
    weak var delegate: HandleNotesDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let isEdit = noteToEdit {
            addNotesTextLabel.text = noteToEdit?.notesText
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButtonPressed(sender: UIBarButtonItem) {
        if let note = noteToEdit {
            note.notesText = addNotesTextLabel.text
            delegate!.handleNotesViewController(self, didFinishGivingNotesDetails: note)
        }
        else {
            let note = Notes(newNote: addNotesTextLabel.text)
            delegate!.handleNotesViewController(self, didFinishGivingNotesDetails: note)
        }
    }
    @IBOutlet weak var addNotesTextLabel: UITextView!
    
}

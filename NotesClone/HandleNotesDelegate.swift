//
//  HandleNotesDelegate.swift
//  NotesClone
//
//  Created by Ramyatha Yugendernath on 1/25/16.
//  Copyright © 2016 Ramyatha Yugendernath. All rights reserved.
//

import Foundation

protocol HandleNotesDelegate: class {
    func handleNotesViewController(controller: HandleNotesViewController, didFinishGivingNotesDetails note: Notes)
}
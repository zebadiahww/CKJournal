//
//  EntryDetailViewController.swift
//  CKJournal
//
//  Created by Zebadiah Watson on 10/14/19.
//  Copyright © 2019 Zebadiah Watson. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController, UITextFieldDelegate {
    
    var entryReceiver: Entry? {
        didSet {
            DispatchQueue.main.async {
                self.loadViewIfNeeded()
                self.updateViews()
            }
        }
    }

    
    
    // Outlets
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var bodyTextField: UITextView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        titleTextField.delegate = self
        
        
    }
    
    // Actions
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let entryTitle = titleTextField.text, let bodyText = bodyTextField.text
            else { return }
        
        if entryTitle.isEmpty || bodyText.isEmpty { return }
        
        if let entry = entryReceiver {
            func update(entry: Entry) {
                
            }
        } else {
            EntryController.shared.addEntryWith(titleText: entryTitle, bodyText: bodyText) { (success) in
                if success {
                    DispatchQueue.main.async {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        }
    }
    
    
    @IBAction func clearButtonTapped(_ sender: Any) {
        titleTextField.text = ""
        bodyTextField.text = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        titleTextField.resignFirstResponder()
        return true
    }
    
    func updateViews() {
        guard let entry = entryReceiver else { return }
        titleTextField.text = entry.titleText
        bodyTextField.text = entry.bodyText
        
    }
}





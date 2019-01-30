//
//  DocumentEditViewController.swift
//  Documents
//
//  Created by Brock Gibson on 1/28/19.
//  Copyright © 2019 Brock Gibson. All rights reserved.
//

import UIKit

class DocumentEditViewController: UIViewController {
    
    var existingDocument: document?
    
    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var contentTextView: UITextView!
    
    @IBOutlet weak var titleBar: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if existingDocument?.title == nil {
            return
        }
        
        titleTextField.text = existingDocument?.title
        let filename = existingDocument!.title
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = dir.appendingPathComponent(filename)
            do {
                let fileText = try String(contentsOf: fileURL, encoding: .utf8)
                contentTextView.text = fileText
            }
            catch {
                print("Couldn't load file contents")
                return
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            titleTextField.resignFirstResponder()
            contentTextView.resignFirstResponder()
    }
    
    @IBAction func clickSave(_ sender: Any) {
        let fileTitle = titleTextField.text ?? ""
        let fileContent = contentTextView.text
        
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            
            if let existingDocument = existingDocument {
                let oldFileURL = dir.appendingPathComponent(existingDocument.title)
                do {
                    try FileManager.default.removeItem(at: oldFileURL)
                } catch {
                    print("couldn't overwrite old file.")
                    return
                }
            }
            let fileURL = dir.appendingPathComponent(fileTitle)
            do {
                try fileContent!.write(to: fileURL, atomically: false, encoding: .utf8)
                
                self.navigationController?.popViewController(animated: true)
            }
            catch {
                print("error writing file.")
                return
            }
        }
    }
    
    @IBAction func editTitle(_ sender: Any) {
        titleBar.title = titleTextField.text
    }
}
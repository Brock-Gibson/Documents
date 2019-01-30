//
//  DocumentViewController.swift
//  Documents
//
//  Created by Brock Gibson on 1/28/19.
//  Copyright © 2019 Brock Gibson. All rights reserved.
//

import UIKit

struct document {
    var title: String
    var size: String
    var modifiedDate: Date
}

class DocumentViewController: UITableViewController {

    @IBOutlet var documentTableView: UITableView!
    
    let dateFormatter = DateFormatter()

    var documents = [document]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.rowHeight = 70
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        dateFormatter.timeStyle = .medium
        dateFormatter.dateStyle = .medium
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        documents = []
        
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let dirPath = documentsURL.path
        
        do {
            let fileList = try fileManager.contentsOfDirectory(atPath: dirPath)
            for fileName in fileList {
                var docSize: UInt64
                var docDate: Date?
                let docPath = dirPath + "/" + fileName
                var docSizeString: String = "0 bytes"
                
                do {
                    let file = try fileManager.attributesOfItem(atPath: docPath)
                    docSize = file[FileAttributeKey.size] as! UInt64
                    docDate = file[FileAttributeKey.modificationDate] as? Date
                    docSizeString = "\(docSize)" + " bytes"
                }
                catch {
                    print("Failed to read file attributes")
                }
                documents.append(document(title: fileName, size: docSizeString, modifiedDate: docDate!))
            }
        }
        catch {
            print("error reading file")
        }
        
        documentTableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        documentTableView.reloadData()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return documents.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "documentCell", for: indexPath)

        if let cell = cell as? DocumentCell {
            cell.titleLabel.text = documents[indexPath.row].title
            cell.fileSizeLabel.text = "Size: " + documents[indexPath.row].size
            cell.lastModifiedLabel.text = "Modified: " + dateFormatter.string(from: documents[indexPath.row].modifiedDate)
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            let file = documents[indexPath.row].title
            if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                let fileURL = dir.appendingPathComponent(file)
                do{
                    try FileManager.default.removeItem(at: fileURL)
                    documents.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                }
                catch{
                    print("Could not delete file")
                    return
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toDetail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if let destination = segue.destination as? DocumentEditViewController ,
            let row = documentTableView.indexPathForSelectedRow?.row{
            destination.existingDocument = documents[row]
        }
    }

}

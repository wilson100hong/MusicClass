//
//  StudentTableViewController.swift
//  MusicClass
//
//  Created by Wilson Hong on 1/29/18.
//  Copyright © 2018 Grace. All rights reserved.
//

import UIKit
import os.log


class StudentTableViewController: UITableViewController {
    var students = [Student]()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        // navigationItem.leftBarButtonItem = editButtonItem
        // Load any saved students, otherwise load sample data.
        if let savedStudents = loadStudents() {
            students += savedStudents
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return students.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellId = "StudentTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? StudentTableViewCell else {
            fatalError("dequeueReusableCell failed")
        }

        let student = students[indexPath.row]
        cell.nameLabel.text = student.name
        cell.photoImageView.image = student.image

        return cell
    }
 
    @IBAction func unwindToStudentList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? StudentViewController, let student = sourceViewController.student {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update an existing student.
                students[selectedIndexPath.row] = student
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            }
            else {
                // Add a new student
                let newIndex = IndexPath(row: students.count, section: 0)
                students.append(student)
                tableView.insertRows(at: [newIndex], with: .automatic)
            } 
        }
        saveStudents()
    }


    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }


    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            students.remove(at: indexPath.row)
            saveStudents()
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */



    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        switch (segue.identifier ?? "") {
        case "AddStudent":
            os_log("Adding a new student.", log: OSLog.default, type: .debug)
        case "ShowStudent":
            os_log("Showing a student.", log: OSLog.default, type: .debug)
            guard let studentViewController = segue.destination as? StudentViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            guard let selectedStudentCell = sender as? StudentTableViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            guard let indexPath = tableView.indexPath(for: selectedStudentCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            let selectedStudent = students[indexPath.row]
            studentViewController.student = selectedStudent
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }
    
    private func saveStudents() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(students, toFile: Student.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Students successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save students...", log: OSLog.default, type: .error)
        }
    }
    
    private func loadStudents() -> [Student]?  {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Student.ArchiveURL.path) as? [Student]
    }
}

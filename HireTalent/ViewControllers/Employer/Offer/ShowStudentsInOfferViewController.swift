//
//  ShowStudentsInOfferViewController.swift
//  HireTalent
//
//  Created by user168029 on 4/28/20.
//  Copyright © 2020 Dream Team. All rights reserved.
//

import UIKit

class ShowStudentsInOfferViewController: UITableViewController {
    
    @IBOutlet var table: UITableView!
    
    var students: [String] = []
    var studentsNames: [String] = []
    var offerId: String = ""
    
    var cellSelected: Int = -1

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getStudents()
        
//        sem.wait()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    func getStudents(){
        var c = 0
        for studentId in students {
           
            StudentDAO.getStudent(studentId) { (error, student) in
                if error != nil {
                    print("fucked up")
                } else {
                    let completeName = student!.firstName + student!.lastName
                    self.studentsNames.insert(completeName, at: 0)
                    c += 1
                    if c == self.students.count{
                        self.table.reloadData()
                    }
                }
            }
        
            
        }
        
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        let columns = 1
        return columns
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rows = studentsNames.count
        return rows
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentCell", for: indexPath)
        
        if studentsNames.count != 0 {
            cell.textLabel?.text = studentsNames[indexPath.row]
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        cellSelected = indexPath.row
        performSegue(withIdentifier: "showStudent", sender: nil)
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showStudent" {
            let destinationController = segue.destination as! ShowStudentDetailViewController
            
            destinationController.studentId = students[cellSelected]
            destinationController.offerId = offerId
        }
    }

}

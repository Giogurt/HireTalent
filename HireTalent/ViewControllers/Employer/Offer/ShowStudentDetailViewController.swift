//
//  ShowStudentDetailViewController.swift
//  HireTalent
//
//  Created by user168029 on 5/19/20.
//  Copyright © 2020 Dream Team. All rights reserved.
//

import UIKit

class ShowStudentDetailViewController: UIViewController {

    @IBOutlet weak var studentNameLabel: UILabel!
    @IBOutlet weak var studentMajorLabel: UILabel!
    @IBOutlet weak var StudentSemesterLabel: UILabel!
    @IBOutlet weak var studentSchoolLabel: UILabel!
    @IBOutlet weak var studentExperienceText: UITextView!
    
    var thisStudent: Student = Student()
    var studentId: String = ""
    var offerId: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        StudentDAO.getStudent(studentId) { (error, student) in
            if error != nil {
                print("fucked up")
            } else {
                self.thisStudent = student!
                
                self.title = self.thisStudent.firstName
                
                print("THIS IS A STUDENT \(self.thisStudent.firstName)")
                self.studentNameLabel.text = "\(self.thisStudent.firstName) \(self.thisStudent.lastName)"
                self.studentMajorLabel.text = self.thisStudent.major
                self.StudentSemesterLabel.text = self.thisStudent.semester
                self.studentSchoolLabel.text = self.thisStudent.school
                self.studentExperienceText.text = self.thisStudent.experience
            }
        }

        
    }
    
    @IBAction func clickInterestedButton(_ sender: UIButton) {
        thisStudent.notifications.insert(offerId, at: 0)
        StudentDAO.editStudent(id: studentId, student: thisStudent) { (error) in
            if (error != nil) {
                print("VALIO")
                let alert = UIAlertController(title: "Failure", message: "There was a problem sending the notification to the student", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "F", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: "Success", message: "A notification has been sent to the student", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "NICE", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

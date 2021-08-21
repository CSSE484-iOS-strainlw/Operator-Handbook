//
//  LoginVC.swift
//  Operator Handbook
//
//  Created by Loki Strain on 8/14/21.
//

import Foundation
import UIKit
import Firebase

class LoginVC: UIViewController {
    
    var usersListener: ListenerRegistration!
    var usersRef: CollectionReference!
    var lanIDs = [String]()
    let homeVCSegueIdentifier = "HomeVCSegueIdentifier"
    var currentID: String!

    @IBOutlet weak var lanIDTextField: UITextField!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBAction func pressedTempEmployee(_ sender: Any) {
        showAddEmployeeDialogue()
    }
    
    
    override func viewDidLoad() {
        
    }
    override func viewDidAppear(_ animated: Bool) {
        usersStartListening(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.usersRef = Firestore.firestore().collection("Users")
        self.lanIDTextField.text?.removeAll()
    }
    
    
    func usersStartListening(_ viewController: LoginVC){
        
        if(usersListener != nil){
            usersListener.remove()
        }
        
        usersListener = usersRef.addSnapshotListener( { (querySnapshot, error) in
            if let querySnapshot = querySnapshot{
                
                querySnapshot.documents.forEach { (documentSnapshot) in
                    self.lanIDs.append(documentSnapshot.documentID)
                    
                    }
                }else {
                print(error!)
                return

            }
        })
    }
    
    @objc func showAddEmployeeDialogue(){
        let alertController = UIAlertController(title: "Create a Temp Employee", message: "", preferredStyle: .alert)
        
        
        // configure
        alertController.addTextField { (textField) in
            textField.placeholder = "First Name"
        }
        alertController.addTextField { (textField) in
            textField.placeholder = "Last Name"
        }
        alertController.addTextField { (textField) in
            textField.placeholder = "LAN ID"
        }
        alertController.addTextField { (textField) in
            textField.placeholder = "Cell"
        }
        alertController.addTextField { (textField) in
            textField.placeholder = "Email"
        }
        alertController.addTextField { (textField) in
            textField.placeholder = "Below"
        }
        alertController.addTextField { (textField) in
            textField.placeholder = "Above (seperated by comma)"
        }
        alertController.addTextField { (textField) in
            textField.placeholder = "Assigned Lessons (seperated by comma)"
        }
        alertController.addTextField { (textField) in
            textField.placeholder = "Assigned Checks (seperated by comma)"
        }
        alertController.addTextField { (textField) in
            textField.placeholder = "Finished Lessons (seperated by comma)"
        }
        alertController.addTextField { (textField) in
            textField.placeholder = "Finished Checks (seperated by comma)"
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let submitAction = UIAlertAction(title: "Create", style: .default) { (action) in
            
            let firstName = (alertController.textFields![0] as UITextField).text
            let lastName = (alertController.textFields![1] as UITextField).text
            let lanID = (alertController.textFields![2] as UITextField).text
            let cell = (alertController.textFields![3] as UITextField).text
            let email = (alertController.textFields![4] as UITextField).text
            let below = (alertController.textFields![5] as UITextField).text
            let aboveString = (alertController.textFields![6] as UITextField).text
            let assignedLessonsString = (alertController.textFields![7] as UITextField).text
            let assignedChecksString = (alertController.textFields![8] as UITextField).text
            let finishedLessonsString = (alertController.textFields![9] as UITextField).text
            let finishedChecksString = (alertController.textFields![10] as UITextField).text
            
            let above = aboveString?.components(separatedBy: ",")
            let assignedLessons = assignedLessonsString?.components(separatedBy: ",")
            let assignedChecks = assignedChecksString?.components(separatedBy: ",")
            let finishedLessons = finishedLessonsString?.components(separatedBy: ",")
            let finishedChecks = finishedChecksString?.components(separatedBy: ",")
            
            self.usersRef.document(lanID!).setData( ["firstName" : firstName!, "lastName": lastName!, "cell": cell!, "email": email!, "below": below!, "above": above!, "assignedLessons":assignedLessons!, "assignedChecks": assignedChecks!, "finishedLessons": finishedLessons!, "finishedChecks": finishedChecks!])
            
            self.currentID = lanID
            self.performSegue(withIdentifier: self.homeVCSegueIdentifier, sender: self)
            
        }
        alertController.addAction(submitAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func pressedLogIn(_ sender: Any) {
        self.currentID = lanIDTextField.text!
        if lanIDs.contains(currentID){
            errorLabel.isHidden = true
            print("worked")
            self.performSegue(withIdentifier: homeVCSegueIdentifier, sender: self)
        }else{
            print("errored")
            errorLabel.isHidden = false
        }
        
    }
    
    
    
    override func viewDidDisappear(_ animated: Bool) {
        usersListener.remove()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        (segue.destination as! HomeVC).lanID = self.currentID
    }
    
}

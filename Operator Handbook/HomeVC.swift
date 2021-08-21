//
//  HomeVC.swift
//  Operator Handbook
//
//  Created by Loki Strain on 8/14/21.
//

import Foundation
import UIKit
import Firebase

class HomeVC: UIViewController {
    
    
    
    
    var lanID: String!
    var userRef: DocumentReference!
    var classesSegueIdentifier = "ClassesSegueIdentifier"
    var userSnapshot: DocumentSnapshot!
    var cell: String!
    
    
    override func viewWillAppear(_ animated: Bool) {
        userRef = Firestore.firestore().collection("Users").document(lanID)
        userRef.getDocument { documentSnapshot, error in
            if let error = error{
                print("Error getting user\(error)")
                return
            } else {
                self.userSnapshot = documentSnapshot
                let data = self.userSnapshot?.data()
                self.cell = data!["cell"] as! String
                print(self.cell)
            }
        }
    }
    
    @IBAction func pressedLogOut(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func pressedClasses(_ sender: Any) {
        performSegue(withIdentifier: classesSegueIdentifier, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        (segue.destination as! ClassesTBC).lanID = self.lanID
        (segue.destination as! ClassesTBC).cell = self.cell
    }
    
}

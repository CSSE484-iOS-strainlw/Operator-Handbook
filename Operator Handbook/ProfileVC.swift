//
//  ProfileVC.swift
//  Operator Handbook
//
//  Created by Loki Strain on 8/15/21.
//

import Foundation
import UIKit
import Firebase

class ProfileVC: UIViewController {
    
    var lanID: String!
    var usersRef = Firestore.firestore().collection("Users")
    var userRef: DocumentReference!
    var userSnapshot: DocumentSnapshot!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var lanIDLabel: UILabel!
    @IBOutlet weak var cellLabel: UILabel!
    @IBOutlet weak var teamLeadLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.lanID = (tabBarController as! ClassesTBC).lanID
        userRef = usersRef.document(lanID)
        
        userRef.getDocument { documentSnapshot, error in
            if let error = error{
                print("Error getting user\(error)")
                return
            } else {
                let data = documentSnapshot?.data()
                let firstName = data!["firstName"]
                let lastName = data!["lastName"]
                let cell = data!["cell"]
                let teamLead = data!["below"]
                self.nameLabel.text = ("\(firstName as! String) \(lastName as! String)")
                self.lanIDLabel.text = self.lanID
                self.cellLabel.text = (cell as! String)
                self.teamLeadLabel.text = (teamLead as! String)
                
            }
            
        }
        
        
        
        
        
        
    }
    
}

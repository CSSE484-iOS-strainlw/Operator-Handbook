//
//  LearnHomeVC.swift
//  Operator Handbook
//
//  Created by Loki Strain on 8/15/21.
//

import Foundation
import UIKit
import Firebase
import SideMenu

class LearnHomeVC: UIViewController {
    
    var lanID: String!
    var usersRef: CollectionReference!
    var userRef: DocumentReference!
    var cellRef: DocumentReference!
    var cellSnapshot: DocumentSnapshot!
    var lessonsSegueIdentifier = "LessonsSegueIdentifier"
    var userSnapshot: DocumentSnapshot!
    var admin: String!
    
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var cellLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        lanID = (tabBarController as! ClassesTBC).lanID
        usersRef = Firestore.firestore().collection("Users")
        userRef = usersRef.document(lanID)
        cellRef = Firestore.firestore().collection("Cells").document((tabBarController as! ClassesTBC).cell)
        
        
        self.imageView.image = UIImage(named: "\(cellRef.documentID).jpg")
        
        cellRef.getDocument { documentSnapshot, error in
            if let error = error{
                print("Error getting user\(error)")
                return
            } else {
                self.cellSnapshot = documentSnapshot
                print(self.cellRef.documentID)
                let data = self.cellSnapshot?.data()
                let admin = data!["admin"] as! String
                self.cellLabel.text = self.cellSnapshot.documentID
                self.admin = admin
            }
        }
        
    }
    
}

//
//  LessonsTVC.swift
//  Operator Handbook
//
//  Created by Loki Strain on 8/15/21.
//

import Foundation
import UIKit
import Firebase
import SideMenu

class LessonsTVC: UITableViewController {
    
    var lanID: String!
    var lessonsListener: ListenerRegistration!
    var lessonsRef: CollectionReference!
    var cell: String!
    var userRef: DocumentReference!
    var userSnapshot: DocumentSnapshot!
    var lessons = [Lesson]()
    var lessonCellSegueIdentifier = "LessonCellSegueIdentifier"
    var admin: String!
    var cellRef: DocumentReference!
    
    
    var learnViewController: ClassesTBC{
        let navController = presentingViewController as! UINavigationController
        return navController.viewControllers.last as! ClassesTBC
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.cell = learnViewController.cell
        self.lanID = learnViewController.lanID
        self.userRef = Firestore.firestore().collection("Users").document(lanID)
        self.cellRef = Firestore.firestore().collection("Cells").document(cell)
        self.lessonsRef = Firestore.firestore().collection("Cells").document(self.cell).collection("Lessons")
        
        tableView.allowsSelectionDuringEditing = true
        
        self.userRef.getDocument { documentSnapshot, error in
            if let error = error{
                print("Error getting user\(error)")
                return
            }
            if let documentSnapshot = documentSnapshot{
                
                self.userSnapshot = documentSnapshot
                self.lessonsStartListening(self)
                
                
            }
        }
            self.cellRef.getDocument { documentSnapshot, error in
                if let error = error{
                    print("Error getting user\(error)")
                    return
                }
                if let documentSnapshot = documentSnapshot{
                    
                    self.userSnapshot = documentSnapshot
                    let data = self.userSnapshot?.data()
                    self.admin = (data!["admin"] as! String)
                    
                    print(self.admin)
                    print(self.lanID)
                        
                        if self.admin == self.lanID {
                            
                            self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.showAddLessonDialogue))
                            self.navigationItem.leftBarButtonItem = self.editButtonItem
                        }
                    
                }
            
        }
        
        
        
        
    }
    
    
    @objc func showAddLessonDialogue() {
        
        let alertController = UIAlertController(title: "Add a new lesson", message: "Be sure to add files", preferredStyle: .alert)
        
        // configure
        alertController.addTextField { (textField) in
            textField.placeholder = "Name"
        }
        alertController.addTextField { (textField) in
            textField.placeholder = "Documents (seperated by comma)"
        }
        alertController.addTextField { (textField) in
            textField.placeholder = "Images (seperated by comma)"
        }
        alertController.addTextField { (textField) in
            textField.placeholder = "Videos (seperated by comma)"
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let submitAction = UIAlertAction(title: "Create Lesson", style: .default) { (action) in
            print("TODO: Create a movie Quote")

            let name = alertController.textFields![0] as UITextField
            let docsString = alertController.textFields![1] as UITextField
            let imagesString = alertController.textFields![2] as UITextField
            let videosString = alertController.textFields![3] as UITextField
            
            let docs = docsString.text?.components(separatedBy: ",")
            let images = imagesString.text?.components(separatedBy: ",")
            let videos = videosString.text?.components(separatedBy: ",")
            
            
            self.lessonsRef.addDocument(data: ["name": name.text!,"docs":docs!, "images": images!, "author": self.lanID!, "videos": videos!,"lastEdited": Timestamp.init()])
            self.tableView.reloadData()
        }
        alertController.addAction(submitAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        
    }
    
    func lessonsStartListening(_ viewController: LessonsTVC){
        
        if(lessonsListener != nil){
            lessonsListener.remove()
        }
        
        
        lessonsListener = lessonsRef.addSnapshotListener( { (querySnapshot, error) in
            if let querySnapshot = querySnapshot{
                
                querySnapshot.documents.forEach { (documentSnapshot) in
                    print(documentSnapshot.documentID)
                    self.lessons.append(Lesson(documentSnapshot))
                    
                }
            }else {
                print(error!)
                return
                
            }
            self.tableView.reloadData()
        })
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lessons.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> LessonCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LessonCell", for: indexPath) as! LessonCell
        
        cell.textLabel?.text = lessons[indexPath.row].name
        
        cell.id = lessons[indexPath.row].id
        cell.tableViewController = self
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.isEditing{
            editCellName(indexPath.row)
        }else{
            performSegue(withIdentifier: lessonCellSegueIdentifier, sender: self)
        }
    }
    
    func editCellName(_ index: Int){
        
        let alertController = UIAlertController(title: "Edit Lesson", message: "", preferredStyle: .alert)
        
        // configure
        alertController.addTextField { (textField) in
            textField.placeholder = "Name"
            textField.text = self.lessons[index].name
        }
        alertController.addTextField { (textField) in
            textField.placeholder = "Documents (seperated by comma)"
            textField.text = self.lessons[index].docs.joined(separator: ",")
        }
        alertController.addTextField { (textField) in
            textField.placeholder = "Images (seperated by comma)"
            textField.text = self.lessons[index].images.joined(separator: ",")
        }
        alertController.addTextField { (textField) in
            textField.placeholder = "Videos (seperated by comma)"
            textField.text = self.lessons[index].videos.joined(separator: ",")
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let submitAction = UIAlertAction(title: "Create Lesson", style: .default) { (action) in
            print("TODO: Create a movie Quote")

            let name = alertController.textFields![0] as UITextField
            let docsString = alertController.textFields![1] as UITextField
            let imagesString = alertController.textFields![2] as UITextField
            let videosString = alertController.textFields![3] as UITextField
            
            
            let docs = docsString.text?.components(separatedBy: ",")
            let images = imagesString.text?.components(separatedBy: ",")
            let videos = videosString.text?.components(separatedBy: ",")
            
            
            self.lessonsRef.document(self.lessons[index].id).updateData(["name": name.text!,"docs":docs!, "images": images!, "author": self.lanID!, "videos": videos!,"lastEdited": Timestamp.init()])
            self.tableView.reloadData()
        }
        alertController.addAction(submitAction)
        
        present(alertController, animated: true, completion: nil)
    }
        
    
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return lanID == admin
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            //            movieQuotes.remove(at: indexPath.row)
            //            tableView.reloadData()
            let lessonToDelete = lessons[indexPath.row]
            lessonsRef.document(lessonToDelete.id).delete()
            lessons.remove(at: indexPath.row)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == lessonCellSegueIdentifier{
            if let index = self.tableView.indexPathForSelectedRow?.row{
            (segue.destination as! LessonViewController).lesson = self.lessons[index]
        }
    }
    
    
    
}

}

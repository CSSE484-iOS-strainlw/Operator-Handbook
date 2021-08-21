//
//  Lesson.swift
//  Operator Handbook
//
//  Created by Loki Strain on 8/16/21.
//

import Foundation
import Firebase

class Lesson {
    
    var author: String
    var name: String
    var docs: [String]
    var images: [String]
    var videos: [String]
    var id: String
    
    init(_ documentSnapshot: DocumentSnapshot){
        
        let data = documentSnapshot.data()
        id = documentSnapshot.documentID
        author = data!["author"] as! String
        name = data!["name"] as! String
        docs = data!["docs"] as! [String]
        images = data!["images"] as! [String]
        videos = data!["videos"] as! [String]
        
    }
        
}

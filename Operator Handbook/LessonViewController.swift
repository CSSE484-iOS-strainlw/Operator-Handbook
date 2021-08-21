//
//  LessonViewController.swift
//  Operator Handbook
//
//  Created by Loki Strain on 8/18/21.
//

import Foundation
import UIKit
import PDFKit

class LessonViewController: UIViewController {
    
    var lesson: Lesson!
    var supSegueIdentifier = "SupSegueIdentifier"
    
    
    @IBOutlet weak var pdfView : PDFView?
    
    override func viewWillAppear(_ animated: Bool) {
        
        let documentName = self.lesson.id
        
        guard let path = Bundle.main.url(forResource: documentName, withExtension: "pdf") else { return }

        if let document = PDFDocument(url: path) {
            pdfView!.document = document
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == supSegueIdentifier {
            (segue.destination as! SupTVC).lesson = self.lesson
        }
    }
    
}

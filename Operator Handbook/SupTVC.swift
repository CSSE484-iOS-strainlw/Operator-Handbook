//
//  SupplementalVC.swift
//  Operator Handbook
//
//  Created by Loki Strain on 8/18/21.
//

import Foundation
import UIKit
import AVKit
import AVFoundation

class SupTVC: UITableViewController {
    
    var lesson: Lesson!
    var player = AVPlayer()
    var playerViewController = AVPlayerViewController()

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lesson.videos.count
    }
    
    @IBAction func pressedDone(_ sender: Any) {
        let popView = (navigationController?.viewControllers[2])!
        self.navigationController?.popToViewController(popView, animated: true)
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VideoCell", for: indexPath) as! VideoCell
        cell.video = lesson.videos[indexPath.row]
        cell.textLabel?.text = cell.video
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedVideo = lesson.videos[indexPath.row]
        
        let videoPath = Bundle.main.url(forResource: "example1", withExtension: "mp4")
        
        print(player)
        print(videoPath!)
        player = AVPlayer(url: videoPath!)
        playerViewController.player = player
        
        present(playerViewController, animated: true, completion: nil)
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
//    func playVideo(_ indexPath: IndexPath){
//        let selectedVideo = lesson.videos[indexPath.row]
//        print(selectedVideo)
//        guard let videoPath = Bundle.main.url(forResource: selectedVideo, withExtension: "mp4") else { return }
//        player = AVPlayer(url: videoPath)
//        playerViewController!.player = player
//        print(player)
//        print(videoPath)
//        self.performSegue(withIdentifier: "Video", sender: self)
//    }
    
    override func viewDidAppear(_ animated: Bool) {
        
}

}

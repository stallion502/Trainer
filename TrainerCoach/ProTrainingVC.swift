//
//  ProTrainingVC.swift
//  TrainerCoach
//
//  Created by User on 08/07/2017.
//  Copyright © 2017 User. All rights reserved.
//

import UIKit
import SwiftyJSON
import YouTubePlayer
import FirebaseStorageUI

class ProTrainingVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var proData: [JSON]?
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet var exerciseView: UIView!
    var youTubePlayer: YouTubePlayerView?
    static var storage: Storage = Storage.storage(url: "gs://personalcoach-edc0d.appspot.com")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    func configure(){
        youTubePlayer = YouTubePlayerView(frame: CGRect(x:0, y:0, width: view.frame.size.width - 32, height: CGFloat(exerciseView.frame.size.height / 2 - 50)))
        exerciseView.addSubview(youTubePlayer!)
        youTubePlayer?.loadVideoURL(URL(string:"https://www.youtube.com/watch?v=klssdO_jB88?start=1275&end=1302")!)
        exerciseView?.alpha = 0
    }

    @IBAction func playVideoView(_ sender: UITapGestureRecognizer) {
        youTubePlayer?.play()
        youTubePlayer?.seekTo(1275, seekAhead: true)
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
       return (proData?.count)!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (proData?[section]["exercises"].count)!
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "header")
        cell?.tag = section
        cell?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(headerToggled)))
        cell?.textLabel?.text = proData?[section]["title"].stringValue
        return cell
    }
    
    func headerToggled(_ sender: UITapGestureRecognizer){
        let dynamicTrainVC = self.storyboard?.instantiateViewController(withIdentifier: "DynamicTrainVC") as! DynamicTrainVC
        dynamicTrainVC.data = proData?[(sender.view?.tag)!]["exercises"].arrayValue
        navigationController?.pushViewController(dynamicTrainVC, animated: true)

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let json = proData?[indexPath.section]["exercises"].arrayValue
        cell.textLabel?.text = json?[indexPath.row].stringValue
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.4) { 
            self.exerciseView.alpha = 1
        }
        let resultString = getURLString(withIndexPath: indexPath)
        let reference = ProTrainingVC.storage.reference(withPath: resultString! + ".jpg")
        imageView.sd_setImage(with: reference, placeholderImage: nil)

    }
    
    func getURLString(withIndexPath indexPath: IndexPath) -> String? {
        let json = proData?[indexPath.section]["exercises"].arrayValue
        let stringToSearch = json?[indexPath.row].stringValue
        var resultString = ""
        for character in (stringToSearch?.characters)! {
            if character != Character("–") {
                resultString += String(character)
                continue
            }
            resultString.remove(at: resultString.index(before: resultString.endIndex))
            return resultString
        }
        return nil
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

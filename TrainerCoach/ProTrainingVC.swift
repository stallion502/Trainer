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

class ProTrainingVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var proData: [JSON]?
    @IBOutlet weak var videoView: YouTubePlayerView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewWillLayoutSubviews()
        view.backgroundColor = UIColor.white
    }

    @IBAction func playVideoView(_ sender: UITapGestureRecognizer) {
        videoView.loadVideoURL(URL(string:"https://www.youtube.com/watch?v=klssdO_jB88&t=1289s&start=1275&end=1302")!)
        videoView.play()
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
       return (proData?.count)!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (proData?[section]["exercises"].count)!
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "header")
        cell?.textLabel?.text = proData?[section]["title"].stringValue
        return cell
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

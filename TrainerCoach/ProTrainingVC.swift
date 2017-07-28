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

class ProTrainingVC: UIViewController, UITableViewDelegate, UITableViewDataSource, ProTrainingHeaderDelegate {
    
    var proData: [JSON]?
    @IBOutlet weak var tableView: UITableView!
    var titleLabelText: String?
    static var storage: Storage = Storage.storage(url: "gs://personalcoach-edc0d.appspot.com")
    private var images = [#imageLiteral(resourceName: "firstCell"), #imageLiteral(resourceName: "backCell1"), #imageLiteral(resourceName: "backCell4")]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let backButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "backArrow"), style: .plain, target: self, action: #selector(back))
        backButtonItem.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItem = backButtonItem
        self.navigationItem.leftBarButtonItem?.setBackgroundVerticalPositionAdjustment(5, for: .default)
        self.navigationItem.leftBarButtonItem?.imageInsets = UIEdgeInsetsMake(5, 5, 5, 20)
        
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 1, green: 0.1333, blue: 0.1333, alpha: 1)
        let font = UIFont(name: "Avenir-Light", size: 25.0)
        let attributeFontSaySomething : [String : Any] = [NSFontAttributeName : font!, NSForegroundColorAttributeName: UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = attributeFontSaySomething
    }
    
    func back() {
        self.navigationController?.popViewController(animated: true)
    }

    
    func numberOfSections(in tableView: UITableView) -> Int {
       return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return proData!.count
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let heightRatio = UIScreen.main.bounds.height / 568
        return heightRatio * 150
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "header", for: indexPath) as! ProTrainingHeader
        
        if indexPath.row%2 == 0 {
            cell.backgroundColor = UIColor.white
            cell.leftConstraint.constant = 12
            cell.rightConstaint.constant = 150
            
            cell.secondLeftConstraint.constant = 12
            cell.secondRightConstraint.constant = 150
        }
        else {
            cell.backgroundColor = UIColor.white
            cell.leftConstraint.constant = 150
            cell.rightConstaint.constant = 12
            cell.mainLabel?.textColor = .white
            cell.mainLabel.textAlignment = .right
            cell.title.textAlignment = .right
            cell.containerView.backgroundColor = UIColor.black
            cell.title?.textColor = UIColor.lightGray
            cell.secondLeftConstraint.constant = 150
            cell.secondRightConstraint.constant = 12
        }
        
        let mainLabel = getURLString(withIndexPath: indexPath, false)
        let titleString = getURLString(withIndexPath: indexPath, true)
        cell.checkedButton.isHidden = !isButtonVisibleFor(indexPath)
        cell.mainLabel?.text = mainLabel
        cell.title?.text = titleString
        cell.delegate = self
        cell.indexPath = indexPath
        cell.imageViewX.image = images[indexPath.row]
        cell.containerView.layer.cornerRadius = 7
        cell.containerView.layer.masksToBounds = true
        cell.containerView.dropShadow()
        return cell
    }
    
    func didSelectHeader(_ indexPath: IndexPath) {
        
        let dynamicTrainVC = self.storyboard?.instantiateViewController(withIdentifier: "DynamicTrainVC") as! DynamicTrainVC
        dynamicTrainVC.data = proData?[indexPath.row]["exercises"].arrayValue
        dynamicTrainVC.titleLabelText = self.titleLabelText
        dynamicTrainVC.week = indexPath.row
        navigationController?.pushViewController(dynamicTrainVC, animated: true)

    }
    
    func getURLString(withIndexPath indexPath: IndexPath, _ before:Bool) -> String? {
        let stringToSearch = proData?[indexPath.row]["title"].stringValue
        let index = stringToSearch?.characters.index(of: "–")
        let nextIndex = stringToSearch?.index(after: index!)
        
        if before == false{
            return stringToSearch?.substring(from: nextIndex!)
        }
        return stringToSearch?.substring(with:(stringToSearch?.startIndex)!..<index!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
 
    func buttonTapedFor(_ indexPath: IndexPath) {
        print(indexPath)
        
        UserDefaults.standard.object(forKey: titleLabelText!)
        
        let annotationView = AnnotationView(frame: self.view.bounds)
        annotationView.transform = CGAffineTransform(translationX: 1000, y: 0)
        self.view.addSubview(annotationView)
        
        UIView.animate(withDuration: 0.8, delay: 0.3, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.7, options: [], animations: { 
            annotationView.transform = .identity
        })
    }
    
    func isButtonVisibleFor(_ indexPath:IndexPath) -> Bool {
        if let exercise = UserDefaults.standard.object(forKey: titleLabelText!) as? NSDictionary {
            if let week = exercise["\(indexPath.row)"] {
                return true
            }
        }
        return false
    }
}

extension UIView {
    
    func dropShadow(scale: Bool = true) {
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.layer.shadowRadius = 5.5
        
       // self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
      //  self.layer.shouldRasterize = true
       // self.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}

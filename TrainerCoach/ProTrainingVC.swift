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
import RealmSwift

class ProTrainingVC: UIViewController, UITableViewDelegate, UITableViewDataSource, ProTrainingHeaderDelegate, AnnotationViewDelegate {
    
    var proData: [JSON]?
    @IBOutlet weak var tableView: UITableView!
    var titleLabelText: String?
    static var storage: Storage = Storage.storage(url: "gs://personalcoach-edc0d.appspot.com")
    private var images = [#imageLiteral(resourceName: "firstCell"), #imageLiteral(resourceName: "backCell1"), #imageLiteral(resourceName: "backCell4")]
    @IBOutlet var annotationView: AnnotationView!
    
    
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
        let font = UIFont(name: "Avenir-Light", size: 23.0)
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
        dynamicTrainVC.type = "pro"
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
        let realm = try! Realm()
        let conclusions = realm.objects(Conclusion.self).filter("key = '\(titleLabelText!)'")
        let conclusion = conclusions.filter("week==\(indexPath.row)").first
        navigationController?.setNavigationBarHidden(true, animated: false)
        annotationView.frame = self.view.bounds
        annotationView.titleLabel_1.text = "\(conclusion?.calories ?? 0)"
        annotationView.titleLabel_2.text = conclusion?.time
        annotationView.titleLabel_3.text = "NOGI!" // hardcoded
        annotationView.titleLabel_4.text = "\(conclusion?.exercises ?? 0)"
        annotationView.alpha = 1
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        let date = formatter.string(from: (conclusion?.date)!)
        annotationView.dateLabel.text = "Последняя тренировка: " + date
        annotationView.transform = CGAffineTransform(translationX: 1000, y: 0)
        self.view.addSubview(annotationView)
        
        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.7, options: [], animations: {
            self.annotationView.transform = .identity
        })
        annotationView.delegate = self
    }
    
    func buttonTaped() {
        UIView.animate(withDuration: 0.8, animations: { 
            self.annotationView.alpha = 0
        }) { (bool) in
            self.annotationView.removeFromSuperview()
            self.navigationController?.setNavigationBarHidden(false, animated: true)
        }
    }

    
    func isButtonVisibleFor(_ indexPath:IndexPath) -> Bool {
        let realm = try! Realm()
        let conclusions = realm.objects(Conclusion.self).filter("key = '\(titleLabelText!)'")
        if conclusions.count != 0 {
            for conclusion in conclusions {
                if conclusion.week == indexPath.row && conclusion.type == "pro" {
                return true
            
                }
            }
        }
        return false
    }
    
    deinit {
        print("deinit ProTrainingVC")
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

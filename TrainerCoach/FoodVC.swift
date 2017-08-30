//
//  FoodVC.swift
//  TrainerCoach
//
//  Created by User on 07/08/2017.
//  Copyright © 2017 User. All rights reserved.
//

import UIKit
import FirebaseStorage
import Firebase
import SwiftSoup

class FoodVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewLayout: UICollectionViewFlowLayout!
    let colors = [UIColor.red, UIColor.blue, UIColor.green, UIColor.yellow, UIColor.purple, UIColor.cyan]
    let images = [#imageLiteral(resourceName: "oatmeal_main_2"), #imageLiteral(resourceName: "HK-main"), #imageLiteral(resourceName: "steak-bomb-rice-and-bean-xl-wnbook2014"), #imageLiteral(resourceName: "broiled-flat-iron-steak-brussels-sprouts-sweet-potatoes"), #imageLiteral(resourceName: "breakfast-1209260_1920")]
    let titles = ["Первый завтрак", "Второй завтрак", "Обед", "Полдник", "Ужин"]
    @IBOutlet weak var addButton: UIBarButtonItem!
    var calloryResult: String?
    var fatResult: String?
    var proteinResult: String?
    var uglevodsResult: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // let decodedTeams = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! [Int:Date]
        // UserDefaults.standard.set(dates, forKey: "dates")
        navigationController?.delegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
    //    let layout = collectionViewLayout as UICollectionViewFlowLayout
    //    layout.itemSize = CGSize(width: collectionView.bounds.width, height: 100)
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let _  = UserDefaults.standard.object(forKey: "dates"){
            addButton.isEnabled = false
            addButton.tintColor = UIColor.clear
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! FoodView
        cell.myImageView.image = images[indexPath.row]
        cell.mailLabel.text = titles[indexPath.row]
        // cell.backgroundColor = colors[indexPath.row]
        return cell
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "identifier" {
            let cell = sender as! UICollectionViewCell
            let toVC = segue.destination
            let indexPath = collectionView.indexPath(for: cell)
            toVC.title = "Завтрак"
        }
    }
    
   
    func collectInfo() {
        
        if let myweight = UserDefaults.standard.object(forKey: "userWeight"), let myheight = UserDefaults.standard.object(forKey: "userHeight") {// Double(weight!)
            
            calloryResult = 35 * Int(myweight)
            
            if sex == "man" {
                proteinResult = Int(myweight)*3
                uglevodsResult = Int(myweight)*5
                fatResult = Int(myweight)*1.5
            }
            else {
                proteinResult = Int(myweight)*2
                uglevodsResult = Int(myweight)*4
                fatResult = Int(myweight)
            }
        
            fatResult = Int(myweight)*1.5
            let uglevods = [uglevodsResult/10*4.5, proteinResult/10*2, fatResult/10*5]
            results.append(uglevods)
        
            let proteins = [uglevodsResult/10*4.5, proteinResult/10*4, fatResult/10*4]
            results.append(proteins)
        
            let fats = [uglevodsResult/10*0.5, proteinResult/10*4, fatResult/10*1]
            results.append(fats)
        }
    }
}

extension FoodVC : UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return ListToDetailAnimation()
    }
}

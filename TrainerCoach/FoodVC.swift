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
    let images = [#imageLiteral(resourceName: "oatmeal_main_2"), #imageLiteral(resourceName: "HK-main")]

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.delegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
    //    let layout = collectionViewLayout as UICollectionViewFlowLayout
    //    layout.itemSize = CGSize(width: collectionView.bounds.width, height: 100)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! FoodView
        cell.myImageView.image = indexPath.row%2==0 ? self.images[0] : self.images[1]
        cell.mailLabel.text = indexPath.row%2==0 ? "Breakfast" : "Huekfast"
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
    
}

extension FoodVC : UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return ListToDetailAnimation()
    }
}

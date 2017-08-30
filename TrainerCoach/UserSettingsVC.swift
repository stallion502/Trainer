//
//  UserSettingsVC.swift
//  TrainerCoach
//
//  Created by User on 26/08/2017.
//  Copyright © 2017 User. All rights reserved.
//

import UIKit
import RealmSwift

class UserSettingsVC: UIViewController, UIScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var collectionView: UICollectionView!
    var trainData: [TrainData]?
    var filteredData = [Results<Conclusion>]()
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var imageView: UIImageView!
    var picker = UIImagePickerController()
    @IBOutlet weak var mainView: UIViewX!
    @IBOutlet weak var photoButton: UIButton!
    @IBOutlet weak var textfield: UITextField!
    @IBOutlet weak var transparantVIew: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
       // scrollView.contentSize = CGSize(width: view.frame.width, height: 930) // (view.frame.width, 930)
        scrollView.delegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 50
        picker.delegate = self
        textfield.delegate = self
        transparantVIew.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(presentImagePicker)))

     /*   ExercisesData.getProTraining { (proTrainig) in
            self.trainData = proTrainig
            self.parseData()
           DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }*/
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        ExercisesData.getProTraining { (proTrainig) in
            self.trainData = proTrainig
            self.parseData()
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
        imageView.isHidden = true
        
        if let name = UserDefaults.standard.object(forKey: "name") as? String {
            textfield.text = name
            textfield.borderStyle = .none
        }
        
        if let decodedImage = UserDefaults.standard.object(forKey: "image") as? Data {
            imageView.isHidden = false
            mainView.isHidden = true
            photoButton.isHidden = true
            let image = NSKeyedUnarchiver.unarchiveObject(with: decodedImage) as! UIImage
            imageView.image = image
        }
        
        if let decoded  = UserDefaults.standard.object(forKey: "dates") as? Data {
            let dates = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! [Int: Date]
            var i = 0
            stackView.subviews.forEach { (view) in
                if let date = dates[i] {
                    var calendar = Calendar.current
                    calendar.timeZone = TimeZone(abbreviation: "GMT")!
                    let componenets = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date)
                    if let hour = componenets.hour, let minute = componenets.minute {
                        let titleM = minute < 10 ? "0\(minute)" : "\(minute)"
                        let titleH = hour < 10 ? "0\(hour)" : "\(hour)"
                        (view.subviews.first as! UILabel).text = titleM + ":" + titleH
                    }
                }
                else {
                    view.isHidden = true
                }
                i+=1
            }
        }
        else {
            stackView.subviews.forEach({ (view) in
                (view.subviews.first as! UILabel).text = "-"
            })
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        UserDefaults.standard.set(textfield.text, forKey: "name")
        self.textfield.borderStyle = .none
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if trainData != nil {
            if (trainData?.count)! + 1 > 3 {
                return trainData!.count + 1
            }
        }
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! UserSettingsCell
        let count = indexPath.row == 0 ? 25 : 3
        let title = indexPath.row == 0 ? "Daily" : trainData?[indexPath.row - 1].title
        var number = 0
        if filteredData.indices.contains(indexPath.row) {
            number = filteredData[indexPath.row].count
        }
        cell.circularProgress.animate(fromAngle: 0.1, toAngle: Double(360/count*number), duration: 1.5, completion: nil)
        cell.labelProgress.text = "\(title?.components(separatedBy: " ").first ?? "") Progress\n\(Int(100*number/count))%"
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func parseData() {
        filteredData.removeAll()
        let realm = try! Realm()
        let userTrain = realm.objects(Conclusion.self).filter("key = 'Тренировка'")
        filteredData.append(userTrain)
        
        for data in trainData! {
            var conclusions = realm.objects(Conclusion.self)
            
            if conclusions.count > 0 {
                conclusions = conclusions.filter("key = '\(data.title)'")
                if conclusions.count > 0 {
                    filteredData.append(conclusions)
                }
            }
        }
    }
    
    @IBAction func trainProgramAction(_ sender: UIButton) {//may not work
        let toVC = storyboard?.instantiateViewController(withIdentifier: "InitialUserVC") as! InitialUserVC
        navigationController?.pushViewController(toVC, animated: true)
    }
    
    @IBAction func changeScheduleAction(_ sender: UIButton) {
        let toVC = storyboard?.instantiateViewController(withIdentifier: "AddScheduleVC") as! AddScheduleVC
        navigationController?.pushViewController(toVC, animated: true)
    }
    
    @IBAction func countCalloryAction(_ sender: UIButton) {
        
        if let decoded  = UserDefaults.standard.object(forKey: "headers") as? Data {
            let headers = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! [[[String:String]]]
            let decodedWeight  = UserDefaults.standard.object(forKey: "weight") as? Data
            let decodedSex  = UserDefaults.standard.object(forKey: "sex") as? Data
            let sex = NSKeyedUnarchiver.unarchiveObject(with: decodedSex!) as! String
            let weight = NSKeyedUnarchiver.unarchiveObject(with: decodedWeight!) as! String
            let toVC = storyboard?.instantiateViewController(withIdentifier: "CalloryResultsVC") as! CalloryResultsVC
            toVC.headers = headers
            toVC.weight = weight
            toVC.sex = sex
            navigationController?.pushViewController(toVC, animated: true)
        }
        else {
            tabBarController?.selectedIndex = 2
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
       let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        photoButton.isHidden = true
        mainView.isHidden = true
        imageView.isHidden = false
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(presentImagePicker)))
        imageView.image = chosenImage
        let encodedImage = NSKeyedArchiver.archivedData(withRootObject: chosenImage)
        UserDefaults.standard.set(encodedImage, forKey: "image")
        dismiss(animated: true, completion: nil)

    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    func presentImagePicker() {
        
        let alertController = UIAlertController(title: "Выберите фото", message: "", preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Камера", style: .default) {
            (result : UIAlertAction) -> Void in
            self.picker.allowsEditing = false
            self.picker.sourceType = .camera
            self.picker.cameraCaptureMode = .photo
            self.present(self.picker, animated: true, completion: nil)
        }
        
        let cancelAction = UIAlertAction(title: "Назад", style: .cancel) { action in
            //self.dismiss(animated: true, completion: nil)
        }
        let libraryAction = UIAlertAction(title: "Библиотека", style: UIAlertActionStyle.default) {
            (result : UIAlertAction) -> Void in
            self.picker.allowsEditing = false
            self.picker.sourceType = .photoLibrary
            self.present(self.picker, animated: true, completion: nil)
        }
        
        alertController.addAction(cameraAction)
        alertController.addAction(libraryAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }

}

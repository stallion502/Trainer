//
//  InitialResultCalloryVC.swift
//  TrainerCoach
//
//  Created by User on 21/08/2017.
//  Copyright © 2017 User. All rights reserved.
//

import UIKit

class InitialResultCalloryVC: UIViewController {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var firstImageView: UIImageView!
    @IBOutlet weak var secondImageView: UIImageView!
    @IBOutlet weak var firstView: UIView!
    @IBOutlet weak var secondView: UIView!
    
    var selected = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        let font = UIFont(name: "Avenir-Light", size: 18.0)
        let attributeFontSaySomething : [String : Any] = [NSFontAttributeName : font!, NSForegroundColorAttributeName: UIColor.white]
        textField.attributedPlaceholder = NSAttributedString(string: "Вес", attributes: attributeFontSaySomething)
        firstImageView.tintColor = UIColor.white
        secondImageView.tintColor = UIColor.white
        
        firstView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(manChosen(_:))))
        secondView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(womanChosen(_:))))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
     func manChosen(_ sender: UITapGestureRecognizer) {
        
        if selected == "woman"
        {
            secondImageView.tintColor = UIColor.white
            secondView.alpha = 1
            UIView.animate(withDuration: 0.3) {
                self.secondImageView.transform = .identity
                self.secondView.transform = .identity
            }
        }
        firstImageView.tintColor = UIColor.black
        firstImageView.alpha = 0.7
        UIView.animate(withDuration: 0.3) {
            self.firstImageView.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)
            self.firstView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        }
        selected = "man"
    }

    func womanChosen(_ sender: UITapGestureRecognizer) {
        
        if selected == "man"
        {
            firstImageView.tintColor = UIColor.white
            firstImageView.alpha = 1
            UIView.animate(withDuration: 0.3) {
                self.firstImageView.transform = .identity
                self.firstView.transform = .identity
            }
        }
        secondImageView.tintColor = UIColor.black
        secondImageView.alpha = 0.7
        UIView.animate(withDuration: 0.3) {
            self.secondImageView.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)
            self.secondView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        }
        selected = "woman"
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if textField.text == "" || textField.text == nil{
            textField.shake()
            return false
        }
        if selected == "" {
            firstView.shake()
            secondView.shake()
            return false
        }
        return true
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let toVC = segue.destination as! CountCalloryVC
        toVC.weight = textField.text
        toVC.sex = selected
    }
 

}

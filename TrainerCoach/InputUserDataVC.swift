//
//  InputUserDataVC.swift
//  TrainerCoach
//
//  Created by User on 28/07/2017.
//  Copyright © 2017 User. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class InputUserDataVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var stackView: UIStackView!
    var texts = [String]()
    var phTexts = ["Рост", "Вес", "Бицепс", "Грудная клетка", "Талия", "Бедро"]
    var popUpViewTexts = ["Программа с упором на руки", "Программа с упором на грудь", "Кардио программа", "Программа с упором на ноги"]
    @IBOutlet weak var blurEffect: UIVisualEffectView!
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet var popUp: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        popUp.layer.cornerRadius = 5
        popUp.layer.masksToBounds = true
        blurEffect.isHidden = true
        var i = 0
        let font = UIFont(name: "Avenir-Light", size: 18.0)
        let attributeFontSaySomething : [String : Any] = [NSFontAttributeName : font!, NSForegroundColorAttributeName: UIColor.white]
        stackView.subviews.forEach { (textfield) in
            (textfield as! UITextField).attributedPlaceholder = NSAttributedString(string: phTexts[i], attributes: attributeFontSaySomething)
            i+=1
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        let backButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "backArrow"), style: .plain, target: self, action: #selector(back))
        backButtonItem.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItem = backButtonItem
        self.navigationItem.leftBarButtonItem?.setBackgroundVerticalPositionAdjustment(5, for: .default)
        self.navigationItem.leftBarButtonItem?.imageInsets = UIEdgeInsetsMake(5, 5, 5, 20)
        
    }
    
    func animateIn() {
        popUp.alpha = 0
        popUp.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        popUp.center = view.center
        mainLabel.text = popUpViewTexts[countTraining()]
        view.addSubview(popUp)
        
        UIView.animate(withDuration: 0.4) { 
            self.blurEffect.isHidden = false
            self.popUp.alpha = 1
            self.popUp.transform = .identity
        }
    }
    
    func back() {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func goOnAction(_ sender: UIButton) {
        
        if shouldGoNextVC() {
            collectText()
            animateIn()
        }
        

    }
    
    func collectText() {
        var i = 0
        let font = UIFont(name: "Avenir-Light", size: 18.0)
        let attributeFontSaySomething : [String : Any] = [NSFontAttributeName : font!, NSForegroundColorAttributeName: UIColor.white]
        stackView.subviews.forEach { (textfield) in
            (textfield as! UITextField).attributedPlaceholder = NSAttributedString(string: phTexts[i], attributes: attributeFontSaySomething)
            texts.append((textfield as! UITextField).text!)
            i+=1
            
        }
    }

    @IBAction func backButtonAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    func countTraining() -> Int {
        let weight = Double(texts[1])
        let height = Double(texts[0])
        
        var minimumSpacingAr = [Double]()
        let variable = weight! / height!
        
        let closest = UserAttributes.keys.enumerated().min( by: { abs($0.1 - variable) < abs($1.1 - variable) } )!
        print(closest.element) // 7
        let perfectAttributes = UserAttributes.attributeDictionary[closest.element] as! [Double]
        print(closest.offset) // 2
        texts.remove(at: 0)
        texts.remove(at: 0)
        for i in 0...texts.count-1 {
            minimumSpacingAr.append(perfectAttributes[i] - Double(texts[i])!)
        }
        return minimumSpacingAr.index(of: minimumSpacingAr.min()!)!
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let toVC = segue.destination as! MainUserVC
        toVC.userAttributes = texts
    }
    
    func shouldGoNextVC() -> Bool {
        var isAllowed = true
        stackView.subviews.forEach { (textField) in
            let text = (textField as! UITextField).text
            if ((text?.isEmpty)! || Int(text!)! < 30 || Int(text!)! > 230) {
                isAllowed = false
                textField.shake()
                textField.layer.borderWidth = 0.5
                textField.layer.add(Pulsing.notAllowedColor(), forKey: "borderColorTF")
            }
        }
        return isAllowed
    }
    
}

extension UIView {
    func shake() {
        self.transform = CGAffineTransform(translationX: 15, y: 0)
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            self.transform = CGAffineTransform.identity
        }, completion: nil)
    }
}

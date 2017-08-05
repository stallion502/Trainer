//
//  InitialUserVC.swift
//  TrainerCoach
//
//  Created by User on 01/08/2017.
//  Copyright © 2017 User. All rights reserved.
//

import UIKit

class InitialUserVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var headerImageView: UIImageView!
    var headerMaskLayer = CAShapeLayer()
    @IBOutlet weak var tableView: UITableView!
    let texts = ["С упором на руки", "С упором на грудь", "Кардио программа", "С упором на ноги", "Стандартная"]
    @IBOutlet weak var blurEffectView: UIVisualEffectView!
    @IBOutlet var popUp: UIView!
    @IBOutlet weak var mainlabel: UILabel!
    var program:String?
    var visualEffect: UIVisualEffect?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.delegate = self
        self.popUp.layer.cornerRadius = 5
        self.popUp.layer.masksToBounds = true
        updateHeaderImagerView()
        blurEffectView.isHidden = true
        tableView.delegate = self
        tableView.dataSource = self
        headerImageView.layer.mask = headerMaskLayer
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateHeaderImagerView(){
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: 0, y: 0))
        bezierPath.addLine(to: CGPoint(x: headerImageView.frame.width, y: 0))
        bezierPath.addLine(to: CGPoint(x: headerImageView.frame.width, y: headerImageView.frame.height))
        bezierPath.addLine(to: CGPoint(x: 0, y: headerImageView.frame.height - 40))
        headerMaskLayer.fillColor = UIColor.black.cgColor
        headerMaskLayer.path = bezierPath.cgPath
        headerMaskLayer.shadowRadius = 6
        headerMaskLayer.shadowColor = UIColor.red.cgColor
        headerMaskLayer.shadowOpacity = 1.0
        headerMaskLayer.shadowOffset = .zero
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as! UserCell
        cell.myLabel?.text = texts[indexPath.row]
        program = "default_program" // Hardcoded
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       animateIn(texts[indexPath.row])
    }
    
    func animateIn(_ name:String) {
        popUp.alpha = 0
        popUp.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        popUp.center = view.center
        popUp.dropShadow()
        mainlabel.text = name
        view.addSubview(popUp)
        self.blurEffectView.isHidden = false
        UIView.animate(withDuration: 0.4) {
            self.popUp.alpha = 1
            self.popUp.transform = .identity
        }
    }
    
    @IBAction func goOnAction(_ sender: UIButton) {
        let toVC = self.storyboard?.instantiateViewController(withIdentifier: "MainUserVC") as! MainUserVC
        toVC.program = program
        navigationController?.pushViewController(toVC, animated: true)
    }
    
    @IBAction func goBackAction(_ sender: Any) {
        UIView.animate(withDuration: 0.4, animations: { 
            self.popUp.alpha = 0
            self.blurEffectView.isHidden = true
        }, completion:{ bool in
            self.popUp.removeFromSuperview()
        })
    }

}

extension InitialUserVC : UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return ListToDetailAnimation()
    }
}

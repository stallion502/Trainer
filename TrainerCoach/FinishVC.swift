//
//  FinishVC.swift
//  TrainerCoach
//
//  Created by User on 21/07/2017.
//  Copyright © 2017 User. All rights reserved.
//

import UIKit
import KDCircularProgress

class FinishVC: UIViewController {

    @IBOutlet weak var iphoneView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var progressView: KDCircularProgress!
    @IBOutlet weak var InsideProgressView: UIView!
    @IBOutlet weak var mainLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationItem.hidesBackButton = true
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 1, green: 0.1333, blue: 0.1333, alpha: 1)
        let font = UIFont(name: "Avenir-Light", size: 25.0)
        let attributeFontSaySomething : [String : Any] = [NSFontAttributeName : font!, NSForegroundColorAttributeName: UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = attributeFontSaySomething
        navigationController?.title = "Results"
       
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func configureView() {
        iphoneView.layer.cornerRadius = 3
        iphoneView.layer.masksToBounds = true
        var coeff = 2.0
        
        let maxWidth = max(UIScreen.main.bounds.width, UIScreen.main.bounds.height)
        
        if maxWidth > 568 {
            coeff = 1.4
        }
        
        if maxWidth >= 735 {
            coeff = 1.2
        }
        
        
        InsideProgressView.layer.cornerRadius = InsideProgressView.frame.size.width / CGFloat(coeff)//progressView.cor
        InsideProgressView.layer.masksToBounds = true
    }
    
    @IBAction func finishAction(_ sender: UIButton) {
    }


}

//
//  InputUserDataVC.swift
//  TrainerCoach
//
//  Created by User on 28/07/2017.
//  Copyright © 2017 User. All rights reserved.
//

import UIKit

class InputUserDataVC: UIViewController {

    @IBOutlet weak var stackView: UIStackView!
    var texts = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)

    }
    
    func collectText() {
        stackView.subviews.forEach { (textfield) in
            texts.append((textfield as! UITextField).text!)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        collectText()
        let toVC = segue.destination as! MainUserVC
        toVC.userAttributes = texts
    }
 

}

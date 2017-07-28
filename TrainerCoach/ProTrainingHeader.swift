//
//  ProTrainingHeader.swift
//  TrainerCoach
//
//  Created by User on 26/07/2017.
//  Copyright © 2017 User. All rights reserved.
//

import Foundation

protocol ProTrainingHeaderDelegate: class {
    func buttonTapedFor(_ indexPath:IndexPath)
    func didSelectHeader(_ indexPath:IndexPath)
}

class ProTrainingHeader: UITableViewCell {
    
    weak var delegate: ProTrainingHeaderDelegate?
    @IBOutlet weak var imageViewX: UIImageViewX!
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var rightConstaint: NSLayoutConstraint!
    @IBOutlet weak var leftConstraint: NSLayoutConstraint!
    @IBOutlet weak var secondLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var secondRightConstraint: NSLayoutConstraint!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var checkImageView: UIImageView!
    var indexPath: IndexPath? {
        didSet {
            containerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectHeader)))
        }
    }
    @IBOutlet weak var checkedButton: UIButtonX!

    @IBAction func taped(_ sender: UIButton) {
        delegate?.buttonTapedFor(self.indexPath!)
    }
    
    func didSelectHeader() {
        delegate?.didSelectHeader(self.indexPath!)
    }
}

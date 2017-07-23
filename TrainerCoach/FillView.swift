//
//  FillView.swift
//  TrainerCoach
//
//  Created by User on 20/07/2017.
//  Copyright © 2017 User. All rights reserved.
//

class FillView: UIButton {
    
    private let fillView = UIView(frame: .zero)
    
    private var coeff:CGFloat = 0.01 {
        didSet {
            // Make sure the fillView frame is updated everytime the coeff changes
            updateFillViewFrame()
        }
    }
    
    // Only needed if view isn't created in xib or storyboard
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // Only needed if view isn't created in xib or storyboard
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    override func awakeFromNib() {
        setupView()
    }
    
    private func setupView() {
        
        // Setup the unfilled backgroundColor
        //UIColor(red: 249.0/255.0, green: 163.0/255.0, blue: 123.0/255.0, alpha: 1.0)
        
        // Setup filledView backgroundColor and add it as a subview
        fillView.backgroundColor = .black /* #ff0022 */   /* #b54200 */ //UIColor(red: 252.0/255.0, green: 95.0/255.0, blue: 95.0/255.0, alpha: 1.0)
        addSubview(fillView)
        
        // Update fillView frame in case coeff already has a value
        updateFillViewFrame()
    }
    
    private func updateFillViewFrame() {
        fillView.frame = CGRect(x:Double(0), y:Double(0), width:Double(bounds.width*coeff), height:Double(bounds.height - 5))
    }
    
    // Setter function to set the coeff animated. If setting it not animated isn't necessary at all, consider removing this func and animate updateFillViewFrame() in coeff didSet
    func setCoeff(coeff: CGFloat, duration:TimeInterval) {
        UIView.animate(withDuration: duration) { 
            self.coeff = coeff
        }
    }
    
}

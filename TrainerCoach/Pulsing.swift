//
//  Pulsing.swift
//  TrainerCoach
//
//  Created by User on 19/07/2017.
//  Copyright © 2017 User. All rights reserved.
//

import Foundation

class Pulsing: CALayer {
    
    var animateionGroup =  CAAnimationGroup()
    var initialPulseScale:Float = 0
    var nextPulseAfter: TimeInterval = 0
    var animationDuration:TimeInterval = 1.5
    var radius:Float = 110
    var numberOfPulses:Float = Float.infinity
    override init(layer: Any) {
        super.init(layer: layer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(nuberOfPulses:Float, position:CGPoint) {
        super.init()
        
        self.contentsScale = UIScreen.main.scale
        self.opacity = 0
        self.position = position
        self.bounds = CGRect(x: Double(0), y: Double(0), width: Double(radius * 2), height: Double(radius * 2))
        self.cornerRadius = CGFloat(radius)
        DispatchQueue.global(qos: .default).async {
            self.createGroupeAnimation()
            
            DispatchQueue.main.async {
                self.add(self.animateionGroup, forKey: "pulse")
            }
        }        
    }
    
    func createOpacityAnimation() -> CABasicAnimation {
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale.xy")
        scaleAnimation.fromValue = 0
        scaleAnimation.toValue = 1
        scaleAnimation.duration = animationDuration
        
        return scaleAnimation
    }
    
    func createScaleAnimation() -> CAKeyframeAnimation {
        let opacityAnimation = CAKeyframeAnimation(keyPath: "opacity")
        opacityAnimation.duration = animationDuration
        opacityAnimation.values = [0.4, 0.8, 0]
        opacityAnimation.keyTimes = [0, 0.2, 1]
        
        return opacityAnimation
    }
    
    func createGroupeAnimation() {
        self.animateionGroup = CAAnimationGroup()
        self.animateionGroup.duration = animationDuration + nextPulseAfter
        self.animateionGroup.repeatCount = numberOfPulses
        
        let defaultCurve = CAMediaTimingFunction(name: kCAMediaTimingFunctionDefault)
        animateionGroup.timingFunction = defaultCurve
        self.animateionGroup.animations = [createOpacityAnimation(), createScaleAnimation()]
    }
}


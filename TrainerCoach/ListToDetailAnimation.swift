//
//  ListToDetailAnimation.swift
//  TrainerCoach
//
//  Created by User on 26/07/2017.
//  Copyright © 2017 User. All rights reserved.
//

import UIKit

class ListToDetailAnimation: NSObject, UIViewControllerAnimatedTransitioning{
    
    private let duration = 0.5
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let fromViewController = transitionContext.viewController(forKey: .from)
        let toViewController = transitionContext.viewController(forKey: .to)
        
        let toView = transitionContext.view(forKey: .to)
        let fromView = transitionContext.view(forKey: .from)
        let container = transitionContext.containerView
        
        container.addSubview(toView!)
        toView?.frame = transitionContext.finalFrame(for: toViewController!)
        toView?.layoutIfNeeded()
        
        toView?.alpha = 0
        
        UIView.animate(withDuration: 0.4, animations: { 
            toView?.alpha = 1
        }) {
            (bool) in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }

    }
    
}

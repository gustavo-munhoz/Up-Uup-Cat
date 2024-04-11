//
//  CustomNavigationAnimator.swift
//  business
//
//  Created by Gustavo Munhoz Correa on 10/04/24.
//

import UIKit

class CustomNavigationAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.25
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from),
              let toView = transitionContext.view(forKey: .to) else {
            transitionContext.completeTransition(false)
            return
        }

        let containerView = transitionContext.containerView
        containerView.addSubview(toView)
        
        toView.alpha = 0

        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            toView.alpha = 1
            fromVC.view.alpha = 0
        }, completion: { finished in
            fromVC.view.alpha = 1
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}


//
//  OpenGalleryAnimator.swift
//  test-gu
//
//  Created by Денис Сизов on 02.11.2021.
//

import Foundation
import UIKit

class OpenGalleryAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    private let duration: TimeInterval = 0.5

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let source = transitionContext.viewController(forKey: .from)
        else { return }
        guard let destination = transitionContext.viewController(forKey: .to)
        else { return }

        let containerViewFrame = transitionContext.containerView.frame
        let sourceViewTargetFrame = CGRect(x: 0,
                                           y: -containerViewFrame.height,
                                           width: source.view.frame.width,
                                           height: source.view.frame.height)
        let destinationViewTargetFrame = source.view.frame

        transitionContext.containerView.addSubview(destination.view)

        destination.view.frame = CGRect(x: 0,
                                        y: containerViewFrame.height,
                                        width: source.view.frame.width,
                                        height: source.view.frame.height)


        UIView
            .animate(withDuration: self.transitionDuration(using: transitionContext),
                     animations: {
                        source.view.frame = sourceViewTargetFrame
                        destination.view.frame = destinationViewTargetFrame
        }) { finished in
            source.removeFromParent()
            transitionContext.completeTransition(finished)
        }


    }
    
}

//
//  CustomNavigationController.swift
//  test-gu
//
//  Created by Сизов Денис on 01.11.2021.
//

import UIKit

final class CustomNavigationController: UINavigationController {
    let interactiveTransition = GalleryInteractiveTransition()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }
}

// MARK: - UINavigationControllerDelegate
extension CustomNavigationController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController,
                              interactionControllerFor animationController: UIViewControllerAnimatedTransitioning)
    -> UIViewControllerInteractiveTransitioning? {
        return interactiveTransition.hasStarted ? interactiveTransition : nil
    }
    
    func navigationController(_ navigationController: UINavigationController,
                              animationControllerFor operation: UINavigationController.Operation,
                              from fromVC: UIViewController,
                              to toVC: UIViewController)
    -> UIViewControllerAnimatedTransitioning? {
        
        var pushAnimator: UIViewControllerAnimatedTransitioning = PushAnimator()
        var popAnimator: UIViewControllerAnimatedTransitioning = PopAnimator()
        
        // тут можно сделать кастомные аниматоры для открытия подробного просмотра фоток
        if toVC is FullscreenViewController {
            pushAnimator = PushAnimator()
            popAnimator = PopAnimator()
        }
        
        if operation == .push {
            self.interactiveTransition.viewController = toVC
            return pushAnimator
        } else if operation == .pop {
            if navigationController.viewControllers.first != toVC {
                self.interactiveTransition.viewController = toVC
            }
            return popAnimator
        }
        return nil
    }
}

//
//  NavigationController.swift
//  CobaltApp
//
//  Created by Jan Slusarz on 12/02/2022.
//

import Foundation
import SwiftUI

protocol NavigationController: UIViewControllerRepresentable {

    func makeUIViewController(context: Context) -> UINavigationController
    func updateUIViewController(_ navigationController: UINavigationController, context: Context)
    func makeCoordinator() -> NavigationStackCoordinator
    func snapShotStackView(navigationController: UINavigationController,
                           dependency: Dependency,
                           router: Router)
    func setInitialView()

}

extension NavigationController {

    func makeUIViewController(context: Context) -> UINavigationController {
        let navigationController = UINavigationController()
        if let coordinator = context.coordinator as? UINavigationControllerDelegate {
            navigationController.delegate = coordinator
        }
        setInitialView()
        return navigationController
    }

    func makeCoordinator() -> NavigationStackCoordinator {
        NavigationStackCoordinator()
    }

    func snapShotStackView(navigationController: UINavigationController,
                           dependency: Dependency,
                           router: Router) {
        let presentedViewControllers = navigationController.viewControllers
        let newViewControllers = router.screens
            .filter { !$0.isModal }
            .map { screen -> UIViewController in
                let viewController = presentedViewControllers.first {
                    $0.title == screen.type.title
                }
                let newVC = StackScreenViewController(dependency: dependency, type: screen.type, router: router)
                return viewController ?? newVC
            }

        navigationController.setViewControllers(newViewControllers, animated: true)

        if router.modalsChanged {
            let newAllModals = router.screens.filter { $0.isModal }
            let previousAllModals = router.previousModals

            let modalsToAdd = newAllModals.filter { !previousAllModals.contains($0) }
            let modalsToDelete = previousAllModals.filter { !newAllModals.contains($0) }

            if modalsToDelete.count == 1 {
                // if there is only one modal to remove
                navigationController.presentedViewController?.dismiss(animated: true, completion: nil)
            } else if modalsToDelete.count > 1 {
                // if there are multiple modals to remove
                print("WARNING: removing multiple modals not handled")
            }

            if newAllModals.count == 1, let modalScreen = newAllModals.first {
                // if there is only one new modal
                let modalVC = StackScreenViewController(dependency: dependency, type: modalScreen.type, router: router)
                modalVC.modalPresentationStyle = .overCurrentContext
                navigationController.present(modalVC, animated: true)
            } else if newAllModals.count > 1 {
                // if there is only one new modal and at least another one is already displayed
                if let modalScreen = newAllModals.last {
                    let modalVC = StackScreenViewController(dependency: dependency, type: modalScreen.type, router: router)
                    modalVC.modalPresentationStyle = .overCurrentContext
                    navigationController.presentedViewController?.present(modalVC, animated: true)
                }
            }

        }
    }

}

final class NavigationStackCoordinator: NSObject, UINavigationControllerDelegate {}

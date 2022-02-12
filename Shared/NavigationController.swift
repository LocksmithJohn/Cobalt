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
            let newVC = StackScreenViewController(dependency: dependency, type: screen.type)
            return viewController ?? newVC
        }

        navigationController.setViewControllers(newViewControllers, animated: true)

        if let screen = router.screens.first(where: { $0.isModal }) {
            let modalVC = StackScreenViewController(dependency: dependency, type: screen.type)
            navigationController.viewControllers.last?.present(modalVC, animated: true)
        } else {
            navigationController.viewControllers.forEach { $0.dismiss(animated: true) }
        }
    }

}

final class NavigationStackCoordinator: NSObject, UINavigationControllerDelegate {}

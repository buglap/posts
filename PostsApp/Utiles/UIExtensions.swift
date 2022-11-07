//
//  UIExtensions.swift
//  PostsApp
//
//  Created by Jenny escobar on 14/11/22.
//

import UIKit

extension UIStackView {
    func removeAllSubviews() {
        subviews.forEach { (view) in
            view.removeFromSuperview()
        }
    }
}

//
//  UIButton+Extension.swift
//  QuizApp
//
//  Created by Daniel Lamprecht on 13.05.21.
//

import Foundation
import UIKit

extension UIButton {
    public func setupCornerRadius(cornerRadius: CGFloat = 20) {
        self.layer.cornerRadius = cornerRadius
    }
}

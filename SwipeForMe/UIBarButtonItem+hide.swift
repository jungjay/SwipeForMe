//
//  UIBarButtonItem+hide.swift
//  SwipeForMe
//
//  Created by Jay Jung on 5/6/21.
//

import UIKit

extension UIBarButtonItem {
    func hide() {
        self.isEnabled = false
        self.tintColor = .clear
    }
}

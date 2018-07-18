//
//  Extension.swift
//  SearchGitHub
//
//  Created by Marcos Suarez on 18/7/18.
//  Copyright © 2018 Marcos Suarez. All rights reserved.
//

import UIKit

extension UIView {
    
    func circular() {
        layer.cornerRadius = min(frame.size.width, frame.size.height)/2
        clipsToBounds = true
    }
    
}

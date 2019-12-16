//
//  CustomViews.swift
//  ZIAPDemo
//
//  Created by Vamsi Kurukuri on 4/11/19.
//  Copyright © 2019 Zimperium. All rights reserved.
//

import Foundation
import UIKit




@IBDesignable class ZRoundButton: UIButton {
    
    
    @IBInspectable var cornerRadius: CGFloat = 15 {
        didSet {
            refreshCorners(value: cornerRadius)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInit()
    }
    
    override func prepareForInterfaceBuilder() {
        sharedInit()
    }
    
    func sharedInit() {
        // Common logic goes here
        refreshCorners(value: cornerRadius)
    }
    
    func refreshCorners(value: CGFloat) {
        layer.cornerRadius = value
    }
    
    
}





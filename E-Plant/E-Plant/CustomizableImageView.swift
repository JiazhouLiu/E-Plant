//
//  CustomizableImageView.swift
//  E-Plant
//
//  Created by Jiazhou Liu on 20/5/17.
//  Copyright © 2017 Jiazhou Liu. All rights reserved.
//

import UIKit

// custom image view IBdesignable class
@IBDesignable class CustomizableImageView: UIImageView {
    
    // add cornerRadius attribute for image view
    @IBInspectable var cornerRadius: CGFloat = 0 {
        
        didSet{
            layer.cornerRadius = cornerRadius
        }
    }
    
    // add borderWidth attribute for image view
    @IBInspectable var borderWidth: CGFloat = 0 {
        
        didSet{
            layer.borderWidth = borderWidth
        }
    }
    

}

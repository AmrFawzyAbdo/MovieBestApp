//
//  UIImage+Extentions.swift
//  MovieBest
//
//  Created by Amr fawzy on 8/9/19.
//  Copyright © 2019 Amr fawzy. All rights reserved.
//

import UIKit
import Kingfisher

extension UIImageView{
    
    func setImage(from url : URL, _ placeholderImgName : String?, _ imageTransition : ImageTransition) {
        
        self.kf.setImage(with: url, placeholder: UIImage(named: placeholderImgName!) ?? nil, options: [.transition(imageTransition)], progressBlock: nil)
    }
}

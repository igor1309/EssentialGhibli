//
//  UIImage+make.swift
//  
//
//  Created by Igor Malyarov on 16.10.2022.
//

import UIKit

#if DEBUG
extension UIImage {
    static func make(
        withColor color: UIColor,
        width: Int = 1,
        height: Int = 1
    ) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: width, height: height)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()!
        context.setFillColor(color.cgColor)
        context.fill(rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }
}
#endif

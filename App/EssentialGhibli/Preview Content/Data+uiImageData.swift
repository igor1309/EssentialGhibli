//
//  Data+uiImageData.swift
//
//
//  Created by Igor Malyarov on 16.10.2022.
//

import Foundation
import UIKit

#if DEBUG
extension Data {
    static func uiImageData(
        withColor color: UIColor,
        width: Int,
        height: Int
    ) -> Data {
        UIImage.make(withColor: color, width: width, height: height).pngData()!
    }
}
#endif

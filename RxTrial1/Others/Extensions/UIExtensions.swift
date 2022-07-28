//
// Created by Ben KIM on 2022/07/02.
//

import UIKit

extension UIViewController {
    func complain(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true)
    }
    
    func confirm(message: String, handler: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            handler?()
        }))
        present(alertController, animated: true)
    }
}
//
//extension UIImage {
//    func resized(toWidth width: CGFloat) -> UIImage? {
//        let width = min(width, size.width)
//        
//        let canvas = CGSize(
//            width: width,
//            height: CGFloat(ceil(width / size.width * size.height)))
//        
//        return UIGraphicsImageRenderer(size: canvas).image { _ in
//            draw(in: CGRect(origin: .zero, size: canvas))
//        }
//    }
//}

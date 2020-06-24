//
//  Extensions.swift
//  Game'OChat
//
//  Created by Roushil singla on 2/25/20.
//  Copyright © 2020 personal. All rights reserved.
//

import Foundation
import UIKit

// MARK:- CacheImage

fileprivate let imageCache = NSCache<AnyObject, AnyObject>()
extension UIImageView{

    func loadImageUsingCache(image: String){
    
        self.image = nil
        
        if let cachedImage = imageCache.object(forKey: image as NSString) as? UIImage{
            self.image = cachedImage
            return
        }
        
        guard let url = URL(string: image) else { return }
        let imageData = try! Data(contentsOf: url)
        let thumbImage = UIImage(data: imageData)
        imageCache.setObject(thumbImage!, forKey: image as NSString)
        self.image = thumbImage
    }
}

// MARK:- Color Shortcut

extension UIColor {
    
    static func rgb(r: CGFloat, g: CGFloat, b: CGFloat) -> UIColor {
        return UIColor(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
    
    static let backgroundColor = UIColor.rgb(r: 21, g: 22, b: 33)
 
}

// MARK:- Underline Textfield

extension UITextField{
    
    func underline(changeColor: Bool){
        
        let border = CALayer()
        let width = CGFloat(2.0)
        changeColor == true ? (border.borderColor = UIColor.blue.cgColor) : (border.borderColor = UIColor.darkGray.cgColor)
        border.frame = CGRect(x: 0,
                              y: self.frame.size.height - width,
                              width: self.frame.size.width,
                              height: self.frame.size.height)
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
}

// MARK:- Instantiate View Controller with Identifier

extension UIViewController{
    
    class func instantiateFromStoryboard(_ name: String = "Main") -> Self {
        
        return instantiateFromStoryboardHelper(name)
    }
    
    fileprivate class func instantiateFromStoryboardHelper<T>(_ name: String) -> T {
        
        let controller = UIStoryboard(name: name, bundle: nil).instantiateViewController(withIdentifier: "\(Self.self)") as! T
        return controller
    }
}


extension DestinationViewController{
    static func shareInstance() -> DestinationViewController{
        DestinationViewController.instantiateFromStoryboard()
    }
}


// MARK:- Get Topmost View Controller

extension UIApplication {

    class func getTopViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {

        if let nav = base as? UINavigationController {
            return getTopViewController(base: nav.visibleViewController)

        } else if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return getTopViewController(base: selected)

        } else if let presented = base?.presentedViewController {
            return getTopViewController(base: presented)
        }
        return base
    }
}

// MARK:- Using Activity Indicator

fileprivate var activityView : UIView?
extension UIViewController{
    
    func showSpinner(){
        activityView = UIView(frame: self.view.bounds)
        activityView?.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = activityView!.center
        activityIndicator.startAnimating()
        activityView?.addSubview(activityIndicator)
        self.view.addSubview(activityView!)
    }
    
    func removeSpinner(){
        activityView!.removeFromSuperview()
        activityView = nil
    }
}


//MARK:- Applying Constraints Programatically

extension UIView{
    
    func anchor(top: NSLayoutYAxisAnchor?, leading: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, trailing: NSLayoutXAxisAnchor?, padding: UIEdgeInsets = .zero, size: CGSize = .zero){
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top{
            topAnchor.constraint(equalTo: top, constant: padding.top).isActive = true
        }
        
        if let leading = leading{
            leadingAnchor.constraint(equalTo: leading, constant: padding.left).isActive = true
        }
        
        if let bottom = bottom{
            bottomAnchor.constraint(equalTo: bottom, constant: padding.bottom).isActive = true
        }
        
        if let trailing = trailing{
            trailingAnchor.constraint(equalTo: trailing, constant: padding.right).isActive = true
        }
        
        if size.width != 0{
            widthAnchor.constraint(equalToConstant: size.width).isActive = true
        }
        
        if size.height != 0{
            heightAnchor.constraint(equalToConstant: size.height).isActive = true
        }
    }
}


//MARK:- Animating Button

extension UIButton{
    
    func pulsate(){
        
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = 0.6
        pulse.fromValue = 0.95
        pulse.toValue = 1.0
        pulse.autoreverses = true
        pulse.repeatCount = 1
        pulse.initialVelocity = 0.5
        pulse.damping = 1.0
        layer.add(pulse, forKey: nil)
    }
    
    func flash(){
        
        let flash = CABasicAnimation(keyPath: "opacity")
        flash.duration = 0.5
        flash.fromValue = 1.0
        flash.toValue = 0.1
        flash.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        flash.autoreverses = true
        flash.repeatCount = 2
        layer.add(flash, forKey: nil)
    }
    
    func shake(){
        
        let shake = CABasicAnimation(keyPath: "position")
        shake.duration = 0.1
        shake.repeatCount = 2
        shake.autoreverses = true
        let fromPoint = CGPoint(x: center.x - 5, y: center.y)
        let fromValue = NSValue(cgPoint: fromPoint)
        let toPoint = CGPoint(x: center.x + 5, y: center.y)
        let toValue = NSValue(cgPoint: toPoint)
        shake.fromValue = fromValue
        shake.toValue = toValue
        layer.add(shake, forKey: nil)
    }
}



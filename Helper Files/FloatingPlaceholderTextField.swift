//
//  FloatingLabelInput.swift
//  FloatingLabelInput
//
//  Created by Arpana on 25/05/20.
//

import UIKit

class FloatingPlaceholderTextField: UITextField {
    var floatingLabel: UILabel!// = UILabel(frame: CGRect.zero)
    var floatingLabelHeight: CGFloat = 14
    var button = UIButton(type: .custom)
    var imageView = UIImageView(frame: CGRect.zero)
    
    @IBInspectable
    var _placeholder: String?
    
    //Assign color to floating label
    @IBInspectable
    var floatingLabelColor: UIColor = UIColor.black {
        didSet {
            self.floatingLabel.textColor = floatingLabelColor
            self.setNeedsDisplay()
        }
    }
    
    
    
    //We can set boarder color when the label is active/ responder
    //  @IBInspectable
    //  var activeBorderColor: UIColor = UIColor.blue
    
    //Can assign background coor if needed
    @IBInspectable
    var floatingLabelBackground: UIColor = UIColor.white.withAlphaComponent(1) {
        didSet {
            self.floatingLabel.backgroundColor = self.floatingLabelBackground
            self.setNeedsDisplay()
        }
    }
    
    //Assign font to the label
    @IBInspectable
    var floatingLabelFont: UIFont = UIFont.systemFont(ofSize: 14) {
        didSet {
            self.floatingLabel.font = self.floatingLabelFont
            //  self.font = self.floatingLabelFont
            self.setNeedsDisplay()
        }
    }
    
    @IBInspectable
    var _backgroundColor: UIColor = UIColor.white {
        didSet {
            self.layer.backgroundColor = self._backgroundColor.cgColor
        }
    }
    
    
    //initialize  the floating label with all properties
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self._placeholder = (self._placeholder != nil) ? self._placeholder : placeholder
        placeholder = self._placeholder // Make sure the placeholder is shown
        self.floatingLabel = UILabel(frame: CGRect.zero)
        self.addTarget(self, action: #selector(self.addFloatingLabel), for: .editingDidBegin)
        self.addTarget(self, action: #selector(self.removeFloatingLabel), for: .editingDidEnd)
        
        kAppDelegate.sharedStyle.apply(textStyle: .title, to: self)
        
        kAppDelegate.sharedStyle.apply(textStyle: .placeholder, to: self.floatingLabel, appliedFont: self.font ?? UIFont.systemFont(ofSize: (90)))
    }
    
    // Add a floating label to the view on becoming first responder
    @objc open func addFloatingLabel(screenType : Int) {
        if screenType == 1 { //Add screen
            if self.text == "" {
                self.floatingLabel.textColor = floatingLabelColor
                //  self.floatingLabel.font = floatingLabelFont
                self.floatingLabel.text = self._placeholder
                self.floatingLabel.layer.backgroundColor = UIColor.white.cgColor
                self.floatingLabel.translatesAutoresizingMaskIntoConstraints = false
                self.floatingLabel.clipsToBounds = true
                self.floatingLabel.frame = CGRect(x: 0, y: 0, width: floatingLabel.frame.width+4, height: floatingLabel.frame.height+2)
                self.floatingLabel.frame.size.width = 0.0
                
                self.floatingLabel.textAlignment = .center
                self.addSubview(self.floatingLabel)
                self.borderStyle = .roundedRect
                self.layer.borderColor =   UIColor.systemGray4.cgColor//self.activeBorderColor.cgColor
                
                self.floatingLabel.bottomAnchor.constraint(equalTo: self.topAnchor, constant: -5).isActive = true // Place our label 10 pts above the text field
                //  self.placeholder = ""
                
            }
            performAnimation(transform: CGAffineTransform(scaleX: 1, y: 1))
            
        }else{
            
            //edits screen
            self.floatingLabel.textColor = floatingLabelColor
            //  self.floatingLabel.font = floatingLabelFont
            self.floatingLabel.text = self._placeholder
            self.floatingLabel.layer.backgroundColor = UIColor.white.cgColor
            self.floatingLabel.translatesAutoresizingMaskIntoConstraints = false
            self.floatingLabel.clipsToBounds = true
            self.floatingLabel.frame = CGRect(x: 0, y: 0, width: floatingLabel.frame.width+4, height: floatingLabel.frame.height+2)
            self.floatingLabel.frame.size.width = 0.0
            
            self.floatingLabel.textAlignment = .center
            self.addSubview(self.floatingLabel)
            self.borderStyle = .roundedRect
            self.layer.borderColor =   UIColor.systemGray4.cgColor//self.activeBorderColor.cgColor
            
            // Place our label 10 pts above the text field
            self.floatingLabel.bottomAnchor.constraint(equalTo: self.topAnchor, constant: -5).isActive = true
            self.placeholder = ""
            
            
            performAnimation(transform: CGAffineTransform(scaleX: 1, y: 1))
            
        }
        // Floating label may be stuck behind text input. we bring it forward as it was the last item added to the view heirachy
        self.bringSubviewToFront(subviews.last!)
        self.setNeedsDisplay()
    }
    
    // When saome text is entered then remove floating label
    @objc func removeFloatingLabel() {
        if self.text == "" {
            UIView.animate(withDuration: 0.13) {
                self.subviews.forEach{ $0.removeFromSuperview()
                }
                self.setNeedsDisplay()
            }
            self.placeholder = self._placeholder
        }
        // self.layer.borderColor = UIColor.black.cgColor
        self.borderStyle = .roundedRect
        self.borderWidth = 1.0
        
        
        if let placeholderHasText = self.placeholder  {
            // UIFont.systemFont(ofSize: style.textSizeForFloatingPlaceholder , weight: .light)
            
            self.attributedPlaceholder = NSAttributedString(string: placeholderHasText , attributes: [
                .foregroundColor: UIColor.lightGray,
                .font: kAppDelegate.sharedStyle.font(for: .placeholder)
            ])
        }
        
    }
    
    //When  text field  is type of password, view option will be at right corner
    func addViewPasswordButton() {
        self.button.setImage(UIImage(named: "ic_reveal"), for: .normal)
        self.button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.button.frame = CGRect(x: 0, y: 16, width: 22, height: 16)
        self.button.clipsToBounds = true
        self.rightView = self.button
        self.rightViewMode = .always
        self.button.addTarget(self, action: #selector(self.enablePasswordVisibilityToggle), for: .touchUpInside)
    }
    
    //if you want some image to be put on  left side of textfield , use below method.
    func addImage(image: UIImage){
        
        self.imageView.image = image
        self.imageView.frame = CGRect(x: 20, y: 0, width: 20, height: 20)
        self.imageView.translatesAutoresizingMaskIntoConstraints = true
        self.imageView.contentMode = .scaleAspectFit
        self.imageView.clipsToBounds = true
        
        DispatchQueue.main.async {
            self.leftView = self.imageView
            self.leftViewMode = .always
        }
        
    }
    
    // functionality to show and hide view password
    
    @objc func enablePasswordVisibilityToggle() {
        isSecureTextEntry.toggle()
        if isSecureTextEntry {
            self.button.setImage(UIImage(named: "ic_show"), for: .normal)
        }else{
            self.button.setImage(UIImage(named: "ic_hide"), for: .normal)
        }
    }
    
    //add in floating textfield class
    func performAnimation(transform: CGAffineTransform) {
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            self.transform = transform
            self.superview?.layoutIfNeeded()
        }, completion: nil) }
    
}

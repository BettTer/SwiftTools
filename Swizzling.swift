//
//  Swizzling.swift
//  Play
//
//  Created by XYoung on 2019/7/25.
//  Copyright © 2019 timedoin. All rights reserved.
//

import UIKit

extension UIButton {
    public static func initializeMethod() {
        if self != UIButton.self {
            return
            
        }
        
        DispatchQueue.once {
            let originalSelector = #selector(UIButton.addTarget(_:action:for:))
            let swizzledSelector = #selector(UIButton.swizzled_addTarget(_:action:for:))
            
            let originalMethod = class_getInstanceMethod(self, originalSelector)
            let swizzledMethod = class_getInstanceMethod(self, swizzledSelector)
            //在进行 Swizzling 的时候,需要用 class_addMethod 先进行判断一下原有类中是否有要替换方法的实现
            let didAddMethod: Bool = class_addMethod(self, originalSelector, method_getImplementation(swizzledMethod!), method_getTypeEncoding(swizzledMethod!))
            //如果 class_addMethod 返回 yes,说明当前类中没有要替换方法的实现,所以需要在父类中查找,这时候就用到 method_getImplemetation 去获取 class_getInstanceMethod 里面的方法实现,然后再进行 class_replaceMethod 来实现 Swizzing
            
            if didAddMethod {
                class_replaceMethod(self, swizzledSelector, method_getImplementation(originalMethod!), method_getTypeEncoding(originalMethod!))
            } else {
                method_exchangeImplementations(originalMethod!, swizzledMethod!)
            }
            
        }
        
    }
    
    @objc func swizzled_addTarget(_ target: Any?, action: Selector, for controlEvents: UIControl.Event) -> Void {
        self.swizzled_addTarget(target, action: action, for: controlEvents)
        
        if let label = self.titleLabel {
            let fontSize = label.font.pointSize
            label.font = UIFont.init(name: EnumSet.FontType.Normal.rawValue, size: fontSize)
            
        }else {
            
            
            
        }
        
    }
    
}

extension UILabel {
    public static func initializeMethod() {
        if self != UILabel.self {
            return
            
        }
        
        DispatchQueue.once {
            let originalSelector = Selector("setText:")
            let swizzledSelector = #selector(UILabel.swizzled_setText(text:))
            
            let originalMethod = class_getInstanceMethod(self, originalSelector)
            let swizzledMethod = class_getInstanceMethod(self, swizzledSelector)
            //在进行 Swizzling 的时候,需要用 class_addMethod 先进行判断一下原有类中是否有要替换方法的实现
            let didAddMethod: Bool = class_addMethod(self, originalSelector, method_getImplementation(swizzledMethod!), method_getTypeEncoding(swizzledMethod!))
            //如果 class_addMethod 返回 yes,说明当前类中没有要替换方法的实现,所以需要在父类中查找,这时候就用到 method_getImplemetation 去获取 class_getInstanceMethod 里面的方法实现,然后再进行 class_replaceMethod 来实现 Swizzing
            
            if didAddMethod {
                class_replaceMethod(self, swizzledSelector, method_getImplementation(originalMethod!), method_getTypeEncoding(originalMethod!))
            } else {
                method_exchangeImplementations(originalMethod!, swizzledMethod!)
            }
            
        }
        
    }
    
    @objc func swizzled_setText(text: String) -> Void {
        self.swizzled_setText(text: text)
    
        self.font = UIFont.init(name: EnumSet.FontType.Normal.rawValue, size: self.font.pointSize)
        
    }
}



extension UITextView {
    public static func initializeMethod() {
        if self != UITextView.self {
            return
            
        }
        
        DispatchQueue.once {
            let originalSelector = Selector("setText:")
            let swizzledSelector = #selector(UITextView.swizzled_setText(text:))
            
            let originalMethod = class_getInstanceMethod(self, originalSelector)
            let swizzledMethod = class_getInstanceMethod(self, swizzledSelector)
            //在进行 Swizzling 的时候,需要用 class_addMethod 先进行判断一下原有类中是否有要替换方法的实现
            let didAddMethod: Bool = class_addMethod(self, originalSelector, method_getImplementation(swizzledMethod!), method_getTypeEncoding(swizzledMethod!))
            //如果 class_addMethod 返回 yes,说明当前类中没有要替换方法的实现,所以需要在父类中查找,这时候就用到 method_getImplemetation 去获取 class_getInstanceMethod 里面的方法实现,然后再进行 class_replaceMethod 来实现 Swizzing
            
            if didAddMethod {
                class_replaceMethod(self, swizzledSelector, method_getImplementation(originalMethod!), method_getTypeEncoding(originalMethod!))
            } else {
                method_exchangeImplementations(originalMethod!, swizzledMethod!)
            }
            
        }
        
    }
    
    @objc func swizzled_setText(text: String) -> Void {
        self.swizzled_setText(text: text)
        
        if let _ = self.font {
            self.font = UIFont.init(name: EnumSet.FontType.Normal.rawValue, size: self.font!.pointSize)
            
        }else {
            self.font = UIFont.init(name: EnumSet.FontType.Normal.rawValue, size: 17)
            
        }
        
        
        
    }
}

extension UITextField {
    public static func initializeMethod() {
        if self != UITextField.self {
            return
            
        }
        
        DispatchQueue.once {
            let originalSelector = #selector(UITextField.becomeFirstResponder)
            let swizzledSelector = #selector(UITextField.swizzled_becomeFirstResponder)
            
            let originalMethod = class_getInstanceMethod(self, originalSelector)
            let swizzledMethod = class_getInstanceMethod(self, swizzledSelector)
            //在进行 Swizzling 的时候,需要用 class_addMethod 先进行判断一下原有类中是否有要替换方法的实现
            let didAddMethod: Bool = class_addMethod(self, originalSelector, method_getImplementation(swizzledMethod!), method_getTypeEncoding(swizzledMethod!))
            //如果 class_addMethod 返回 yes,说明当前类中没有要替换方法的实现,所以需要在父类中查找,这时候就用到 method_getImplemetation 去获取 class_getInstanceMethod 里面的方法实现,然后再进行 class_replaceMethod 来实现 Swizzing
            
            if didAddMethod {
                class_replaceMethod(self, swizzledSelector, method_getImplementation(originalMethod!), method_getTypeEncoding(originalMethod!))
            } else {
                method_exchangeImplementations(originalMethod!, swizzledMethod!)
            }
            
        }
        
    }
    
    @objc func swizzled_becomeFirstResponder() -> Void {
        self.swizzled_becomeFirstResponder()
        
        if let _ = self.font {
            self.font = UIFont.init(name: EnumSet.FontType.Normal.rawValue, size: self.font!.pointSize)
            
        }else {
            self.font = UIFont.init(name: EnumSet.FontType.Normal.rawValue, size: 17)
            
        }
    }
}

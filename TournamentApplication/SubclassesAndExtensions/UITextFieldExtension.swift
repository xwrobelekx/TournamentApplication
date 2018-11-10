//
//  UITextFieldExtension.swift
//  TournamentApplication
//
//  Created by Kamil Wrobel on 11/9/18.
//  Copyright © 2018 Kamil Wrobel. All rights reserved.
//

import UIKit


///preSet to post notification to TournamentCollectionViewCell
extension UITextField{
    @IBInspectable var doneAccessory: Bool{
        get{
            return self.doneAccessory
        }
        set (hasDone) {
            if hasDone{
                addDoneButtonOnKeyboard()
            }
        }
    }
    
    func addDoneButtonOnKeyboard()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .blackTranslucent
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonAction))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.inputAccessoryView = doneToolbar
    }
    
    
    @objc func doneButtonAction()
    {
        self.resignFirstResponder()
        NotificationCenter.default.post(name: NSNotification.Name("userPressedNextRoundButtonNotification"), object: nil)
    }
}

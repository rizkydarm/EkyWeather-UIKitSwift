//
//  Extension+ UITextField.swift
//  EkyWeather
//
//  Created by Eky on 19/01/25.
//

import UIKit

extension UITextField {
    func addDoneButton() {
        let doneToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        doneToolbar.barStyle = UIBarStyle.default
           
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
        let done = UIBarButtonItem(
            title: "Done",
            style: UIBarButtonItem.Style.done,
            target: self,
            action: #selector(doneButtonAction)
        )
        done.tintColor = .systemBlue
           
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)
           
        doneToolbar.items = items
        doneToolbar.sizeToFit()
           
        self.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction() {
        self.endEditing(true)
    }
}

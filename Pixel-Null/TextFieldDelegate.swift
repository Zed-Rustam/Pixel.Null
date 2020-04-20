//
//  TextFieldDelegate.swift
//  new Testing
//
//  Created by Рустам Хахук on 14.01.2020.
//  Copyright © 2020 Zed Null. All rights reserved.
//

import UIKit

class TextFieldDelegate : NSObject, UITextFieldDelegate {
    var check : (_ textField: UITextField)->() = {_ in}
    var delegate : TextFieldProtocol? = nil
    init(method : @escaping (_ textField: UITextField)->()){
       check = method
    }
    init(del : TextFieldProtocol) {
        delegate = del
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        check(textField)
        delegate?.changeText(field : textField)
    }
}

protocol TextFieldProtocol {
    func changeText(field : UITextField)
}

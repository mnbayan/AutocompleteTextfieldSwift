//
//  AutoCompletionTextProtocol.swift
//  AutocompleteTextfieldSwift
//
//  Created by Mohshin Shah on 24/10/2016.
//  Copyright © 2016 mnbayan. All rights reserved.
//

import Foundation

/**
 Enables an model object to be used in AutoCompletion of UITextField.
 */

public protocol AutoCompletionTextProtocol {
    
    /**
     Returns the autocompletion text
     - returns: Model Auto Completion Text.
     */
    func autocompletionText() -> String
    
}

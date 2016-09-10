//
//  Swift+AddText.swift
//  MyLocations
//
//  Created by Seab on 9/10/16.
//  Copyright © 2016 Seab Jackson. All rights reserved.
//

import Foundation

extension String {
    mutating func addText(text: String?, withSeparator separator: String = "") {
        if let text = text {
            if !isEmpty {
                self += separator
            }
            self += text
        }
    }
}

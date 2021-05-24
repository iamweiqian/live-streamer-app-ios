//
//  FormatterUtils.swift
//  Streamer
//
//  Created by Wei Qian Yap on 20/05/2021.
//

import UIKit

extension String {
    
    func trim() -> String {
        return self.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
    }
    
}

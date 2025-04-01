//
//  Bundle+appVersion.swift
//  DripNotePresentation
//
//  Created by 김정완 on 4/1/25.
//

import Foundation

extension Bundle {
    var appVersion: String {
        return infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"
    }
} 

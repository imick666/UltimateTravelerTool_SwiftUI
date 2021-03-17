//
//  Int+Date.swift
//  UltimateTravelerTool_SwiftUI
//
//  Created by mickael ruzel on 17/03/2021.
//

import Foundation

extension Int {
    
    func date(timezone offset: Int) -> Date {
        let dtWithOffest = self - offset
        let dt = Double(dtWithOffest)
        let date = Date(timeIntervalSince1970: dt)
        
        return date
    }
    
}

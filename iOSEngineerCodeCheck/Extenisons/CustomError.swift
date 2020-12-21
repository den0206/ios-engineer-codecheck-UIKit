//
//  CustomError.swift
//  iOSEngineerCodeCheck
//
//  Created by 酒井ゆうき on 2020/12/20.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import Foundation

enum APIError : Error {
    case noURL
    case NoData
    
    var errorDescription : String? {
        switch self {
       
        case .noURL:
            return NSLocalizedString("Repositry URLが見つかりません", comment: "")
        case .NoData:
            return NSLocalizedString("Repositry Dataが見つかりません", comment: "")

        }
    }
}

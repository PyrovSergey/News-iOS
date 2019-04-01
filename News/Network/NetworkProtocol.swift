//
//  NetworkProtocol.swift
//  News
//
//  Created by Sergey on 01/04/2019.
//  Copyright © 2019 Sergey. All rights reserved.
//

import Foundation

protocol NetworkProtocol {
    func successRequest(result: [Article], category: String)
    
    func errorRequest(errorMessage: String)
}

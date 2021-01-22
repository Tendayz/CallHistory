//
//  CallModel.swift
//  CallHistory
//
//  Created by Stepan Grachev on 22.01.2021.
//

import UIKit

struct CallModel: Codable {
    var id: String
    var state: String
    var client: ClientModel
    var type: String
    var created: String
    var businessNumber: BusinessNumberModel
    var origin: String
    var favorite: Bool
    var duration: String
}

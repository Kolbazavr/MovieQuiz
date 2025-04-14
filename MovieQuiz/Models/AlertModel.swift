import Foundation

struct AlertModel {
    let title: String
    let message: String
    var alertId: String?
    
    let buttons: [AlertButtonModel]
}

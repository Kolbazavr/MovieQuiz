import UIKit

protocol Coordinator {
    var navigationController: UINavigationController? { get set }
    
    func navigateBack()
    
    func start()
}

protocol Coordinating {
    var coordinator: Coordinator? { get set }
}

import UIKit

extension UIButton {
    
    func configure(title: String) {
        
        var buttonConfiguration: UIButton.Configuration = .borderless()
        var container = AttributeContainer()
        
        container.font = UIFont(name: "YSDisplay-Medium", size: 20)
        
        buttonConfiguration.title = title
        buttonConfiguration.imagePadding = 10
        buttonConfiguration.baseForegroundColor = .ypBlack
        buttonConfiguration.attributedTitle = AttributedString(title, attributes: container)
        
        self.configuration = buttonConfiguration
        self.layer.cornerRadius = 15
        self.backgroundColor = .ypWhite
        self.setTitleColor(.ypBlack, for: .normal)
    }
}

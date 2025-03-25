import UIKit

final class MoviePosterView: UIImageView {
    func showSomething(movieTitle: String, movieImage: UIImage?) {
        removeText()
        if let image = movieImage {
            UIView.transition(with: self, duration: 0.3, options: .transitionFlipFromTop, animations: {
                self.image = image
                self.backgroundColor = .clear
            }, completion: nil)
        } else {
            let placeholderLabel = UILabel(frame: self.bounds)
            placeholderLabel.numberOfLines = 0
            placeholderLabel.text = "Я хз, что с картинкой,\n но вот тебе тайтл:\n >>\(movieTitle)<<,\n угадывай так..."
            placeholderLabel.font = UIFont(name: "YSDisplay-Medium", size: 20)
            placeholderLabel.textAlignment = .center
            placeholderLabel.textColor = .ypBlack
            self.backgroundColor = .ypWhite
            self.addSubview(placeholderLabel)
            self.image = nil
        }
    }
    
    func setBorderColor(_ color: CGColor?) {
        if let color {
            UIView.animate(withDuration: 0.3) {
                self.layer.borderColor = color
                self.layer.borderWidth = 8
            }
        } else {
            self.layer.borderColor = UIColor.clear.cgColor
            layer.borderWidth = 0
        } 
    }
    
    private func removeText() {
        guard !self.subviews.isEmpty else { return }
        for subView in self.subviews {
            subView.removeFromSuperview()
        }
    }
}

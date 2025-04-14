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
            placeholderLabel.text = "Я хз, что с картинкой,\n но вот тебе тайтл:\n >>\(movieTitle)<<\n угадывай так..."
            placeholderLabel.font = UIFont(name: "YSDisplay-Medium", size: 20)
            placeholderLabel.textAlignment = .center
            placeholderLabel.textColor = .ypWhite
            self.backgroundColor = .ypBlack
            self.addSubview(placeholderLabel)
            self.image = nil
        }
    }
    
    func setBorderColor(for isCorrect: Bool) {
        let color = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        UIView.animate(withDuration: 0.3) {
            self.layer.borderColor = color
            self.layer.borderWidth = 8
        }
    }
    
    func resetBorderColor() {
        self.layer.borderColor = UIColor.clear.cgColor
        self.layer.borderWidth = 0
    }
    
    private func removeText() {
        guard !self.subviews.isEmpty else { return }
        for subView in self.subviews {
            subView.removeFromSuperview()
        }
    }
}

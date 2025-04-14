import Foundation

protocol VoiceCommandRecognizerDelegate: AnyObject {
    func commandRecognized(_ command: Bool)
}

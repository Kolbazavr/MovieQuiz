import Foundation

protocol UserSettingsProtocol {
    var questionsCount: Int { get set }
    var loaderType: LoaderType? { get set }
    var voiceControlEnabled: Bool { get set }
}

import Foundation

extension UserDefaults {
    
    func removeAll() {
        for (key, _) in dictionaryRepresentation() {
            removeObject(forKey: key)
        }
    }
    
    func setThingy<T: Codable>(_ value: T?, forKey key: String) {
        if let value = value {
            let encoder = JSONEncoder()
            if let encodedData = try? encoder.encode(value) {
                self.set(encodedData, forKey: key)
            }
        } else {
            self.removeObject(forKey: key)
        }
    }
    
    func getThingy<T: Codable>(forKey key: String, as type: T.Type) -> T? {
        guard let data = data(forKey: key) else { return nil }
        let decoder = JSONDecoder()
        return try? decoder.decode(T.self, from: data)
    }
}

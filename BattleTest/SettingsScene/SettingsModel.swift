import Foundation

final class SettingsModel: Codable {
    var name: String
    var scroll: CGFloat
    var loadValue: String
    var stepperValue: Double
    
    init(name: String, scroll: CGFloat, loadValue: String, stepperValue: Double) {
        self.name = name
        self.scroll = scroll
        self.loadValue = loadValue
        self.stepperValue = stepperValue
    }
}

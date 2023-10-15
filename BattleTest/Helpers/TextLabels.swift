import Foundation

struct TextLabels {
    
    struct ScoreCell {
        static var reuseId: String {
            return NSLocalizedString("ScoreCell", comment: "")
        }
    }
    
    struct StartVC {
        static var gameLabel: String {
            return NSLocalizedString("GAME", comment: "")
        }
        static var start: String {
            return NSLocalizedString("START", comment: "")
        }
        static var settings: String {
            return NSLocalizedString("SETTINGS", comment: "")
        }
        static var score: String {
            return NSLocalizedString("SCORE", comment: "")
        }
    }
    
    struct AlertVC {
        static var gameOver: String {
            return NSLocalizedString("Игра окончена!", comment: "")
        }
        static var yourScore: String {
            return NSLocalizedString("Ваш счет", comment: "")
        }
        static var yourName: String {
            return NSLocalizedString("Ваше имя", comment: "")
        }
        static var ok: String {
            return NSLocalizedString("OK", comment: "")
        }
        static var enterName: String {
            return NSLocalizedString("Введите Ваше имя", comment: "")
        }
        static var name: String {
            return NSLocalizedString("Имя", comment: "")
        }
        static var cancel: String {
            return NSLocalizedString("Отмена", comment: "")
        }
    }
    
    struct ScoreVC {
        static var records: String {
            return NSLocalizedString("Рекорды", comment: "")
        }
    }
    
    struct SettingsVC {
        static var settings: String {
            return NSLocalizedString("Settings", comment: "")
        }
        static var enterName: String {
            return NSLocalizedString("Введите свое имя", comment: "")
        }
        static var chooseAirplane: String {
            return NSLocalizedString("Выберите самолет", comment: "")
        }
        static var airplaneSpeed: String {
            return NSLocalizedString("Скорость самолета", comment: "")
        }
        static var save: String {
            return NSLocalizedString("Применить", comment: "")
        }
 
    }
    
    struct Images {
        static var airplaineOne: String {
            return "AirplaineOne"
        }
        static var airplaineTwo: String {
            return "AirplaineTwo"
        }
        static var airplaineThree: String {
            return "AirplaineThree"
        }
    }
    
}

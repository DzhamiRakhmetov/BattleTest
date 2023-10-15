import UIKit

final class AlertAction {

    func gameOverAlert(_ view: UIViewController, score: Int, result: [Int]) {

        var scoreArray: [Int] = []

        let alertController = UIAlertController(title: TextLabels.AlertVC.gameOver,
                                                message: TextLabels.AlertVC.yourScore + " " + "\(score)",
                                                preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: TextLabels.AlertVC.ok, style: .default) { _ in
            view.navigationController?.popViewController(animated: true)
            scoreArray = result
            scoreArray.append(score)

            UserDefaults.standard.set(scoreArray, forKey: UserDefaultKeys.record.rawValue)
        }
        alertController.addAction(okAction)
        view.present(alertController, animated: true)
    }


    func nameAlert(_ view: UIViewController, name: UILabel) {
        let alertController = UIAlertController(title: "", message: TextLabels.AlertVC.enterName, preferredStyle: .alert)
        let okAction = UIAlertAction(title: TextLabels.AlertVC.ok, style: .default) {  _ in
            let textField = alertController.textFields?.first
            if textField?.text != "" {
                name.text = textField?.text
            } else {
                name.text = TextLabels.AlertVC.yourName
            }
        }
        
        alertController.addTextField { name in name.placeholder = TextLabels.AlertVC.name }

        let cancelAlertAction = UIAlertAction(title: TextLabels.AlertVC.cancel, style: .default) {_ in
            alertController.dismiss(animated: true)
        }
        alertController.addAction(okAction)
        alertController.addAction(cancelAlertAction)
        view.present(alertController, animated: true)
    }
}

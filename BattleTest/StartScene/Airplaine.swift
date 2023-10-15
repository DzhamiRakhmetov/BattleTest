import UIKit

final class Airplaine: UIImageView {
    
    let airplaineSize = CGSize(width: 50, height: 50)
    var airplaineCenter: CGPoint!
    
    func airplaineStep(to newCenter: CGPoint, view: UIView, boardFrames: [CGRect]) -> Bool {
        
        let newFrame = CGRect(
            origin: CGPoint(x: newCenter.x - airplaineSize.width / 2,
                            y: newCenter.y),
            size: airplaineSize)
        
        for boardFrame in boardFrames {
            if newFrame.intersects(boardFrame) {
                return false
            }
        }
        let viewBounds = view.safeAreaLayoutGuide.layoutFrame
        if !viewBounds.contains(newFrame) {
            return false
        }
        return true
    }
    
    func updateViewPosition() {
        UIView.animate(withDuration: 0.2) { [self] in
            self.center = airplaineCenter
        }
    }
}

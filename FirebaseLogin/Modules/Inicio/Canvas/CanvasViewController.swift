import UIKit
import CoreMotion

class CanvasViewController: UIViewController {
    
    @IBOutlet weak var blueSquare: UIView!
    
    var animator: UIDynamicAnimator!
    var gravity: UIGravityBehavior!
    var motion: CMMotionManager!

    var queue: OperationQueue! // used for updating UI objects with motion
    
    override func viewDidLoad() {
        super.viewDidLoad()
        queue = OperationQueue.current
        animator = UIDynamicAnimator(referenceView: self.view)
        gravity = UIGravityBehavior(items: [blueSquare])
        motion = CMMotionManager()
        
        animator.addBehavior(gravity)

        
        // the objects that responds to collision
        let collision = UICollisionBehavior(items: [blueSquare])

        // the boundary AKA the borders. In this case if the full ViewController view
        collision.addBoundary(withIdentifier: "borders" as NSCopying, for: UIBezierPath(rect: self.view.frame))
        
        
        animator.addBehavior(collision)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
}

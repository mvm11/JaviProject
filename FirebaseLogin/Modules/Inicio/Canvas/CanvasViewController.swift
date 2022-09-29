import UIKit
import CoreMotion

class CanvasViewController: UIViewController {
    
    @IBOutlet weak var blueSquare: UIView!
    
    var animator: UIDynamicAnimator!
    var gravity: UIGravityBehavior!
    var motion: CMMotionManager!

    var queue: OperationQueue! // used for updating UI objects with motion
    
    var panGesture = UIPanGestureRecognizer()
    
    let colors = [UIColor.blue, UIColor.red, UIColor.yellow, UIColor.green]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        queue = OperationQueue.current
        animator = UIDynamicAnimator(referenceView: self.view)
        gravity = UIGravityBehavior(items: [blueSquare])
        
        motion = CMMotionManager()
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(CanvasViewController.draggedView(_:)))
        blueSquare.isUserInteractionEnabled = true
        blueSquare.addGestureRecognizer(panGesture)
        
        animator.addBehavior(gravity)

        
        // the objects that responds to collision
        let collision = UICollisionBehavior(items: [blueSquare])

        // the boundary AKA the borders. In this case if the full ViewController view
        collision.addBoundary(withIdentifier: "borders" as NSCopying, for: UIBezierPath(rect: self.view.frame))
        
        
        animator.addBehavior(collision)
        
        //Elasticity
        let bounce = UIDynamicItemBehavior(items: [blueSquare])
        bounce.elasticity = 8
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    @objc func draggedView(_ sender:UIPanGestureRecognizer){
        self.view.bringSubviewToFront(blueSquare)
        let translation = sender.translation(in: self.view)
        blueSquare.center = CGPoint(x: blueSquare.center.x + translation.x, y: blueSquare.center.y + translation.y)
        sender.setTranslation(CGPoint.zero, in: self.view)
        
        animator.updateItem(usingCurrentState: blueSquare)
    }
}

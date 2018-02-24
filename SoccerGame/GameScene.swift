import SpriteKit
import GameplayKit

let screenSize = UIScreen.main.bounds
var screenWidth: CGFloat?
var screenHeight: CGFloat?

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    private var ball : Ball?
    private var score : Int = 0
    private var goalKeeper : GoalKeeper?
    private var goal : Goal?
    
    override func didMove(to view: SKView) {
        screenWidth = frame.width
        screenHeight = frame.height
        
        self.ball = Ball()
        self.addChild(self.ball!)
        
        self.physicsWorld.contactDelegate = self
        // Get label node from scene and store it for use later
        self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
        if let label = self.label {
            
            label.text = "Hit the Ball!"
            label.run(SKAction.fadeOut(withDuration: 3.0))
        }
        
        
        // Create shape node to use during mouse interaction
        let w = (self.size.width + self.size.height) * 0.05
        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
        
        if let spinnyNode = self.spinnyNode {
            spinnyNode.lineWidth = 2.5
            
            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(M_PI), duration: 1)))
            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
                                              SKAction.fadeOut(withDuration: 0.5),
                                              SKAction.removeFromParent()]))
        }
        
        //let easyVelocity: CGFloat = 5.0
        let mediumVelocity: CGFloat = 15.0
        self.goalKeeper = GoalKeeper(Velocity: mediumVelocity)
        self.addChild(self.goalKeeper!)
        
        self.goal = Goal()
        self.addChild(self.goal!)
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        addSpinnyNode(pos, SKColor.green)
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        addSpinnyNode(pos, SKColor.blue)
    }
    
    func touchUp(atPoint pos : CGPoint) {
        addSpinnyNode(pos, SKColor.red)
    }
    
    private func addSpinnyNode(_ pos: CGPoint, _ color: SKColor) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = color
            n.zPosition = 1
            self.addChild(n)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        
        //if let ball = self.ball {
            for t in touches {
                let location  = t.location(in: self)
                if (self.ball?.ballHit(location))! {
                    // score += 1
                }
            }
        //}
        
        /*
        if let label = self.label {
            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
            label.text = "\(score)"
        }
        */
        
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if (contact.bodyA.node?.name == "ball") {
            self.ballHit(contact.bodyB.node!)
        }
        
        if (contact.bodyB.node?.name == "ball") {
            self.ballHit(contact.bodyA.node!)
        }
    }
    
    func ballHit(_ node: SKNode) {
        if (node.name == "goalkeeper") {
            keeperCatchedBall()
        }
        else if (node.name == "goal") {
            scoredAGoal()
        }
        else if (node.name == "ground") {
            /*
            score = 0
            if let label = self.label {
                label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
                label.text = "\(score)"
            }
            */
        }
    }
    
    func scoredAGoal() {
        print("Goal!")
        label?.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
        label?.text = "GOAL!"
        
        self.ball?.position = CGPoint(x: 500.0, y: 400.0 )
    }
    
    func keeperCatched( _ node: SKNode) {
        //print("catched \(node.name)")
        if (node.name == "ball") {
            keeperCatchedBall()
        }
    }
    
    func keeperCatchedBall() {
        print("Gotcha!")
        let diffX = (self.goalKeeper?.position.x)! - (ball?.frame.origin.x)! - (ball?.frame.size.width)!/2
        // let diffX = location.x - ball.frame.origin.x - ball.frame.size.width/2
        ball?.pushDown((self.goalKeeper?.position)!)
        ball?.physicsBody?.applyImpulse(CGVector(dx: -5 * diffX, dy: -1000))
        //ball?.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
    }
    
    override func update(_ currentTime: TimeInterval) {
        self.goalKeeper?.Update()
        
        //CollisionManager.CheckCollision(scene: self, object1: ball, object2: goalKeeper)
    }
}

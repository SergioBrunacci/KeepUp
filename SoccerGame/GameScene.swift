import SpriteKit
import GameplayKit

let screenSize = UIScreen.main.bounds
var screenWidth: CGFloat?
var screenHeight: CGFloat?

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    private var label : SKLabelNode?
    private var lblGoal : UILabel?
    private var spinnyNode : SKShapeNode?
    private var ball : SKLabelNode?
    private var score : Int = 0
    private var goal : Int = 0
    private var goalKeeper : GoalKeeper?
    
    override func didMove(to view: SKView) {
        screenWidth = frame.width
        screenHeight = frame.height
        
        self.ball = self.childNode(withName: "ball") as? SKLabelNode
        if let ball = self.ball {
            ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.fontSize/2)
            ball.physicsBody?.contactTestBitMask=1
        }
        self.ball?.zPosition = 2
        
        self.physicsWorld.contactDelegate = self
        // Get label node from scene and store it for use later
        self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
        if let label = self.label {
            label.alpha = 0.0
            label.run(SKAction.fadeIn(withDuration: 2.0))
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
        if let ball = self.ball {
            for t in touches {
                let location  = t.location(in: self)

                if ball.contains(location) {
                    score += 1
                    let diffX = location.x - ball.frame.origin.x - ball.frame.size.width/2
                    print(diffX)
                    ball.physicsBody?.applyImpulse(CGVector(dx: -5 * diffX, dy: 1000))
             
        //        if ((self.goalKeeper?.position.y)! < (ball.frame.origin.y + ball.frame.size.width/2))  {
                    if ((self.goalKeeper?.position.y)! < (location.y + ball.frame.size.width/2))  {
                        print("Goooaaalll", goal)
                        goal += 1
                        label?.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
                        label?.text = "\(goal)"
                    }
                }
            }
        }
        
        if let label = self.label {
            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
            label.text = "\(score)"
        }
        
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
        guard contact.bodyA.node?.name == "ground" || contact.bodyB.node?.name == "ground" else {
            if (contact.bodyA.node?.name == "goalkeeper") {
                keeperCatched(contact.bodyB.node!)
            }
            if (contact.bodyB.node?.name == "goalkeeper") {
                keeperCatched(contact.bodyA.node!)
            }
            return
        }
        score = 0
        if let label = self.label {
            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
            label.text = "\(score)"
        }

    }
    
    func keeperCatched( _ node: SKNode) {
        //print("catched \(node.name)")
        if (node.name == "ball") {
            keeperCatchedBall()
        } else {
            keeperMissedBall()
        }
    }
    
    func keeperCatchedBall() {
        print("Gotcha!")
        let diffX = (self.goalKeeper?.position.x)! - (ball?.frame.origin.x)! - (ball?.frame.size.width)!/2
        // let diffX = location.x - ball.frame.origin.x - ball.frame.size.width/2
        ball?.physicsBody?.applyImpulse(CGVector(dx: -5 * diffX, dy: -1000))
        //ball?.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
    }

    func keeperMissedBall() {
//        if ((self.goalKeeper?.position.y)! < (ball?.frame.origin.y)! + 50)  {
//            print("Goooaaalll")
//            goal += 1
//            label?.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
//            label?.text = "GOOOOOAAAAALLLL!!!!"
//        }

        //print("Goooaaalll!")
//        let diffX = (self.goalKeeper?.position.x)! - (ball?.frame.origin.x)! - (ball?.frame.size.width)!/2
        // let diffX = location.x - ball.frame.origin.x - ball.frame.size.width/2
//        ball?.physicsBody?.applyImpulse(CGVector(dx: -5 * diffX, dy: -1000))
        //ball?.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
    }

    override func update(_ currentTime: TimeInterval) {
        self.goalKeeper?.Update()
        
        //CollisionManager.CheckCollision(scene: self, object1: ball, object2: goalKeeper)
    }
}

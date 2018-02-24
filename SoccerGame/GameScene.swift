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
        self.label?.zPosition = 5.0
        
        
        // Create shape node to use during mouse interaction
        let w = (self.size.width + self.size.height) * 0.05
        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
        
        if let spinnyNode = self.spinnyNode {
            spinnyNode.lineWidth = 2.5
            
            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)))
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
        
        for t in touches {
            let location  = t.location(in: self)
            self.ball?.ballHit(location)
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
    
    // function called anytime a collision happens
    // between nodes configured to do so
    func didBegin(_ contact: SKPhysicsContact) {
        print("collision: " + (contact.bodyA.node?.name)! + " with " + (contact.bodyB.node?.name)! )
        if (contact.bodyA.node?.name == "ball") {
            self.ballHit(contact.bodyB.node!)
        }
        
        if (contact.bodyB.node?.name == "ball") {
            self.ballHit(contact.bodyA.node!)
        }
    }
    
    // ball collided with parameter node
    func ballHit(_ node: SKNode) {
        if (node.name == "goalkeeper") {
            keeperCatchedBall()
        }
        else if (node.name == "goal") {
            scoredAGoal()
        }
        else if (node.name == "ground") {
        }
    }
    
    func displayGoalLabel() {
        print("Goal!")

        label?.text = "GOAL!"
        label?.alpha = 1.0
        let pulse = SKAction.init(named: "Pulse")
        let fade = SKAction.fadeAlpha(to: 0.0, duration: 2.0)
        //let show = SKAction.fadeAlpha(to: 1.0, duration: 0.0)
        let changeLabel = SKAction.run {
            self.label?.text = "Score: \(self.score)"
        }
        
        let sequence = SKAction.sequence([pulse!, fade, changeLabel, pulse!, fade])
        self.label?.run(sequence)
    }
    
    func scoredAGoal() {
        score = score + 1;
        self.displayGoalLabel()
        self.replaceBall()
    }
    
    // generate a new ball after a goal
    func replaceBall() {
        self.ball?.destroy()
        self.ball = Ball()
        self.addChild(self.ball!)
    }
    
    func keeperCatchedBall() {
        print("Gotcha!")
        ball?.pushDown((self.goalKeeper?.position)!)
    }
    
    override func update(_ currentTime: TimeInterval) {
        self.goalKeeper?.Update()
        
        //CollisionManager.CheckCollision(scene: self, object1: ball, object2: goalKeeper)
    }
}

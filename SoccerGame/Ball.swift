import SpriteKit

class Ball : SKLabelNode { //: GameObject
    
    override init() {
        super.init()
        self.name = "ball"
        self.physicsBody = SKPhysicsBody(circleOfRadius: self.fontSize/2)
        self.physicsBody?.contactTestBitMask = 1//(self.physicsBody?.collisionBitMask)!
        self.zPosition = 4
        
        //self.fontName = "Helvetica"
        self.fontSize = 150.0
        self.text = "⚽️"
        self.physicsBody?.affectedByGravity = true
        //self.physicsWorld.gravity = CGVectorMake(0.0, -9.8);
        self.position = CGPoint(x: 500.0, y:450.0)
        self.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        self.verticalAlignmentMode   = SKLabelVerticalAlignmentMode.center
        //self.physicsBody?.allowsRotation = false
    }
    
    func start() {
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func checkPointCollision(_ p: CGPoint) -> Bool {
        return super.contains(p)
    }
    
    func pushDown(_ p: CGPoint) {
        self.applyImpulse(p, -1.0)
    }
    
    func pushUp(_ p: CGPoint) {
        self.applyImpulse(p, 1.0)
    }
    
    private func applyImpulse(_ p: CGPoint, _ ydirection: CGFloat) {
        let diffX = p.x - self.frame.origin.x - self.frame.size.width/2
        let xC: CGFloat = -2
        let yC: CGFloat = 70 * ydirection
        self.physicsBody?.applyImpulse(CGVector(dx: xC * diffX, dy: yC))
        print(diffX)
    }
    
    func destroy() {
        self.physicsBody?.isDynamic = false
        //self.run(SKAction.init(named: "Pulse")!, withKey: "fadeOut")//, completion: self.removeFromParent)
        //let pulse = SKAction.init(named: "Pulse")
        let fade = SKAction.fadeAlpha(to: 0.0, duration: 2.0)
        let removeFromParent = SKAction.removeFromParent()
        let sequence = SKAction.sequence([fade, removeFromParent])
        self.run(sequence)
    }
    
    func ballHit(_ p: CGPoint) -> Bool {
        if checkPointCollision(p) {
            self.applyImpulse(p, 1.0)
            return true
        }
        return false
    }
}

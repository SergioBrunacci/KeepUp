import SpriteKit

class Ball : SKLabelNode { //: GameObject
    
    override init() {
        super.init()
        self.name = "ball"
        // apply a circle body to ball
        self.physicsBody = SKPhysicsBody(circleOfRadius: self.fontSize/2)
        // apply collision
        self.physicsBody?.contactTestBitMask = 1//(self.physicsBody?.collisionBitMask)!
        self.zPosition = 4
        
        //self.fontName = "Helvetica"
        self.fontSize = 150.0
        self.text = "⚽️"
        self.physicsBody?.affectedByGravity = true
        self.position = CGPoint(x: 500.0, y:450.0)
        
        // center ball text with body center
        self.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        self.verticalAlignmentMode   = SKLabelVerticalAlignmentMode.center
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
    
    // apply a force vector to ball
    private func applyImpulse(_ p: CGPoint, _ ydirection: CGFloat) {
        let diffX = p.x - self.frame.origin.x - self.frame.size.width/2
        let xC: CGFloat = -2
        let yC: CGFloat = 70 * ydirection
        self.physicsBody?.applyImpulse(CGVector(dx: xC * diffX, dy: yC))
        print(diffX)
    }
    
    // destroy ball
    // applying freeze and fade effect
    func destroy() {
        // do not react anymore to physics
        self.physicsBody?.isDynamic = false
        // do not collide
        self.physicsBody?.contactTestBitMask = 0
        let fade = SKAction.fadeAlpha(to: 0.0, duration: 2.0)
        let removeFromParent = SKAction.removeFromParent()
        let sequence = SKAction.sequence([fade, removeFromParent])
        self.run(sequence)
    }
    
    // check if ball collided with point p
    // and push it if so
    func ballHit(_ p: CGPoint) {
        if checkPointCollision(p) {
            self.applyImpulse(p, 1.0)
            //return true
        }
        //return false
    }
}

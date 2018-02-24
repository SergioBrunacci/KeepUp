import SpriteKit

class Goal : SKLabelNode {
    
    override init() {
        super.init()
        self.name = "goal"
        self.text = ""
        //self.color = SKColor.red
        self.alpha = 0.0
        self.position = goalCenter()
        
        setPhysics()
    }
    
    func start() {
        
    }
    
    func goalCenter() -> CGPoint {
        let distanceFromTop: CGFloat = 140.0
        let centerx: CGFloat = 375.0
        let centery: CGFloat = screenHeight! - distanceFromTop
        return CGPoint(x: centerx, y: centery )
    }
    
    func setPhysics() {
        self.physicsBody = SKPhysicsBody(circleOfRadius: 1)
        self.physicsBody?.contactTestBitMask = (self.physicsBody?.collisionBitMask)!
        self.zPosition = 6
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.isDynamic = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func checkPointCollision(_ p: CGPoint) -> Bool {
        return super.contains(p)
    }
    
    func ballHit(_ p: CGPoint) -> Bool {
        if checkPointCollision(p) {
            //score += 1
            let diffX = p.x - self.frame.origin.x - self.frame.size.width/2
            print(diffX)
            self.physicsBody?.applyImpulse(CGVector(dx: -5 * diffX, dy: 1000))
            return true
        }
        return false
    }
}

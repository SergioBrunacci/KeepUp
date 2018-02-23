import SpriteKit

class Ball : SKLabelNode { //: GameObject
    
    override init() {
        super.init()
        self.physicsBody = SKPhysicsBody(circleOfRadius: self.fontSize/2)
        self.physicsBody?.contactTestBitMask = 1
        self.zPosition = 4
        
        self.fontName = "Helvetica"
        self.fontSize = 150.0
        self.text = "⚽️"
        self.physicsBody?.affectedByGravity = true
        //self.physicsWorld.gravity = CGVectorMake(0.0, -9.8);
    }
    
    func start() {
        
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

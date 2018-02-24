import SpriteKit

class Goal : SKLabelNode {
    
    override init() {
        super.init()
        self.name = "goal"
        self.text = ""
        //self.color = SKColor.red
        self.alpha = 0.0
        // set this point to goal's center
        self.position = goalCenter()
        
        setPhysics()
    }
    
    func start() {
        
    }
    
    // return goal's center point
    func goalCenter() -> CGPoint {
        let distanceFromTop: CGFloat = 140.0
        let centerx: CGFloat = 375.0
        let centery: CGFloat = screenHeight! - distanceFromTop
        return CGPoint(x: centerx, y: centery )
    }
    
    // apply collision to goal
    // so we can check if ball entered
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
}

import SpriteKit

class GoalKeeper: GameObject {
    
    var velocity: CGFloat?
    var direction: CGFloat?
    var distanceFromGoal: CGFloat?
    var fieldBorderHeight: CGFloat?
    
    // constructor
    init(Velocity velocity: CGFloat) {
        self.velocity = velocity
        self.direction = 1.0
        self.fieldBorderHeight = 63.0
        self.distanceFromGoal = 40.0
        
        super.init(imageString: "goalkeeper", initialScale: 1.0)

        Start()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func CheckBounds() {
        // right boundary
        if(self.position.x > screenWidth! - self.halfwidth!) {
            self.position.x = screenWidth! - self.halfwidth!
            self.changeDirection()
        }
        
        // left boundary
        if(self.position.x < self.halfwidth!) {
            self.position.x = self.halfwidth!
            self.changeDirection()
        }
    }
    
    override func Start() {
        // swift3.0 bugfix
        let startingY: CGFloat = CGFloat((screenHeight!) - CGFloat(self.halfheight!)) -
            CGFloat((self.distanceFromGoal!) + (self.fieldBorderHeight!))
        self.position = CGPoint(x: self.halfwidth!, y: startingY )
        self.zPosition = 3
        setPhysics()
    }
    
    func setPhysics() {
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody?.isDynamic = false
        self.physicsBody?.contactTestBitMask = (self.physicsBody?.collisionBitMask)!
    }
    
    func ballCollision() {
        
        
    }
    
    /*
    func setPhysics() {
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        physicsBody!.usesPreciseCollisionDetection = true
        //physicsBody!.categoryBitMask = PhysicsCategory.Edge
        physicsBody!.friction = 0
        physicsBody!.restitution = 1
        physicsBody!.angularDamping = 0
        physicsBody!.linearDamping = 0
        self.physicsBody?.isDynamic = false
    }*/
    
    override func Update() {
        self.moveTick()
        self.CheckBounds()
    }
    
    /*
    func TouchMove(newPos: CGPoint) {
        self.position = newPos
    }*/
    
    func changeDirection() {
        self.direction = self.direction! * CGFloat(-1.0)
    }
    
    func moveTick() {
        self.position = CGPoint(x: self.position.x + ( self.direction! * self.velocity!), y: self.position.y)
    }
    
}

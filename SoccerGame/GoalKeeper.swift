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
        self.distanceFromGoal = 60.0
        
        super.init(imageString: "goalkeeper", initialScale: 1.0)

        Start()
    }
    
    override func Start() {
        // swift3.0 bugfix
        let startingY: CGFloat = CGFloat((screenHeight!) - CGFloat(self.halfheight!)) -
            CGFloat((self.distanceFromGoal!) + (self.fieldBorderHeight!))
        self.position = CGPoint(x: self.halfwidth!, y: startingY )
        self.zPosition = 3
        setPhysics()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // check to see if goalkeeper is going outside the field
    // and change direction if so
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
    
    // apply physics to goalkeeper
    func setPhysics() {
        // rectangular body
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        // do no react to collisions
        self.physicsBody?.isDynamic = false
        // apply collision
        self.physicsBody?.contactTestBitMask = (self.physicsBody?.collisionBitMask)!
    }
    
    override func Update() {
        self.moveTick()
        self.CheckBounds()
    }
    
    func changeDirection() {
        self.direction = self.direction! * CGFloat(-1.0)
    }
    
    // move goalkeeper
    func moveTick() {
        self.position = CGPoint(x: self.position.x + ( self.direction! * self.velocity!), y: self.position.y)
    }
    
}

import SpriteKit

class GoalKeeper: GameObject {
    
    var velocity: CGFloat?
    var direction: CGFloat?
    
    // constructor
    init(Velocity velocity: CGFloat) {
        self.velocity = velocity
        self.direction = 1.0
        
        super.init(imageString: "goalkeeper", initialScale: 1.0)
        
        Start()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func CheckBounds() {
        // right boundary
        if(self.position.x > screenSize.width - self.halfwidth!) {
            self.position.x = screenSize.width - self.halfwidth!
            self.changeDirection()
        }
        
        // left boundary
        if(self.position.x < self.halfwidth!) {
            self.position.x = self.halfwidth!
            self.changeDirection()
        }
    }
    
    override func Start() {
        self.position = CGPoint(x: 0, y: 0)
        self.zPosition = 2
    }
    
    override func Update() {
        self.moveTick()
        self.CheckBounds()
    }
    
    func TouchMove(newPos: CGPoint) {
        self.position = newPos
    }
    
    func changeDirection() {
        self.direction = self.direction! * CGFloat(-1.0)
    }
    
    func moveTick() {
        self.position = CGPoint(x: self.position.x + ( self.direction! * self.velocity!), y: self.position.y)
    }
    
}

import CoreGraphics
import SpriteKit

class CollisionManager {
    
    init() {
        
    }
    
    public static func CheckCollision(scene: SKScene, object1: GameObject, object2: GameObject) {
        if(CGPoint.Distance(P1: object1.position, P2: object2.position) <
            object1.halfheight! + object2.halfheight!) {
            
            if(!object2.isColliding!) {
                if(object2.name == "goalkeeper") {
                    print("Goal Keeper collision!")
                    //scene.run(SKAction.playSoundFileNamed("yay", waitForCompletion: false))
                    //ScoreManager.Score += 100
                }
                
                /*
                if(object2.name == "cloud") {
                    scene.run(SKAction.playSoundFileNamed("thunder", waitForCompletion: false))
                    //ScoreManager.Lives -= 1
                }
                */
                
                object2.isColliding = true
            }
            
        }
        else {
            object2.isColliding = false
        }
    }
    
}

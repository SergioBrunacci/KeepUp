import CoreGraphics
import SpriteKit

public extension CGPoint {
    public static func Distance(P1:CGPoint, P2:CGPoint) -> CGFloat {
        return sqrt(pow((P2.x - P1.x), 2) + pow((P2.y - P1.y), 2))
    }
}

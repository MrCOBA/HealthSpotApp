
public protocol EntityWrapper: AnyObject {}

public class CompositeCollectionWrapper<A: EntityWrapper, B: EntityWrapper> {

    public let first: A
    public let second: [B]

    public init(wrappers first: A, _ second: [B]) {
        self.first = first
        self.second = second
    }

}

import Foundation
import Combine

extension CurrentValueSubject {
    func mutate(closure: (inout Output) -> ()) {
        var _value = value
        closure(&_value)
        send(_value)
    }
    
    func mutate<T>(_ keyPath: WritableKeyPath<Output, T>, _ newValue: T) {
        var _value = value
        _value[keyPath: keyPath] = newValue
        send(_value)
    }
}

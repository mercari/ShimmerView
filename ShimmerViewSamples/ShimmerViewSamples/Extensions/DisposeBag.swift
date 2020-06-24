import Combine

class DisposeBag {
    fileprivate var cancellables = [AnyCancellable]()
}

extension AnyCancellable {
    func add(to disposeBag: DisposeBag) {
        disposeBag.cancellables.append(self)
    }
}

import UIKit

extension UIView {
    func bounceOut(duration: TimeInterval) {
        UIView.animate(withDuration: duration, animations: { [unowned self] in
            self.transform = CGAffineTransform(scaleX: 0.0001, y: 0.0001)
        })
    }
}

let view = UIView()
view.bounceOut(duration: 3)

extension Int {
    func times(closure: () -> Void) {
        guard self > 0 else { return }
        
        for _ in 0 ..< self {
            closure()
        }
    }
}

5.times() {
    print("Hello")
}

extension Array where Element: Comparable {
    mutating func remove(item: Element) {
        if let index = self.firstIndex(of: item) {
            self.remove(at: index)
        }
    }
}



var arrays = ["Swift", "Dog", "Cat", "Cat", "Mouse"]
print(arrays)
arrays.remove(item: "Cat")
print(arrays)

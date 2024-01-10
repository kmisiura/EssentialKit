#if os(iOS)
import UIKit

public extension UIView {
    
    /// Constrain view to it's superview
    ///
    /// This method include translatesAutoresizingMaskIntoConstraints = false
    /// - Parameters:
    ///   - view: view to contrain
    ///   - topInset: default zero
    ///   - leadingInset: default zero
    ///   - bottomInset: default zero
    ///   - trailingInset: default zero
    ///   - edges: default .all
    func pinToSuperview(topInset: CGFloat = 0, leadingInset: CGFloat = 0, bottomInset: CGFloat = 0, trailingInset: CGFloat = 0, edges: UIRectEdge = .all) {
        guard let superview = superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        if edges.contains(.top) {
            topAnchor.constraint(equalTo: superview.topAnchor, constant: topInset).isActive = true
        }
        if edges.contains(.bottom) {
            bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -bottomInset).isActive = true
        }
        if edges.contains(.left) {
            leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: leadingInset).isActive = true
        }
        if edges.contains(.right) {
            trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -trailingInset).isActive = true
        }
    }
    
    /// Constrain view to specified view
    ///
    /// This method include translatesAutoresizingMaskIntoConstraints = false
    /// - Parameters:
    ///   - view: view to contrain
    ///   - topInset: default zero
    ///   - leadingInset: default zero
    ///   - bottomInset: default zero
    ///   - trailingInset: default zero
    ///   - edges: default .all
    func pin(to view: UIView, topInset: CGFloat = 0, leadingInset: CGFloat = 0, bottomInset: CGFloat = 0, trailingInset: CGFloat = 0, edges: UIRectEdge = .all) {
        translatesAutoresizingMaskIntoConstraints = false
        if edges.contains(.top) {
            topAnchor.constraint(equalTo: view.topAnchor, constant: topInset).isActive = true
        }
        if edges.contains(.bottom) {
            bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -bottomInset).isActive = true
        }
        if edges.contains(.left) {
            leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leadingInset).isActive = true
        }
        if edges.contains(.right) {
            trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -trailingInset).isActive = true
        }
    }
    
    @available(iOS 9.0, *)
    func constraintsToFillContainer(_ container: UIView, insetingBy points: CGFloat = 0.0, useSafeArea: Bool = true) -> [NSLayoutConstraint] {
        
        let constraints: [NSLayoutConstraint]
        
        if useSafeArea {
            constraints = [
                self.topAnchor.constraint(equalTo: container.safeAreaLayoutGuide.topAnchor, constant: points),
                self.leadingAnchor.constraint(equalTo: container.safeAreaLayoutGuide.leadingAnchor, constant: points),
                self.bottomAnchor.constraint(equalTo: container.safeAreaLayoutGuide.bottomAnchor, constant: -points),
                self.trailingAnchor.constraint(equalTo: container.safeAreaLayoutGuide.trailingAnchor, constant: -points)
            ]
        } else {
            constraints = [
                self.topAnchor.constraint(equalTo: container.topAnchor, constant: points),
                self.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: points),
                self.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -points),
                self.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -points)
            ]
        }
        
        return constraints
    }
    
    @available(iOS 9.0, *)
    func constraintsToCenterInContainer(_ container: UIView, useSafeArea: Bool = true) -> [NSLayoutConstraint] {
        
        let constraints: [NSLayoutConstraint]
        
        if useSafeArea {
            constraints = [
                self.centerYAnchor.constraint(equalTo: container.centerYAnchor),
                self.centerXAnchor.constraint(equalTo: container.centerXAnchor)
            ]
        } else {
            constraints = [
                self.centerYAnchor.constraint(equalTo: container.safeAreaLayoutGuide.centerYAnchor),
                self.centerXAnchor.constraint(equalTo: container.safeAreaLayoutGuide.centerXAnchor)
            ]
        }
        
        return constraints
    }
    
    ///Same as addSubview, but already have view.translatesAutoresizingMaskIntoConstraints = false
    func addConstrainedSubview(_ view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
    }
    
    ///Add array of views as subviews and set translatesAutoresizingMaskIntoConstraints to false for them
    func addConstrainedSubviews(_ views: [UIView]) {
        views.forEach(addConstrainedSubview)
    }
    
}

public extension Array where Element == NSLayoutConstraint {
    func activate() {
        NSLayoutConstraint.activate(self)
    }
    
    func deactivate() {
        NSLayoutConstraint.deactivate(self)
    }
}
#endif

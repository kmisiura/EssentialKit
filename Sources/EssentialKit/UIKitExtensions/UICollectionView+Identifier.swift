#if os(iOS)
import UIKit

public protocol ReusableView: AnyObject {}

public extension ReusableView where Self: UIView {
    static var reuseIdentifier: String { String(describing: self) }
    ///The kind identifier of the supplementary view.
    static var supplementaryViewKind: String { String(describing: self) + "-supplementary-view-kind" }
}

extension UICollectionReusableView: ReusableView {}
extension UITableViewCell: ReusableView {}
extension UITableViewHeaderFooterView: ReusableView {}

public extension UICollectionView {
    
    /// Registers a class for use in creating new collection view cells.
    ///
    /// - Important : This method use class name as reuseIdentifier
    /// - Parameter cellClass: The class of a cell that you want to use in the collection view.
    func register<Cell: UICollectionViewCell>(_ cellClass: Cell.Type) {
        register(Cell.self, forCellWithReuseIdentifier: cellClass.reuseIdentifier)
    }
    
    /// Registers a nib, by using class name for nib name, for use in creating new collection view cells.
    ///
    /// - Important : This method use class name as reuseIdentifier
    /// - Parameter cellClass: The class to use for generating nib name for collection view cell.
    func registerNib<Cell: UICollectionViewCell>(_ cellClass: Cell.Type) {
        let nib = UINib(nibName: String(describing: cellClass), bundle: nil)
        register(nib, forCellWithReuseIdentifier: cellClass.reuseIdentifier)
    }
    
    /// Dequeues a reusable cell object located by its identifier.
    ///
    ///  Throws fatal error if identifiers do not match
    /// - Parameters:
    ///   - cellClass: The class of a cell that you want to use in the collection view.
    ///   - indexPath: The index path specifying the location of the cell.
    /// - Returns: UICollectionViewCell of the dequed class.
    func dequeueReusableCell<Cell: UICollectionViewCell>(_ cellClass: Cell.Type, forIndexPath indexPath: IndexPath) -> Cell {
         guard let cell = dequeueReusableCell(withReuseIdentifier: cellClass.reuseIdentifier, for: indexPath) as? Cell else {
             fatalError("Could not dequeue cell with identifier: \(cellClass.reuseIdentifier)")
         }
         return cell
     }
    
    /// Registers a class for use in creating supplementary views for the collection view.
    ///
    /// - Important : This method use class name as reuseIdentifier and class name + "-supplementary-view-kind" as element kind identifier.
    /// - Parameter viewClass: The class to use for the supplementary view.
    func register<SupplementaryView: UICollectionReusableView>(_ viewClass: SupplementaryView.Type) {
        register(SupplementaryView.self,
                 forSupplementaryViewOfKind: viewClass.supplementaryViewKind,
                 withReuseIdentifier: viewClass.reuseIdentifier)
    }
    
    /// Registers a nib, by using class name for nib name, for use in creating supplementary views for the collection view.
    ///
    /// - Important : This method use class name as reuseIdentifier and class name + "-supplementary-view-kind" as element kind identifier.
    /// - Parameter viewClass: The class to use for generating nib name for the supplementary view.
    func registerNib<SupplementaryView: UICollectionReusableView>(_ viewClass: SupplementaryView.Type) {
        let nib = UINib(nibName: String(describing: viewClass), bundle: nil)
        register(nib,
                 forSupplementaryViewOfKind: viewClass.supplementaryViewKind,
                 withReuseIdentifier: viewClass.reuseIdentifier)
    }
    
    /// Dequeues a reusable supplementary view located by its identifier and kind.
    ///
    /// - Parameters:
    ///   - viewClass: The class to use for the supplementary view.
    ///   - indexPath: The index path specifying the location of the view.
    /// - Returns: UICollectionReusableView of the dequed class.
    func dequeueReusableSupplementaryView<SupplementaryView: UICollectionReusableView>(_ viewClass: SupplementaryView.Type, forIndexPath indexPath: IndexPath) -> SupplementaryView {
        guard let supplementaryView = dequeueReusableSupplementaryView(ofKind: viewClass.supplementaryViewKind,
                                                                       withReuseIdentifier: viewClass.reuseIdentifier,
                                                                       for: indexPath) as? SupplementaryView else {
            fatalError("Could not dequeue SupplementaryView with identifier: \(viewClass.reuseIdentifier)")
        }
        return supplementaryView
    }
}

public extension UITableView {
    
    /// Registers a class for use in creating new table view cells.
    ///
    /// - Important : This method use class name as reuseIdentifier
    /// - Parameter cellClass: The class of a cell that you want to use in the table view.
    func register<Cell: UITableViewCell>(_ cellClass: Cell.Type) {
        register(Cell.self, forCellReuseIdentifier: cellClass.reuseIdentifier)
    }
    
    /// Registers a nib, by using class name for nib name, for use in creating new table view cells.
    ///
    /// - Important : This method use class name as reuseIdentifier
    /// - Parameter cellClass: The class to use for generating nib name for table view cell.
    func registerNib<Cell: UITableViewCell>(_ cellClass: Cell.Type) {
        let nib = UINib(nibName: String(describing: cellClass), bundle: nil)
        register(nib, forCellReuseIdentifier: cellClass.reuseIdentifier)
    }
    
    /// Dequeues a reusable cell object located by its identifier.
    ///
    ///  Throws fatal error if identifiers do not match
    /// - Parameters:
    ///   - cellClass: The class of a cell that you want to use in the table view.
    ///   - indexPath: The index path specifying the location of the cell.
    /// - Returns: UITableViewCell of the dequed class.
    func dequeueReusableCell<Cell: UITableViewCell>(_ cellClass: Cell.Type, forIndexPath indexPath: IndexPath) -> Cell {
        guard let cell = dequeueReusableCell(withIdentifier: cellClass.reuseIdentifier, for: indexPath) as? Cell else {
            fatalError("Could not dequeue cell with identifier: \(cellClass.reuseIdentifier)")
        }
        return cell
    }
    
    /// Registers a class for use in creating HeaderFooterView for the table view.
    ///
    func register<HeaderFooterView: UITableViewHeaderFooterView>(_ viewClass: HeaderFooterView.Type) {
        register(HeaderFooterView.self, forHeaderFooterViewReuseIdentifier: viewClass.reuseIdentifier)
    }
    
    func registerNib<HeaderFooterView: UITableViewHeaderFooterView>(_ viewClass: HeaderFooterView.Type) {
        let nib = UINib(nibName: String(describing: viewClass), bundle: nil)
        register(nib, forHeaderFooterViewReuseIdentifier: viewClass.reuseIdentifier)
    }
    
    func dequeueReusableHeaderFooter<HeaderFooter: UITableViewHeaderFooterView>(_ viewClass: HeaderFooter.Type, forIndexPath indexPath: IndexPath) -> HeaderFooter {
        guard let headerFooter = dequeueReusableHeaderFooterView(withIdentifier: viewClass.reuseIdentifier) as? HeaderFooter else {
            fatalError("Could not dequeue headerFooter with identifier: \(viewClass.reuseIdentifier)")
        }
        return headerFooter
    }
}

#endif

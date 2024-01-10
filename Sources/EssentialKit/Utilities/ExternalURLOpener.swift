#if os(iOS)
import UIKit
import SafariServices

public protocol ExternalURLOpener {}

public extension ExternalURLOpener {
    
    func openBrowserView(for urlString: String?, from viewController: UIViewController?) {
        guard let urlString = urlString, let url = URL(string: urlString) else { return }
        let safariViewController = SFSafariViewController(url: url)
        viewController?.present(safariViewController, animated: true, completion: nil)
    }
    
    func openBrowserView(for url: URL?, from viewController: UIViewController?) {
        guard let url = url else { return }
        let safariViewController = SFSafariViewController(url: url)
        viewController?.present(safariViewController, animated: true, completion: nil)
    }
}

public extension ExternalURLOpener where Self: UIViewController {
    
    func openBrowserView(for urlString: String?) {
        guard let urlString = urlString, let url = URL(string: urlString) else { return }
        let safariViewController = SFSafariViewController(url: url)
        present(safariViewController, animated: true, completion: nil)
    }
    
    func openBrowserView(for url: URL?) {
        guard let url = url else { return }
        let safariViewController = SFSafariViewController(url: url)
        present(safariViewController, animated: true, completion: nil)
    }
}
#endif

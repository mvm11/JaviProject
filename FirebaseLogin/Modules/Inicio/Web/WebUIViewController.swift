import UIKit
import WebKit
 
class WebUIViewController: UIViewController {
    
    // Mark - IBOutlets
    @IBOutlet weak var uiWKWebView: WKWebView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        
        setWKWebViewPreferences()
        loadPage(url: "https://www.behance.net/")

        
    }
    
    //MARK: - private methods
    
     fileprivate func setWKWebViewPreferences() {
        // Web View Prefs
        uiWKWebView.configuration.defaultWebpagePreferences.allowsContentJavaScript = true
        uiWKWebView.configuration.preferences.javaScriptCanOpenWindowsAutomatically = true
    }

    
    fileprivate func loadPage(url:String){
        uiWKWebView.load(URLRequest(url: URL(string: url)!))
    }

    
}

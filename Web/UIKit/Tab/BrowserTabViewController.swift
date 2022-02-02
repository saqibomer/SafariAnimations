//
//  BrowserTabViewController.swift
//  Web
//
//  Created by Saqib Omer on 30/01/2022.
//

import UIKit
import WebKit

protocol BrowserTabViewControllerDelegate: AnyObject {
  func tabViewController(_ tabViewController: BrowserTabViewController, didStartLoadingURL url: URL)
  func tabViewController(_ tabViewController: BrowserTabViewController, didChangeLoadingProgressTo progress: Float)
  func tabViewControllerDidScroll(yOffsetChange: CGFloat)
  func tabViewControllerDidEndDragging()
}

class BrowserTabViewController: UIViewController {
  private let contentView = BrowserTabContentView()
  private var isScrolling = false
  private var startYOffset = CGFloat(0)
  private var loadingProgressObservation: NSKeyValueObservation?
  var hasLoadedUrl = false
  weak var delegate: BrowserTabViewControllerDelegate?
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    let isBackgroundColorDark = contentView.statusBarBackgroundView.backgroundColor?.isDark ?? false
    return isBackgroundColorDark ? .lightContent : .darkContent
  }
  
  override func loadView() {
    view = contentView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupWebView()
  }
  
  override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
    switch keyPath {
    case #keyPath(WKWebView.url):
        guard let url = contentView.webView.url else {return}
      delegate?.tabViewController(self, didStartLoadingURL: url)
    case #keyPath(WKWebView.estimatedProgress):
      delegate?.tabViewController(self, didChangeLoadingProgressTo: Float(contentView.webView.estimatedProgress))
    case #keyPath(WKWebView.themeColor):
      updateStatusBarColor()
    case #keyPath(WKWebView.underPageBackgroundColor):
      updateStatusBarColor()
    default:
      break
    }
  }
  
  func loadWebsite(from url: URL) {
    contentView.webView.load(URLRequest(url: url))
    hasLoadedUrl = true
    hideEmptyStateIfNeeded()
  }
  
  func showEmptyState() {
    UIView.animate(withDuration: 0.2) {
      self.contentView.emptyStateView.alpha = 1
    }
  }
  
  func hideEmptyStateIfNeeded() {
    guard hasLoadedUrl else { return }
    UIView.animate(withDuration: 0.2) {
      self.contentView.emptyStateView.alpha = 0
    }
  }
}

// MARK: Helper methods
private extension BrowserTabViewController {
  func setupWebView() {
    contentView.webView.scrollView.panGestureRecognizer.addTarget(self, action: #selector(handlePan(_:)))
    contentView.webView.navigationDelegate = self
    contentView.webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
    contentView.webView.addObserver(self, forKeyPath: #keyPath(WKWebView.url), options: .new, context: nil)
    contentView.webView.addObserver(self, forKeyPath: #keyPath(WKWebView.themeColor), options: .new, context: nil)
    contentView.webView.addObserver(self, forKeyPath: #keyPath(WKWebView.underPageBackgroundColor), options: .new, context: nil)
  }
  
  func updateStatusBarColor() {
    let color = (contentView.webView.themeColor ?? contentView.webView.underPageBackgroundColor ?? .white).withAlphaComponent(1)
    contentView.statusBarBackgroundView.backgroundColor = color
    setNeedsStatusBarAppearanceUpdate()
  }
}

// MARK: Action methods
private extension BrowserTabViewController {
  @objc func handlePan(_ panGestureRecognizer: UIPanGestureRecognizer) {
    let yOffset = contentView.webView.scrollView.contentOffset.y
    switch panGestureRecognizer.state {
    case .began:
      startYOffset = yOffset
    case .changed:
      delegate?.tabViewControllerDidScroll(yOffsetChange: startYOffset - yOffset)
    case .failed, .ended, .cancelled:
      delegate?.tabViewControllerDidEndDragging()
    default:
      break
    }
  }
}

// MARK: WKNavigationDelegate
extension BrowserTabViewController: WKNavigationDelegate {
  func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
    if navigationAction.navigationType == .linkActivated {
      // handle redirects
      guard let url = navigationAction.request.url else { return }
      webView.load(URLRequest(url: url))
    }
    decisionHandler(.allow)
  }
}

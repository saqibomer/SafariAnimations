//
//  BrowserContainerViewController.swift
//  Web
//
//  Created by Saqib Omer on 30/01/2022.
//

import UIKit
import Combine
import SwiftUI


class BrowserContainerViewController: UIViewController {
    let contentView = BrowserContainerContentView()
    var tabViewControllers = [BrowserTabViewController]()
    let viewModel: BrowserContainerViewModel
    var isVerticalPan = false
    var dragValue = 1.0
    @Binding var tabs: [Tab]
    
    
    // Address bar animation properties
    var isAddressBarActive = false
    var hasHiddenTab = false
    var currentTabIndex = 0 {
        didSet {
            updateAddressBarsAfterTabChange()
            setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    
    
    // Toolbar animation properties
    var collapsingToolbarAnimator: UIViewPropertyAnimator?
    var expandingToolbarAnimator: UIViewPropertyAnimator?
    var isCollapsed = false
    
    var currentAddressBar: BrowserAddressBar {
        contentView.addressBars[currentTabIndex]
    }
    
    var leftAddressBar: BrowserAddressBar? {
        contentView.addressBars[safe: currentTabIndex - 1]
    }
    
    var rightAddressBar: BrowserAddressBar? {
        contentView.addressBars[safe: currentTabIndex + 1]
    }
    
    override var childForStatusBarStyle: UIViewController? {
        tabViewControllers[safe: currentTabIndex]
    }
    
    init(viewModel: BrowserContainerViewModel = .init(), tabs: Binding<[Tab]>) {
        self.viewModel = viewModel
        _tabs = tabs
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCancelButton()
        setupAddressBarsScrollView()
        setupAddressBarsExpandingOnTap()
        setupAddressBarSwipeUp()
        setupKeyboardManager()
        setupPanGesture()
        openNewTab(isHidden: false)
    }
    
    func setCancelButtonHidden(_ isHidden: Bool) {
        UIView.animate(withDuration: 0.1) {
            self.contentView.cancelButton.alpha = isHidden ? 0 : 1
        }
    }
}

// MARK: Helper methods
private extension BrowserContainerViewController {
    func setupAddressBarsScrollView() {
        contentView.addressBarsScrollView.delegate = self
    }
    
    func setupCancelButton() {
        contentView.cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
    }
    
    func openNewTab(isHidden: Bool) {
        addTabViewController(isHidden: isHidden)
        addAddressBar(isHidden: isHidden)
    }
    
    func scrollToLast() {
        let bottomOffset = CGPoint(x: Int(contentView.tabsScrollView.contentSize.width) * tabViewControllers.count, y: 0)
        contentView.tabsScrollView.setContentOffset(bottomOffset, animated: true)
        
    }
    
    func addTabViewController(isHidden: Bool) {
        let tabViewController = BrowserTabViewController()
        tabViewController.view.alpha = isHidden ? 0 : 1
        tabViewController.view.transform = isHidden ? CGAffineTransform(scaleX: 0.8, y: 0.8) : .identity
        tabViewController.showEmptyState()
        tabViewController.delegate = self
        tabViewControllers.append(tabViewController)
        contentView.tabsStackView.addArrangedSubview(tabViewController.view)
        tabViewController.view.snp.makeConstraints {
            $0.width.equalTo(contentView)
        }
        addChild(tabViewController)
        tabViewController.didMove(toParent: self)
    }
    
    func addAddressBar(isHidden: Bool) {
        let addressBar = BrowserAddressBar()
        addressBar.delegate = self
        contentView.addressBarsStackView.addArrangedSubview(addressBar)
        addressBar.snp.makeConstraints {
            $0.width.equalTo(contentView).offset(contentView.addressBarWidthOffset)
        }
        
        if isHidden {
            hasHiddenTab = true
            addressBar.containerViewWidthConstraint?.update(offset: contentView.addressBarContainerHidingWidthOffset)
            addressBar.containerView.alpha = 0
            addressBar.plusOverlayView.alpha = 1
        }
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func updateAddressBarsAfterTabChange() {
        currentAddressBar.setSideButtonsHidden(false)
        currentAddressBar.isUserInteractionEnabled = true
        leftAddressBar?.setSideButtonsHidden(true)
        leftAddressBar?.isUserInteractionEnabled = false
        rightAddressBar?.setSideButtonsHidden(true)
        rightAddressBar?.isUserInteractionEnabled = false
    }
    
    func setupAddressBarsExpandingOnTap() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(addressBarScrollViewTapped))
        contentView.addressBarsScrollView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func setupAddressBarSwipeUp() {
//        let swipeUpGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeUpGestureRecogniser))
//        swipeUpGesture.direction = .up
//        contentView.addressBarsScrollView.addGestureRecognizer(swipeUpGesture)
    }
    
    func setupPanGesture() {
        let panGestureRecognizer = PanDirectionGestureRecognizer(direction: .vertical, target: self, action: #selector(didPan(_:)))
        panGestureRecognizer.delegate = self
        panGestureRecognizer.cancelsTouchesInView = false
        contentView.addressBarsStackView.addGestureRecognizer(panGestureRecognizer)
    }
    
    func animateView() {
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: [.curveEaseInOut]) {
            
            self.contentView.tabsScrollView.transform = CGAffineTransform(scaleX: self.dragValue, y: self.dragValue)
            
            for controller in self.tabViewControllers {
                controller.view.clipsToBounds = true
                
            }

        }
    }
}

// MARK: Action methods
extension BrowserContainerViewController {
    @objc func cancelButtonTapped() {
        dismissKeyboard()
    }
    
    @objc func addressBarScrollViewTapped() {
        guard isCollapsed else { return }
        setupExpandingToolbarAnimator()
        expandingToolbarAnimator?.startAnimation()
        isCollapsed = false
    }
    
    @objc func swipeUpGestureRecogniser() {
        var homeView = Home(tabs: self.viewModel.tabs)
        homeView.onAddNewTab = { [weak self] hidden in
            self?.openNewTab(isHidden: hidden)
            self?.scrollToLast()
        }
        
        let viewCtrl = UIHostingController(rootView: homeView)
        viewCtrl.modalPresentationStyle = .fullScreen
        self.present(viewCtrl, animated: true, completion: nil)
        
          
    }
    
    @objc private func didPan(_ gestureRecognizer: UIPanGestureRecognizer) {
        switch gestureRecognizer.state {
        case .began:
            print("Started")
            
        case .changed:
            
            let trnslation = gestureRecognizer.translation(in: gestureRecognizer.view)
            let fraction = trnslation.y / view.bounds.height
            
            
            
            dragValue =  1 - (fraction * (-1))
            
            if dragValue > 1 {
                dragValue = 1
                for controller in self.tabViewControllers {
                    controller.view.clipsToBounds = false
                    
                }
            }
            
            if dragValue <= 0.5 {
                dragValue = 0.5
            }
                
            if isVerticalPan {
                self.animateView()
            }
            
            
            
            

            
        case .ended:
            if dragValue == 0.5 {
                var homeView = Home(tabs: self.viewModel.tabs)
                homeView.onAddNewTab = { [weak self] hidden in
                    self?.openNewTab(isHidden: hidden)
                    self?.scrollToLast()
                }
                
                let viewCtrl = UIHostingController(rootView: homeView)
                viewCtrl.modalPresentationStyle = .fullScreen
                self.present(viewCtrl, animated: true) {
                    self.dragValue = 1.0
                    self.animateView()
                }
            } else {
                dragValue = 1.0
                self.animateView()
                
            }
            print("Ended")
            case .cancelled:
            print("Ended")
            
        default:
            break
        }
    }
    
    
}

// MARK: BrowserAddressBarDelegate
extension BrowserContainerViewController: BrowserAddressBarDelegate {
    func addressBarDidBeginEditing() {
        isAddressBarActive = true
    }
    
    func addressBar(_ addressBar: BrowserAddressBar, didReturnWithText text: String) {
        let tabViewController = tabViewControllers[currentTabIndex]
        let isLastTab = currentTabIndex == tabViewControllers.count - 1
        if isLastTab && !tabViewController.hasLoadedUrl {
            // if we started loading a URL and it is on the last tab then ->
            // open a hidden tab so that we can prepare it for new tab animation if the user swipes to the left
            openNewTab(isHidden: true)
        }
        if let url = self.viewModel.getURL(for: text) {
            addressBar.domainLabel.text = viewModel.getDomain(from: url)
            tabViewController.loadWebsite(from: url)
            let tab = Tab(tabURL: url.absoluteString)
            if !self.viewModel.tabs.contains(tab) {
                self.viewModel.tabs.append(tab)
            }
            
            
        }
        dismissKeyboard()
    }
}

extension BrowserContainerViewController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let gesture = gestureRecognizer as? UIPanGestureRecognizer else { return false }
        
        let translation = gesture.translation(in: self.view)
        self.isVerticalPan = abs(translation.y) > abs(translation.x); // BOOL property

        return self.isVerticalPan
    }
}

//
//  AppolyViewController.swift
//  ContactsList
//
//  Created by Elliott Walker on 08/04/2021.
//

import UIKit
import JGProgressHUD
import QuickLook


typealias JSONDictionary = [String : Any]
typealias JSONArray = [JSONDictionary]

class AppolyViewController: UIViewController {
    
    // MARK: - IBACtion
    
    @objc private func back() {
        if(navigationController != nil && navigationController?.viewControllers.count ?? 0 > 1) {
            navigationController?.popViewController(animated: true)
        } else {
            navigationController?.dismiss(animated: true, completion: nil)
        }
    }
    
    

    // MARK: Backend Variables
    
    @IBInspectable var hideNavBar: Bool = true
    let errorHUD = JGProgressHUD(style: .dark)
    let successHUD = JGProgressHUD(style: .dark)
    let spinnerHUD = JGProgressHUD(style: .dark)
    var previewItem: URL!
    
    public static var identifier: String {
        return NSStringFromClass(self).components(separatedBy: ".").last ?? ""
    }
    
    
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBackButton()
        setupHUDs()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(hideNavBar, animated: true)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
    
    
    
    // MARK: - Utilities
    
    private func setupBackButton() {
        let backButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(back))
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = backButton
    }
    
    func makeNavBarTransparent(_ navigationBar: UINavigationBar) {
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = true
    }

    
    func getSafeAreaInsets() -> UIEdgeInsets? {
        let window = UIApplication.shared.keyWindow
        return window?.safeAreaInsets
    }
    
    
    private func setupHUDs() -> Void {
        errorHUD.indicatorView = JGProgressHUDErrorIndicatorView()
        successHUD.indicatorView = JGProgressHUDSuccessIndicatorView()
    }
    
    
    func showError(message: String, completion: (() -> Void)?) -> Void {
        errorHUD.detailTextLabel.text = message
        errorHUD.show(in: view)
        
        if(completion != nil) {
            completion?()
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: { [weak self] in
                self?.hideError(completion: nil)
            })
        }
    }
    
    
    func hideError(completion: (() -> Void)?) -> Void {
        errorHUD.dismiss()
        errorHUD.detailTextLabel.text = ""
        completion?()
    }
    
    
    func showSuccess(message: String, completion: (() -> Void)?) -> Void {
        successHUD.detailTextLabel.text = message
        successHUD.show(in: view)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            guard let self = self else { return }
            self.successHUD.dismiss()
            completion?()
        }
    }
    
    
    func hideSuccess(blankText: Bool = true, completion: (() -> Void)?) {
        if blankText {
            successHUD.detailTextLabel.text = ""
        }
        
        successHUD.dismiss()
        completion?()
    }
    
    
    func showSpinner(message: String) -> Void {
        spinnerHUD.detailTextLabel.text = message
        spinnerHUD.show(in: view)
    }
    
    
    func hideSpinner(animated: Bool = true) {
        spinnerHUD.detailTextLabel.text = ""
        spinnerHUD.dismiss(animated: animated)
    }
    

    func getViewController<T: UIViewController>(withIdentifier id: String) -> T? {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: id) as? T else { return nil }
        return vc
    }
    
    
    func getViewController<T: UIViewController>(withStoryboardId storyId: String, withIdentifier id: String) -> T? {
        guard let vc = UIStoryboard(name: storyId, bundle: .main).instantiateViewController(withIdentifier: id) as? T else { return nil }
        return vc
    }
    
    
    func pushViewController(_ viewController: UIViewController, animated: Bool) {
        navigationController?.pushViewController(viewController, animated: animated)
    }
}



extension AppolyViewController: QLPreviewControllerDataSource, QLPreviewControllerDelegate {
    
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return 1
    }
    
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        return previewItem as QLPreviewItem
    }
    
    
    func previewControllerDidDismiss(_ controller: QLPreviewController) {
        previewItem = nil
    }
    
}



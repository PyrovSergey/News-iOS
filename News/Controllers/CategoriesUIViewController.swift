//
//  CategoriesUIViewController.swift
//  News
//
//  Created by Sergey on 01/04/2019.
//  Copyright © 2019 Sergey. All rights reserved.
//

import UIKit
import SwipeMenuViewController
import Alamofire
import SwiftyJSON

class CategoriesUIViewController: SwipeMenuViewController, NetworkProtocol {
    
    private let arraySwipe = ["General", "Entertainment", "Sport", "Technology", "Health", "Business"]
    private var arrayControllers = [String : ContentTableViewController]()
    
    var options = SwipeMenuViewOptions()
    var dataCount: Int = 6
    
    override func viewDidLoad() {
        arraySwipe.forEach { data in
            let vc = ContentTableViewController()
            arrayControllers[data] = vc
            vc.title = data
            vc.parentController = self
            //vc.setNewListCategoryAndUpdateUI(articleArray: TemporaryStorage.instace.getCategoryList(categoryName: data))
            self.addChild(vc)
        }
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NetworkManager.instace.getUpdateCategoryLists(listener: self)
    }
    
    func successRequest(result: [Article], category: String) {
        let vc = arrayControllers[category]
        vc?.setNewListCategoryAndUpdateUI(articleArray: result)
    }
    
    func errorRequest(errorMessage: String) {
        
    }
    
    private func reload() {
        swipeMenuView.reloadData(options: options)
    }
    
    // MARK: - SwipeMenuViewDelegate
    override func swipeMenuView(_ swipeMenuView: SwipeMenuView, viewWillSetupAt currentIndex: Int) {
        super.swipeMenuView(swipeMenuView, viewWillSetupAt: currentIndex)
        //print("will setup SwipeMenuView")
    }
    
    override func swipeMenuView(_ swipeMenuView: SwipeMenuView, viewDidSetupAt currentIndex: Int) {
        super.swipeMenuView(swipeMenuView, viewDidSetupAt: currentIndex)
        //print("did setup SwipeMenuView")
    }
    
    override func swipeMenuView(_ swipeMenuView: SwipeMenuView, willChangeIndexFrom fromIndex: Int, to toIndex: Int) {
        super.swipeMenuView(swipeMenuView, willChangeIndexFrom: fromIndex, to: toIndex)
        //print("will change from section\(fromIndex + 1)  to section\(toIndex + 1)")
    }
    
    override func swipeMenuView(_ swipeMenuView: SwipeMenuView, didChangeIndexFrom fromIndex: Int, to toIndex: Int) {
        super.swipeMenuView(swipeMenuView, didChangeIndexFrom: fromIndex, to: toIndex)
        //print("did change from section\(fromIndex + 1)  to section\(toIndex + 1)")
    }
    
    
    // MARK - SwipeMenuViewDataSource
    override func numberOfPages(in swipeMenuView: SwipeMenuView) -> Int {
        return dataCount
    }
    
    override func swipeMenuView(_ swipeMenuView: SwipeMenuView, titleForPageAt index: Int) -> String {
        return children[index].title ?? ""
    }
    
    override func swipeMenuView(_ swipeMenuView: SwipeMenuView, viewControllerForPageAt index: Int) -> UIViewController {
        let vc = children[index]
        vc.didMove(toParent: self)
        return vc
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.performSegue(withIdentifier: "goToArticleViewFromCategories", sender: self)
    }
}

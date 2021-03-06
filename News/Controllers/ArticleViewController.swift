//
//  ArticleViewController.swift
//  News
//
//  Created by Sergey on 01/04/2019.
//  Copyright © 2019 Sergey. All rights reserved.
//

import UIKit
import WebKit
import RealmSwift

class ArticleViewController: UIViewController, WKNavigationDelegate {
    
    private let realm = try! Realm()
    private var bookmarksArray : Results<Article>?
    private var addToBookmarksButton: UIBarButtonItem?
    
    var article: Article?

    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var progressLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        addToBookmarksButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.bookmarks, target: self, action: #selector(ArticleViewController.clickAddToBookmarksButton(_:)))
        self.navigationItem.rightBarButtonItem = addToBookmarksButton
        checkArticleInBookmarks(article: article)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.isHidden = true
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.setProgress(0.0, animated: true)
        self.tabBarController?.tabBar.isHidden = true
        if let url = URL(string: (article?.articleUrl)!) {
            webView.load(URLRequest(url: url))
            webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
            webView.allowsBackForwardNavigationGestures = true
        }
        load()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if Float(webView.estimatedProgress) == 1.0 {
            webView.isHidden = false
            progressView.isHidden = true
            progressLabel.isHidden = true
        }
        if keyPath == "estimatedProgress" {
            let progress = Float(webView.estimatedProgress)
            let result = (progress * 100.0)
            progressLabel.text = String("\(Int(result))%")
            progressView!.progress = Float(webView.estimatedProgress)
        }
    }
    
    @objc private func clickAddToBookmarksButton(_ sender: UIBarButtonItem) {
                do {
                    try realm.write {
                        realm.add(article!)
                        addToBookmarksButton?.isEnabled = false
                    }
                } catch {
                    print("Error saving article \(error)")
                }
            }
    
    private func checkArticleInBookmarks(article: Article?) {
        let bookmarksArray : Results<Article> = realm.objects(Article.self)
        for bookmark in bookmarksArray {
            if bookmark.articleUrl == article?.articleUrl {
                addToBookmarksButton?.isEnabled = false
                break
            }
        }
    }
    
    private func load() {
        bookmarksArray = realm.objects(Article.self)
        
    }
}


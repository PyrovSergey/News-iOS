//
//  NetworkManager.swift
//  News
//
//  Created by Sergey on 01/04/2019.
//  Copyright © 2019 Sergey. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import DateToolsSwift


class NetworkManager {
    
    private let swipeCategory = ["General", "Entertainment", "Sport", "Technology", "Health", "Business"]
    private let baseUrlTopHeadlinesAndCategory: String = "https://newsapi.org/v2/top-headlines"
    private let baseUrlForRequest: String = "https://newsapi.org/v2/everything"
    private let apiKey: String = "1d48cf2bd8034be59054969db665e62e"
    private let pageSize: String = "100"
    
    static let instace = NetworkManager()
    
    
    private var temporaryStorage: TemporaryStorage
    
    private init() {
        temporaryStorage = TemporaryStorage.instace
    }
    
    func getTopHeadLinesNews(listener: NetworkProtocol) {
        let params: [String : String] = [
            "country" : getCurrentCountry(),
            "pageSize" : pageSize,
            "apiKey" : apiKey
        ]
        getRequest(params, listener, "HeadLines")
    }
    
    func getRequestDataNews(request: String, listener: NetworkProtocol) {
        let params: [String : String] = [
            "q" : request,
            "sortBy" : "relevancy",
            "pageSize" : pageSize,
            "apiKey" : apiKey
        ]
        getRequest(params, listener, request)
    }
    
    func getUpdateCategoryLists(listener: NetworkProtocol) {
        for category in swipeCategory {
            let params: [String : String] = [
                "q" : category,
                "language" : getCurrentCountry(),
                "sortBy" : "relevancy",
                "pageSize" : pageSize,
                "apiKey" : apiKey
            ]
            getRequest(params, listener, category)
        }
    }
    
    private func getRequest(_ params: [String : String], _ listener: NetworkProtocol, _ category: String) {
        var url: String?
        if params.count == 3  {
            url = baseUrlTopHeadlinesAndCategory
        } else {
            url = baseUrlForRequest
        }
        Alamofire.request(url!, method: .get, parameters: params).responseJSON {
            response in
            if response.result.isSuccess {
                let responseJSON : JSON = JSON(response.result.value!)
                self.parsingJsonResult(responseJSON, listener, category)
            } else {
                listener.errorRequest(errorMessage: "Response in errorr \(response.error!)")
            }
        }
    }
    
    private func parsingJsonResult(_ responseJSON: JSON, _ listener: NetworkProtocol, _ category: String) {
        var resultArrayArticles = [Article]()
        if let responseArticleArray = responseJSON["articles"].array {
            if !responseArticleArray.isEmpty {
                for responseArticle in responseArticleArray {
                    let article = Article()
                    
                    article.sourceTitle = responseArticle["source"]["name"].string ?? ""
                    article.articleTitle = responseArticle["title"].string ?? ""
                    article.articleImageUrl = responseArticle["urlToImage"].string ?? ""
                    article.articleUrl = responseArticle["url"].string ?? ""
                    
                    let publishedAtString = responseArticle["publishedAt"].string ?? ""

                    article.articlePublicationTime = getDateFromApi(date: publishedAtString).timeAgoSinceNow
                    
                    let newsUrl: URL = URL(string: article.articleUrl)!
                    let baseSourceUrl = newsUrl.host
                    article.sourceImageUrl = "https://besticon-demo.herokuapp.com/icon?url=\(baseSourceUrl!)&size=32..64..64"
                    resultArrayArticles.append(article)
                }
            }
        }
        TemporaryStorage.instace.setCategoryList(result: resultArrayArticles, categoryName: category)
        listener.successRequest(result: resultArrayArticles, category: category)
    }
    
    private func getCurrentCountry() -> String {
        var defaultCountry: String = "us"
        let arrayCountry = ["ae", "ar", "at", "au", "be", "bg", "br", "ca", "ch", "cn", "co", "cu", "cz", "de", "eg", "fr", "gb", "gr", "hk", "hu", "id", "ie", "il", "in", "it", "jp", "kr", "lt", "lv", "ma", "mx", "my", "ng", "nl", "no", "nz", "ph", "pl", "pt", "ro", "rs", "ru", "sa", "se", "sg", "si", "sk", "th", "tr", "tw", "ua", "us", "ve", "za"]
        if let countryCode = (Locale.current as NSLocale).object(forKey: .countryCode) as? String {
            if arrayCountry.contains(countryCode.lowercased()) {
                defaultCountry = countryCode.lowercased()
            }
        }
        return defaultCountry
    }
    
    private func getDateFromApi(date: String) -> Date {
        var parsingString = date
        parsingString.removeLast()
        let parsingDateAndTime = parsingString.components(separatedBy: "T")
        let parsingDate = parsingDateAndTime[0]
        let parsingTime = parsingDateAndTime[1]
        let date = parsingDate.components(separatedBy: "-")
        let time = parsingTime.components(separatedBy: ":")
        let year = date[0]
        let mounth = date[1]
        let day = date[2]
        let hours = time[0]
        let min = time[1]
        let sec = time[2]
        var components = DateComponents()
        components.day = Int(day)!
        components.month = Int(mounth)!
        components.year = Int(year)!
        components.hour = Int(hours)!
        components.minute = Int(min)!
        components.second = Int(sec)!
        components.timeZone = TimeZone(abbreviation: "UTC")
        let datePublishedAt = Calendar.current.date(from: components as DateComponents)
        return datePublishedAt!
    }
}


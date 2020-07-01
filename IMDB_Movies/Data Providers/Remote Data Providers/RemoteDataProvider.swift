//
//  RemoteDataProvider.swift
//  IMDB_Movies
//
//  Created by Anirudha Mahale on 30/06/20.
//  Copyright © 2020 Anirudha Mahale. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift
import RxAlamofire
import SwiftyJSON

class RemoteDataProvider {
  
  let disposeBag = DisposeBag()
  
  private var delayObservable: Observable<Int> {
    return Observable<Int>.timer(RxTimeInterval.seconds(1), scheduler: MainScheduler.instance)
  }
  
  func get(_ url: URLConvertible, parameters: Parameters? = nil) -> Observable<(HTTPURLResponse, Any)> {
    URLCache.shared.removeAllCachedResponses()
    let observable = wrapObservable(RxAlamofire.requestJSON(.get, url, parameters: parameters, encoding: URLEncoding.default, headers: nil))
    return Observable.zip(delayObservable, observable, resultSelector: { (_, value) -> (HTTPURLResponse, Any) in
      return value
    })
  }
}

// Private methods
extension RemoteDataProvider {
  private func wrapObservable(_ observable: Observable<(HTTPURLResponse, Any)>, logout: Bool = true) -> Observable<(HTTPURLResponse, Any)> {
    return observable.do(onNext: { (resp, data) in
      if resp.statusCode != 200 {
        let error = self.parseErrorWith(data, statusCode: resp.statusCode)
        throw error
      }
    })
  }
  
  private func parseErrorWith(_ data: Any, statusCode: Int) -> Error {
    var userInfo = [NSLocalizedDescriptionKey: "The request timed out."]
    let json = JSON(data)
    if let error = json["status_message"].string {
      userInfo = [NSLocalizedDescriptionKey: error]
    }
    if let error = json["errors"].array?.first?.string {
      userInfo = [NSLocalizedDescriptionKey: error]
    }
    let error = NSError(domain: "", code: statusCode, userInfo: userInfo)
    return error
  }
}

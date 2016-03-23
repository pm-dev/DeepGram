//
//  DGClient+PromiseKit.swift
//  Bill-iOS
//
//  Created by Peter Meyers on 3/23/16.
//  Copyright © 2016 Operator. All rights reserved.
//

import PromiseKit

extension DGClient {

    func getBalance(progress: ((NSProgress) -> Void)?) -> Promise<Float> {
        return Promise { fulfill, reject in
            self.getBalanceWithProgress(progress, success: { task, number in
                fulfill(number.floatValue)
            }, failure:  { task, error  in
                reject(error)
            })
        }
    }

    func indexURL(audioURL: NSURL, progress: ((NSProgress) -> Void)?) -> Promise<String> {
        return Promise { fulfill, reject in
            self.indexURL(audioURL, progress: progress, success: { task, content in
                fulfill(content)
            }, failure: { task, error  in
                reject(error)
            })
        }
    }

    func statusOfContent(contentID: String, progress: ((NSProgress) -> Void)?) -> Promise<DGIndexStatus> {
        return Promise { fulfill, reject in
            self.statusOfContent(contentID, progress: progress, success: { task, status in
                fulfill(DGIndexStatus(rawValue: status.unsignedIntegerValue)!)
            }, failure: { task, error in
                reject(error)
            })
        }
    }

    func matchesInContent(contentID: String, withQuery query: String, snippet: Bool, nmax Nmax: NSNumber?, confidenceMin: NSNumber?, progress: ((NSProgress) -> Void)?) -> Promise<Array<DGMatch>> {
        return Promise { fulfill, reject in
            self.matchesInContent(contentID, withQuery: query, snippet: snippet, nmax: Nmax, confidenceMin: confidenceMin, progress: progress, success: { task, matches in
                fulfill(matches)
            }, failure: { task, error in
                reject(error)
            })
        }
    }

    func transcriptForContent(contentID: String, progress: ((NSProgress) -> Void)?) -> Promise<Dictionary<NSNumber, String>> {
        return Promise { fulfill, reject in
            self.transcriptForContent(contentID, progress: progress, success: { task, paragraphs in
                fulfill(paragraphs)
            }, failure: { task, error in
                reject(error)
            })
        }
    }
    
}



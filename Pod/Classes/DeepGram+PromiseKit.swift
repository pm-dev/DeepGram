//
//  DGClient+PromiseKit.swift
//  Pods
//
//  Created by Peter Meyers on 3/23/16.
//  Copyright (c) 2016 Peter Meyers. All rights reserved.
//

import PromiseKit

extension DGClient {

    /**
     Check account balance.

     - parameter progress: A closure to be executed when the download progress is updated. Note this closure is called on the session queue, not the main queue.

     - returns: A promise that fulfills with a Float value of hours remaining.
     */
    public func getBalance(progress: ((NSProgress) -> Void)?) -> Promise<Float> {
        return Promise { fulfill, reject in
            self.getBalanceWithProgress(progress, success: { task, number in
                fulfill(number.floatValue)
            }, failure:  { task, error  in
                reject(error)
            })
        }
    }

    /**
     Submit file to API

     - parameter audioURL: The remote audio resource's URL. This value is returned in the success block of -indexURL:.
     - parameter progress: A closure to be executed when the download progress is updated. Note this closure is called on the session queue, not the main queue.

     - returns: A promise that fulfills with a string with the contentID.
     */
    public func indexURL(audioURL: NSURL, progress: ((NSProgress) -> Void)?) -> Promise<String> {
        return Promise { fulfill, reject in
            self.indexURL(audioURL, progress: progress, success: { task, content in
                fulfill(content)
            }, failure: { task, error  in
                reject(error)
            })
        }
    }

    /**
     Check file status.

     - parameter contentID: The content ID of the audio resource on Deep Gram. This value is returned by indexURL().
     - parameter progress:  A closure to be executed when the download progress is updated. Note this closure is called on the session queue, not the main queue.

     - returns: A promise that fulfills with a DGIndexStatus of the files status.
     */
    public func statusOfContent(contentID: String, progress: ((NSProgress) -> Void)?) -> Promise<DGIndexStatus> {
        return Promise { fulfill, reject in
            self.statusOfContent(contentID, progress: progress, success: { task, status in
                fulfill(DGIndexStatus(rawValue: status.unsignedIntegerValue)!)
            }, failure: { task, error in
                reject(error)
            })
        }
    }

    /**
     Search through a file.

     - parameter contentID:     The content ID of the audio resource on Deep Gram. This value is returned by indexURL().
     - parameter query:         The string to search the content with.
     - parameter snippet:       Boolean determining whether to include the text matched with the query.
     - parameter Nmax:          Maximum number of words in the match.
     - parameter confidenceMin: Value between 0 and 1. Confidence threshold that must be met before allowing a match.
     - parameter progress:      A closure to be executed when the download progress is updated. Note this closure is called on the session queue, not the main queue.

     - returns: A promise that fulfills with an array of DGMatch objects.
     */
    public func matchesInContent(contentID: String, query: String, snippet: Bool, Nmax: Float?, confidenceMin: Float?, progress: ((NSProgress) -> Void)?) -> Promise<Array<DGMatch>> {
        return Promise { fulfill, reject in
            self.matchesInContent(contentID, withQuery: query, snippet: snippet, nmax: Nmax, confidenceMin: confidenceMin, progress: progress, success: { task, matches in
                fulfill(matches)
            }, failure: { task, error in
                reject(error)
            })
        }
    }

    /**
     Download file transcript.

     - parameter contentID: The content ID of the audio resource on Deep Gram. This value is returned by indexURL().
     - parameter progress:   A closure to be executed when the download progress is updated. Note this closure is called on the session queue, not the main queue.

     - returns: A promise that fulfills with a Dictionary mapping start time to paragraph text.
     */
    public func transcriptForContent(contentID: String, progress: ((NSProgress) -> Void)?) -> Promise<Dictionary<NSNumber, String>> {
        return Promise { fulfill, reject in
            self.transcriptForContent(contentID, progress: progress, success: { task, paragraphs in
                fulfill(paragraphs)
            }, failure: { task, error in
                reject(error)
            })
        }
    }
    
    /**
     Search through many files.

     - parameter query:    The string to search the content with.
     - parameter tag:
     - parameter Nmax:          Maximum number of words in the match.
     - parameter confidenceMin: Value between 0 and 1. Confidence threshold that must be met before allowing a match.
     - parameter progress: A closure to be executed when the download progress is updated. Note this closure is called on the session queue, not the main queue.

     - returns: A promise that fulfills with an array of DGMatch objects.
     */
    public func searchAllContent(query: String, tag: String?, Nmax: Float?, confidenceMin: Float?, progress: ((NSProgress) -> Void)?) -> Promise<Array<DGMatch>> {
        return Promise { fulfill, reject in
            self.searchAllContentWithQuery(query, tag: tag, nmax: Nmax, confidenceMin: confidenceMin, progress: progress, success: { task, matches in
                fulfill(matches)
            }, failure: { task, error in
                reject(error)
            })
        }
    }
}

//
//  JsonReader.swift
//  WeatherExercise
//
//  Created by Jawad Ali on 10/03/2021.
//  Copyright © 2021 Jawad Ali. All rights reserved.
//

import Foundation

public enum JsonReaderError: Error {
    case formatError
    case fileNotFound
}

public protocol JsonReaderType {
    func getJsonData<T:Decodable>(fileName: String, bundle: Bundle, completionHandler: (T?, JsonReaderError?) -> Void)
}

public class JsonReader: JsonReaderType {
    public init(){}
    
    public func getJsonData<T:Decodable>(fileName: String, bundle: Bundle, completionHandler: (T?, JsonReaderError?) -> Void) {
        
        if let url = bundle.url(forResource: fileName, withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(T.self, from: data)
                completionHandler(jsonData, nil)
            } catch {
                completionHandler(nil, .formatError)
            }
        } else {
            completionHandler(nil, .fileNotFound)
        }
    }
    
}

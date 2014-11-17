//
//  Teechio.swift
//  Teech_io_SDK
//
//  Created by Teech.io Ltd
//  Copyright (c) Teech.io All rights reserved.
//  More info at www.teech.io

import Foundation

class Teechio{
    
    var data: NSMutableData = NSMutableData()
    var result1: NSDictionary!
    var result2: Array<NSDictionary>!
    var request: NSMutableURLRequest!
    var e: NSError?

    
    var apik: String!
    var apdI: String!
    
    init(ApiKey: String, AppId: String) {
        self.apik = ApiKey
        self.apdI = AppId
    }
    
    func connect (urlt: String, type: String, data: NSDictionary = ["":""]) -> Void {
        let jsonData = NSJSONSerialization.dataWithJSONObject(data,options: NSJSONWritingOptions(0),error: &e)
        var jsonString = NSString(data: jsonData!, encoding: NSUTF8StringEncoding)
        
        println(urlt)
        
        var escapedurl = urlt.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        var url: NSURL = NSURL(string: escapedurl!)
        request =  NSMutableURLRequest(URL: url)
        request.addValue(self.apdI , forHTTPHeaderField: "Teech-Application-Id")
        request.addValue(self.apik , forHTTPHeaderField: "Teech-REST-API-Key")
        request.addValue("application/json" , forHTTPHeaderField: "Content-Type")
        request.HTTPMethod = type
        
        if (request.HTTPMethod != "GET") {
            let data = (jsonString as NSString).dataUsingEncoding(NSUTF8StringEncoding)
            request.HTTPBody = data
        }
    }
    
    func retrieve(endpoint: String, id: String, callback: (NSURLResponse!, NSDictionary!, NSError!) -> Void) -> Void {
        self.connect("http://api.teech.io/\(endpoint)/\(id)", type: "GET")
        doRequest(callback);
    }
    
    func retrieveAll(endpoint: String, callback: (NSURLResponse!, NSArray!, NSError!) -> Void) -> Void {
        self.connect("http://api.teech.io/\(endpoint)", type: "GET")
        doRequest(callback);
    }
    
    func save(endpoint: String, body: NSDictionary, callback: (NSURLResponse!, NSDictionary!, NSError!) -> Void) -> Void {
        self.connect("http://api.teech.io/\(endpoint)", type: "POST", data:body)
        doRequest(callback);
    }
    
    func update(endpoint: String, id:String, body: NSDictionary, callback: (NSURLResponse!, NSDictionary!, NSError!) -> Void) -> Void {
        self.connect("http://api.teech.io/\(endpoint)/\(id)", type: "PUT", data:body)
        doRequest(callback);
    }
    
    func delete(endpoint: String, id:String, callback: (NSURLResponse!, NSDictionary!, NSError!) -> Void) -> Void {
        self.connect("http://api.teech.io/\(endpoint)/\(id)", type: "DELETE")
        doRequest(callback);
    }
    
    func query(endpoint: String, constraints:NSDictionary, callback: (NSURLResponse!, NSArray!, NSError!) -> Void) -> Void {
        let jsonData = NSJSONSerialization.dataWithJSONObject(constraints,options: NSJSONWritingOptions(0),error: &e)
        var jsonString = NSString(data: jsonData!, encoding: NSUTF8StringEncoding)
        self.connect("http://api.teech.io/\(endpoint)?query=\(jsonString)", type: "GET")
        doRequest(callback);
    }
    
    func doRequest(callback: (NSURLResponse!, NSDictionary!, NSError!) -> Void) -> Void {
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), { (response: NSURLResponse!, body: NSData!, error: NSError!) -> Void in
            var jsonResult: NSDictionary = NSJSONSerialization.JSONObjectWithData(body, options: NSJSONReadingOptions.MutableContainers, error: &self.e) as NSDictionary
            callback(response, jsonResult, error);
        })
    }
    
    func doRequest(callback: (NSURLResponse!, NSArray!, NSError!) -> Void) -> Void {
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), { (response: NSURLResponse!, body: NSData!, error: NSError!) -> Void in
            var jsonResult: NSArray = NSJSONSerialization.JSONObjectWithData(body, options: NSJSONReadingOptions.MutableContainers, error: &self.e) as NSArray
            callback(response, jsonResult, error);
        })
    }
}

//
//  ViewController.swift
//  show Document Files
//
//  Created by Anil on 01/07/15.
//  Copyright (c) 2015 Variya Soft Solutions. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var filePicker: UIPickerView!
    var fileList = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        
        let documentDirectory = paths[0] as! String
        
        let path = documentDirectory.stringByAppendingPathComponent("Dates")
        println(path)
        
        let (filenamesOpt, errorOpt) = contentsOfDirectoryAtPath(path)
        if let filenames = filenamesOpt {
            println(filenames) // [".localized", "kris", ...]
            fileList = filenames
        }
        
        let (filenamesOpt2, errorOpt2) = contentsOfDirectoryAtPath("/NoSuchDirectory")
        if let err = errorOpt2 {
            err.description         // "Error Domain=NSCocoaErrorDomain Code=260 "The operation couldn’t be completed. ... "
        }
        
        getContentsOfDirectoryAtPath("/Users") { (result, error) in
            if let e = error {
                e.description
            }
            else if let filenames = result {
                filenames                     // [".localized", "kdj", ... ]
            }
        }
        
        getContentsOfDirectoryAtPath("/NoSuchDirectory") { (result, error) in
            if let e = error {
                e.description                // "Error Domain=NSCocoaError..."
            }
            else if let filenames = result {
                filenames
            }
        }
        
        // Do something with the files in my home directory
        let listMyFiles = { block in self.getContentsOfDirectoryAtPath("/Users/kdj", block: block) }
        
        listMyFiles { (result, error) in
            if let e = error {
                e.description
            }
            else if let filenames = result {
                filenames                     // [".bashrc", ... ]
            }
        }
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return fileList.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return fileList[row]
    }
    
    // Tuple result
    
    // Get contents of directory at specified path, returning (filenames, nil) or (nil, error)
    func contentsOfDirectoryAtPath(path: String) -> (filenames: [String]?, error: NSError?) {
        var error: NSError? = nil
        let fileManager = NSFileManager.defaultManager()
        let contents = fileManager.contentsOfDirectoryAtPath(path, error: &error)
        if contents == nil {
            return (nil, error)
        }
        else {
            let filenames = contents as! [String]
            return (filenames, nil)
        }
    }
    
    // Continuation Passing Style (CPS) interface
    
    // Get contents of directory at specified path, invoking block with (filenames, nil) or (nil, error)
    func getContentsOfDirectoryAtPath(path: String, block: (filenames: [String]?, error: NSError?) -> ()) {
        var error: NSError? = nil
        let fileManager = NSFileManager.defaultManager()
        let contents = fileManager.contentsOfDirectoryAtPath(path, error: &error)
        if contents == nil {
            block(filenames: nil, error: error)
        }
        else {
            let filenames = contents as! [String]
            block(filenames: filenames, error: nil)
        }
    }
}


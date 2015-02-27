//
//  AutocompleteTextfield.swift
//  AutocompleteTextfieldSwift
//
//  Created by Mylene Bayan on 2/21/15.
//  Copyright (c) 2015 MaiLin. All rights reserved.
//

import Foundation
import UIKit


@objc protocol AutocompleteTextFieldDelegate{
  /**
  Sends the selected string to the conforming class
  
  :param: text      the selected string from the list of suggestions
  :param: indexPath the position of the selected string on the tableview
  */
  func didSelectAutocompleteText(text:String, indexPath:NSIndexPath)
  
  /**
  Observes text changes on the textfield and send it to the conforming class, in here you may want to process the user-typed text to provide your suggestions
  
  :param: text the current text content of the textfield
  */
  optional func textFieldDidChange(text:String)
}

class AutocompleteTextfield:UITextField, UITableViewDataSource, UITableViewDelegate{

  var autoCompleteDelegate:AutocompleteTextFieldDelegate?
  
  /// The strings to be shown on as suggestions, setting the value of this automatically reload the tableview
  var autoCompleteStrings:[String]?{
    didSet{
      reloadAutoCompleteData()
    }
  }
  
  /// Font for the text suggestions
  var autoCompleteTextFont = UIFont(name: "HelveticaNeue-Light", size: 12)
  
  /// Color of the text suggestions
  var autoCompleteTextColor = UIColor.blackColor()
  
  /// Used to set the height of cell for each suggestions
  var autoCompleteCellHeight:CGFloat = 44.0
  
  /// The maximum visible suggestion
  var maximumAutoCompleteCount = 3
  
  /// Used to set your own preferred separator inset
  var autoCompleteSeparatorInset = UIEdgeInsetsZero
  
  /// Hides autocomplete tableview when the textfield is empty
  var hideWhenEmpty = true
  
  /// Hides autocomplete tableview after selecting a suggestion
  var hideWhenSelected = true
  
  /// The table view height, derived from the maximumAutoCompleteCount and the tableCellHeight
  private var autoCompleteTableHeight:CGFloat?
  
  /// Manages the instance of tableview
  private var autoCompleteTableView:UITableView?
  
  
  override init() {
    super.init()
    
    initialize()
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    initialize()
  }
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
    initialize()
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    initialize()
  }
  
  
  //MARK: Initialization
  func initialize(){
    autoCompleteTableHeight = autoCompleteCellHeight * CGFloat(maximumAutoCompleteCount)
    setupTextField()
    setupTableView()
  }
  
  private func setupTextField(){
    self.clearButtonMode = .Always
    self.addTarget(self, action: "textFieldDidChange", forControlEvents: .EditingChanged)
  }
  
  private func setupTableView(){
    let screenSize = UIScreen.mainScreen().bounds.size
    let tableView = UITableView(frame: CGRectMake(self.frame.origin.x, self.frame.origin.y + CGRectGetHeight(self.frame), screenSize.width - (self.frame.origin.x * 2), autoCompleteTableHeight!))
    tableView.dataSource = self
    tableView.delegate = self
    tableView.rowHeight = autoCompleteCellHeight
    self.superview?.addSubview(tableView)
    
    autoCompleteTableView = tableView
    tableViewSetHidden(hideWhenEmpty)
  }
  
  private func tableViewSetHidden(hidden:Bool){
    autoCompleteTableView?.hidden = hidden
  }
  
  private func reloadAutoCompleteData(){
    autoCompleteTableView?.reloadData()
  }
  
  func textFieldDidChange(){
    autoCompleteDelegate?.textFieldDidChange?(self.text)
    if hideWhenEmpty {
      if self.text.isEmpty{
        tableViewSetHidden(true)
        autoCompleteStrings = nil
      }
      else{
        tableViewSetHidden(false)
      }
    }
    else{
      tableViewSetHidden(false)
    }
  }
  
  //MARK: UITableViewDataSource
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    return autoCompleteStrings != nil ? (autoCompleteStrings!.count > maximumAutoCompleteCount ? maximumAutoCompleteCount : autoCompleteStrings!.count) : 0
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cellIdentifier = "autocompleteCellIdentifier"
    var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? UITableViewCell
    if cell == nil{
      cell = UITableViewCell(style: .Default, reuseIdentifier: cellIdentifier)
    }
    
    cell?.textLabel?.font = autoCompleteTextFont
    cell?.textLabel?.textColor = autoCompleteTextColor
    cell?.textLabel?.text = autoCompleteStrings![indexPath.row]
    
    return cell!
  }
  
  
  //MARK: UITableViewDelegate
  func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
    if cell.respondsToSelector("setSeparatorInset:"){
      cell.separatorInset = autoCompleteSeparatorInset
    }
    
    if cell.respondsToSelector("setPreservesSuperviewLayoutMargins:"){
      cell.preservesSuperviewLayoutMargins = false
    }
    
    if cell.respondsToSelector("setLayoutMargins:"){
      cell.layoutMargins = autoCompleteSeparatorInset
    }
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    let cell = tableView.cellForRowAtIndexPath(indexPath)
    let text = cell?.textLabel?.text
    self.text = text
    
    autoCompleteDelegate?.didSelectAutocompleteText(text!, indexPath: indexPath)
    tableViewSetHidden(hideWhenSelected)
  }
  
}

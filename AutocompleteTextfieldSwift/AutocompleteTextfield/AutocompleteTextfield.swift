//
//  AutocompleteTextfield.swift
//  AutocompleteTextfieldSwift
//
//  Created by Mylene Bayan on 2/21/15.
//  Copyright (c) 2015 MaiLin. All rights reserved.
//

import Foundation
import UIKit

@objc protocol AutocompleteTextFieldDataSource{
  optional var autoCompleteCellHeight:CGFloat{set get}
  optional var maximumAutoCompleteCount:Int{set get}
  optional var autoCompleteEdgeInset:UIEdgeInsets{set get}
}

@objc protocol AutocompleteTextFieldDelegate{
  func didSelectAutocompleteText(text:String, indexPath:NSIndexPath)
  optional func textFieldDidChange(text:String)
}

class AutocompleteTextfield:UITextField, UITableViewDataSource, UITableViewDelegate{

  var autoCompleteStrings:[String]?{
    didSet{
      reloadAutoCompleteData()
    }
  }
  
  var autoCompleteTextFont:UIFont?
  var autoCompleteTextColor:UIColor?
  
  var autoCompleteDelegate:AutocompleteTextFieldDelegate?
  var autoCompleteDataSource:AutocompleteTextFieldDataSource?{
    didSet{
      initialize()
    }
  }
  
  private var autoCompleteTableHeight:CGFloat?
  private var autoCompleteTableView:UITableView?
  private var tableCellHeight:CGFloat = 44.0
  private var tableEdgeInset = UIEdgeInsetsZero
  private var maxSuggestionCount = 3
  
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
    setDefaultValues()
    setupTextField()
    setupTableView()
  }
  
  private func setDefaultValues(){
    if autoCompleteDataSource != nil{
      maxSuggestionCount = autoCompleteDataSource!.maximumAutoCompleteCount != nil ? autoCompleteDataSource!.maximumAutoCompleteCount! : maxSuggestionCount
      
      tableCellHeight = autoCompleteDataSource!.autoCompleteCellHeight != nil ? autoCompleteDataSource!.autoCompleteCellHeight! : tableCellHeight
      
      tableEdgeInset = autoCompleteDataSource!.autoCompleteEdgeInset != nil ? autoCompleteDataSource!.autoCompleteEdgeInset! : tableEdgeInset
    }
    autoCompleteTextColor = UIColor.blackColor()
    autoCompleteTextFont = UIFont(name: "HelveticaNeue-Light", size: 12)
    autoCompleteTableHeight = CGFloat(tableCellHeight) * CGFloat(maxSuggestionCount)
    
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
    tableView.rowHeight = tableCellHeight
    if self.superview != nil{
      self.superview?.addSubview(tableView)
    }
    
    autoCompleteTableView = tableView
    tableViewSetHidden(true)
  }
  
  private func tableViewSetHidden(hidden:Bool){
    autoCompleteTableView?.hidden = hidden
  }
  
  private func reloadAutoCompleteData(){
    tableViewSetHidden(false)
    autoCompleteTableView?.reloadData()
  }
  
  internal func textFieldDidChange(){
    autoCompleteDelegate?.textFieldDidChange?(self.text)
    if self.text.isEmpty{
      autoCompleteTableView?.hidden = true
      autoCompleteStrings = nil
    }
  }
  
  //MARK: UITableViewDataSource
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    return autoCompleteStrings != nil ? (autoCompleteStrings!.count > maxSuggestionCount ? maxSuggestionCount : autoCompleteStrings!.count) : 0
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
      cell.separatorInset = tableEdgeInset
    }
    
    if cell.respondsToSelector("setPreservesSuperviewLayoutMargins:"){
      cell.preservesSuperviewLayoutMargins = false
    }
    
    if cell.respondsToSelector("setLayoutMargins:"){
      cell.layoutMargins = tableEdgeInset
    }
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    let cell = tableView.cellForRowAtIndexPath(indexPath)
    let text = cell?.textLabel?.text
    self.text = text
    
    autoCompleteDelegate?.didSelectAutocompleteText(text!, indexPath: indexPath)
    tableViewSetHidden(true)
    
  }
  
}

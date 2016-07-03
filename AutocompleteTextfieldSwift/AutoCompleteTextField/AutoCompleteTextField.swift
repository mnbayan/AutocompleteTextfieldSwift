//
//  AutoCompleteTextField.swift
//  AutocompleteTextfieldSwift
//
//  Created by Mylene Bayan on 6/13/15.
//  Copyright (c) 2015 mnbayan. All rights reserved.
//

import Foundation
import UIKit

//MARK:- Interface
public class AutoCompleteTextField:UITextField {
	//MARK: Properties
	//Outlets
	@IBOutlet weak var presenterView: UIView!
	
	//Inspectables
	@IBInspectable public var hidesWhenSelected: Bool = true
	@IBInspectable public var maximumAutoCompleteCount: Int = 4
	@IBInspectable public var enableAttributedText: Bool = false
	@IBInspectable public var autoCompleteCellHeight: CGFloat = 44
	@IBInspectable public var autoCompleteSeparatorInset: UIEdgeInsets = UIEdgeInsetsZero
	@IBInspectable public var autoCompleteTextColor: UIColor = .darkGrayColor()
	@IBInspectable public var hidesWhenEmpty: Bool = true { didSet { autoCompleteTableView?.hidden = hidesWhenEmpty } }
	
	//Variables
	private var autoCompleteTableView: UITableView?
	public var autoCompleteAttributes: [String: AnyObject]?
	public var onTextChange: ((String) -> ()) = { _ in }
	public var onSelect: ((String, NSIndexPath) -> ()) = { _, _ in }
	private lazy var attributedAutoCompleteStrings = [NSAttributedString] ()
	public var autoCompleteTableHeight: CGFloat = (4 * 44) { didSet { redrawTable() } }
	public var autoCompleteStrings: [String]? {
		didSet {
			reload()
			autoCompleteTableHeight = CGFloat(min(maximumAutoCompleteCount, autoCompleteStrings?.count ?? 0)) * autoCompleteCellHeight
			redrawTable()
		}
	}
	
	//Constants
	let reuseIdentifier = "autocompleteCellReuseIdentifier"
	
	//MARK:- Initialisation
	override init(frame: CGRect) {
		super.init(frame:frame)
		commonInit()
	}
	
	public required init?(coder aDecorder: NSCoder) { super.init(coder: aDecorder) }
}

//MARK:- Implementation
extension AutoCompleteTextField {
	//MARK: System
	public override func awakeFromNib() {
		super.awakeFromNib()
		commonInit()
	}
}

extension AutoCompleteTextField {
	//MARK: Common Init
	private func commonInit() {
		//Initial Configuration
		autoCompleteAttributes = [NSForegroundColorAttributeName: UIColor.blackColor(), NSFontAttributeName: UIFont.boldSystemFontOfSize(12)]
		addTarget(self, action: #selector(textFieldDidChange), forControlEvents: .EditingChanged)
		addTarget(self, action: #selector(textFieldDidEndEditing), forControlEvents: .EditingDidEnd)
		
		//Setup Table
		performClosureAsynchoronouslyOnMainThread() { self.setupAutocompleteTable() }
	}
}

extension AutoCompleteTextField {
	//MARK: Handle Text Input
	func textFieldDidChange() {
		guard let text = text else { return }
		
		onTextChange(text)
		if text.isEmpty { autoCompleteStrings = nil }
		performClosureAsynchoronouslyOnMainThread() { self.autoCompleteTableView?.hidden = self.hidesWhenEmpty ? text.isEmpty : false }
	}
	
	func textFieldDidEndEditing() {
		autoCompleteTableView?.hidden = true
	}
}

extension AutoCompleteTextField {
	//MARK: Configure Table
	//Setup Table
	@objc private func setupAutocompleteTable() {
		//Configure Table Frame
		autoCompleteTableView = UITableView(frame: CGRectZero, style: .Plain)
		if let presenterView = presenterView, convertedPoint = self.superview?.convertPoint(CGPoint(x: CGRectGetMinX(self.frame), y: CGRectGetMaxY(self.frame)), toView: presenterView), convertedFrame = CGRect(origin: convertedPoint, size: CGSize(width: self.frame.width, height: 0)) as CGRect? {
			autoCompleteTableView?.frame = convertedFrame
		}
		
		//Configure Table Properties
		autoCompleteTableView?.dataSource = self
		autoCompleteTableView?.delegate = self
		autoCompleteTableView?.rowHeight = autoCompleteCellHeight
		autoCompleteTableView?.hidden = hidesWhenEmpty ?? true
		
		//Add Table To Presenter View
		if autoCompleteTableView != nil { presenterView?.addSubview(autoCompleteTableView!) }
		
		//Set Table Height
		autoCompleteTableHeight = CGFloat(0)
	}
	
	//Perform Custom Table Reload
	private func reload() {
		//Preare Reload
		if enableAttributedText == true {
			let attrs = [NSForegroundColorAttributeName: autoCompleteTextColor, NSFontAttributeName: UIFont.boldSystemFontOfSize(12.0)]
			if attributedAutoCompleteStrings.count > 0 { attributedAutoCompleteStrings.removeAll(keepCapacity: false) }
			if let autoCompleteStrings = autoCompleteStrings, autoCompleteAttributes = autoCompleteAttributes {
				for i in 0..<autoCompleteStrings.count {
					let str = autoCompleteStrings[i] as NSString
					let range = str.rangeOfString(text!, options: . CaseInsensitiveSearch)
					let attString = NSMutableAttributedString(string: autoCompleteStrings[i], attributes: attrs)
					attString.addAttributes(autoCompleteAttributes, range: range)
					attributedAutoCompleteStrings.append(attString)
				}
			}
		}
		//Perform Reload
		autoCompleteTableView?.reloadData()
	}
	
	//Redraw Table On Screen
	private func redrawTable() {
		guard autoCompleteTableView != nil else { return }
		
		//Update Table Height
		var newFrame = autoCompleteTableView!.frame
		newFrame.size.height = autoCompleteTableHeight
		UIView.animateWithDuration(0.3) {  self.autoCompleteTableView?.frame = newFrame }
	}
}

extension AutoCompleteTextField: UITableViewDataSource, UITableViewDelegate {
	//MARK: Table Data Source And Delegates
	public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return autoCompleteStrings != nil ? (autoCompleteStrings?.count > maximumAutoCompleteCount ? maximumAutoCompleteCount : autoCompleteStrings!.count) : 0
	}
	
	public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return autoCompleteCellHeight
	}
	
	public func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
		if cell.respondsToSelector(Selector("setSeparatorInset:")) { cell.separatorInset = autoCompleteSeparatorInset }
		if cell.respondsToSelector(Selector("setPreservesSuperviewLayoutMargins:")) { cell.preservesSuperviewLayoutMargins = false }
		if cell.respondsToSelector(Selector("setLayoutMargins:")) { cell.layoutMargins = autoCompleteSeparatorInset }
	}
	
	public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier) ?? UITableViewCell(style: .Default, reuseIdentifier: reuseIdentifier)
		cell.contentView.gestureRecognizers = nil
		if enableAttributedText {
			cell.textLabel?.attributedText = attributedAutoCompleteStrings[indexPath.row]
		} else {
			cell.textLabel?.font = self.font
			cell.textLabel?.textColor = autoCompleteTextColor
			cell.textLabel?.text = autoCompleteStrings![indexPath.row]
		}
		return cell
	}
	
	public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		if let cell = tableView.cellForRowAtIndexPath(indexPath) as UITableViewCell?, selectedText = cell.textLabel?.text {
			self.text = selectedText
			onSelect(selectedText, indexPath)
		}
		performClosureAsynchoronouslyOnMainThread() { tableView.hidden = self.hidesWhenSelected }
	}
}

extension AutoCompleteTextField {
	//MARK: Additionals
	func performClosureAsynchoronouslyOnMainThread(closure: () -> ()) { dispatch_async(dispatch_get_main_queue(), closure) }
}
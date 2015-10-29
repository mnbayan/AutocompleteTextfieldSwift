# AutocompleteTextfieldSwift
Simple and straightforward sublass of UITextfield to manage string suggestions

Plain        | Attributed
------------- | -------------
![Plain](http://i.imgur.com/SvyLreh.png?1)  | ![Attributed](http://i.imgur.com/qlMgLaB.png?1)


## Installation
Drag AutoCompleteTextField Folder in your project

## How to use

#### Customize
Customize autocomplete suggestions! You can override the provided properties to create your desired appearance.
Properties are pretty self explanatory. Some of them are listed below, with their respective default values:

```
/// Font for the text suggestions
public var autoCompleteTextFont = UIFont(name: "HelveticaNeue-Light", size: 12)
/// When set to true, shows autocomplete text with formatting
public var enableAttributedText = false
/// User Defined Attributes
public var autoCompleteAttributes:[String:AnyObject]?
/// Hides autocomplete tableview after selecting a suggestion
public var hidesWhenSelected = true
```


#### Setting Content
The most important property to use is the `autoCompleteStrings`. As what is declared in the description setting the value of this will automatically reload the tableview, through the use of `didSet`
 ```
/// The strings to be shown on as suggestions, setting the value of this automatically reload the tableview
public var autoCompleteStrings:[String]?{
    didSet{ reload() }
}
  ```


#### User Interactions
To handle text changed event, use `onTextChange:` closure. This returns the current text content of the textfield.
```
autocompleteTextfield.onTextChange = {[weak self] text in 
// your code goes here
...
}
```
To know when user selected a text, use `onSelect:` closure: This returns the selected text and it's indexPath.

```
autocompleteTextfield.onSelect = {[weak self] text, indexpath in
// your code goes here
...
}
```
It's that easy! Feel free to use it, don't worry, it's free. :)

## Example Code:
In the example project, I used [Google Places Autocomplete API](https://developers.google.com/places/documentation/autocomplete) to show the usage of this library. For testing purposes i created my own google api key.

If you want to create your own Google Api Key follow the steps in this [link](https://developers.google.com/maps/documentation/javascript/tutorial#api_key)

##### Note: Recent updates in google places API requires you to enable "Google Places API Web Service" and use a Server Key instead of an iOS key. To do so, go to [Google Developers Console](https://console.developers.google.com/).

## License
AutocompleteTextfield is under [MIT license](http://opensource.org/licenses/MIT). See LICENSE for details.
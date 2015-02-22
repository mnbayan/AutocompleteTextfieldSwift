# AutocompleteTextfieldSwift
Simple and straightforward sublass of UITextfield to manage string suggestions

## Installation
Drag AutocompleteTextfield Folder in yor project

## How to use:
To customize autocomplete table, you can conform with AutocompleteTextfieldDataSource and assign values with the following properties:

```
optional var autoCompleteCellHeight:CGFloat{set get}
var maximumAutoCompleteCount:Int{set get}
optional var autoCompleteEdgeInset:UIEdgeInsets{set get}
```

Use AutocompleteTextfieldDelegate to handle event when user selected from the autocomplete suggestions:

``` func didSelectAutocompleteText(text:String, indexPath:NSIndexPath)```

and an optional delegate for observing text change has been provided:
```optional func textFieldDidChange(text:String)```

##Example Code:
In the example project, I used [Google Places Autocomplete API](https://developers.google.com/places/documentation/autocomplete) to show the usage of this library. For testing purposes i created my own googl api key

#####Note: _If you want to create your own Googl Api Key follow the steps in this [link](https://developers.google.com/maps/documentation/javascript/tutorial#api_key)_

To conform with autoCompleteDataSource and autoCompleteDelegate 
```
class ViewController: UIViewController, AutocompleteTextFieldDelegate, AutocompleteTextFieldDataSource
```

and add:

```
autocompleTextfield.autoCompleteDelegate = self
autocompleTextfield.autoCompleteDataSource = self
```

It's that easy!

Aside from the three provided datasource for customization, you can also use:

```
autocompleTextfield.autoCompleteTextColor = UIColor.blackColor()
autocompleTextfield.autoCompleteTextFont = UIFont(name: "HelveticaNeue-Light", size: 12.0)
```

Finally:
You can do whatever you want with the provided delegates! In here i used `textFieldDidChange(text:String)` to request autocomplete places to google api 

```
func textFieldDidChange(text: String) {
    if !text.isEmpty{
      if connection != nil{
        connection!.cancel()
        connection = nil
      }
      let baseURLString = "https://maps.googleapis.com/maps/api/place/autocomplete/json"
      let url = NSURL(string: "\(baseURLString)?key=\(googleMapsKey)&input=\(text)")
      if url != nil{
        let urlRequest = NSURLRequest(URL: url!)
        connection = NSURLConnection(request: urlRequest, delegate: self)
      }
    }
  }
```

and `didSelectAutocompleteText(text:String, indexPath:NSIndexPath)` to process the selected string, in which I performed geocoding using `CLGeocoder` to retrieve placemark and add annotation to our mapview.

![Sample Usage](http://i.imgur.com/EJfFLty.png)

##License
AutocompleteTextfield is under MIT license. See LICENSE for details.


# Readme 
## Introduction
This thumbmnail project is written in Swift 5 using XCode 12.1 and tested on iPhone simulator 11. It tries to be as similar to the mockup from the document. There are enhancements added too based on my thinking and idea.
- Added a zoom icon button at top right of each thumbnail to view the picture in a full screen mode as the picture is very nice
- Added a next icon button to view a youtube video that is corresponding to the caption, able to like or dislike the video and add comment to it. 

![List of images](https://github.com/leonltl/ThumbnailApp/blob/main/Show_list_of_images.png =250x)

## Build Instruction
**Using Xcode**
Open in Xcode 12.1. 
Command B to build the project, Command R to run the project in iPhone Simulator, Command U to run the test in Simulator 

**Using Xcodebuild**
Open terminal and execute the below code to build 

With code signing
 ```
 xcodebuild clean build -project ThumbnailApp.xcodeproj
```

Without code signing
```
 xcodebuild clean build  CODE_SIGNING_REQUIRED=NO CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED="NO" CODE_SIGN_ENTITLEMENTS="" CODE_SIGNING_ALLOWED="NO"
 ```
 
Run test (using iPhone 11 simulator as example)
```
xcodebuild test -scheme ThumbnailApp CODE_SIGNING_REQUIRED=NO CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED="NO" CODE_SIGN_ENTITLEMENTS="" CODE_SIGNING_ALLOWED="NO"  -destination "name=iPhone 11"
```
## Application Test
Thunbnail class whether it can read the json data correctly
Automation test is only done for Thumbnail List to test the functionality
- tapping of the loading button 
- revealing the list of thumbnails
- select the next button from a thumbnail
- play the youtube video
- press the like button
- text and add a comment
- delete a comment



## Design
It contains navigating within 3 Controllers. The concept is to download a list of thumbnails from the Rest Api and selecting on the thumbnail will display a video corresponding to the caption. If there are no thumbnails received from the Rest Api, it will display error icon/  

### MainViewController.swift
- The main controller class that is attached to Main View Controller Scene in Storyboard
It is to show the load pictures button and control the logic to download the list of thumbnails from the Rest Api and show the loading spinner.

### ImagesCollectionViewController
- The collection view controller class that is attached toImages Colleciton ViewScene in Storyboard
It is embedded in the Main View Controller Scene within the Storyboard and control the logic to display the list of the thumbnails downloaded. It will also trigger the download when it is pulled down. If there are no thumbnails downloaded from the Rest Api, it will show error image

### DetailViewController
-  The controller class that is attached to Detail View Controller Scene in Storyboard 
It is to display a youtube video after selecting a thumbnail and control the logic of different matching video to the caption of the thumbnail and able to like or dislike the video. This controller also able to add comments or delete comments. 

### EnlargeImageViewController
-  The controller class that is attached to Enlarge Image View Controller Scene in Storyboard 
It is to display the image in a full screen mode  


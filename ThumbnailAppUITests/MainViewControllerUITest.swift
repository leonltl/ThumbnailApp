
import XCTest

class MainViewControllerUITest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testRunUI() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        /// Use recording to get started writing UI tests.
        /// Use XCTAssert and related functions to verify your tests produce the correct results.
        
        /// Press tthe load pictures button
        app.buttons["Load Pictures"].tap()
       
        /// Find the collectiion view
        XCTAssert(app.collectionViews["ImagesCollectionViewController"].exists)
        let collectionView = app.collectionViews["ImagesCollectionViewController"]
        waitForElementToAppear(element: collectionView.cells.element(boundBy: 0))
        
        /// If total number of cells are more than 1
        if (collectionView.cells.count > 1) {
            
            /// Check for multiple images
            XCTAssertEqual(collectionView.cells.count > 1, true)
            let staticTexts = collectionView.cells.staticTexts
            
            /// Check if the text are not empty
            for staticText in staticTexts.allElementsBoundByIndex {
                let value = staticText.label
                XCTAssertEqual(!value.isEmpty, true)
            }
            
            /// Find the image to tap
            let firstCell = collectionView.cells.element(boundBy: 0)
            XCTAssertTrue(firstCell.exists)
            firstCell.tap()
            
            /// Find the youtube video to tap
            waitForElementToAppear(element: app.otherElements["viewWebViewWrapper"])
            XCTAssert(app.webViews.element(boundBy:0).exists)
            let webView = app.webViews.element(boundBy:0)
            webView.tap()
            
            /// Find the like button to tap
            XCTAssert(app.buttons["btnLike"].exists)
            app.buttons["btnLike"].tap()
            
            /// Check if the count increment
            XCTAssert(app.staticTexts.element(matching: .any, identifier: "lblLikeCounts").exists)
            let likesCount = app.staticTexts.element(matching: .any, identifier: "lblLikeCounts").label
            XCTAssertEqual(likesCount, "1")
            
            /// Find the text field to tap and fill in text
            XCTAssert(app.textFields["txtWriteComment"].exists)
            app.textFields["txtWriteComment"].tap()
            app.textFields["txtWriteComment"].typeText("This is a first comment")
            app.keyboards.buttons["return"].tap()
            
            /// Find the comments list and check for a comment
            XCTAssert(app.tables["tblCommentsList"].exists)
            let tblCommentsList = app.tables["tblCommentsList"]
            waitForElementToAppear(element: tblCommentsList.cells.element(boundBy: 0))
            
            /// Find the cross button to tap and cheeck for comment deleted
            let tblCommentCell = tblCommentsList.cells.element(boundBy: 0)
            tblCommentCell.buttons.element(boundBy: 0).tap()
            let commentCount = tblCommentsList.cells.count
            XCTAssertEqual(commentCount, 0)
            
        }
        else {
            /// Find  an image
            let cell = collectionView.cells.element(boundBy: 0)
        
            /// Check if the text are not empty
            var value = ""
            let staticTexts = cell.staticTexts
            for staticText in staticTexts.allElementsBoundByIndex {
                value = staticText.label
            }
            
            /// Check if it is error text
            if value == "Problem loading image..." {
                XCTAssertEqual(value, "Problem loading image...")
            }
            else {
                /// Check if the text is not empty
                XCTAssertEqual(!value.isEmpty, true)
                
                /// Find the first image to tap
                let firstCell = collectionView.cells.element(boundBy: 0)
                XCTAssertTrue(firstCell.exists)
                firstCell.tap()
                
                /// Find the youtube video to tap
                waitForElementToAppear(element: app.otherElements["viewWebViewWrapper"])
                XCTAssert(app.webViews.element(boundBy:0).exists)
                let webView = app.webViews.element(boundBy:0)
                webView.tap()
                
                /// Find the like button to tap
                XCTAssert(app.buttons["btnLike"].exists)
                app.buttons["btnLike"].tap()
                
                /// Check if the count increment
                XCTAssert(app.staticTexts.element(matching: .any, identifier: "lblLikeCounts").exists)
                let likesCount = app.staticTexts.element(matching: .any, identifier: "lblLikeCounts").label
                XCTAssertEqual(likesCount, "1")
                
                /// Find the text field to tap and fill in text
                XCTAssert(app.textFields["txtWriteComment"].exists)
                app.textFields["txtWriteComment"].tap()
                app.textFields["txtWriteComment"].typeText("This is a first comment")
                app.keyboards.buttons["return"].tap()
                
                /// Find the comments list and check for a comment
                XCTAssert(app.tables["tblCommentsList"].exists)
                let tblCommentsList = app.tables["tblCommentsList"]
                waitForElementToAppear(element: tblCommentsList.cells.element(boundBy: 0))
                
                /// Find the cross button to tap and cheeck for comment deleted
                let tblCommentCell = tblCommentsList.cells.element(boundBy: 0)
                tblCommentCell.buttons.element(boundBy: 0).tap()
                let commentCount = tblCommentsList.cells.count
                XCTAssertEqual(commentCount, 0)
                
            }
        }
    }

    func waitForElementToAppear(element: XCUIElement, timeout: TimeInterval = 5,  file: String = #file, line: UInt = #line) {
        let existsPredicate = NSPredicate(format: "exists == true")

        expectation(for: existsPredicate,
                    evaluatedWith: element, handler: nil)

        waitForExpectations(timeout: timeout) { (error) -> Void in
            if (error != nil) {
                let message = "Failed to find \(element) after \(timeout) seconds."
                let location = XCTSourceCodeLocation(filePath: file, lineNumber: Int(line))
                let issue = XCTIssue(type: .assertionFailure, compactDescription: message, detailedDescription: nil, sourceCodeContext: .init(location: location), associatedError: nil, attachments: [])
                self.record(issue)
            }
        }
    }

}

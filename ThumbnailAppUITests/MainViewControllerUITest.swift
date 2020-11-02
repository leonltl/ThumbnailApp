
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

        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        app.buttons["Load Pictures"].tap()
       
        let collectionView = app.collectionViews.element(boundBy: 0)
        waitForElementToAppear(element: collectionView.cells.element(boundBy: 0))
        if (collectionView.cells.count > 1) {
            XCTAssertEqual(collectionView.cells.count > 1, true)
            let staticTexts = collectionView.cells.staticTexts
            for staticText in staticTexts.allElementsBoundByIndex {
                let value = staticText.label
                XCTAssertEqual(!value.isEmpty, true)
            }
        }
        else {
            let cell = collectionView.cells.element(boundBy: 0)
        
            var value = ""
            let staticTexts = cell.staticTexts
            for staticText in staticTexts.allElementsBoundByIndex {
                value = staticText.label
            }
            
            if value == "Problem loading image..." {
                XCTAssertEqual(value, "Problem loading image...")
            }
            else {
                print(value)
                XCTAssertEqual(!value.isEmpty, true)
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

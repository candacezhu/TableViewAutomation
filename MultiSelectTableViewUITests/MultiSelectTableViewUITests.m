#import <XCTest/XCTest.h>

@interface MultiSelectTableViewUITests : XCTestCase

@property (nonatomic, strong) XCUIApplication* app;
@property (nonatomic, strong) XCUIElement* masterNavigationBar;
@property (nonatomic, strong) XCUIElement* editButton;
@property (nonatomic, strong) XCUIElement* addButton;
@property (nonatomic, strong) XCUIElementQuery* tablesQuery;

@end

@implementation MultiSelectTableViewUITests


- (void)setUp {
    [super setUp];
    self.app = [XCUIApplication new];
    self.masterNavigationBar = self.app.navigationBars[@"Master"];
    self.editButton = self.masterNavigationBar.buttons[@"Edit"];
    self.tablesQuery = self.app.tables;
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    // In UI tests it is usually best to stop immediately when a failure occurs.
    self.continueAfterFailure = NO;
    // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
    [[[XCUIApplication alloc] init] launch];
    
    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testRemoveAllItems {
    [self.editButton tap];
    [self.masterNavigationBar.buttons[@"Delete All"] tap];
    [self.app.sheets[@"Are you sure you want to remove these items?"].collectionViews.buttons[@"OK"] tap];
    XCTAssertEqual(self.tablesQuery.cells.count, 0, @"There are cells not deleted");
    XCTAssertEqual(self.editButton.enabled, NO, @"Edit button should be disabled");
}


- (void)testAddThenRemoveItems {
    
    // Stage test variables
    NSUInteger addElementsCount = 3; // TODO: Should we drive this from a plist?

    self.addButton = self.masterNavigationBar.buttons[@"Add"];
    NSUInteger numberOfCellsBeforeAddCells = self.tablesQuery.cells.count;
    
    // Add n elements to the table
    for(int i = 0; i < addElementsCount; i++) {
        [self.addButton tap];
    }
    
    // Verify that we added n elements
    NSUInteger numberOfCellsAfterAddCells = self.tablesQuery.cells.count;
    XCTAssertEqual(numberOfCellsAfterAddCells - numberOfCellsBeforeAddCells, addElementsCount);
    
    // Set table in selection mode
    [self.masterNavigationBar.buttons[@"Edit"] tap];
    
    // Randomly select up to n elements to test removal
    int numberOfCellsRemoved = 0;
    for(int i = 0; i < addElementsCount; i++) {
        int index =  arc4random() % addElementsCount;
        XCUIElement *cell = [self.tablesQuery.cells elementBoundByIndex: numberOfCellsAfterAddCells - index - 1];
        
        // To simplify the random logic, skip any duplicate values
        if(!cell.selected) {
            [cell tap];
            numberOfCellsRemoved++;
        }
    }
    
    // Find the delete button, and trigger removal
    NSString *buttonText = [NSString stringWithFormat:@"Delete (%d)", numberOfCellsRemoved];
    XCUIElement *deleteBtn = self.masterNavigationBar.buttons[buttonText];
    XCTAssertEqual(deleteBtn.exists, YES);
    [deleteBtn tap];
    
    // Verify action sheet prompt, and approve. TODO: Verify that cancel does not remove?
    NSString *sheetPromptText = [NSString stringWithFormat:@"Are you sure you want to remove %@?",
                            (numberOfCellsRemoved == 1) ? @"this item" : @"these items"];
    XCUIElement *sheet = self.app.sheets[sheetPromptText];
    XCTAssertEqual(sheet.exists, YES, @"Wrong title text on action sheet");
    [sheet.collectionViews.buttons[@"OK"] tap];
    
    // Confirm that the cell count is what we expect after removing test cells
    XCTAssertEqual(numberOfCellsAfterAddCells - self.tablesQuery.cells.count, numberOfCellsRemoved);
}
@end

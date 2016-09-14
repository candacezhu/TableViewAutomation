# UITestDemo
TableViewAutomation Example

## The Problem
Automate adding and removing table view items using XCTest

## The Solution
I created two test cases to address the problem asks.

### Running the solution
1. open the xcodeproject
2. Run test target

### testRemoveAllItems
This test demonstrates XCTest that removes all items from a tableview.

### testAddThenRemoveItems
This test demonstrates XCTest that combines adding some new items to the tableview, as well as removing cells.

Note: I was not required to randomize the cell index for removal, but I did not want to always delete specific hard-coded cells.

## Trade offs
I had to use the cell count to verify removal. This does not specifically test which cells are being removed.
We could alter the application to give us more information in the new text (for example New Item (1), New Item (2)). This wouild allow us to identify the cell by text. 


## Whats Left?!?
Given more time, I would work to break out the test cases into smaller individual components.

Customizing the test input params could be done in some external configuration file (plist?).

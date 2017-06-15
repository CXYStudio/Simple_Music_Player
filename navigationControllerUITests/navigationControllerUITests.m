

#import <XCTest/XCTest.h>

@interface navigationControllerUITests : XCTestCase

@end

@implementation navigationControllerUITests

- (void)setUp {
    [super setUp];
    
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

- (void)testExample {
    // Use recording to get started writing UI tests.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    
    XCUIApplication *app = [[XCUIApplication alloc] init];
    XCUIElementQuery *tablesQuery = app.tables;
    XCUIElement *staticText = tablesQuery.staticTexts[@"3OH!3,Katy Perry - Starstrukk.mp3"];
    [staticText tap];
    
    XCUIElement *button = app.buttons[@"\u6682\u505c"];
    [button tap];
    
    XCUIElement *button2 = app.buttons[@"\u64ad\u653e"];
    [button2 tap];
    [button tap];
    [button2 tap];
    
    XCUIElement *button3 = app.buttons[@"\u4e0a\u4e00\u9996"];
    [button3 tap];
    [button3 tap];
    
    XCUIElement *button4 = app.buttons[@"\u4e0b\u4e00\u9996"];
    [button4 tap];
    [button4 tap];
    [button4 tap];
    [button4 tap];
    [button4 tap];
    [button3 tap];
    [button3 tap];
    [button3 tap];
    [button3 tap];
    
    XCUIElement *slider = app.sliders[@"36%"];
    [slider swipeLeft];
    [slider pressForDuration:0.9];
    [app.buttons[@"\u9759\u97f3"] tap];
    [app.buttons[@"\u6062\u590d\u58f0\u97f3"] tap];
    [app.navigationBars[@"Adam Levine - Lost Stars.mp3"].buttons[@"<\u8fd4\u56de"] tap];
    [tablesQuery.staticTexts[@"Adam Lambert - Another Lonely Night.mp3"] tap];
    [app.navigationBars[@"Adam Lambert - Another Lonely Night.mp3"].buttons[@"<\u8fd4\u56de"] tap];
    
    XCUIElement *firstviewNavigationBar = app.navigationBars[@"FirstView"];
    [[[firstviewNavigationBar childrenMatchingType:XCUIElementTypeButton] elementBoundByIndex:1] tap];
    [[[[app.navigationBars[@"UIView"] childrenMatchingType:XCUIElementTypeButton] matchingIdentifier:@"Back"] elementBoundByIndex:0] tap];
    
    XCUIElement *button5 = [[firstviewNavigationBar childrenMatchingType:XCUIElementTypeButton] elementBoundByIndex:0];
    [button5 tap];
    [app.switches[@"0"] tap];
    
    XCUIElement *settingNavigationBar = app.navigationBars[@"Setting"];
    [[[[settingNavigationBar childrenMatchingType:XCUIElementTypeButton] matchingIdentifier:@"Back"] elementBoundByIndex:1] tap];
    [staticText tap];
    
    XCUIElement *button6 = app.navigationBars[@"3OH!3,Katy Perry - Starstrukk.mp3"].buttons[@"<\u8fd4\u56de"];
    [button6 tap];
    [staticText tap];
    [button3 tap];
    [button4 tap];
    [button tap];
    [button2 tap];
    [button tap];
    [button6 tap];
    [[[[[[app.otherElements containingType:XCUIElementTypeNavigationBar identifier:@"FirstView"] childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeTable].element tap];
    [button5 tap];
    [app.switches[@"1"] tap];
    [[[[settingNavigationBar childrenMatchingType:XCUIElementTypeButton] matchingIdentifier:@"Back"] elementBoundByIndex:0] tap];
    [staticText tap];
    [button4 tap];
    [button4 tap];
    [button3 tap];
    [button3 tap];
    [button3 tap];
    [button2 tap];
    [button2 tap];
    
}

@end

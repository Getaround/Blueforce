//
//  BlueforceTests.m
//  BlueforceTests
//
//  Created by Elliot Kroo on 6/13/14.
//  Copyright (c) 2014 Getaround. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BlueforceConnectionManager.h"

@interface BlueforceTests : XCTestCase <BlueforceConnectionManagerDelegate>
@property BlueforceConnectionManager *connManager;
@end

@implementation BlueforceTests

-(void)isBluetoothEnabled:(bool)enabled {
    // pass
}

-(void)didDiscoverConnection:(BlueforceConnection *)fob {
    // pass
}

- (void)setUp
{
    [super setUp];
    self.connManager = [[BlueforceConnectionManager alloc] initWithDelegate: self];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testConnection
{
    [self.connManager startScan];
}

@end

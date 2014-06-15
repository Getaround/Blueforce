//
//  BlueforceConnectionManager.h
//  Blueforce
//
//  Created by Elliot Kroo on 6/13/14.
//  Copyright (c) 2014 Getaround. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BlueforceConnection.h"
#import <CoreBluetooth/CoreBluetooth.h>

@protocol BlueforceConnectionManagerDelegate
- (void) isBluetoothEnabled:(bool) enabled;
- (void) didDiscoverConnection:(BlueforceConnection*) fob;
@end

@interface BlueforceConnectionManager : NSObject <CBCentralManagerDelegate>

@property CBCentralManager *cm;
@property BOOL acceptNewFobs;
@property id<BlueforceConnectionManagerDelegate> delegate;

+(BlueforceConnectionManager *)sharedConnectionManager;

-(BlueforceConnectionManager *)initWithDelegate:(id<BlueforceConnectionManagerDelegate>)delegate;
-(void)startScan;
@end

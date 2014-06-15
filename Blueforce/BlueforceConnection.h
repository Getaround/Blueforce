//
//  BlueforceConnection.h
//  Blueforce
//
//  Created by Elliot Kroo on 6/13/14.
//  Copyright (c) 2014 Getaround. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface BlueforceConnection : NSObject <CBPeripheralDelegate>
@property CBPeripheral *peripheral;
@property CBCharacteristic *characteristic;


+(BlueforceConnection *)connectionWithId: (NSString *)peripheralName;
+(BlueforceConnection *)createConnectionForId: (NSString *)peripheralName WithPeripheral:(CBPeripheral *)peripheral;

-(BlueforceConnection *)initWithPeripheral:(CBPeripheral *)peripheral;

-(BOOL) canLockUnlock;
-(void) lock;
-(void) unlock;


// called by BlueforceConnectionManager to notify the connection that it is now active.
-(void) blueforceConnectionManagerConnected;

@end

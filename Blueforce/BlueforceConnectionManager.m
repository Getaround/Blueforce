//
//  Blueforce.m
//  Blueforce
//
//  Created by Elliot Kroo on 6/13/14.
//  Copyright (c) 2014 Getaround. All rights reserved.
//

#import "BlueforceConnectionManager.h"
#import "BlueforceConstants.h"

@implementation BlueforceConnectionManager

static BlueforceConnectionManager* sharedConnection = nil;
+(BlueforceConnectionManager *)sharedConnectionManager {    
    if (sharedConnection == nil) {
        sharedConnection = [[BlueforceConnectionManager alloc] initWithDelegate:nil];
    }
    
    return sharedConnection;
}

-(BlueforceConnectionManager *)initWithDelegate:(id<BlueforceConnectionManagerDelegate>)delegate {
    self.delegate = delegate;
    self.cm = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    
    return self;
}

-(void)startScan {
    NSDictionary* scanOptions = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:CBCentralManagerScanOptionAllowDuplicatesKey];
    [self.cm stopScan];
    
    [self.cm scanForPeripheralsWithServices:nil options:scanOptions];
}

-(void)centralManagerDidUpdateState:(CBCentralManager *)central {
    if (!self.delegate) {
        return;
    }
    
    if ([central state] == CBCentralManagerStatePoweredOn) {
        [self.delegate isBluetoothEnabled:YES];
    } else {
        [self.delegate isBluetoothEnabled:NO];
    }
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    NSArray *serviceData = [advertisementData objectForKey:@"kCBAdvDataServiceUUIDs"];
    if (!serviceData || (![serviceData containsObject: [CBUUID UUIDWithString: kBlueforceUUID]])) {
        //NSLog(@"Discovered unknown device, %@, %@", [peripheral name], [peripheral identifier]);
        return;
    }
    
    if (![BlueforceConnection connectionWithId:peripheral.name]) {
        NSLog(@"Discovered peripheral, name %@, data: %@, RSSI: %f", [peripheral name], advertisementData, RSSI.floatValue);
        [BlueforceConnection createConnectionForId:peripheral.name WithPeripheral:peripheral];
        [self.cm connectPeripheral:peripheral options:nil];
    }
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    BlueforceConnection *connection = [BlueforceConnection connectionWithId:peripheral.name];
    [connection blueforceConnectionManagerConnected];
    if (self.delegate) {
        [self.delegate didDiscoverConnection:connection];
    }
}

@end

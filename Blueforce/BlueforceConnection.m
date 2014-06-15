//
//  BlueforceConnection.m
//  Blueforce
//
//  Created by Elliot Kroo on 6/13/14.
//  Copyright (c) 2014 Getaround. All rights reserved.
//

#import "BlueforceConnection.h"

@implementation BlueforceConnection

static NSMutableDictionary *connections = nil;

+(BlueforceConnection *)connectionWithId: (NSString *)peripheralName {
    if (!connections) {
        connections = [NSMutableDictionary dictionaryWithCapacity:10];
    }
    
    BlueforceConnection *connection = [connections objectForKey:peripheralName];
    return connection;
}

+(BlueforceConnection *)createConnectionForId: (NSString *)peripheralName WithPeripheral:(CBPeripheral *)peripheral {
    if (!connections) {
        connections = [NSMutableDictionary dictionaryWithCapacity:10];
    }
    
    BlueforceConnection *connection = [connections objectForKey:peripheralName];
    if (!connection) {
        connection = [[BlueforceConnection alloc] initWithPeripheral: peripheral];
        [connections setObject:connection forKey:peripheralName];
    }
    
    return connection;
}

-(BlueforceConnection *)initWithPeripheral:(CBPeripheral *)peripheral {
    self.peripheral = peripheral;
    self.peripheral.delegate = self;
    return self;
}

-(void) blueforceConnectionManagerConnected {
    // scan for all available services on the peripheral
    [self.peripheral discoverServices:nil];
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
    // only one service is likely published on the peripheral
    [peripheral discoverCharacteristics:nil forService: [peripheral.services objectAtIndex:0]];
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    NSLog(@"Discovered characteristics %@", service.characteristics);
    self.characteristic = [service.characteristics objectAtIndex:0];
}

- (BOOL) canLockUnlock {
    return self.characteristic != nil;
}

- (void) lock {
    [self.peripheral writeValue:[NSData dataWithBytes:"\1" length:1] forCharacteristic:self.characteristic type:CBCharacteristicWriteWithResponse];
    NSLog(@"lock command sent");
}

- (void) unlock {
    [self.peripheral writeValue:[NSData dataWithBytes:"\0" length:1] forCharacteristic:self.characteristic type:CBCharacteristicWriteWithResponse];
    NSLog(@"unlock command sent");
}



@end

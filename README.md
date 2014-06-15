Blueforce
=========

Getting Started
---------------

To add the Getaround Blueforce library to your iOS project, drag the repo into your projects, and add the two headers `BlueforceConnectionManager.h` and `BlueforceConnection.h` to your project's include path.  The simplest way to do this is just to drag these to files into your project, and uncheck 'copy items into destination group's folder'.

![](http://cl.ly/image/3F3g1M3f1v06/Screen%20Shot%202014-06-14%20at%207.20.36%20PM.png)

Usage
-----

Create a class that implements the `BlueforceConnectionManagerDelegate` protocol, then construct a `BlueforceConnectionManager`.  You will receive an initial callback when bluetooth is enabled, then additional callbacks as Getaround Connect devices are discovered.

```objective-c
@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Initializes a connection manager instance for this view controller
	self.cm = [[BlueforceConnectionManager alloc] initWithDelegate:self];
}

#pragma mark - BlueforceConnectionManagerDelegate callbacks
// Called once after instantiation of the Connection Manager
- (void) isBluetoothEnabled:(bool)enabled {
    self.label.text = enabled ? @"Scanning" : @"Bluetooth Off";
    
    if (enabled) {
        [self.cm startScan];
    }
}

// Called each time a new BlueforceConnection is discovered
- (void) didDiscoverConnection:(BlueforceConnection *)connection {
    self.label.text = @"Connected";
    self.conn = connection;
    [self.lock setHidden:NO];
    [self.unlock setHidden:NO];
}

#pragma mark - Getaround Connnect IBActions
- (IBAction) lock:(id)sender {
    if (self.conn && [self.conn canLockUnlock]) {
        [self.conn lock];
    }
}

- (IBAction) unlock:(id)sender {
    if (self.conn && [self.conn canLockUnlock]) {
        [self.conn unlock];
    }
}

@end
```

### BlueforceConnectionManagerDelegate Protocol

#### - (void) isBluetoothEnabled:(bool) enabled

A callback you will receive as soon as a `BlueforceConnectionManager` is constructed.  Note that Blueforce requires bluetooth LE, which is available only on iPhone 4s's and newer devices.

#### - (void) didDiscoverConnection:(BlueforceConnection*) connection

A callback you will receive each time a Getaround Connect is discovered in range.  Note you will not receive these callbacks until `startScan` is called.


### BlueforceConnectionManager API

#### -(BlueforceConnectionManager *)initWithDelegate:(id<BlueforceConnectionManagerDelegate>)delegate

Construct a new `BlueforceConnectionManager` with a specified delegate.  `delegate` can be nil, though no updates will be sent until a delegate is attached.

```
self.cm = [[BlueforceDelegateManager alloc] initWithDelegate: self];
```
  
#### -(void)startScan

Begins scanning for new `BlueforceConnection`s.  This should be called only after a delegate object is attached to the connection manager.

```
[self.cm startScan];
```

### BlueforceConnection API

#### -(BOOL) canLockUnlock

Provides a convenient way to check wether this blueforce connection is active and ready to send commands.

#### -(void) lock

Sends a lock command to the device.

#### -(void) unlock

Sends an unlock command to the device.



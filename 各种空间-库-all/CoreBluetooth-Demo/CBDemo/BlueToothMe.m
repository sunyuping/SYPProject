//
//  BlueToothMe.m
//  CBDemo
//
//  Created by Sergio on 25/01/12.
//  Copyright (c) 2012 Sergio. All rights reserved.
//

#import "BlueToothMe.h"

static eventHardwareBlock privateBlock;

@interface BlueToothMe (Private)

- (BOOL)supportLEHardware;

@end

@implementation BlueToothMe
@synthesize manager, dicoveredPeripherals, testPeripheral, servicesCBUUID, characteristicsCBUUID, letWriteDataCBUUID, delegate;

- (BOOL)supportLEHardware
{
    NSString * state = nil;
    
    switch ([manager state]) 
    {
        case CBCentralManagerStateUnsupported:
            state = @"The platform/hardware doesn't support Bluetooth Low Energy.";
            break;
        case CBCentralManagerStateUnauthorized:
            state = @"The app is not authorized to use Bluetooth Low Energy.";
            break;
        case CBCentralManagerStatePoweredOff:
            state = @"Bluetooth is currently powered off.";
            break;
        case CBCentralManagerStatePoweredOn:
            return TRUE;
        case CBCentralManagerStateUnknown:
        default:
            return false;
    }
    
    NSLog(@"Central manager state: %@", state);

    return false;
}

- (void)setCharacteristics:(NSArray *)characteristics forServiceCBUUID:(NSString *)serviceCBUUID
{
    [self.characteristicsCBUUID setValue:characteristics forKey:serviceCBUUID];
}

- (void)setServicesUID:(NSArray *)cbuuid
{
    self.servicesCBUUID = cbuuid;
}

- (void)setValuesToNotify:(NSArray *)notifiers
{
    [notifiers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        CBCharacteristic *localChar = (CBCharacteristic *)obj;
        [testPeripheral setNotifyValue:YES forCharacteristic:localChar];
    }];
}

- (void)hardwareResponse:(eventHardwareBlock)block
{
    privateBlock = [block copy];
}

+ (BlueToothMe *)shared
{
    static BlueToothMe *class;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        class = [BlueToothMe new];
    });
    
    return class;
}

- (id)init
{
    if ((self = [super init]))
    {
        self.characteristicsCBUUID = [NSMutableDictionary new];
        self.dicoveredPeripherals = [NSMutableArray new];
        manager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    }
    
    return self;
}

- (void)startScan
{
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:FALSE], CBCentralManagerScanOptionAllowDuplicatesKey, nil];
    
    [manager scanForPeripheralsWithServices:self.dicoveredPeripherals options:options];
}

- (void)stopScan
{
    [manager stopScan];
}

#pragma mark - 
#pragma mark CBManagerDelegate methods

/*
 Invoked whenever the central manager's state is updated.
 */
- (void)centralManagerDidUpdateState:(CBCentralManager *)central 
{
    if (![self supportLEHardware]) 
    {
        @throw ([NSError errorWithDomain:@"Bluetooth LE not supported"
                                    code:999
                                userInfo:nil]);
    }
}

/*
 Invoked when the central discovers peripheral while scanning.
 */
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    NSLog(@"Did discover peripheral. peripheral: %@ rssi: %@, UUID: %@ advertisementData: %@ ", peripheral, RSSI, peripheral.UUID, advertisementData);
    
    if(![self.dicoveredPeripherals containsObject:peripheral])
        [self.dicoveredPeripherals addObject:peripheral];
    
    [manager retrievePeripherals:[NSArray arrayWithObject:(id)peripheral.UUID]];
}

/*
 Invoked when the central manager retrieves the list of known peripherals.
 Automatically connect to first known peripheral
 */
- (void)centralManager:(CBCentralManager *)central didRetrievePeripherals:(NSArray *)peripherals
{
    NSLog(@"Retrieved peripheral: %d - %@", [peripherals count], peripherals);
    
    [self stopScan];
    
    /* If there are any known devices, automatically connect to it.*/
    if([peripherals count] >= 1)
    {
        testPeripheral = [peripherals objectAtIndex:0];

        [manager connectPeripheral:testPeripheral
                           options:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:CBConnectPeripheralOptionNotifyOnDisconnectionKey]];
    }
}

/*
 Invoked whenever a connection is succesfully created with the peripheral. 
 Discover available services on the peripheral
 */
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    NSLog(@"Did connect to peripheral: %@", peripheral);
    
    privateBlock(peripheral, BLUETOOTH_STATUS_CONNECTED, nil);
    
    NSLog(@"Connected");
    [peripheral setDelegate:self];
    [peripheral discoverServices:nil];
}

/*
 Invoked whenever an existing connection with the peripheral is torn down. 
 Reset local variables
 */
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"Did Disconnect to peripheral: %@ with error = %@", peripheral, [error localizedDescription]);

    privateBlock(peripheral, BLUETOOTH_STATUS_DISCONNECTED, error);
    
    if (testPeripheral)
    {
        [testPeripheral setDelegate:nil];
        testPeripheral = nil;
    }
}

/*
 Invoked whenever the central manager fails to create a connection with the peripheral.
 */
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"Fail to connect to peripheral: %@ with error = %@", peripheral, [error localizedDescription]);
    
    privateBlock(peripheral, BLUETOOTH_STATUS_FAIL_TO_CONNECT, error);
    
    if (testPeripheral)
    {
        [testPeripheral setDelegate:nil];
        testPeripheral = nil;
    }
}

#pragma mark - 
#pragma mark CBPeripheralDelegate methods

/*
 Invoked upon completion of a -[discoverServices:] request.
 */
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    if (error) 
    {
        NSLog(@"Discovered services for %@ with error: %@", peripheral.name, [error localizedDescription]);
        return;
    }
    
    [self.servicesCBUUID enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        NSString *externalCBUUID = (NSString *)obj;
        
        for (CBService *service in peripheral.services)
        {
            NSLog(@"Service found with UUID: %@", service.UUID);
            
            if ([service.UUID isEqual:[CBUUID UUIDWithString:externalCBUUID]])
            {
                [testPeripheral discoverCharacteristics:[self.characteristicsCBUUID valueForKey:(NSString *)service.UUID] 
                                             forService:service];
            }
            else if ([service.UUID isEqual:[CBUUID UUIDWithString:CBUUIDGenericAccessProfileString]])
            {
                /* GAP (Generic Access Profile) - discover device name characteristic */
                [testPeripheral discoverCharacteristics:[NSArray arrayWithObject:[CBUUID UUIDWithString:CBUUIDDeviceNameString]]  forService:service];
            }
        }
    }];
}

/*
 Invoked upon completion of a -[discoverCharacteristics:forService:] request.
 */
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error 
{
    if (error) 
    {
        NSLog(@"Discovered characteristics for %@ with error: %@", service.UUID, [error localizedDescription]);
        return;
    }
    
    [self.servicesCBUUID enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
       
        NSString *localUUID = (NSString *)obj;
        
        if([service.UUID isEqual:[CBUUID UUIDWithString:localUUID]])
        {
            [self.characteristicsCBUUID enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                
                NSString *localChar = (NSString *)obj;
                for (CBCharacteristic * characteristic in service.characteristics)
                {
                    if( [characteristic.UUID isEqual:[CBUUID UUIDWithString:localChar]])
                    {      
                        if ([letWriteDataCBUUID containsObject:(NSString *)localChar])
                        {
                            //write
                            uint16_t val = 2;
                            NSData * valData = [NSData dataWithBytes:(void*)&val length:sizeof(val)];
                            [testPeripheral writeValue:valData forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];  
                            NSLog(@"Found a Temperature Measurement Interval Characteristic - Write interval value");
                            
                        }
                 
                        //read
                        [testPeripheral readValueForCharacteristic:characteristic];
                        NSLog(@"Found a Device Manufacturer Name Characteristic - Read manufacturer name");
                        
                    }
                }
            }];
        }

        if ([service.UUID isEqual:[CBUUID UUIDWithString:CBUUIDGenericAccessProfileString]])
        {
            for (CBCharacteristic *characteristic in service.characteristics) 
            {
                /* Read device name */
                if([characteristic.UUID isEqual:[CBUUID UUIDWithString:CBUUIDDeviceNameString]])
                {                
                    [testPeripheral readValueForCharacteristic:characteristic];
                    NSLog(@"Found a Device Name Characteristic - Read device name");
                }
            }
        }
    }];
}

/*
 Invoked upon completion of a -[readValueForCharacteristic:] request or on the reception of a notification/indication.
 */
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error) 
    {
        NSLog(@"Error updating value for characteristic %@ error: %@", characteristic.UUID, [error localizedDescription]);
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(peripheralDidReadChracteristic:withPeripheral:withError:)])
        [self.delegate peripheralDidReadChracteristic:characteristic withPeripheral:peripheral withError:error];
}

/*
 Invoked upon completion of a -[writeValue:forCharacteristic:] request.
 */
- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error 
{
    if (error) 
    {
        NSLog(@"Error writing value for characteristic %@ error: %@", characteristic.UUID, [error localizedDescription]);
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(peripheralDidWriteChracteristic:withPeripheral:withError:)])
        [self.delegate peripheralDidWriteChracteristic:characteristic withPeripheral:peripheral withError:error];
}

/*
 Invoked upon completion of a -[setNotifyValue:forCharacteristic:] request.
 */
- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error 
{
    if (error) 
    {
        NSLog(@"Error updating notification state for characteristic %@ error: %@", characteristic.UUID, [error localizedDescription]);
        return;
    }
    
    NSLog(@"Updated notification state for characteristic %@ (newState:%@)", characteristic.UUID, [characteristic isNotifying] ? @"Notifying" : @"Not Notifying");   
    
    if ([self.delegate respondsToSelector:@selector(hardwareDidNotifyBehaviourOnCharacteristic:withPeripheral:error:)])
        [self.delegate hardwareDidNotifyBehaviourOnCharacteristic:characteristic withPeripheral:peripheral error:error];
}

@end

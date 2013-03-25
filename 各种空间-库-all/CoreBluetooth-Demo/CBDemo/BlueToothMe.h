//
//  BlueToothMe.h
//  CBDemo
//
//  Created by Sergio on 25/01/12.
//  Copyright (c) 2012 Sergio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@protocol BlueToothMeDelegate <NSObject>
@required

- (void)peripheralDidWriteChracteristic:(CBCharacteristic *)characteristic 
                         withPeripheral:(CBPeripheral *)peripheral 
                              withError:(NSError *)error;

- (void)peripheralDidReadChracteristic:(CBCharacteristic *)characteristic 
                        withPeripheral:(CBPeripheral *)peripheral 
                             withError:(NSError *)error;

@optional

- (void)hardwareDidNotifyBehaviourOnCharacteristic:(CBCharacteristic *)characteristic
                                    withPeripheral:(CBPeripheral *)peripheral
                                             error:(NSError *)error;


@end

typedef enum
{
    BLUETOOTH_STATUS_DISCONNECTED = 0,
    BLUETOOTH_STATUS_FAIL_TO_CONNECT = 1,
    BLUETOOTH_STATUS_CONNECTED = 2
}BLUETOOTH_STATUS;

typedef void (^eventHardwareBlock)(CBPeripheral *peripheral, BLUETOOTH_STATUS status, NSError *error);

@interface BlueToothMe : NSObject <CBCentralManagerDelegate, CBPeripheralDelegate>
{
    NSMutableArray *dicoveredPeripherals;
    NSArray *letWriteDataCBUUID;
    id delegate;
    
@private
    CBCentralManager *manager;
    CBPeripheral *testPeripheral;
    NSArray *servicesCBUUID;
    NSDictionary *characteristicsCBUUID;
}

+ (BlueToothMe *)shared;
- (void)startScan;
- (void)stopScan;
- (void)setServicesUID:(NSArray *)cbuuid;
- (void)setCharacteristics:(NSArray *)characteristics forServiceCBUUID:(NSString *)serviceCBUUID;
- (void)setValuesToNotify:(NSArray *)notifiers;
- (void)hardwareResponse:(eventHardwareBlock)block;

@property (nonatomic, strong) CBCentralManager *manager;
@property (nonatomic, strong) NSMutableArray *dicoveredPeripherals;
@property (nonatomic, strong) NSArray *servicesCBUUID;
@property (nonatomic, strong) CBPeripheral *testPeripheral;
@property (nonatomic, strong) NSDictionary *characteristicsCBUUID;
@property (nonatomic, strong) NSArray *letWriteDataCBUUID;
@property (nonatomic, strong) id<BlueToothMeDelegate> delegate;

@end

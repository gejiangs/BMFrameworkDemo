//
//  BMManager.h
//  BatteryMonitor
//
//  Created by 郭江 on 2016/3/13.
//  Copyright © 2016年 郭江. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <CoreLocation/CoreLocation.h>

@protocol BMManagerDelegate<NSObject>
@optional

// MAC address to receive equipment
-(void)BMManagerDeviceMAC:(NSString *)mac;

//Receive is genuine equipment
-(void)BMManagerDeviceIsGenuine:(BOOL)isGenuine;

/*
 * Receive start voltage data
 * dict : @{@"date":[NSDate date], @"voltage":12.1, @"status":1, @"voltages":vols}
 * status:(1:Battery ok, 2:Low power)
 */
-(void)BMManagerReceiveStartupData:(NSDictionary *)dict;

/*
 * Receiving voltage real-time data
 * dict @{@"voltage":12.5, @"status":1, @"power":0.98}
 * status:(1:Battery ok, 2:Low power, 3:Run out, 4:Charging)
 */
-(void)BMManagerRealtimeData:(NSDictionary *)dict;

//Receiving device firmware version
-(void)BMManagerDeviceFirmwareVersion:(int)version;

@end


@interface BMManager : NSObject

//delegate
@property (nonatomic, weak) id<BMManagerDelegate> delegate;


+(instancetype)sharedManager;


/*
 * method 1 (must)
 */
-(void)didConnectPeripheral:(CBPeripheral *)peripheral;

/*
 * method 2 (must)
 */
-(void)disDisconnectPeripheral:(CBPeripheral *)peripheral;


/*
 *  @method readHistoryLength:block:
 *  Read history voltage data length
 *
 *  @param block		return voltage data lenght
 */
-(void)readHistoryLength:(void(^)(int len))block;

/*
 * Idling Voltage Test step 1
 */
-(void)sendIdlingVoltageTest:(void(^)())block;

/*
 * High Voltage Test step 2
 *  @param block block	Charging test data,format @[@{@"idlingValtage":12.6, @"highVoltage":12.6,@"status":1}]
 *  status:(1:Battery OK, 2:Low power, 3:High power)
 */
-(void)sendHighVoltageTest:(void(^)(NSDictionary *dict))block;

/*
 *  @method readVoltageWithDate:completeBlock:
 *  Read history voltage data
 *
 *  @param date         read data date
 *  @param block voltageArray	voltage data,format @[@{@"voltage":12.6,@"status":1}]
 *  status:(0:null, 2:Car Startup, 3:Car Flameout)
 */
-(void)readVoltageWithDate:(NSDate *)date completeBlock:(void(^)(BOOL isEnd, NSArray *voltageArray))block;


/*
 *  @method readVoltageWithDate:completeBlock:
 *  Read history voltage data
 *
 *  @param date         read data date
 *  @param block voltageArray	voltage data,format @[@{@"voltage":12.6,@"status":1}]
 *  status:(0:null, 2:Car Startup, 3:Car Flameout)
 */
-(void)readVoltageWithStartDate:(NSDate *)startDate endDate:(NSDate *)endDete completeBlock:(void(^)(BOOL isEnd,NSArray *voltageArray))block;;


/*
 *  @method checkNewVersion:
 *  Check new firmware version
 *
 *  @param block         Has new version
 */
-(void)checkHardwareUpgradeWithBlock:(void(^)(BOOL hasNew, NSDictionary *upgradeData))block;


/*
 *  @method firmwareUpgradeWithProgress:failure:
 *  Firmware Upgrade
 *
 *  @param progress         Upgrade progress
 *  @param failure          Upgrade failure
 */
-(void)firmwareUpgradeWithProgress:(void(^)(float progress))progress failure:(void(^)())failure;

@end

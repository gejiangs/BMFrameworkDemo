//
//  BluetoothManager.h
//  ThermoTimer
//
//  Created by gejiangs on 15/8/10.
//  Copyright (c) 2015年 gejiangs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <BMFramework/BMManager.h>

typedef NS_ENUM(NSInteger, ConnectState) {
    ConnectStateNone = 0,
    ConnectStateConnect = 1,
    ConnectStateUnconnect ,
    ConnectStateDisconnect
};

typedef NS_ENUM(NSInteger, CmdStep){
    CmdStepNone,
    CmdStepIdling,
    CmdStepHigh,
    CmdStepHistory,
    CmdStepLock,
    CmdStepUnlock
};

@interface BluetoothManager : NSObject

@property (nonatomic, strong)   CBCentralManager *manager;
@property (nonatomic, strong)   CBPeripheral *peripheral;                   //当前连接蓝牙设备
@property (nonatomic, strong)   NSMutableArray *peripheralArray;            //扫描设备列表
@property (nonatomic, copy)     void(^blueConnectBlock)(BOOL success);      //蓝牙连接block
@property (nonatomic, assign)   ConnectState state;
@property (nonatomic, assign)   CmdStep cmdStep;
@property (nonatomic, copy)     void(^historyListBlock)(NSDictionary *dict);//历史记录block
@property (nonatomic, assign)   int deviceVersion;                          //硬件版本号（0,1,2,3,4.....）

+(BluetoothManager *)shareManager;

//系统不支持蓝牙4.0
-(BOOL)unsupported;

/**
 *  系统是否支持蓝牙
 *
 *  @return 返回系统是否支持蓝牙
 */
-(BOOL)supportHardware;


/**
 *  开始扫描蓝牙设备
 */
-(void)startScan;

/**
 *  开始扫描蓝牙设备
 *
 *  @param block 扫描到的设备列表
 */
-(void)startScanBlock:(void (^)(NSArray *peripheralArray))block;
-(void)startScanBlock:(void (^)(NSArray *peripheralArray))block finally:(void(^)())finally;

-(void)startScanBlueBlock:(void (^)(CBPeripheral *peripheral))block;

/**
 *  停止扫描蓝牙设备
 */
-(void)stopScan;


/**
 *  连接蓝牙设备
 *
 *  @param block 蓝牙连接是否成功
 */
-(void)connect:(CBPeripheral *)peripheral block:(void(^)(BOOL success))block;


/**
 *  断开蓝牙连接
 *
 */
-(void)cancelPeripheralConnection:(CBPeripheral *)peripheral;

/**
 *  断开当前蓝牙连接
 *
 */
-(void)cancelCurrentPeripheralConnection;

@end

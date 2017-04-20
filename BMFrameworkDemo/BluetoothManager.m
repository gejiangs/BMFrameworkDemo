//
//  BluetoothManager.m
//  ThermoTimer
//
//  Created by gejiangs on 15/8/10.
//  Copyright (c) 2015年 gejiangs. All rights reserved.
//

#import "BluetoothManager.h"

#define BLE_SERVICE_NAME                   @"Battery Monitor"  //蓝牙名


@interface BluetoothManager ()<CBCentralManagerDelegate, CBPeripheralDelegate>

@property (nonatomic, copy)     void(^scanResultBlock)(NSArray *Array);     //扫描返回设备列表
@property (nonatomic, copy)     void(^scanModelBlock)(CBPeripheral *peripheral);//扫描单个蓝牙对象数据
@property (nonatomic, copy)     void(^scanFinallyBlock)();                  //扫描结束

@end

@implementation BluetoothManager

+ (BluetoothManager *)shareManager
{
    static BluetoothManager *share = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
    {
      share = [[self alloc] init];
    });
    return share;
}

-(id)init
{
    if (self = [super init]) {
        self.manager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
        self.state = ConnectStateNone;
    }
    return self;
}

//开始扫描
-(void)startScan
{
    //先暂停扫描，再开始扫描
    [self.manager stopScan];
    
    //开始扫描，清空之前扫描结果
    self.peripheralArray = [NSMutableArray array];
    
    NSDictionary *options = @{CBCentralManagerScanOptionAllowDuplicatesKey:@YES};
    //新硬件支持后台扫描蓝牙功能
    NSArray *uuids = @[[CBUUID UUIDWithString:@"FFF0"]];
    [self.manager scanForPeripheralsWithServices:uuids options:options];
}

//开始扫描
-(void)startScanBlock:(void (^)(NSArray *))block
{
    [self startScanBlock:block finally:nil];
}

-(void)startScanBlock:(void (^)(NSArray *))block finally:(void (^)())finally
{
    //蓝牙未打开，不搜索蓝牙
    if (self.manager.state != CBCentralManagerStatePoweredOn) {
        self.peripheralArray = [NSMutableArray array];
        
        if (block) {
            block(self.peripheralArray);
        }
        
        if (finally) {
            finally();
        }
        
        return;
    }
    
    self.scanResultBlock = block;
    self.scanFinallyBlock = finally;
    [self startScan];
    
    if (finally) {
        
        dispatch_time_t time_t = dispatch_time(DISPATCH_TIME_NOW,(int64_t)(3 * NSEC_PER_SEC));
        
        dispatch_after(time_t, dispatch_get_main_queue(), ^{
            [self stopScan];
            if (self.scanFinallyBlock) {
                self.scanFinallyBlock();
            }
        });
        
    }
}

-(void)startScanBlueBlock:(void (^)(CBPeripheral *))block
{
    self.scanModelBlock = block;
    [self startScan];
}

//停止扫描
-(void)stopScan
{
    [self.manager stopScan];
}

//系统不支持蓝牙4.0
-(BOOL)unsupported
{
    return self.manager.state == CBCentralManagerStateUnsupported;
}

//判断系统是否支持蓝牙
- (BOOL)supportHardware
{
    BOOL v = NO;
    switch ([self.manager state])
    {
        case CBCentralManagerStateUnsupported:  //  系统不支持蓝牙
        case CBCentralManagerStateUnauthorized: //  设备未授权状态
        case CBCentralManagerStatePoweredOff:   //  设备关闭状态
        case CBCentralManagerStateUnknown:      //  初始的时候是未知的
        case CBCentralManagerStateResetting:    //  正在重置状态
            v = NO;
            break;
        case CBCentralManagerStatePoweredOn:    // 设备开启状态 -- 可用状态
            v = YES;
            break;
    }
    return v;
}


//开始查看服务，蓝牙开启
-(void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    switch (central.state) {
        case CBCentralManagerStatePoweredOn:
            NSLog(@"蓝牙已打开,请扫描外设");
            break;
        default:
            break;
    }
}

//查到外设后，停止扫描，连接设备
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral
     advertisementData:(NSDictionary *)advertisementData
                  RSSI:(NSNumber *)RSSI
{
    //此处判断设备名（可自动连接）
    if (![peripheral.name isEqualToString:BLE_SERVICE_NAME]) {
        return;
    }
    
    //扫描到设备，添加到列表(去重)
    BOOL hasExist = NO;
    for (CBPeripheral *p in self.peripheralArray) {
        if ([p.identifier.UUIDString isEqualToString:peripheral.identifier.UUIDString]) {
            hasExist = YES;break;
        }
    }
    
    if (!hasExist) {
        [self.peripheralArray addObject:peripheral];
    }
    
    
    //返回扫描设备列表
    if (self.scanResultBlock) {
        self.scanResultBlock(self.peripheralArray);
    }
    //        NSLog(@"RSSI:%@＝＝%@＝＝%@", RSSI, peripheral, advertisementData);
    
    if (self.scanModelBlock) {
        self.scanModelBlock(peripheral);
    }
    
}

//连接蓝牙设备
-(void)connect:(CBPeripheral *)peripheral block:(void (^)(BOOL))block
{
    self.blueConnectBlock = block;
    
    NSDictionary *options = @{CBConnectPeripheralOptionNotifyOnDisconnectionKey:@YES};
    
    self.manager.delegate = self;
    [self.manager connectPeripheral:peripheral options:options];
}

/**
 *  断开当前蓝牙连接
 *
 */
-(void)cancelCurrentPeripheralConnection
{
    [self cancelPeripheralConnection:self.peripheral];
}

//断开蓝牙设备
-(void)cancelPeripheralConnection:(CBPeripheral *)peripheral
{
    [self.manager cancelPeripheralConnection:peripheral];
}

#pragma mark  CBCentralManagerDelegate
//蓝牙设备连接成功，开始发现服务
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    self.state = ConnectStateConnect;
    self.peripheral = peripheral;
    
    //蓝牙设备连接成功
    if (self.blueConnectBlock) {
        self.blueConnectBlock(YES);
    }
    
    [[BMManager sharedManager] didConnectPeripheral:peripheral];
}

//连接外设失败
-(void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    self.state = ConnectStateUnconnect;
    if (self.blueConnectBlock) {
        self.blueConnectBlock(NO);
    }
}

// 断开连接
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    self.state = ConnectStateDisconnect;
    self.peripheral = nil;//蓝牙断开连接，清空对象
    
    if (self.blueConnectBlock) {
        self.blueConnectBlock(NO);
    }
    [[BMManager sharedManager] disDisconnectPeripheral:peripheral];
}



@end

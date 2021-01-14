
#import <UIKit/UIKit.h>
#import <React/RCTConvert.h>
#import <MapKit/MapKit.h>
#import <React/RCTLog.h>
#import "RCTTICBridgeManager.h"
// 这里专门抛出给RN进行调用的接口
#import "RCTTICCoreManager.h"
@implementation RCTTICBridgeManager 
RCT_EXPORT_MODULE();
typedef UInt32 uint32;

RCT_EXPORT_METHOD(initEngine:(NSString *)identifier info:(NSDictionary *)info resolve:(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject)
{
  // 初始化引擎,初始化单例
    [[RCTTICCoreManager sharedInstance] initEngine:identifier info:info delegate:self];
  resolve(@"1");
//  RCTLogInfo(@"sdkAppId: %d", sdkAppId);
}

RCT_EXPORT_METHOD(joinRoom:(NSString *)roomUuid roomToken:(NSString *)roomToken resolve:(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject)
{
  // 加入到频道里面
 [[RCTTICCoreManager sharedInstance] joinRoom:roomUuid roomToken:roomToken];
  resolve(@"1");

}

// 方法调用
RCT_EXPORT_METHOD(callMethod:
                  (NSString *) methodName params:(NSDictionary *) params resolve:(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject)
{
  // 方法调用
//  [RCTTICCoreManager sharedInstance];
  [[RCTTICCoreManager sharedInstance] callMethod: methodName params:params];
  resolve(@"1");
  
}
// 设置主播模式
RCT_EXPORT_METHOD(setViewMode:
                  (NSString *) mode  resolve:(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject)
{
  // 方法调用

  [[RCTTICCoreManager sharedInstance] setViewMode:mode];
  resolve(@"1");
  
}
// 注销引擎
RCT_EXPORT_METHOD(unInitEngine  :(RCTPromiseResolveBlock) resolve reject:(RCTPromiseRejectBlock) reject)
{
  // 方法调用
  
  [[RCTTICCoreManager sharedInstance] unInitEngine];
  resolve(@"1");
}
#pragma mark - listener
- (NSArray<NSString *> *)supportedEvents
{
  return @[@"BorderviewReady", @"JoinRoomSuccess", @"JoinRoomError"];
}

- (void)viewReady
{
  [self sendEventWithName:@"BorderviewReady" body:@{}];
}
- (void)JoinRoomCallback: (NSDictionary *) body
{
  RCTLogInfo(@"加入频道的状态回调 %@", body);
    [self sendEventWithName:[body objectForKey:@"type"] body:body];
}

@end

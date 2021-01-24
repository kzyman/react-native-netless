#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import <WhiteSDK.h>

#import <React/RCTBridgeModule.h>
#import <React/RCTViewManager.h>
#import <Whiteboard/Whiteboard.h>
@interface RCTTICCoreManager : UIViewController
/**
 * 获取单例
 **/
+ (instancetype)sharedInstance;
- (void) initEngine: (NSString *)identifier info:(NSDictionary *)info delegate:(id)delegate;
- (void) setViewMode:(NSString *) mode;
- (void) joinRoom: (NSString *)roomUuid roomToken:(NSString *)roomToken;
- (void) leaveRoom;
- (UIView *) getBoardController;
- (void) callMethod: (NSString *) methodName params:(NSDictionary *) params;
- (void) unInitEngine;

@end

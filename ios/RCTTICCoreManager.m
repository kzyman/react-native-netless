#import "RCTTICCoreManager.h"
#import <UIKit/UIKit.h>
#import <React/RCTLog.h>
#import <CoreGraphics/CGBase.h>
@interface RCTTICCoreManager ()<WhiteRoomCallbackDelegate>
  @property (nonatomic, assign) NSString* sdkToken;
  @property (nonatomic, strong) id delegate;
    @property (nonatomic, strong) NSNumber* width;
  @property (nonatomic, strong) NSNumber *height;
  @property (nonatomic, strong) NSString *groupId;
  @property (nonatomic, strong) NSString *userId;
  @property (nonatomic, strong) NSString *userSig;
  @property (nonatomic, strong) UIView *imController;
  @property (nonatomic, strong) WhiteBoardView *boardView;
  @property (nonatomic, strong) UIView *boardView111;
  @property (nonatomic, strong) WhiteSDK *sdk;
  @property (nonatomic, strong) WhiteRoom *room;
  #pragma mark - CallbackDelegate
  @property (nonatomic, weak, nullable) id<WhiteCommonCallbackDelegate> commonDelegate;
@end

@implementation RCTTICCoreManager
//白板视图容器
+ (instancetype)sharedInstance
{
    static RCTTICCoreManager *instance = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        instance = [[RCTTICCoreManager alloc] init];;
    });
    return instance;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //    [self.boardView mas_makeConstraints:^(MASConstraintMaker *make) {
//      make.top.equalTo(self.mas_topLayoutGuideBottom);
//      make.left.bottom.right.equalTo(self.view);
//    }];


}
- (void) initEngine: (NSString *)identifier info:(NSDictionary *)info delegate:(id)delegate{
    dispatch_sync(dispatch_get_main_queue(), ^{
        self.boardView = [[WhiteBoardView alloc] init];
        CGFloat width = [RCTConvert CGFloat: [info objectForKey:@"width"]];
        CGFloat height = [RCTConvert CGFloat: [info objectForKey:@"height"]];
        self.view.frame = CGRectMake(0, 0, width, height);
        self.boardView.frame = CGRectMake(0, 0, width, height);
        [self.view addSubview:self.boardView ];
        WhiteSdkConfiguration *config = [[WhiteSdkConfiguration alloc] initWithApp:identifier];
        self.sdk = [[WhiteSDK alloc] initWithWhiteBoardView:self.boardView config:config commonCallbackDelegate:self];
        _delegate = delegate;
    });
}
- (void) joinRoom: (NSString *)roomUuid roomToken:(NSString *)roomToken{
  // 加入房间
  dispatch_sync(dispatch_get_main_queue(), ^{
      WhiteRoomConfig *roomConfig = [[WhiteRoomConfig alloc] initWithUuid:roomUuid roomToken:roomToken];
      

      [self.sdk joinRoomWithConfig:roomConfig callbacks:self completionHandler:^(BOOL success, WhiteRoom * _Nonnull room, NSError * _Nonnull error) {
          if (success) {
            self.room = room;
            // 在这里给个回调
            // 允许序列化才能使用 undo redo
            [self.room disableSerialization:NO];
              NSDictionary *body =@{@"type": @"joinRoomSuccess"};
              [self->_delegate performSelector:@selector(JoinRoomCallback:) withObject:body];

          } else {
              // 错误处理
            // 在这里给个回调
              NSDictionary *body =@{@"type": @"joinRoomError", @"msg": error};
              [self->_delegate performSelector:@selector(JoinRoomCallback:) withObject:body];
          }
      }];
  });
}


- (void) leaveRoom {
  // 离开房间
    if (self.room) {
      dispatch_sync(dispatch_get_main_queue(), ^{
        [self.room disconnect:^{
            //断连成功
            RCTLogInfo(@"成功退出白板房间");
        }];    
      });
    };

}

- (void)setViewMode: (NSString *) mode{
    if ([mode isEqualToString:@"freedom"]) {
        [self.room setViewMode:WhiteViewModeFreedom];
    } else if ([mode isEqualToString:@"follower"]) {
        [self.room setViewMode:WhiteViewModeFollower];
    } else if ([mode isEqualToString:@"broadcaster"]) {
        [self.room setViewMode:WhiteViewModeBroadcaster];
    }
}
- (void)disableDeviceInputs: (BOOL *) enable{
    [self.room disableDeviceInputs: enable];
}
- (UIView *)getBoardController
{
    return self.view;
}


// 释放引擎
- (void) unInitEngine {
  dispatch_sync(dispatch_get_main_queue(), ^{
//    [[TIMManager sharedInstance] unInit];
//    [_boardController unInit];

      [self.view removeReactSubview:self.boardView];
  });
}
- (void) callMethod: (NSString *) methodName params:(NSMutableDictionary *) params {
    // 动态调用各个方法
  dispatch_sync(dispatch_get_main_queue(), ^{
    if ([methodName isEqualToString:@"setToolType"]) {
      // 设置白板工具, 这里包含直线，随意曲线，椭圆,方形, 鼠标等
      WhiteMemberState *memberState = [[WhiteMemberState alloc] init];
      //白板初始状态时，教具默认为 pencil
      memberState.currentApplianceName = [params objectForKey:@"type"];


      [_room setMemberState:memberState];
    } else if ([methodName isEqualToString:@"clearBackground"]) {
      // 清空选中或者全屏
        [_room deleteOpertion];
//      [_room cleanScene:  [RCTConvert BOOL:[params objectForKey:@"retainPPT"]]];
    } else if ([methodName isEqualToString:@"setBrushColor"]) {
      // 设置刷子颜色
      NSArray *color = [params objectForKey:@"color"];
      WhiteMemberState *memberState = [[WhiteMemberState alloc] init];
      //白板初始状态时，教具默认为 pencil
        memberState.strokeColor = color;
      [_room setMemberState:memberState];
    } else if ([methodName isEqualToString:@"setBrushThin"]) {
      // 设置刷子粗细
      WhiteMemberState *memberState = [[WhiteMemberState alloc] init];
      //白板初始状态时，教具默认为 pencil
        
      memberState.strokeWidth = [RCTConvert NSNumber: [params objectForKey:@"thin"]];
      [_room setMemberState:memberState];
    } else if ([methodName isEqualToString:@"setTextColor"]) {
      // 设置文本颜色
      NSArray *color = [params objectForKey:@"color"];
      WhiteMemberState *memberState = [[WhiteMemberState alloc] init];
      //白板初始状态时，教具默认为 pencil
      memberState.strokeColor = color;
      [_room setMemberState:memberState];
    } else if ([methodName isEqualToString:@"setTextSize"]) {
      // 设置字体大小
      WhiteMemberState *memberState = [[WhiteMemberState alloc] init];
      //白板初始状态时，教具默认为 pencil
      memberState.textSize = [RCTConvert NSNumber: [params objectForKey:@"size"]];
      [_room setMemberState:memberState];
    } else if ([methodName isEqualToString:@"undo"]) {
      // 撤销
      [_room undo];
    } else if ([methodName isEqualToString:@"redo"]) {
      // 重做
      [_room redo];
    } else if ([methodName isEqualToString:@"insertImage"]) {
        [self.room getRoomStateWithResult:^(WhiteRoomState * _Nonnull state) {
            
            WhiteImageInformation *info = [[WhiteImageInformation alloc] init];
            info.width = [RCTConvert CGFloat: [params objectForKey:@"width"]];
            info.height = [RCTConvert CGFloat: [params objectForKey:@"height"]];
            info.uuid = [RCTConvert NSString: [params objectForKey:@"uuid"]];
            info.centerX =  [RCTConvert CGFloat: state.cameraState.centerX];
            info.centerY =  [RCTConvert CGFloat: state.cameraState.centerY];
            [self.room insertImage:info src:[RCTConvert NSString: [params objectForKey:@"src"]]];
        }];
//        WhiteCameraBound *bound = [WhiteCameraBound defaultMinContentModeScale:0.5 maxContentModeScale:3];
//        [self.room setCameraBound:bound];
    } else if ([methodName isEqualToString:@"setDrawEnable"]) {
      // 是否允许涂鸦
//      [_boardController setDrawEnable: [RCTConvert BOOL:[params objectForKey:@"enable"]]];
    } else if ([methodName isEqualToString:@"setBackGround"]){
        NSArray *color = [params objectForKey:@"color"];
        [_room setBackgroundColor : [UIColor colorWithRed:[[color objectAtIndex: 0] integerValue]/255.0
                                                          green:[[color objectAtIndex: 1] integerValue]/255.0
                                                          blue:[[color objectAtIndex: 2] integerValue]/255.0
                                                          alpha:[[color objectAtIndex: 3] integerValue]]];
    } else if ([methodName isEqualToString:@"disableDeviceInputs"]) {
        //禁用启用教具
        [_room disableDeviceInputs:  [RCTConvert BOOL:[params objectForKey:@"disable"]]];
    } else if ([methodName isEqualToString:@"disableOperations"]) {
        //禁用启用教具
        [_room disableOperations:  [RCTConvert BOOL:[params objectForKey:@"readonly"]]];
    }
  });
}
// 房间状态变化的回调
- (void)fireRoomStateChanged:(WhiteRoomState *)modifyState {
    // RCTLogInfo(@"房间状态的变化 %@",modifyState);
};
@end


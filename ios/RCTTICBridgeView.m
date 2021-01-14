#import "RCTTICBridgeView.h"
#import <UIKit/UIKit.h>
#import "RCTTICCoreManager.h"
#import <React/RCTLog.h>
#import <MapKit/MapKit.h>

@implementation AATest

- (void)viewDidLoad {
    [super viewDidLoad];
}

@end
@implementation TICBridgeViewManager
//白板视图容器

RCT_EXPORT_MODULE(TICBridgeView);

- (UIView *)view
{
    return [[RCTTICCoreManager sharedInstance] getBoardController];
    UIView *a = [[UIView alloc]  init];
    UIView *b = [[RCTTICCoreManager sharedInstance] getBoardController];
    [a addSubview:b];
    return a;
}

@end


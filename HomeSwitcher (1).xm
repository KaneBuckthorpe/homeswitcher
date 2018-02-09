#import "HomeSwitcher.h"

HSCollectionView *switcherView;
HSHomeView *homeView;
%hook SpringBoard
-(void)frontDisplayDidChange:(id)newDisplay {
    [switcherView reloadSwitcher];
  %orig;
}
%end

%hook SBIconScrollView
- (id)init{
    id orig = %orig;
homeView = [[HSHomeView alloc] init];

    switcherView = [[HSCollectionView alloc] init];
_UIBackdropView*blurView = [[_UIBackdropView alloc] initWithStyle:2029];

[blurView setBlurRadiusSetOnce:NO];
[blurView setBlurRadius:5];
[blurView setBlurQuality:@"default"];
blurView.backgroundColor=[UIColor whiteColor];
blurView.alpha=0.2;
blurView.layer.shadowColor=[UIColor whiteColor].CGColor; 
      [blurView.layer setShadowOpacity:1];
blurView.layer.shadowRadius=30; 
blurView.layer.shadowOffset = CGSizeMake(0,30 ); 
    [switcherView reloadSwitcher];
    [orig addSubview:homeView];
   [homeView addSubview:switcherView];
switcherView.backgroundView =blurView; 
    return orig;


}
%end

%hook SBRootIconListView
/*
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [self hitTest:point withEvent:event];

    if (view == self) {
        view = switcherView;
    }

    return view;
}

*/
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    UIView *hitTestResult = %orig;

    if ([hitTestResult pointInside:point withEvent:event]) {
           self.userInteractionEnabled = NO;
      return switcherView;
    }else{
        self.userInteractionEnabled = YES;
     return hitTestResult;
    }
}



%end




#pragma mark - helper methods

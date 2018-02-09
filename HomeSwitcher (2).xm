#import "HomeSwitcher.h"

HSCollectionView *switcherView;
HSHomeView *homeView;
UIView *topViewSB;
%hook SpringBoard
-(void)frontDisplayDidChange:(id)newDisplay {
    [switcherView reloadSwitcher];


  %orig;
}
%end

%hook SpringBoard
-(void) applicationDidFinishLaunching:(id) application {
%orig;

topViewSB = [[%c(SBIconController) sharedInstance] _rootFolderController].contentView;




for(UIView *v in topViewSB.subviews){
			     if([v isKindOfClass:[UIView class]] && !v.hidden){
			     	topViewSB = v;

			     }
			}
for(UIScrollView *z in topViewSB.subviews){
			     if([z isKindOfClass:[UIScrollView class]] && !z.hidden){
			     	topViewSB = z;

			     }
			}

for(UIView *x in topViewSB.subviews){
			     if(x.frame.origin.x ==[[UIScreen mainScreen] bounds].size.width && x.frame.origin.y ==0 && !x.hidden){
			     	topViewSB = x;

			     }
			}

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
    [topViewSB
 addSubview:homeView];
   [homeView addSubview:switcherView];
switcherView.backgroundView =blurView; 
				[topViewSB bringSubviewToFront:homeView];

}
%end


#pragma mark - helper methods

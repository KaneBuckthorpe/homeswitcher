#import "HomeSwitcher.h"

HSCollectionView *switcherView;
HSHomeView *homeView;
UIView *topViewSB;
CGPoint switcherCenter;
CGPoint lastPoint;
CGPoint panPoint;
NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];


%hook SpringBoard
-(void) applicationDidFinishLaunching:(id) application {
%orig;

switcherCenter = CGPointFromString([userDefaults objectForKey:@"switcherViewPosition"]);
topViewSB = [[%c(SBIconController) sharedInstance] _rootFolderController].contentView;

for(UIView *a in topViewSB.subviews){
			     if([a isKindOfClass:[UIView class]] && !a.hidden){
			     	topViewSB = a;
			     }
			}
for(UIScrollView *b in topViewSB.subviews){
			     if([b isKindOfClass:[UIScrollView class]] && !b.hidden){
			     	topViewSB = b;
			     }
			}
			


homeView = [[HSHomeView alloc] init];
    switcherView = [[HSCollectionView alloc] init];

UIView*rightArrow = [[UIView alloc] initWithFrame:CGRectMake(switcherView.frame.size.width-20, 0 ,20, switcherView.frame.size.height)];
[rightArrow setUserInteractionEnabled:YES];
rightArrow.backgroundColor=[UIColor clearColor];
rightArrow.alpha =1;


UIView*leftArrow = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, switcherView.frame.size.height)];
[leftArrow setUserInteractionEnabled:YES];
leftArrow.backgroundColor=[UIColor clearColor];
leftArrow.alpha=1;

UIView*centerButton = [[UIView alloc] initWithFrame:CGRectMake(switcherView.frame.size.width/2-100, switcherView.frame.size.height-15 ,200, 15)];
[centerButton setUserInteractionEnabled:YES];
centerButton.backgroundColor=[UIColor clearColor];
centerButton.alpha =1;

UITapGestureRecognizer *scrollToStartCenter = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollToCenter:)];
scrollToStartCenter.numberOfTouchesRequired = 1;
[centerButton addGestureRecognizer:scrollToStartCenter];


UITapGestureRecognizer *scrollToStartTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollToStart:)];
scrollToStartTap.numberOfTouchesRequired = 1;
[leftArrow addGestureRecognizer:scrollToStartTap];

UITapGestureRecognizer *scrollToEndTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollToEnd:)];
scrollToEndTap.numberOfTouchesRequired = 1;
[rightArrow addGestureRecognizer:scrollToEndTap];

UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveSwitcher:)];
[pan setMinimumNumberOfTouches:2];
[pan setMaximumNumberOfTouches:2];
[switcherView addGestureRecognizer:pan];
  
if (!CGPointEqualToPoint(switcherCenter, CGPointZero)) {
switcherView.center=switcherCenter;
} else {
switcherCenter = switcherView.center;
}

    [topViewSB
 addSubview:homeView];
   [homeView addSubview:switcherView];
[switcherView.backgroundView addSubview:rightArrow];
[switcherView.backgroundView addSubview:centerButton];
[switcherView.backgroundView addSubview:leftArrow];
///switcherView.backgroundView =blurView; 
[switcherView reloadSwitcher];
}

-(void)frontDisplayDidChange:(id)newDisplay {
%orig(newDisplay);
if (newDisplay==nil){
switcherView.switcherItems = [[%c(SBAppSwitcherModel) sharedInstance] mainSwitcherDisplayItems];

[switcherView reloadAndScroll];
}
}
%new
-(void) scrollToCenter:(UITapGestureRecognizer *) gesture {

[switcherView scrollToStartAnimated];
 
}
%new
-(void) scrollToEnd:(UITapGestureRecognizer *) gesture {

 [UIView animateWithDuration:0.5 delay:0 options: UIViewAnimationOptionCurveEaseInOut  animations:^{ 
               [switcherView setContentOffset:CGPointMake(switcherView.contentSize.width-[[UIScreen mainScreen] bounds].size.width, 0) animated:NO];
 
}
                     completion:^(BOOL finished) {
 [UIView animateWithDuration:0.5 delay:0 options: UIViewAnimationOptionCurveEaseInOut  animations:^{ 
[switcherView updateCellsLayout];
}completion:nil];
                  
}];
}
%new
-(void) scrollToStart:(UITapGestureRecognizer *) gesture {
 [UIView animateWithDuration:0.5 delay:0 options: UIViewAnimationOptionCurveEaseInOut  animations:^{ 

             [switcherView setContentOffset:CGPointMake(0, 0) animated:NO];
}
                     completion:^(BOOL finished) {
 [UIView animateWithDuration:0.5 delay:0 options: UIViewAnimationOptionCurveEaseInOut  animations:^{ 
[switcherView updateCellsLayout];
}completion:nil];
                  
}];
}
%new
-(void)moveSwitcher:(UIPanGestureRecognizer *)pan {
panPoint = [pan locationInView:switcherView];
switcherCenter = switcherView.center;


if (CGPointEqualToPoint(lastPoint, CGPointZero)) {
lastPoint = panPoint;
}


switcherCenter.y += panPoint.y - lastPoint.y;

if (switcherCenter.y >= 64 && switcherCenter.y <= UIScreen.mainScreen.bounds.size.height - 64) {

switcherView.frame = switcherView.bounds;
switcherView.center = switcherCenter;
[userDefaults setObject:NSStringFromCGPoint(switcherCenter) forKey:@"switcherViewPosition"];
    
}
if (pan.state == UIGestureRecognizerStateEnded) {
lastPoint = CGPointZero;
[userDefaults synchronize];
}
}
%end


%hook SBRootIconListView
-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    for (UIView *view in self.subviews) {
        if (!view.hidden && view.userInteractionEnabled && [view pointInside:[self convertPoint:point toView:view] withEvent:event])
            return YES;
    }
    return NO;
}
%end


#pragma mark - helper methods

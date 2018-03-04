#import "HomeSwitcher.h"

HSCollectionView *switcherView;
HSHomeView *homeView;
UIView *topViewSB;
UIView*rightArrow;
UIView*leftArrow;
UIView*centerButton;
CGPoint switcherCenter;
CGPoint lastPoint;
CGPoint panPoint;
CGPoint leftButtonCenter;
CGPoint rightButtonCenter;
CGPoint centerButtonCenter;


static NSUserDefaults *preferences;
static bool enabled;


%hook SpringBoard
-(void) applicationDidFinishLaunching:(id) application {
%orig;
int regToken;
notify_register_dispatch("com.kaneb.HomeSwitcher/prefsChanged", &regToken, dispatch_get_main_queue(), ^(int token) {
[self loadPrefs];
NSLog(@"boolchanged" );
        });
[self loadPrefs];

	if(enabled) {



notify_register_dispatch("com.kaneb.HomeSwitcher/CprefsChanged", &regToken, dispatch_get_main_queue(), ^(int token) {
[self updateSwitcherForPrefs];

        });

}
}
%new
-(void)loadPrefs{
preferences = [[NSUserDefaults alloc] initWithSuiteName:@"com.kaneb.HomeSwitcher"];
	[preferences registerDefaults:@{
		@"enabled": @YES,
	}];
	enabled 				= [preferences boolForKey:@"enabled"];

if(enabled&& !homeView){

homeView = [[HSHomeView alloc] init];
homeView.clipsToBounds=YES;
    [self updateSwitcherForPrefs];

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
			


    [topViewSB
 addSubview:homeView];
}else{
[homeView removeFromSuperview];
homeView = NULL;
}
}

%new
-(void)updateSwitcherForPrefs{
[switcherView removeFromSuperview];
switcherView = NULL;
switcherView = [[HSCollectionView alloc] init];
switcherCenter = CGPointFromString([preferences objectForKey:@"switcherViewPosition"]);

if (!CGPointEqualToPoint(switcherCenter, CGPointZero)) {
switcherView.center=switcherCenter;
} else {
switcherCenter = switcherView.center;
}


rightArrow = [[UIView alloc] initWithFrame:CGRectMake(switcherView.frame.size.width-20, switcherView.frame.origin.y ,20, switcherView.frame.size.height)];
[rightArrow setUserInteractionEnabled:YES];
rightArrow.backgroundColor=[UIColor clearColor];
rightArrow.alpha =1;

leftArrow = [[UIView alloc] initWithFrame:CGRectMake(0, switcherView.frame.origin.y, 20, switcherView.frame.size.height)];
[leftArrow setUserInteractionEnabled:YES];
leftArrow.backgroundColor=[UIColor clearColor];
leftArrow.alpha=1;

centerButton = [[UIView alloc] initWithFrame:CGRectMake(switcherView.frame.size.width/2-100, switcherView.frame.origin.y +switcherView.frame.size.height-15 ,200, 15)];
[centerButton setUserInteractionEnabled:YES];
centerButton.backgroundColor=[UIColor clearColor];
centerButton.alpha =1;

UITapGestureRecognizer *scrollToCenterTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollToCenter:)];
scrollToCenterTap.numberOfTouchesRequired = 1;
[centerButton addGestureRecognizer:scrollToCenterTap];

UITapGestureRecognizer *scrollToStartTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollToStart:)];
scrollToStartTap.numberOfTouchesRequired = 1;
[leftArrow addGestureRecognizer:scrollToStartTap];

UITapGestureRecognizer *scrollToEndTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollToEnd:)];
scrollToEndTap.numberOfTouchesRequired = 1;
[rightArrow addGestureRecognizer:scrollToEndTap];

UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveSwitcher:)];
[pan setMinimumNumberOfTouches:1];
[pan setMaximumNumberOfTouches:1];
[centerButton addGestureRecognizer:pan];
  
   [homeView addSubview:switcherView];
[homeView addSubview:rightArrow];
[homeView addSubview:centerButton];
[homeView addSubview:leftArrow];
///[switcherView reloadSwitcher];
}
-(void)frontDisplayDidChange:(id)newDisplay {
%orig(newDisplay);
if (newDisplay==nil && ![[%c(SBUIController) sharedInstance] isAppSwitcherShowing]){
[switcherView reloadAndScroll];
}
}
/*
%new
 - (NSDictionary)handleMessageNamed:(NSString *)name withUserInfo:(NSDictionary *)userinfo {

SBIconController *iconController = [%c(SBIconController) sharedInstance];
SBRootFolderController *rootFolderController = [iconController valueForKey:@"_rootFolderController"];
int maxPages = [rootFolderController iconListViewCount];

return maxPages;
}
*/
%new
-(void) scrollToCenter:(UITapGestureRecognizer *) gesture {

[switcherView scrollToCenterAnimated];
 
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
leftButtonCenter=leftArrow.center;
rightButtonCenter=rightArrow.center;
centerButtonCenter=centerButton.center;

if (CGPointEqualToPoint(lastPoint, CGPointZero)) {
lastPoint = panPoint;
}

leftButtonCenter.y+=panPoint.y - lastPoint.y;
rightButtonCenter.y+=panPoint.y - lastPoint.y;
centerButtonCenter.y+=panPoint.y - lastPoint.y;
switcherCenter.y += panPoint.y - lastPoint.y;

if (switcherCenter.y >= 64 && switcherCenter.y <= UIScreen.mainScreen.bounds.size.height - 64) {

switcherView.frame = switcherView.bounds;
switcherView.center = switcherCenter;
leftArrow.frame= leftArrow.bounds;
leftArrow.center=leftButtonCenter;
rightArrow.frame= rightArrow.bounds;
rightArrow.center=rightButtonCenter;
centerButton.frame= centerButton.bounds;
centerButton.center=centerButtonCenter;

[preferences setObject:NSStringFromCGPoint(switcherCenter) forKey:@"switcherViewPosition"];
    
}
if (pan.state == UIGestureRecognizerStateEnded) {
lastPoint = CGPointZero;
[preferences synchronize];
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

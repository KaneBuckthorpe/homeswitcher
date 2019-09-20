#import "HomeSwitcher.h"
HSSetup*homeSwitcher;
int iOSVersion;

@interface SBLockScreenManager :NSObject
+(id)sharedInstance;
-(BOOL)isLockScreenVisible;
@end

%hook SBIconController
-(void)_performInitialLayoutWithOrientation:(long long)arg1{
%orig;

if (kCFCoreFoundationVersionNumber>=1443.00){
iOSVersion=11;
} else{
iOSVersion=10;
}
if (!homeSwitcher&&iOSVersion==11){
homeSwitcher = [[HSSetup alloc] initWithPrefs];
}
}
%end

%hook SpringBoard
-(void) applicationDidFinishLaunching:(id) application {
%orig;

if(kCFCoreFoundationVersionNumber>=1443.00){
iOSVersion=11;
} else{
iOSVersion=10;
}
if (!homeSwitcher&&iOSVersion==10){
homeSwitcher = [[HSSetup alloc] initWithPrefs];
}

}
-(void)frontDisplayDidChange:(id)newDisplay {
%orig(newDisplay);
NSLog(@"layouHS3");
if(newDisplay==nil && ![[%c(SBUIController) sharedInstance] isAppSwitcherShowing] && homeSwitcher.alwaysOnHomescreen && ![[%c(SBLockScreenManager) sharedInstance] isLockScreenVisible]){
[homeSwitcher hideSwitcher];

}else if([homeSwitcher.homeView isDescendantOfView:homeSwitcher.topViewSB] || [homeSwitcher.homeView isDescendantOfView:homeSwitcher.switcherWindow]){


[homeSwitcher.homeView.superview bringSubviewToFront:homeSwitcher.homeView];

[homeSwitcher.switcherView reloadSwitcher];

} 
}
%end
 

@implementation HSActivator
- (void)activator:(LAActivator *)activator receiveEvent:(LAEvent *)event forListenerName:(NSString *)listenerName{
		
if (homeSwitcher.activatorGesturesEnabled){
if ([listenerName isEqualToString:@"com.indiedevkb.hideSwitcher"]){

[homeSwitcher hideSwitcher];

} else if ([listenerName isEqualToString:@"com.indiedevkb.showSwitcher"]){
[homeSwitcher showSwitcher];

} else if ([listenerName isEqualToString:@"com.indiedevkb.toggleSwitcher"]){
[homeSwitcher showOrHideSwitcher];
}
}
[event setHandled:YES];
}
+(void)load {
LAActivator *activator= [%c(LAActivator) sharedInstance]; 

	[activator registerListener:[self new] forName:@"com.indiedevkb.showSwitcher"];

	[activator registerListener:[self new] forName:@"com.indiedevkb.hideSwitcher"];

	[activator registerListener:[self new] forName:@"com.indiedevkb.toggleSwitcher"];
}

- (NSArray *)exclusiveAssignmentGroupsForListenerName:(NSString *)listenerName{
	NSArray *groups = @[@"HomeSwitcher"];
	return groups;
}
@end

%hook SBUIController
-(void)_deviceUILocked{
%orig;
[homeSwitcher hideSwitcher];
}
%end

#import <SpringBoard/SBRootFolderView.h>
#import <notify.h>
@interface SBRecentAppLayouts: NSObject
+ (id)sharedInstance;
-(id)_recentsFromPrefs;
-(void)remove:(id)arg1 ;
@end

@interface SBUIController : NSObject
+(id)sharedInstance;
-(void)clickedMenuButton;
-(void)activateApplication:(id)arg1 ;
-(BOOL)isAppSwitcherShowing;
@end

@interface SBApplicationController : NSObject
+(id)sharedInstance;
-(id)applicationWithBundleIdentifier:(id)arg1;
+(id)sharedInstanceIfExists;
@end

@interface SBApplication : NSObject
- (int)pid;
@end

@interface UIApplication (HomeSwitcher)
+(id)sharedApplication;
-(BOOL)launchApplicationWithIdentifier:(id)arg1 suspended:(BOOL)arg2;
@end

@interface SBDisplayItem : NSObject <NSCopying>
@property (nonatomic, copy, readonly) NSString *displayIdentifier;
@end

@interface SBAppLayout:NSObject<NSCopying>
-(id)allItems;
@end

@interface SBAppSwitcherModel :NSObject{
	NSMutableArray* _recentDisplayItems;
}

+ (id)sharedInstance;
-(id)_recentsFromPrefs;
-(void)remove:(id)arg1 ;
@end

@interface SBFolderController : UIView
@property (nonatomic,retain,readonly) SBFolderView* contentView;
-(unsigned long long)iconListViewCount;
@end

@interface SBRootFolderController:SBFolderController
@end

@interface SBIconController : NSObject
+(id)sharedInstance;
- (id)contentView;
-(SBFolderController*)_rootFolderController;
@end

@interface UIImage (IndieDev)
+ (UIImage *)_applicationIconImageForBundleIdentifier:( NSString *)bundleIdentifier format:(int)format scale:(CGFloat)scale;
@end

@interface LSApplicationProxy

@property (nonatomic, readonly) NSURL *dataContainerURL;
@property (nonatomic, copy, readonly) NSString *localizedName;

+ (instancetype)applicationProxyForIdentifier:(NSString *)identifier;

@end

@interface LSApplicationWorkspace : NSObject
 +(id)defaultWorkspace;
- (BOOL)openApplicationWithBundleID:(NSString *)bundleID;
@end

@interface CPDistributedMessagingCenter : NSObject
+(CPDistributedMessagingCenter*)centerNamed:(NSString*)serverName;
-(void)registerForMessageName:(NSString*)messageName target:(id)target selector:(SEL)selector;
-(NSDictionary*)sendMessageAndReceiveReplyName:(NSString*)name userInfo:(NSDictionary*)info;
-(void)runServerOnCurrentThread;
@end

@interface SpringBoard:NSObject
-(void)loadPrefs;
-(void)updateSwitcherForPrefs;
@end

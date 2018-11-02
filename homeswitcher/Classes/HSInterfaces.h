#import "WPSAlertController.h"
#import <Foundation/Foundation.h>
#import <SpringBoard/SBApplicationController.h>
#import <SpringBoard/SBFolderController.h>
#import <SpringBoard/SBFolderView.h>
#import <SpringBoard/SBIconController.h>
#import <UIKit/UIKit.h>
#import <notify.h>
#import <objc/runtime.h>

@interface LSApplicationProxy
    @property(nonatomic, readonly) NSURL *dataContainerURL;
    @property(nonatomic, copy, readonly) NSString *localizedName;
    
+ (instancetype)applicationProxyForIdentifier:(NSString *)identifier;
    @end

@interface LSApplicationWorkspace : NSObject
+ (id)defaultWorkspace;
- (BOOL)openApplicationWithBundleID:(NSString *)bundleID;
    @end

@interface SpringBoard : UIApplication
- (id)_accessibilityTopDisplay;
- (BOOL)isShowingHomescreen;
    
    @end

@interface UIApplication (HS)
+ (id)sharedApplication;
- (BOOL)launchApplicationWithIdentifier:(id)arg1 suspended:(BOOL)arg2;
    @end

@interface SBRootFolderController : SBFolderController
    @end

@interface SBRecentAppLayouts : NSObject
+ (id)sharedInstance;
- (id)_recentsFromPrefs;
- (void)remove:(id)arg1;
    @end

@interface SBDisplayItem : NSObject <NSCopying>
    @property(nonatomic, copy, readonly) NSString *displayIdentifier;
    @end

@interface SBUIController : NSObject
+ (id)sharedInstance;
- (void)clickedMenuButton;
- (void)activateApplication:(id)arg1;
- (BOOL)isAppSwitcherShowing;
    @end

@interface SBFluidSwitcherViewController : UIViewController
- (void)killAppLayoutOfContainer:(id)arg1
                    withVelocity:(double)arg2
                       forReason:(long long)arg3;
    @property NSArray *appLayouts;
    @end

@interface SBAppSwitcherModel : SBFluidSwitcherViewController
+ (id)sharedInstance;
- (id)_recentsFromPrefs;
- (void)remove:(id)arg1;
    @end

@interface SBAppLayout : NSObject <NSCopying>
- (id)allItems;
- (id)initWithItemsForLayoutRoles:(id)arg1 configuration:(long long)arg2;
    @end

@interface UIImage (IndieDev)
+ (UIImage *)_applicationIconImageForBundleIdentifier:
(NSString *)bundleIdentifier
                                               format:(int)format
                                                scale:(CGFloat)scale;
    @end

@interface SBApplicationProcessState : NSObject
    @property(nonatomic, readonly) int pid;
- (int)pid;
    @end

@interface SBApplication : NSObject
    @property(nonatomic, readonly) SBApplicationProcessState *processState;
- (int)pid;
- (id)bundleIdentifier;
    @end

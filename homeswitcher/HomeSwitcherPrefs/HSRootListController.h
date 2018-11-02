#import <Preferences/PSListController.h>
#import <Preferences/PSSpecifier.h>
#import <Preferences/PSTableCell.h>
#import <objc/runtime.h>
#import <spawn.h>

@interface HSRootListController : PSListController
    @end

@interface HSInstructionsController : PSListController
    @end

@interface UIImage (IndieDev)
+ (UIImage *)_applicationIconImageForBundleIdentifier:
(NSString *)bundleIdentifier
                                               format:(int)format
                                                scale:(CGFloat)scale;
    @end

@interface KBAppList
    : PSViewController <UITableViewDataSource, UITableViewDelegate>
    @property(nonatomic, strong) UITableView *tableView;
    @property(nonatomic, strong) NSArray *installedApps;
    @property(nonatomic, strong) NSMutableArray *selectedApps;
    @property(nonatomic, strong) NSArray *installedAppsBundleID;
    @property(nonatomic, assign) BOOL allSelected;
    @end

@interface LSBundleProxy : NSObject
    @property(nonatomic, readonly) NSString *bundleIdentifier;
- (id)localizedName;
    @end

@interface LSApplicationProxy : LSBundleProxy
    @property(nonatomic, readonly) NSURL *dataContainerURL;
    @property(nonatomic, copy, readonly) NSString *localizedName;
    
+ (instancetype)applicationProxyForIdentifier:(NSString *)identifier;
    @end

@interface LSApplicationWorkspace : NSObject
+ (id)defaultWorkspace;
- (BOOL)openApplicationWithBundleID:(NSString *)bundleID;
- (id)allInstalledApplications;
    @end

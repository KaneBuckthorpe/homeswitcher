#import <KBPreferences/KBPreferences.h>
#import <Preferences/PSTableCell.h>
#import <spawn.h>
#import <objc/runtime.h>
#import <Preferences/PSSpecifier.h>


@interface HSRootListController : KBPListController
@end

@interface HSInstructionsController : KBPListController
@end


@interface UIImage (IndieDev)
+ (UIImage *)_applicationIconImageForBundleIdentifier:( NSString *)bundleIdentifier format:(int)format scale:(CGFloat)scale;
@end

@interface LSBundleProxy :NSObject
@property (nonatomic,readonly) NSString* bundleIdentifier; 
-(id)localizedName;
@end

@interface LSApplicationProxy :LSBundleProxy
@property (nonatomic, readonly) NSURL *dataContainerURL;
@property (nonatomic, copy, readonly) NSString *localizedName;

+ (instancetype)applicationProxyForIdentifier:(NSString *)identifier;
@end

@interface LSApplicationWorkspace : NSObject
 +(id)defaultWorkspace;
- (BOOL)openApplicationWithBundleID:(NSString *)bundleID;
-(id)allInstalledApplications;
@end

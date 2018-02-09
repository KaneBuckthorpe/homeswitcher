@interface _UIBackdropView : UIView
- (id)initWithFrame:(CGRect)arg1 autosizesToFitSuperview:(BOOL)arg2 settings:(id)arg3;
- (id)initWithPrivateStyle:(int)arg1;
- (id)initWithSettings:(id)arg1;
- (id)initWithStyle:(int)arg1;
+ (id)allBackdropViews;

- (void)setBlurFilterWithRadius:(float)arg1 blurQuality:(id)arg2 blurHardEdges:(int)arg3;
- (void)setBlurFilterWithRadius:(float)arg1 blurQuality:(id)arg2;
- (void)setBlurHardEdges:(int)arg1;
- (void)setBlurQuality:(id)arg1;
- (void)setBlurRadius:(float)arg1;
- (void)setBlurRadiusSetOnce:(BOOL)arg1;
- (void)setBlursBackground:(BOOL)arg1;
- (void)setBlursWithHardEdges:(BOOL)arg1;
- (void)setStyle:(int)arg1;
@end

@interface _UIBackdropViewSettings : NSObject
+(id) settingsForStyle:(int)arg1;
@end
@interface SBApplicationController : NSObject
+(id)sharedInstance;
-(id)applicationWithBundleIdentifier:(id)arg1;
+(id)sharedInstanceIfExists;
@end

@interface SBUIController: NSObject
+(id)sharedInstanceIfExists;
-(void)activateApplication:(id)arg1 ;
@end

@interface SBApplication
-(int)pid;
@end

@interface UIApplication (HomeSwitcher)
+(id)sharedApplication;
-(BOOL)launchApplicationWithIdentifier:(id)arg1 suspended:(BOOL)arg2;
@end

@interface SBDisplayItem : NSObject <NSCopying>
@property (nonatomic, copy, readonly) NSString *displayIdentifier;
@end

@interface SBAppSwitcherModel :NSObject{
	NSMutableArray* _recentDisplayItems;
}

+ (id)sharedInstance;
-(id)mainSwitcherDisplayItems;
-(void)remove:(id)arg1 ;
@end

@interface MYView :UIView<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    UICollectionView *_collectionView;
    NSArray<SBDisplayItem *> *switcherApps;
}
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

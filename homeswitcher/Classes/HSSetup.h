#import "HSWindow.h"
#import "HSCollectionView.h"
#import "HSHomeView.h"
#import "HSInterfaces.h"

@interface HSSetup :NSObject<UIGestureRecognizerDelegate>
    @property (nonatomic, retain) HSWindow*switcherWindow;
    @property (nonatomic, retain) HSCollectionView *switcherView;
    @property (nonatomic, retain) HSHomeView *homeView;
    @property (nonatomic, retain) UIView *topViewSB;
    @property (nonatomic, assign) BOOL alwaysOnHomescreen;
    @property (nonatomic, assign) BOOL isInWindow;
    @property (nonatomic, assign) BOOL activatorGesturesEnabled;
    @property (nonatomic, assign) CGRect homeFrame;
    @property (nonatomic, assign) float gestureViewThickness;
    @property (nonatomic, assign) int pageSliderNumber;
    @property (nonatomic, assign) int homeViewOriginY;
    
-(void)initWithPrefs;
-(void)showSwitcher;
-(void)hideSwitcher;
-(void)showOrHideSwitcher;
    @end

@interface SBIconScrollView :UIView
    @end

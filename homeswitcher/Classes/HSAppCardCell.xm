#import "HSAppCardCell.h"

int iOS;
static NSUserDefaults *preferences;

@implementation HSAppCardCell
    UIWindow *contentWindow;
    BOOL verticalMode;
    
- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        if (kCFCoreFoundationVersionNumber >= 1443.00) {
            iOS = 11;
        } else {
            iOS = 10;
        }
        
        [self loadPrefs];
        
        deletingApp = NO;
        openingApp = NO;
        self.clipsToBounds = NO;
        CGSize cellViewSize = self.frame.size;
        
        self.appImageView = [[UIImageView alloc]
                             initWithFrame:CGRectMake(0, 0, cellViewSize.width,
                                                      cellViewSize.width)];
        self.appImageView.backgroundColor = UIColor.whiteColor;
        self.appImageView.layer.cornerRadius = 10;
        self.appImageView.clipsToBounds = YES;
        CGSize appImageSize = self.appImageView.frame.size;
        self.appImageView.layer.shadowColor = [UIColor clearColor].CGColor;
        [self.appImageView.layer setShadowOpacity:0.5];
        self.appImageView.layer.shadowRadius = 3;
        
        UIVisualEffect *blurEffect;
        blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        
        self.blurView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        self.blurView.frame = self.appImageView.bounds;
        self.blurView.layer.cornerRadius = 10;
        self.blurView.clipsToBounds = YES;
        
        self.overlay = [[UIView alloc] initWithFrame:self.appImageView.bounds];
        self.overlay.backgroundColor = [UIColor colorWithRed:1
                                                       green:0
                                                        blue:0
                                                       alpha:0];
        
        self.iconImageView = [[UIImageView alloc]
                              initWithFrame:CGRectMake(
                                                       appImageSize.width / 2 - (appImageSize.width / 8),
                                                       appImageSize.height - (appImageSize.width / 8),
                                                       appImageSize.width / 4, appImageSize.width / 4)];
        
        self.iconImageView.backgroundColor = UIColor.clearColor;
        self.iconImageView.layer.cornerRadius = 1.5;
        self.iconImageView.clipsToBounds = NO;
        [self.iconImageView.layer setShadowOpacity:1];
        self.iconImageView.layer.cornerRadius = 5;
        [self.iconImageView.layer setShadowOffset:CGSizeMake(0, 0)];
        /*
         
         CGFloat labelTop =
         appImageSize.height+(self.iconImageView.frame.size.height/2);
         
         
         self.appNameLabel = [[UILabel alloc]
         initWithFrame:CGRectMake(0,labelTop,
         cellViewSize.width,cellViewSize.height -labelTop)];
         
         self.appNameLabel.numberOfLines = 1;
         self.appNameLabel.adjustsFontSizeToFitWidth = YES;
         self.appNameLabel.textAlignment = NSTextAlignmentCenter;
         self.appNameLabel.textColor = UIColor.whiteColor;
         
         */
        
        UIScrollView *scrollView =
        [[UIScrollView alloc] initWithFrame:self.bounds];
        
        self.zoomView = [[UIView alloc] initWithFrame:scrollView.bounds];
        /// self.zoomView.layer.shadowColor=[UIColor whiteColor].CGColor;
        [self.zoomView.layer setShadowOpacity:1];
        self.zoomView.layer.shadowRadius = 8;
        self.zoomView.layer.shadowOffset = CGSizeMake(0, 0);
        
        scrollView.backgroundColor = [UIColor clearColor];
        if (verticalMode) {
            [scrollView
             setContentSize:CGSizeMake(scrollView.bounds.size.width * 2,
                                       self.bounds.size.height)];
        } else {
            [scrollView
             setContentSize:CGSizeMake(self.bounds.size.width,
                                       scrollView.bounds.size.height * 2.0)];
        }
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.pagingEnabled = YES;
        scrollView.decelerationRate = UIScrollViewDecelerationRateNormal;
        scrollView.clipsToBounds = NO;
        scrollView.delegate = self;
        
        [self addSubview:scrollView];
        [scrollView addSubview:self.zoomView];
        [self.zoomView addSubview:self.appImageView];
        [self.zoomView addSubview:self.blurView];
        [self.zoomView addSubview:self.iconImageView];
        [self.appImageView addSubview:self.overlay];
        /*
         [self.zoomView addSubview:self.appNameLabel];
         */
    }
    return self;
}
- (void)loadPrefs {
    
    preferences =
    [[NSUserDefaults alloc] initWithSuiteName:@"com.kaneb.HomeSwitcher"];
    
    [preferences registerDefaults:@{
                                    @"verticalMode" : @NO,
                                    }];
    
    verticalMode = [preferences boolForKey:@"verticalMode"];
}
    
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (deletingApp) {
        [self closeApp];
        deletingApp = NO;
    } else if (openingApp) {
        [self openApp];
        openingApp = NO;
    }
    [UIView animateWithDuration:0.3
                     animations:^{
                         [scrollView setContentOffset:CGPointMake(0, 0)
                                             animated:NO];
                     }
                     completion:^(BOOL finished){
                     }];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    float percent;
    
    if (verticalMode) {
        percent = (scrollView.contentOffset.x / 100.0);
        
        if (scrollView.contentOffset.x >= 0 &&
            scrollView.contentOffset.x <= self.bounds.size.width * 0.3) {
            
            self.alpha = 1 - percent;
            
            self.zoomView.transform = CGAffineTransformScale(
                                                             CGAffineTransformIdentity, 1 - percent, 1 - percent);
            deletingApp = NO;
            
        } else if (scrollView.contentOffset.x > self.bounds.size.width * 0.3) {
            self.alpha = 1 - percent * 2;
            deletingApp = YES;
            openingApp = NO;
            
        } else if (scrollView.contentOffset.x < 0 &&
                   scrollView.contentOffset.x > -35) {
            self.zoomView.transform = CGAffineTransformScale(
                                                             CGAffineTransformIdentity, 1 + percent / 2, 1 + percent / 2);
            self.alpha = 1;
            
        } else if (scrollView.contentOffset.x < -35) {
            self.alpha = 1;
            deletingApp = NO;
            openingApp = YES;
        }
        
    } else {
        percent = (scrollView.contentOffset.y / 100.0);
        if (scrollView.contentOffset.y >= 0 &&
            scrollView.contentOffset.y <= self.bounds.size.height * 0.2) {
            
            self.alpha = 1 - percent;
            
            self.zoomView.transform = CGAffineTransformScale(
                                                             CGAffineTransformIdentity, 1 - percent, 1 - percent);
            deletingApp = NO;
            
        } else if (scrollView.contentOffset.y > self.bounds.size.height * 0.2) {
            self.alpha = 1 - percent * 2;
            deletingApp = YES;
            openingApp = NO;
            
        } else if (scrollView.contentOffset.y < 0 &&
                   scrollView.contentOffset.y > -35) {
            self.zoomView.transform = CGAffineTransformScale(
                                                             CGAffineTransformIdentity, 1 + percent / 2, 1 + percent / 2);
            self.alpha = 1;
            
        } else if (scrollView.contentOffset.y < -35) {
            self.alpha = 1;
            deletingApp = NO;
            openingApp = YES;
        }
    }
    
    self.overlay.backgroundColor = [UIColor colorWithRed:1
                                                   green:0
                                                    blue:0
                                                   alpha:1 - self.alpha];
}
    
- (void)openApp {
    dispatch_async(
                   dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
                       NSLog(@"opening app");
                       
                       [[% c(LSApplicationWorkspace) defaultWorkspace]
                        openApplicationWithBundleID:self.bundleID];
                   });
}
    
- (void)closeApp {
    NSLog(@"close App");
    
    SBApplication *application = [[NSClassFromString(@"SBApplicationController")
                                   sharedInstance] applicationWithBundleIdentifier:self.bundleID];
    
    SBAppSwitcherModel *appSwitcherModel =
    [NSClassFromString(@"SBAppSwitcherModel") sharedInstance];
    
    SBDisplayItem *appToClose;
    if (iOS == 11) {
        
        if (application.processState.pid > 0) {
            kill(application.processState.pid, SIGTERM);
        }
        
        NSMutableArray *holding = [NSMutableArray new];
        SBDisplayItem *appToClose;
        SBRecentAppLayouts *recentLayouts =
        [% c(SBRecentAppLayouts) sharedInstance];
        NSMutableArray *recentAppLayouts = [recentLayouts _recentsFromPrefs];
        
        for (SBAppLayout *appLayout in recentAppLayouts) {
            [holding addObjectsFromArray:appLayout.allItems];
            
            for (SBDisplayItem *displayItem in holding) {
                
                if ([[displayItem valueForKey:@"_displayIdentifier"]
                     isEqualToString:self.bundleID]) {
                    appToClose = displayItem;
                }
            }
            
            if ([appLayout.allItems containsObject:appToClose]) {
                [recentLayouts remove:appLayout];
            }
        }
        
    } else {
        // This closes the app
        if (application.pid > 0) {
            kill(application.pid, SIGTERM);
        }
        
        for (SBDisplayItem *displayItem in
             [appSwitcherModel valueForKey:@"_recentsFromPrefs"]) {
            if ([[displayItem valueForKey:@"_displayIdentifier"]
                 isEqualToString:self.bundleID]) {
                appToClose = displayItem;
            }
        }
        
        [appSwitcherModel remove:appToClose];
    }
    
    SBApplication *currentApp = [[objc_getClass("SpringBoard")
                                  sharedApplication] _accessibilityTopDisplay];
    
    NSString *currentAppID = [currentApp bundleIdentifier];
    
    if ([currentAppID isEqualToString:self.bundleID]) {
        
        [self fadeOut];
    }
    
    [self.superview performSelector:@selector(reloadSwitcher)
                         withObject:nil
                         afterDelay:0.0];
}
    
- (void)fadeOut {
    if (!contentWindow) {
        
        // works for all screen sizes
        
        contentWindow =
        [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, 2048, 2048)];
        
        contentWindow.backgroundColor = self.appImageView.backgroundColor;
        
        contentWindow.windowLevel = UIWindowLevelStatusBar;
        
        contentWindow.hidden = NO;
    }
    
    contentWindow.alpha = 1;
    [UIView beginAnimations:nil context:nil];
    
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDelegate:self];
    
    [UIView setAnimationDuration:2];
    
    contentWindow.alpha = 0;
    
    [UIView commitAnimations];
    
    [self performSelector:@selector(hide) withObject:nil afterDelay:1.5];
}
    
- (void)hide {
    
    contentWindow.hidden = YES;
    contentWindow = nil;
}
    
    @end

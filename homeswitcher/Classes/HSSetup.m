#import "HSSetup.h"

static NSUserDefaults *preferences;

@implementation HSSetup
    
    UIView*rightArrow;
    int endTag=3003;
    UIView*centerButton;
    int centerTag=2002;
    UIView*leftArrow;
    int startTag=1001;
    
    CGPoint switcherCenter;
    CGPoint lastPoint;
    CGPoint panPoint;
    CGPoint leftButtonCenter;
    CGPoint rightButtonCenter;
    CGPoint centerButtonCenter;
    
-(void)initWithPrefs{
    
    int regToken;
    notify_register_dispatch("com.kaneb.HomeSwitcher/HSLoadPrefs", &regToken, dispatch_get_main_queue(), ^(int token) {
        [self loadPrefs];
    });
    notify_register_dispatch("com.kaneb.HomeSwitcher/HSPrefChanged", &regToken, dispatch_get_main_queue(), ^(int token) {
        [self loadPrefs];
        [self loadHomeView];
        [self loadSwitcherView];
        [self loadGestureViews];
        [self.switcherView reloadSwitcher];
    });
    
    notify_register_dispatch("com.kaneb.HomeSwitcher/showOrHide", &regToken, dispatch_get_main_queue(), ^(int token) {
        [self showOrHideSwitcher];
    });
    
    
    [self loadPrefs];
    [self loadSwitcherWindow];
    [self loadHomeView];
    [self loadSwitcherView];
    [self loadGestureViews];
    [self.switcherView reloadAndScroll];
}
    
    // load the current Prefs
-(void)loadPrefs{
    preferences = [[NSUserDefaults alloc] initWithSuiteName:@"com.kaneb.HomeSwitcher"];
    
    BOOL overlapStatusBar;
    
    [preferences registerDefaults:@{
                                    @"alwaysOnHomescreen": @YES,
                                    }];
    
    [preferences registerDefaults:@{
                                    @"activatorGesturesEnabled": @YES,
                                    }];
    [preferences registerDefaults:@{
                                    @"overlapStatusBar": @NO,
                                    }];
    [preferences registerDefaults:@{
                                    @"gestureViewThickness":	[NSNumber numberWithFloat:20],
                                    }];
    [preferences registerDefaults:@{
                                    @"pageSliderNumber":    [NSNumber numberWithInteger:1],
                                    }];
    
    
    self.alwaysOnHomescreen 				= [preferences boolForKey:@"alwaysOnHomescreen"];
    
    self.activatorGesturesEnabled 				= [preferences boolForKey:@"activatorGesturesEnabled"];
    
    overlapStatusBar 				= [preferences boolForKey:@"overlapStatusBar"];
    
    self.gestureViewThickness		= 100* ([preferences floatForKey:@"gestureViewThickness"]/100);
    
    self.pageSliderNumber= [preferences integerForKey:@"pageSliderNumber"];
    
    if(overlapStatusBar){
        self.homeViewOriginY =-20;
    } else{
        self.homeViewOriginY =0;
    }
    
}
-(void)loadSwitcherWindow{
    if (!self.switcherWindow){
        self.switcherWindow = [[HSWindow alloc] initWithFrame:CGRectMake(0,0,UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height)];
        
        
        self.switcherWindow.windowLevel = 10;
        self.switcherWindow.clipsToBounds=YES;
        self.switcherWindow.backgroundColor=UIColor.clearColor;
        self.switcherWindow.opaque=NO;
        [self.switcherWindow.layer setCornerRadius:20.0f];
        [self.switcherWindow.layer setMasksToBounds:YES];
        
        
        [self.switcherWindow makeKeyAndVisible];
    }
}
-(void)loadHomeView{
    if (self.homeView){
        [self.homeView removeFromSuperview];
        self.homeView = NULL;
    }
    
    
    self.homeView= [[HSHomeView alloc] initWithFrame:CGRectMake(UIScreen.mainScreen.bounds.size.width*self.pageSliderNumber, self.homeViewOriginY, UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height*0.8)];
    self.homeView.clipsToBounds=YES;
    
    self.homeView.homeFrame =self.homeView.frame;
    
    self.homeView.windowFrame=self.switcherWindow.frame;
    
    
    self.topViewSB = [[objc_getClass("SBIconController") sharedInstance] _rootFolderController].contentView;
    
    
    for(UIView *a in self.topViewSB.subviews){
        if([a isKindOfClass:[UIView class]] && !a.hidden){
            self.topViewSB = a;
        }
    }
    
    for(UIScrollView *b in self.topViewSB.subviews){
        if([b isKindOfClass:[UIScrollView class]] && !b.hidden){
            self.topViewSB = b;
        }
    }
    
    if(self.alwaysOnHomescreen){
        [self.topViewSB
         addSubview:self.homeView];
    }
}
-(void)loadSwitcherView{
    if (self.switcherView){
        [self.switcherView removeFromSuperview];
        self.switcherView = NULL;
    }
    self.switcherView = [HSCollectionView new];
    
    switcherCenter = CGPointFromString([preferences objectForKey:@"switcherViewPosition"]);
    
    if (self.switcherView.verticalMode){
        switcherCenter.y=self.switcherView.frame.size.height/2;
        
        
    }else{
        
        switcherCenter.x=self.switcherView.frame.size.width/2;
        
    }
    
    if (!CGPointEqualToPoint(switcherCenter, CGPointZero)) {
        self.switcherView.center=switcherCenter;
    } else {
        switcherCenter = self.switcherView.center;
    }
    
    
    
    
    [self.homeView addSubview:self.switcherView];
    
}
    
    
-(void)loadGestureViews{
    if (rightArrow){
        [rightArrow removeFromSuperview];
        rightArrow = NULL;
    }
    if (leftArrow){
        [leftArrow removeFromSuperview];
        leftArrow = NULL;
    }
    if (centerButton){
        [centerButton removeFromSuperview];
        centerButton = NULL;
    }
    float switcherWidth= self.switcherView.frame.size.width;
    float switcherHeight= self.switcherView.frame.size.height;
    float switcherOriginY= self.switcherView.frame.origin.y;
    float switcherOriginX= self.switcherView.frame.origin.x;
    
    
    rightArrow = [[UIView alloc] initWithFrame:CGRectMake(switcherOriginX+switcherWidth-self.gestureViewThickness, switcherOriginY ,self.gestureViewThickness, switcherHeight)];
    
    leftArrow = [[UIView alloc] initWithFrame:CGRectMake(switcherOriginX, switcherOriginY, self.gestureViewThickness, switcherHeight)];
    
    centerButton = [[UIView alloc] initWithFrame:CGRectMake(switcherOriginX+self.gestureViewThickness, switcherOriginY +switcherHeight-self.gestureViewThickness ,switcherWidth-(self.gestureViewThickness*2), self.gestureViewThickness)];
    
    
    [rightArrow setUserInteractionEnabled:YES];
    rightArrow.backgroundColor=[UIColor clearColor];
    rightArrow.alpha =0.3;
    rightArrow.tag=endTag;
    rightArrow.layer.masksToBounds=YES;
    rightArrow.layer.cornerRadius=6;
    
    [leftArrow setUserInteractionEnabled:YES];
    leftArrow.backgroundColor=[UIColor clearColor];
    leftArrow.alpha=0.3;
    leftArrow.tag=startTag;
    leftArrow.layer.masksToBounds=YES;
    leftArrow.layer.cornerRadius=6;
    
    [centerButton setUserInteractionEnabled:YES];
    centerButton.backgroundColor=[UIColor clearColor];
    centerButton.alpha =0.3;
    centerButton.layer.masksToBounds=YES;
    centerButton.layer.cornerRadius=6;
    centerButton.tag=centerTag;
    
    UITapGestureRecognizer *scrollToCenterTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollToPosition:)];
    scrollToCenterTap.numberOfTouchesRequired = 1;
    scrollToCenterTap.delegate=self;
    [centerButton addGestureRecognizer:scrollToCenterTap];
    
    UITapGestureRecognizer *scrollToStartTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollToPosition:)];
    scrollToStartTap.numberOfTouchesRequired = 1;
    scrollToStartTap.delegate=self;
    [leftArrow addGestureRecognizer:scrollToStartTap];
    
    UITapGestureRecognizer *scrollToEndTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollToPosition:)];
    scrollToEndTap.numberOfTouchesRequired = 1;
    scrollToEndTap.delegate=self;
    [rightArrow addGestureRecognizer:scrollToEndTap];
    
    UIPanGestureRecognizer *leftPan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveSwitcher:)];
    [leftPan setMinimumNumberOfTouches:1];
    [leftPan setMaximumNumberOfTouches:1];
    leftPan.delegate=self;
    [leftArrow addGestureRecognizer:leftPan];
    
    UIPanGestureRecognizer *centerPan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveSwitcher:)];
    [centerPan setMinimumNumberOfTouches:1];
    [centerPan setMaximumNumberOfTouches:1];
    centerPan.delegate=self;
    [centerButton addGestureRecognizer:centerPan];
    
    UIPanGestureRecognizer *rightPan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveSwitcher:)];
    [rightPan setMinimumNumberOfTouches:1];
    [rightPan setMaximumNumberOfTouches:1];
    rightPan.delegate=self;
    [rightArrow addGestureRecognizer:rightPan];
    
    [self.homeView addSubview:rightArrow];
    [self.homeView addSubview:centerButton];
    [self.homeView addSubview:leftArrow];
}
    
    
    -(void)scrollToPosition: (UITapGestureRecognizer *) gesture{
        
        if (gesture.view.tag==startTag){
            [self.switcherView scrollToStartAnimated];
        } else if (gesture.view.tag==centerTag){
            [self.switcherView scrollToCenterAnimated];
        } else if (gesture.view.tag==endTag){
            [self.switcherView scrollToEndAnimated];
        }
        
    }
-(void)moveSwitcher:(UIPanGestureRecognizer *)pan {
    pan.view.backgroundColor=UIColor.whiteColor;
    panPoint = [pan locationInView:self.switcherView];
    
    switcherCenter = self.switcherView.center;
    leftButtonCenter=leftArrow.center;
    rightButtonCenter=rightArrow.center;
    centerButtonCenter=centerButton.center;
    
    if (CGPointEqualToPoint(lastPoint, CGPointZero)) {
        lastPoint = panPoint;
    }
    
    if (self.switcherView.verticalMode){
        switcherCenter.y =self.switcherView.frame.size.height/2;
        
        
        leftButtonCenter.x+=panPoint.x - lastPoint.x;
        rightButtonCenter.x+=panPoint.x - lastPoint.x;
        centerButtonCenter.x+=panPoint.x - lastPoint.x;
        switcherCenter.x += panPoint.x - lastPoint.x;
        
    } else{
        switcherCenter.x =self.switcherView.frame.size.width/2;
        
        
        leftButtonCenter.y+=panPoint.y - lastPoint.y;
        rightButtonCenter.y+=panPoint.y - lastPoint.y;
        centerButtonCenter.y+=panPoint.y - lastPoint.y;
        switcherCenter.y += panPoint.y - lastPoint.y;
    }
    if ((switcherCenter.y >= self.switcherView.frame.size.height/2 && switcherCenter.y <= self.homeView.frame.size.height-self.switcherView.frame.size.height/2 && !self.switcherView.verticalMode) ||(switcherCenter.x >= self.switcherView.frame.size.width/2 && switcherCenter.x <= self.homeView.frame.size.width-self.switcherView.frame.size.width/2 && self.switcherView.verticalMode) ) {
        
        self.switcherView.frame = self.switcherView.bounds;
        self.switcherView.center = switcherCenter;
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
        pan.view.backgroundColor=UIColor.clearColor;
    }
}
    
    
    ////// show, hide & show/hide methods
    
-(void)showSwitcher{
    [self.switcherWindow addSubview:self.homeView];
    self.isInWindow=YES;
    self.homeView.frame=self.switcherWindow.frame;
    [self.switcherView reloadAndScroll];
    
    
} 
    
-(void)hideSwitcher{
    self.isInWindow=NO;
    
    if (self.alwaysOnHomescreen){
        self.homeView.frame =self.homeView.homeFrame;
        [self.topViewSB addSubview:self.homeView];
        [self.switcherView reloadAndScroll];
    }  else{
        
        [self.homeView removeFromSuperview];
        
    }
}
-(void)showOrHideSwitcher{
    if (self.isInWindow){
        
        [self hideSwitcher];
        
    } else {
        
        [self showSwitcher];
        
    }
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    if ([otherGestureRecognizer isKindOfClass:[UISwipeGestureRecognizer class]]){
        return NO;
    } else{
        return YES;
        
    }
}
    - (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
        
        if (([[gestureRecognizer view] isDescendantOfView:self.homeView]) && ![[otherGestureRecognizer view] isDescendantOfView:[gestureRecognizer view]]) {
            return YES;
        }else{
            return NO;
        }
    }
    @end

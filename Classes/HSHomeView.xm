#import "HSHomeView.h"
static NSUserDefaults *preferences;
static NSInteger pageSliderNumber;
CGRect homeFrame;

@implementation HSHomeView
- (instancetype)init{
                        [self loadPrefs];
int regToken;
        notify_register_dispatch("com.kaneb.HomeSwitcher/HprefsChanged", &regToken, dispatch_get_main_queue(), ^(int token) {
            preferences = [[NSUserDefaults alloc] initWithSuiteName:@"com.kaneb.HomeSwitcher"];
            [preferences registerDefaults:@{
                                            @"pageSliderNumber":    [NSNumber numberWithInteger:1],
                                            }];
            pageSliderNumber = [preferences integerForKey:@"pageSliderNumber"];
            NSLog(@"prefs working" );
                        [self loadPrefs];
            [self updateUsingPrefs];
        });


homeFrame =CGRectMake([[UIScreen mainScreen] bounds].size.width*pageSliderNumber, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);


    if (self = [super initWithFrame:homeFrame]) {
        self.clipsToBounds = NO;
        self.backgroundColor = [UIColor clearColor];
        
        
    }
    
    return self;
}
-(void)loadPrefs{
      preferences = [[NSUserDefaults alloc] initWithSuiteName:@"com.kaneb.HomeSwitcher"];
            [preferences registerDefaults:@{
                                            @"pageSliderNumber":    [NSNumber numberWithInteger:1],
                                            }];
            pageSliderNumber = [preferences integerForKey:@"pageSliderNumber"];
            NSLog(@"prefs working" );
}
-(void) updateUsingPrefs{
homeFrame =CGRectMake([[UIScreen mainScreen] bounds].size.width*pageSliderNumber, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);

self.frame=homeFrame;
}
-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    for (UIView* subview in self.subviews ) {
        if ( [subview hitTest:[self convertPoint:point toView:subview] withEvent:event] != nil ) {
            return YES;
        }
    }
    return NO;
}
@end

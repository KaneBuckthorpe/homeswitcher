#import "HSHomeView.h"

@implementation HSHomeView
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self.clipsToBounds = YES;
    self.backgroundColor = UIColor.clearColor;
    [self.layer setCornerRadius:20.0f];
    [self.layer setMasksToBounds:YES];
    
    return self;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    for (UIView *subview in self.subviews) {
        if ([subview hitTest:[self convertPoint:point toView:subview]
                   withEvent:event] != nil) {
            return YES;
        }
    }
    return NO;
}
@end

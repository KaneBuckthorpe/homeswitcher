#import "HSHomeView.h"

@implementation HSHomeView
- (id)init{
  CGRect homeFrame =CGRectMake([[UIScreen mainScreen] bounds].size.width, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);

  if (self = [super initWithFrame:homeFrame]) {
    self.clipsToBounds = YES;
    self.backgroundColor = [UIColor clearColor];

  }

  return self;
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
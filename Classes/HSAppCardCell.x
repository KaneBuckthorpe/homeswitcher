#import "HSAppCardCell.h"

@implementation HSAppCardCell
- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]){
      deletingApp=NO;
      openingApp=NO;
self.clipsToBounds = NO;
      CGSize cellViewSize = self.frame.size;

      self.appImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, cellViewSize.width, cellViewSize.width)];
      self.appImageView.backgroundColor = UIColor.whiteColor;
      self.appImageView.layer.cornerRadius = 10;
self.appImageView.clipsToBounds =YES;
      CGSize appImageSize = self.appImageView.frame.size;
self.appImageView.layer.shadowColor=[UIColor clearColor].CGColor; 
      [self.appImageView.layer setShadowOpacity:0.5];
self.appImageView.layer.shadowRadius=3; 


self.overlay = [[UIView alloc] initWithFrame:self.appImageView.bounds];
self.overlay.backgroundColor=[UIColor colorWithRed:1 green:0 blue:0 alpha:0];




      self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(appImageSize.width/2-(appImageSize.width/8),appImageSize.height-(appImageSize.width/8), appImageSize.width/4, appImageSize.width/4)];


      self.iconImageView.backgroundColor = UIColor.clearColor;
      self.iconImageView.layer.cornerRadius = 1.5;
      self.iconImageView.clipsToBounds = NO;
      [self.iconImageView.layer setShadowOpacity:1];
      [self.iconImageView.layer setCornerRadius:5];
      [self.iconImageView.layer setShadowOffset:CGSizeMake(0, 0)];
/*

      CGFloat labelTop = appImageSize.height+(self.iconImageView.frame.size.height/2);


      self.appNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,labelTop, cellViewSize.width,cellViewSize.height -labelTop)];

      self.appNameLabel.numberOfLines = 1;
      self.appNameLabel.adjustsFontSizeToFitWidth = YES;
      self.appNameLabel.textAlignment = NSTextAlignmentCenter;
      self.appNameLabel.textColor = UIColor.whiteColor;

*/

      UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];

      self.zoomView = [[UIView alloc] initWithFrame:scrollView.bounds];
self.zoomView.layer.shadowColor=[UIColor whiteColor].CGColor; 
      [self.zoomView.layer setShadowOpacity:0.5];
self.zoomView.layer.shadowRadius=8; 
self.zoomView.layer.shadowOffset = CGSizeMake(0,0 ); 

      scrollView.backgroundColor = [UIColor clearColor];
      [scrollView setContentSize:CGSizeMake(self.bounds.size.width, scrollView.bounds.size.height*2.0)];

      scrollView.showsHorizontalScrollIndicator=NO;
      scrollView.showsVerticalScrollIndicator=NO;
      scrollView.pagingEnabled = YES;
      scrollView.decelerationRate = UIScrollViewDecelerationRateNormal;
      scrollView.clipsToBounds = NO;
      scrollView.delegate = self;


      [self addSubview:scrollView];
      [scrollView addSubview:self.zoomView];
      [self.zoomView addSubview:self.appImageView];
      [self.zoomView addSubview:self.iconImageView];
[self.appImageView addSubview:self.overlay];
/*
      [self.zoomView addSubview:self.appNameLabel];
*/
    }
    return self;
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
if (deletingApp){
[self closeApp];
deletingApp=NO;
} else if (openingApp){
[self openApp];
openingApp=NO;
}
[UIView animateWithDuration:0.3 animations:^{
[scrollView setContentOffset:CGPointMake(0,0) animated:NO];
} completion:^(BOOL finished){
}];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
float percent = (scrollView.contentOffset.y / 150.0);


    if(scrollView.contentOffset.y >= 0 && scrollView.contentOffset.y <= self.bounds.size.height*0.2) {
NSLog(@"0 To 150");

               self.alpha = 1-percent;

self.zoomView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1-percent/2, 1-percent/2);
deletingApp=NO;
///openingApp=NO;
    } else if (scrollView.contentOffset.y > self.bounds.size.height*0.2){
        self.alpha = 1-percent;
deletingApp=YES;
openingApp=NO;

    } else if (scrollView.contentOffset.y < 0 && scrollView.contentOffset.y > -35) {
self.zoomView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1+percent/2, 1+percent/2);
self.alpha = 1;

}else if (scrollView.contentOffset.y < -35 ) {
self.alpha = 1;
deletingApp=NO;
openingApp=YES;
    }
self.overlay.backgroundColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:1-self.alpha];
}


-(void)openApp{
dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
NSLog(@"opening app");

[LSApplicationWorkspace.defaultWorkspace openApplicationWithBundleID:self.bundleID];
});
}

-(void)closeApp{
NSLog(@"close App");

SBApplication *application = [[NSClassFromString(@"SBApplicationController") sharedInstance] applicationWithBundleIdentifier:self.bundleID];

	// This closes the app
	if (application.pid > 0) {
		kill(application.pid, SIGUSR1);
	}

		SBAppSwitcherModel *model = [NSClassFromString(@"SBAppSwitcherModel") sharedInstance];

		SBDisplayItem *itemToRemove;
		for(SBDisplayItem *displayItem in [model valueForKey:@"mainSwitcherDisplayItems"]) {
			if([[displayItem valueForKey:@"_displayIdentifier"] isEqualToString:self.bundleID]) {
				itemToRemove = displayItem;
			}
		}
		[model remove:itemToRemove];

[self.superview performSelector:@selector(reloadSwitcher) withObject:nil afterDelay:0.0];


	}
@end

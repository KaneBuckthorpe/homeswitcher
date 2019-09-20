#include "HSRootListController.h"

static NSUserDefaults *preferences = [[NSUserDefaults alloc] initWithSuiteName:@"com.kaneb.HomeSwitcher"];

@implementation HSRootListController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
	}

	return _specifiers;
}

-(UIColor*)navigationBarTint{
	return [UIColor colorWithRed:1 green:0.17 blue:0.33 alpha:1];
}

-(void)loadView{
[super loadView];

UIBarButtonItem *respringButton = [[UIBarButtonItem alloc]  initWithTitle:@"Respring" style:UIBarButtonItemStylePlain target:self action:@selector(respring)];
	[self.navigationItem setRightBarButtonItem:respringButton];

}
- (id)tableView:(id)tableView viewForHeaderInSection:(NSInteger)section {
if (section == 0) {
CGFloat headerHeight =140;
CGFloat tableWidth =[[UIApplication sharedApplication] keyWindow].frame.size.width;

UIImage *headerImage = [UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/HomeSwitcher.bundle/headerImage.png"];

UIImageView*headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,tableWidth, headerHeight)];

headerImageView.image = headerImage;
[headerImageView setClipsToBounds:YES];
[headerImageView.layer setMasksToBounds:YES];

		return headerImageView;
	} else {
		return [super tableView:tableView viewForHeaderInSection:section];
	}
}


- (CGFloat)tableView:(id)tableView heightForHeaderInSection:(NSInteger)section {
	if (section == 0) {
		return 140;
	} else {
		return [super tableView:tableView heightForHeaderInSection:section];
	}
}

- (void)respring{
    pid_t pid;
int status;
const char* args[] = {"killall", "-9", "SpringBoard", NULL}; 
posix_spawn(&pid, "/usr/bin/killall", NULL, NULL, (char* const*)args, NULL);
waitpid(pid, &status, WEXITED);
}

- (void)showOrHide {
    	CFNotificationCenterRef r = CFNotificationCenterGetDarwinNotifyCenter();
    CFNotificationCenterPostNotification(r, (CFStringRef)@"com.kaneb.HomeSwitcher/showOrHide", NULL, NULL, true);
}
@end

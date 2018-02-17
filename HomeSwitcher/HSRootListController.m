#include "HSRootListController.h"


@implementation HSRootListController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"Root" target:self] retain];
	}

	return _specifiers;
}
- (void)viewDidLoad {
	[super viewDidLoad];

[UISegmentedControl appearanceWhenContainedInInstancesOfClasses:@[[self.class class]]].tintColor =[UIColor colorWithRed:1 green:0.17 blue:0.33 alpha:1];

	UIBarButtonItem *respringButton = [[UIBarButtonItem alloc]  initWithTitle:@"Respring" style:UIBarButtonItemStylePlain target:self action:@selector(respring)];
respringButton.tintColor=[UIColor colorWithRed:1 green:0.17 blue:0.33 alpha:1];
	[self.navigationItem setRightBarButtonItem:respringButton];

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PSTableCell *cell = (PSTableCell *)[super tableView:tableView cellForRowAtIndexPath:indexPath];
    
    cell.textLabel.textColor = [UIColor colorWithRed:1 green:0.17 blue:0.33 alpha:1];

return cell;
}
- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];

[UISegmentedControl appearanceWhenContainedInInstancesOfClasses:@[[self.class class]]].tintColor =[UIColor colorWithRed:1 green:0.17 blue:0.33 alpha:1];

	// tint navbar
self.navigationController.navigationController.navigationBar.tintColor = [UIColor colorWithRed:1 green:0.17 blue:0.33 alpha:1];

}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];

[UISegmentedControl appearanceWhenContainedInInstancesOfClasses:@[[self.class class]]].tintColor =[UIColor colorWithRed:1 green:0.17 blue:0.33 alpha:1];

self.navigationController.navigationController.navigationBar.tintColor = [UIColor colorWithRed:1 green:0.17 blue:0.33 alpha:1];
}

-(void)respring{
pid_t pid;
int status;
const char* args[] = {"killall", "-9", "SpringBoard", NULL}; 
posix_spawn(&pid, "/usr/bin/killall", NULL, NULL, (char* const*)args, NULL);
waitpid(pid, &status, WEXITED);
}

- (id)tableView:(id)tableView viewForHeaderInSection:(NSInteger)section {
if (section == 0) {
CGFloat headerHeight =148;
CGFloat tableWidth =[[UIApplication sharedApplication] keyWindow].frame.size.width;
	CGRect labelFrame;

		UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,tableWidth, headerHeight)];
		headerView.backgroundColor = [UIColor colorWithRed:1 green:0.17 blue:0.33 alpha:0.3];
		headerView.clipsToBounds = YES;



UIImage *iconImage = [UIImage imageWithContentsOfFile:@"/Library/Application Support/BabyPlayer/microplayerIcon.png"];

UIImageView*icon = [[UIImageView alloc] initWithFrame:CGRectMake((tableWidth/2)-25, 20,50,50)];

[icon.layer setCornerRadius:8];
icon.layer.borderColor = [UIColor whiteColor].CGColor;
icon.layer.borderWidth = 2.0f;
icon.image = iconImage;
[icon setClipsToBounds:YES];
[icon.layer setMasksToBounds:YES];
[headerView addSubview:icon];

labelFrame = CGRectMake(0, icon.frame.size.height+20, tableWidth, 60);

UILabel *label = [[UILabel alloc] initWithFrame:labelFrame];
[label setBackgroundColor:[UIColor clearColor]];
[label setTextColor:[UIColor whiteColor]];
[label.layer setShadowColor:[UIColor blackColor].CGColor];
[label.layer setShadowOpacity:0.8];
[label.layer setShadowRadius:2];
[label.layer setShadowOffset:CGSizeMake(0, 5)];

[label setText:@"HomeSwitcher"];
[label setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:40]];
[label setTextAlignment:NSTextAlignmentCenter];
[headerView addSubview:label];


		return headerView;
	} else {
		return [super tableView:tableView viewForHeaderInSection:section];
	}
}

- (CGFloat)tableView:(id)tableView heightForHeaderInSection:(NSInteger)section {
	if (section == 0) {
		return 148;
	} else {
		return [super tableView:tableView heightForHeaderInSection:section];
	}
}


@end


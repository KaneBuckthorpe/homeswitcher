#include "HSRootListController.h"
#include "HSSliderCell.h"
#include "PSStepperCell.h"

static NSUserDefaults *preferences =
[[NSUserDefaults alloc] initWithSuiteName:@"com.kaneb.HomeSwitcher"];

@implementation HSRootListController

- (NSArray *)specifiers {
    if (!_specifiers) {
        _specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
    }
    
    return _specifiers;
}

- (void)loadView {
    [super loadView];
    
    UIBarButtonItem *respringButton =
    [[UIBarButtonItem alloc] initWithTitle:@"Respring"
                                     style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(respring)];
    respringButton.tintColor = [UIColor colorWithRed:1
                                               green:0.17
                                                blue:0.33
                                               alpha:1];
    [self.navigationItem setRightBarButtonItem:respringButton];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = (PSTableCell *)[super tableView:tableView
                                      cellForRowAtIndexPath:indexPath];
    
    CGFloat inset = cell.bounds.size.width * 10;
    
    if ([cell isKindOfClass: %c(PSTableCell)]) {
        PSSpecifier *specifier = ((PSTableCell *)cell).specifier;
        NSString *identifier = specifier.identifier;
        
        ////cell.textLabel.textColor = [UIColor blackColor];
        
        if ([identifier isEqualToString:@"pageNumber"]) {
            double pageNumber = [preferences doubleForKey:@"pageSliderNumber"];
            
            cell.separatorInset = UIEdgeInsetsMake(0, inset, 0, 0);
            cell.indentationWidth = -inset;
            cell.indentationLevel = 1;
            cell.detailTextLabel.text =
            [NSString stringWithFormat:@"%.0lf", pageNumber];
            cell.detailTextLabel.textColor = [UIColor colorWithRed:1
                                                             green:0.17
                                                              blue:0.33
                                                             alpha:1];
        }
        if ([cell isKindOfClass: %c(KBButtonCell)]) {
            cell.separatorInset = UIEdgeInsetsMake(0, inset, 0, 0);
            cell.indentationWidth = -inset;
            cell.indentationLevel = 1;
        }
    }
    
    return cell;
}

- (void)sliderMoved:(UISlider *)slider {
    
    UITableViewCell *textCell =
    (UITableViewCell *)[self cachedCellForSpecifierID:@"pageNumber"];
    textCell.detailTextLabel.text =
    [NSString stringWithFormat:@"%.0lf", slider.value];
    NSLog(@"textCell: %@", textCell);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [UISegmentedControl
     appearanceWhenContainedInInstancesOfClasses:@ [[self.class class]]]
    .tintColor = [UIColor colorWithRed:1 green:0.17 blue:0.33 alpha:1];
    
    // tint navbar
    self.navigationController.navigationController.navigationBar.tintColor =
    [UIColor colorWithRed:1 green:0.17 blue:0.33 alpha:1];
    
    [UISwitch
     appearanceWhenContainedInInstancesOfClasses:@ [[self.class class]]]
    .onTintColor = [UIColor blackColor];
    
    [UISlider
     appearanceWhenContainedInInstancesOfClasses:@ [[self.class class]]]
    .thumbTintColor = [UIColor blackColor];
    
    [UIStepper
     appearanceWhenContainedInInstancesOfClasses:@ [[self.class class]]]
    .tintColor = [UIColor blackColor];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [UISegmentedControl
     appearanceWhenContainedInInstancesOfClasses:@ [[self.class class]]]
    .tintColor = [UIColor colorWithRed:1 green:0.17 blue:0.33 alpha:1];
    
    self.navigationController.navigationController.navigationBar.tintColor =
    [UIColor colorWithRed:1 green:0.17 blue:0.33 alpha:1];
}

- (id)tableView:(id)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        CGFloat headerHeight = 140;
        CGFloat tableWidth =
        [[UIApplication sharedApplication] keyWindow].frame.size.width;
        
        UIImage *headerImage = [UIImage
                                imageWithContentsOfFile:@"/Library/PreferenceBundles/"
                                @"HomeSwitcher.bundle/headerImage.png"];
        
        UIImageView *headerImageView = [[UIImageView alloc]
                                        initWithFrame:CGRectMake(0, 0, tableWidth, headerHeight)];
        
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

- (void)respring {
    pid_t pid;
    int status;
    const char *args[] = {"killall", "-9", "SpringBoard", NULL};
    posix_spawn(&pid, "/usr/bin/killall", NULL, NULL, (char *const *)args,
                NULL);
    waitpid(pid, &status, WEXITED);
}

- (void)showOrHide {
    CFNotificationCenterRef r = CFNotificationCenterGetDarwinNotifyCenter();
    CFNotificationCenterPostNotification(
                                         r, (CFStringRef) @"com.kaneb.HomeSwitcher/showOrHide", NULL, NULL,
                                         true);
}
- (void)twitter {
    NSURL *url = [NSURL URLWithString:@"https://twitter.com/indieDevKB"];
    [[UIApplication sharedApplication] openURL:url];
}
- (void)paypal {
    NSURL *url = [NSURL URLWithString:@"https://paypal.me/kanebuckthorpe"];
    [[UIApplication sharedApplication] openURL:url];
}
@end

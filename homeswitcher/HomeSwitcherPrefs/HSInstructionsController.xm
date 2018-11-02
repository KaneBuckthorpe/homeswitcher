#include "HSRootListController.h"

@implementation HSInstructionsController

- (NSArray *)specifiers {
    if (!_specifiers) {
        _specifiers =
        [self loadSpecifiersFromPlistName:@"HSInstructionsController"
                                   target:self];
    }
    
    return _specifiers;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.topItem.backBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                     style:UIBarButtonItemStylePlain
                                    target:nil
                                    action:nil];
    
    self.backgroundColor = [UIColor whiteColor];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PSTableCell *cell = (PSTableCell *)[super tableView:tableView
                                  cellForRowAtIndexPath:indexPath];
    
    cell.textLabel.textColor = [UIColor blackColor];
    
    return cell;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.topItem.backBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                     style:UIBarButtonItemStylePlain
                                    target:nil
                                    action:nil];
    // tint navbar
    self.navigationController.navigationController.navigationBar.tintColor =
    [UIColor colorWithRed:1 green:0.17 blue:0.33 alpha:1];
    self.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.backBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                     style:UIBarButtonItemStylePlain
                                    target:nil
                                    action:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationController.navigationBar.tintColor =
    [UIColor colorWithRed:1 green:0.17 blue:0.33 alpha:1];
}

- (id)tableView:(id)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        CGFloat headerHeight = 140;
        CGFloat tableWidth =
        [[UIApplication sharedApplication] keyWindow].frame.size.width;
        
        UIImage *headerImage =
        [UIImage imageWithContentsOfFile:
         @"/Library/PreferenceBundles/HomeSwitcher.bundle/"
         @"headerImageInstructions.png"];
        
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
@end

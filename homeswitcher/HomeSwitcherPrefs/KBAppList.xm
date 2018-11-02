#include "HSRootListController.h"
#import "KBAppListCell.h"

@implementation KBAppList
    NSUserDefaults *preferences;
    UIBarButtonItem *saveButton;
    UIButton *toggleAllButton;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Apps To Blur";
    
    self.allSelected = NO;
    saveButton =
    [[UIBarButtonItem alloc] initWithTitle:@"Save"
                                     style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(save)];
    saveButton.tintColor = UIColor.blackColor;
    [self.navigationItem setRightBarButtonItem:saveButton];
    
    self.tableView = [[UITableView alloc]
                      initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,
                                               self.view.frame.size.height)];
    self.tableView.backgroundColor = UIColor.blackColor;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    UIView *headerView = [[UIView alloc]
                          initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
    
    toggleAllButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [toggleAllButton setTitleColor:[UIColor whiteColor]
                          forState:UIControlStateNormal];
    toggleAllButton.backgroundColor = UIColor.grayColor;
    [toggleAllButton addTarget:self
                        action:@selector(toggleAllPressed)
              forControlEvents:UIControlEventTouchUpInside];
    [toggleAllButton setTitle:@"Select/deselect all"
                     forState:UIControlStateNormal];
    toggleAllButton.frame = headerView.frame;
    [headerView addSubview:toggleAllButton];
    
    self.tableView.tableHeaderView = headerView;
    
    [self.view bringSubviewToFront:self.tableView];
    self.navigationController.navigationBar.topItem.backBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                     style:UIBarButtonItemStylePlain
                                    target:nil
                                    action:nil];
    
    self.view.backgroundColor = [UIColor whiteColor];
}
    
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}
    
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    
    return [self.installedApps count];
}
    
- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}
    
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    KBAppListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
    if (cell == nil) {
        cell = [[KBAppListCell alloc] initWithStyle:UITableViewCellStyleDefault
                                    reuseIdentifier:@"CELL"];
    }
    cell.appName.text = [self.installedApps objectAtIndex:indexPath.row];
    cell.appIconView.image = [UIImage
                              _applicationIconImageForBundleIdentifier:[self.installedAppsBundleID
                                                                        objectAtIndex:indexPath
                                                                        .row]
                              format:1
                              scale:UIScreen.mainScreen.scale];
    
    if ([self.selectedApps containsObject:[self.installedAppsBundleID
                                           objectAtIndex:indexPath.row]]) {
        cell.appSelected = YES;
        cell.checkBoxView.image = [UIImage
                                   imageNamed:@"hide"
                                   inBundle:[NSBundle
                                             bundleWithPath:
                                             @"/Library/PreferenceBundles/"
                                             @"HomeSwitcher.bundle"]
                                   compatibleWithTraitCollection:nil];
    } else {
        cell.appSelected = NO;
        cell.checkBoxView.image = nil;
    }
    return cell;
}
    
- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    saveButton.tintColor = [UIColor colorWithRed:1
                                           green:0.17
                                            blue:0.33
                                           alpha:1];
    
    KBAppListCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell) {
        if (!cell.appSelected) {
            [self.selectedApps addObject:[self.installedAppsBundleID
                                          objectAtIndex:indexPath.row]];
            
            cell.appSelected = YES;
            
        } else {
            if ([self.selectedApps
                 containsObject:[self.installedAppsBundleID
                                 objectAtIndex:indexPath.row]]) {
                     [self.selectedApps
                      removeObject:[self.installedAppsBundleID
                                    objectAtIndex:indexPath.row]];
                     
                     cell.appSelected = NO;
                 }
        }
    }
    [tableView reloadData];
}
    
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    preferences =
    [[NSUserDefaults alloc] initWithSuiteName:@"com.kaneb.HomeSwitcher"];
    self.selectedApps = [NSMutableArray
                         arrayWithArray:[preferences objectForKey:@"selectedApps"]];
    NSArray *appsToHide = @[
                            @"com.apple.fieldtest",
                            @"com.apple.gamecenter.GameCenterUIService",
                            @"com.apple.HealthPrivacyService",
                            @"com.apple.InCallService",
                            @"com.apple.MailCompositionService",
                            @"com.apple.mobilesms.compose",
                            @"com.apple.MusicUIService",
                            @"com.apple.PassbookUIService",
                            @"com.apple.PhotosViewService",
                            @"com.apple.PreBoard",
                            @"com.apple.social.SLGoogleAuth",
                            @"com.apple.social.SLYahooAuth",
                            @"com.apple.SafariViewService",
                            @"com.apple.mobilecal",
                            @"org.coolstar.SafeMode",
                            @"com.apple.ScreenSharingviewService",
                            @"com.apple.ScreenshotServicesService",
                            @"com.apple.purplebuddy",
                            @"com.apple.SharedWebCredentialViewService",
                            @"com.apple.SharingViewService",
                            @"com.apple.susuiservice",
                            @"com.apple.StoreDemoViewService",
                            @"com.apple.ios.StoreKitUIService",
                            @"com.apple.TrustMe",
                            @"com.apple.VSViewService",
                            @"com.apple.WLAccessService",
                            @"com.apple.webapp1",
                            @"com.apple.webapp",
                            @"com.apple.reminders",
                            @"com.apple.WebSheet",
                            @"com.apple.iad.iAdOptOut",
                            @"com.apple.CloudKit.ShareBear",
                            @"com.apple.AXUIViewService",
                            @"com.apple.AccountAuthenticationDialog",
                            @"com.apple.AskPermissionUI",
                            @"com.apple.CTCarrierSpaceAuth",
                            @"com.apple.CheckerBoard",
                            @"com.apple.CompassCalibrationViewService",
                            @"com.apple.CoreAuthUI",
                            @"com.apple.datadetectors.DDActionsService",
                            @"com.apple.carkit.DNDBuddy",
                            @"com.apple.DataActivation",
                            @"com.apple.DemoApp",
                            @"com.apple.DiagnosticsService",
                            @"com.apple.Diagnostics",
                            @"com.apple.FTMInternal",
                            @"com.apple.PrintKit.Print-Center",
                            @"com.apple.ScreenSharingViewService",
                            @"com.apple.ServerDocuments",
                            @"com.apple.WebContentFilter.remoteUI.WebContentAnalysisUI",
                            @"com.apple.AdPlatformsDiagnostics",
                            @"com.apple.AdSheetPhone"
                            ];
    
    NSMutableArray *sortingAppList = [NSMutableArray new];
    NSMutableArray *sortingAppBundleID = [NSMutableArray new];
    
    for (LSApplicationProxy *app in [[% c(LSApplicationWorkspace)
                                      defaultWorkspace] allInstalledApplications]) {
        /*
         NSDictionary *info = app._infoDictionary.propertyList;
         NSArray *background = info[@"UIBackgroundModes"];
         if (background && [background containsObject:@"audio"]){
         [returning addObject:app. localizedName];
         }
         */
        if (![appsToHide containsObject:app.bundleIdentifier]) {
            
            [sortingAppList addObject:app.localizedName];
            [sortingAppBundleID addObject:app.bundleIdentifier];
        }
    }
    
    self.installedAppsBundleID = sortingAppBundleID;
    self.installedApps = sortingAppList;
    
    self.navigationController.navigationBar.topItem.backBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                     style:UIBarButtonItemStylePlain
                                    target:nil
                                    action:nil];
    // tint navbar
    self.navigationController.navigationController.navigationBar.tintColor =
    [UIColor colorWithRed:1 green:0.17 blue:0.33 alpha:1];
    
    self.navigationItem.backBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                     style:UIBarButtonItemStylePlain
                                    target:nil
                                    action:nil];
}
    
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationController.navigationBar.tintColor =
    [UIColor colorWithRed:1 green:0.17 blue:0.33 alpha:1];
}
    
- (void)toggleAllPressed {
    saveButton.tintColor = [UIColor colorWithRed:1
                                           green:0.17
                                            blue:0.33
                                           alpha:1];
    
    if (!self.allSelected) {
        [toggleAllButton setTitleColor:[UIColor blackColor]
                              forState:UIControlStateNormal];
        NSMutableArray *holding =
        [NSMutableArray arrayWithArray:self.installedAppsBundleID];
        /// add to array
        self.selectedApps = holding;
        self.allSelected = YES;
        [self.tableView reloadData];
        
    } else {
        // remove from array
        [toggleAllButton setTitleColor:[UIColor whiteColor]
                              forState:UIControlStateNormal];
        [self.selectedApps removeAllObjects];
        self.allSelected = NO;
        [self.tableView reloadData];
    }
}
    
- (void)save {
    [preferences setObject:self.selectedApps forKey:@"selectedApps"];
    [preferences synchronize];
    
    CFNotificationCenterRef r = CFNotificationCenterGetDarwinNotifyCenter();
    CFNotificationCenterPostNotification(
                                         r, (CFStringRef) @"com.kaneb.HomeSwitcher/HSCollectionViewPrefChanged",
                                         NULL, NULL, true);
    
    saveButton.tintColor = UIColor.blackColor;
}
    @end

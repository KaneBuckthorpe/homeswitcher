#import <UIKit/UIKit.h>
#import <dlfcn.h>
#import <objc/runtime.h>
#import "Classes/interfaces.h"
#import "Classes/HSCollectionView.h"
#import "Classes/HSHomeView.h"
#import <SpringBoard/SBRootFolderView.h>
@interface SBRootIconListView:UIView
@end


@interface SBFolderController : UIView
@property (nonatomic,retain,readonly) SBFolderView* contentView;
@end

@interface SBIconController : UIViewController
+(instancetype)sharedInstance;
- (id)contentView;
-(SBFolderController*)_rootFolderController;
@end


@interface SBIconScrollView :UIView
@end

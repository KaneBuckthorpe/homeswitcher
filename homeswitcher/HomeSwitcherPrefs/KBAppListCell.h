#import <UIKit/UIKit.h>

@interface KBAppListCell : UITableViewCell
    
    @property(nonatomic, strong) UILabel *appName;
    @property(nonatomic, strong) UIImageView *appIconView;
    @property(nonatomic, strong) UIImageView *checkBoxView;
    @property(nonatomic, assign) BOOL appSelected;
    
    @end

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "interfaces.h"


@interface HSAppCardCell : UICollectionViewCell <UIScrollViewDelegate>
{
UIImageView *_appImageView;
UIImageView*_iconImageView;
UILabel *_appNameLabel;
UIView *_overlay;
BOOL deletingApp;
BOOL openingApp;
}
@property (nonatomic, retain) UIView *zoomView;
@property (nonatomic, retain) UIView *overlay;
@property (nonatomic, strong) UIImageView *appImageView;
@property (nonatomic, retain) UIImageView *iconImageView;
@property (nonatomic, retain) UILabel *appNameLabel;
@property (nonatomic) NSString *bundleID;
@property (nonatomic) NSIndexPath*indexPath;
@end
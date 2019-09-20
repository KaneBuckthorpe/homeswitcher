#import "HSInterfaces.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "HSAppCardCell.h"

@interface HSCollectionView :UICollectionView<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) NSArray<SBDisplayItem *> *switcherItems;
@property (nonatomic, strong) NSArray*blurAppsList;
@property float itemScale;
@property (nonatomic, assign) BOOL verticalMode;

- (void)reloadSwitcher;
- (void) updateCellsLayout;
-(void)scrollToCenterAnimated;
-(void)scrollToStartAnimated;
-(void)scrollToEndAnimated;
-(void) reloadAndScroll;
@end

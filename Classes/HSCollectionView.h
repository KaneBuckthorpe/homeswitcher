#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "HSAppCardCell.h"
#import "interfaces.h"

@interface HSCollectionView :UICollectionView<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) NSArray<SBDisplayItem *> *switcherItems;
@property float itemScale;
- (void)reloadSwitcher;
- (void) updateCellsLayout;
-(void)scrollToCenterAnimated;
-(void) reloadAndScroll;
@end

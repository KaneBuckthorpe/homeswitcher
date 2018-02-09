#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "HSAppCardCell.h"

@interface HSCollectionView :UICollectionView<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) NSArray<SBDisplayItem *> *switcherItems;
@property float itemScale;
- (id)init;
- (void)reloadSwitcher;
- (void) updateCellsLayout;
-(void)scrollToStartAnimated;
-(void) reloadAndScroll;
@end

#import "HSCollectionView.h"

int iOS;
static NSUserDefaults *preferences;
static NSInteger appcardNumber;
static NSString* shadowColorHex;
UIColor *shadowColor;
static NSString *fallbackHex;

float screenWidth=[[UIScreen mainScreen] bounds].size.width;
float cellWidth =screenWidth/(appcardNumber+0.5);
float imageViewSize = cellWidth;
float iconSize =imageViewSize/4;
float scrollStartPoint = cellWidth;
float pageStartInset = screenWidth/2-cellWidth/2;
int targetCellIndex;
CGRect switcherFrame;



@implementation HSCollectionView
- (id)init{
if (kCFCoreFoundationVersionNumber>=1443.00){
iOS=11;
} else{
iOS=10;
}


[self loadPrefs];
  [self updateForPrefs];

switcherFrame=CGRectMake(0, ([[UIScreen mainScreen] bounds].size.height)*0.5, [[UIScreen mainScreen] bounds].size.width,(cellWidth+iconSize/2)+20);

UICollectionViewFlowLayout * layout;
layout = [UICollectionViewFlowLayout new];
  layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
layout.minimumInteritemSpacing = 0;
layout.minimumLineSpacing = 0;


  if (self = [super initWithFrame:switcherFrame collectionViewLayout:layout]) {

  



 

int regToken;
notify_register_dispatch("com.kaneb.HomeSwitcher/CprefsChanged", &regToken, dispatch_get_main_queue(), ^(int token) {
[self loadPrefs];

            [self updateForPrefs];
[self loadPrefs];
        });
    [self setValue:[NSValue valueWithCGSize:CGSizeMake(0.996000f,0.996000f)] forKey:@"_decelerationFactor"];
    self.pagingEnabled = NO;
    self.userInteractionEnabled = YES;
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    self.alwaysBounceHorizontal = NO;
    self.clipsToBounds = NO;
    self.backgroundColor = [UIColor clearColor];
///self.decelerationRate = UIScrollViewDecelerationRateNormal;
    [self registerClass:[HSAppCardCell class] forCellWithReuseIdentifier:@"switcherCell"];

    [self setDataSource:self];
    [self setDelegate:self];
  
}
  return self;
}
-(void)loadPrefs{
preferences = [[NSUserDefaults alloc] initWithSuiteName:@"com.kaneb.HomeSwitcher"];
       

	[preferences registerDefaults:@{
		@"appcardNumber":	[NSNumber numberWithInteger:3],

	}];

appcardNumber		= [preferences integerForKey:@"appcardNumber"];


}
-(void)updateForPrefs{
cellWidth =screenWidth/(appcardNumber+0.5);
imageViewSize = cellWidth;
iconSize =imageViewSize/4;
scrollStartPoint = cellWidth;
pageStartInset = screenWidth/2-cellWidth/2;
}

-(void)reloadSwitcher{
NSMutableArray *holding = [NSMutableArray new];

if(iOS==11){
SBRecentAppLayouts *recentLayouts = [%c(SBRecentAppLayouts) sharedInstance];
NSMutableArray *recentAppLayouts = [NSMutableArray new];
recentAppLayouts= [recentLayouts _recentsFromPrefs];
for (SBAppLayout *appLayout in recentAppLayouts) {
[holding addObjectsFromArray:appLayout.allItems];
}
} else{
SBAppSwitcherModel *switcherModel = [%c(SBAppSwitcherModel) sharedInstance];
holding= [switcherModel _recentsFromPrefs];
}


if ([holding count] ==0 && [self.switcherItems count] ==0){
self.switcherItems = nil;
[self reloadData];
}else{
self.switcherItems =holding;
[self reloadSections:[NSIndexSet indexSetWithIndex:0]];
[self
updateCellsLayout];
}
}
-(void)reloadAndScroll{
NSMutableArray *holding = [NSMutableArray new];

if(iOS==11){
SBRecentAppLayouts *recentLayouts = [%c(SBRecentAppLayouts) sharedInstance];
NSMutableArray *recentAppLayouts = [NSMutableArray new];
recentAppLayouts= [recentLayouts _recentsFromPrefs];
for (SBAppLayout *appLayout in recentAppLayouts) {
[holding addObjectsFromArray:appLayout.allItems];
}
} else{
SBAppSwitcherModel *switcherModel = [%c(SBAppSwitcherModel) sharedInstance];
holding= [switcherModel _recentsFromPrefs];
}



if ([holding count] ==0 && [self.switcherItems count] ==0){
self.switcherItems = nil;
[self reloadData];
}else{
self.switcherItems =holding;
[self reloadSections:[NSIndexSet indexSetWithIndex:0]];
[self scrollToCenterAnimated];
}
}
- (UIImage *)squareImageFromImage: (UIImage *)image{
    return [[UIImage alloc] initWithCGImage:CGImageCreateWithImageInRect(image.CGImage, CGRectMake(0, 0, image.size.width, image.size.width))];
}


- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();    
    UIGraphicsEndImageContext();
    return newImage;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
int count = [self.switcherItems count];
if (count ==0){
return 1;
}else {
    return count;

}
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HSAppCardCell *cell;

cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"switcherCell" forIndexPath:indexPath];
    cell.backgroundColor=[UIColor clearColor];

int count = [self.switcherItems count];
if (count ==0){

cell.bundleID = nil;
cell.indexPath=nil;
cell.iconImageView.image=nil;
cell.appNameLabel.text = nil;
cell.appImageView.image=nil;
cell.appImageView.backgroundColor = UIColor.clearColor;
cell.zoomView.layer.shadowColor=UIColor.clearColor.CGColor;

}else {

    NSString *bundleID = [self.switcherItems[indexPath.row] displayIdentifier];
cell.bundleID = bundleID;
cell.indexPath=indexPath;

    LSApplicationProxy *appProxy = [LSApplicationProxy applicationProxyForIdentifier:bundleID];

    cell.iconImageView.image = [UIImage _applicationIconImageForBundleIdentifier:bundleID format:1 scale:UIScreen.mainScreen.scale];

cell.appNameLabel.text = appProxy.localizedName;


NSURL *appDocs = appProxy.dataContainerURL;
NSString *pathToSnaps;
if (appDocs) {
    pathToSnaps = [NSString stringWithFormat:@"%@/Library/Caches/Snapshots/%@/downscaled", appDocs.path, bundleID];
} else {
    pathToSnaps = [NSString stringWithFormat:@"/private/var/mobile/Library/Caches/Snapshots/%@/%@/downscaled", bundleID, bundleID];
}
    NSArray<NSString *> *appSnaps = [NSFileManager.defaultManager contentsOfDirectoryAtPath:pathToSnaps error:NULL];


UIImage*snapshotImage= [UIImage
imageWithContentsOfFile:[pathToSnaps stringByAppendingPathComponent:appSnaps.firstObject]];

if(snapshotImage.size.width >snapshotImage.size.height ){
snapshotImage= [UIImage
imageWithContentsOfFile:[pathToSnaps stringByAppendingPathComponent:appSnaps.lastObject]];
}

UIImage *squareSnapshotImage = [self imageWithImage:snapshotImage scaledToSize:CGSizeMake(cell.appImageView.frame.size.width, cell.appImageView.frame.size.width*1.78)];
cell.appImageView.contentMode = UIViewContentModeTopLeft;

cell.appImageView.image=squareSnapshotImage;
cell.appImageView.backgroundColor = UIColor.whiteColor;
cell.zoomView.layer.shadowColor=shadowColor.CGColor;

}
return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(cellWidth, self.bounds.size.height);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout *)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section {
return UIEdgeInsetsMake(0,pageStartInset,0,pageStartInset);
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    float currentOffset = scrollView.contentOffset.x;
if(currentOffset<0){

[self scrollToStart];
 [self updateCellsLayout];
}else{
 [self updateCellsLayout];
}
}
-(void) scrollToStart{
                [self setContentOffset:CGPointMake(0, 0) animated:NO];

}

-(void)scrollToCenterAnimated{

 [UIView animateWithDuration:0.5 delay:0 options: UIViewAnimationOptionCurveEaseInOut  animations:^{ 
if ([self.switcherItems count]==1){
[self setContentOffset:CGPointMake(0, 0) animated:NO];
}else {
[self setContentOffset:CGPointMake(cellWidth*floor(([self.switcherItems count]-1)/2), 0) animated:NO];
}
}
                     completion:^(BOOL finished) {
 [UIView animateWithDuration:0.5 delay:0 options: UIViewAnimationOptionCurveEaseInOut  animations:^{ 
[self updateCellsLayout];
}completion:nil];
                  
}];
}
- (void) updateCellsLayout{

    double centerX = self.contentOffset.x + (self.frame.size.width)/2;
    for (HSAppCardCell *cell in self.visibleCells) {

        double offsetX = centerX - cell.center.x;
        if (offsetX < 0) {
            offsetX *= -1;
}

        cell.transform = CGAffineTransformIdentity;
        double offsetPercentage = offsetX / screenWidth;
        CGFloat scaleX = (CGFloat) (1.0f-offsetPercentage);

        cell.transform = CGAffineTransformMakeScale(scaleX, scaleX);
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{


    float currentOffset = scrollView.contentOffset.x;
    float targetOffset = targetContentOffset->x;
    float newTargetOffset = 0;

    if (targetOffset > currentOffset)
        newTargetOffset = ceilf(currentOffset / scrollStartPoint) * scrollStartPoint;
    else
        newTargetOffset = floorf(currentOffset / scrollStartPoint) * scrollStartPoint;

    if (newTargetOffset < 0)
        newTargetOffset = 0;
    else if (newTargetOffset > scrollView.contentSize.width)
        newTargetOffset = scrollView.contentSize.width;

    targetContentOffset->x = currentOffset;
    [scrollView setContentOffset:CGPointMake(newTargetOffset, scrollView.contentOffset.y) animated:YES];

    float target = targetContentOffset->x;
    float remainder = target / cellWidth;
    targetCellIndex = lroundl(remainder);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:targetCellIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
}

@end

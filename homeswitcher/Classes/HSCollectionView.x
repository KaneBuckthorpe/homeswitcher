#import "HSCollectionView.h"

@implementation HSCollectionView
static NSUserDefaults *preferences;
int targetCellIndex;
int iOS;

static float viewAreaWidth;
static float viewAreaHeight;

UICollectionViewFlowLayout *layout;
static float appcardSizePercentage;
static float shadowRadius;
BOOL freeFlowScrolling;

float cellWidth;
float imageViewSize;
float iconSize;
float cellHeight;
float scrollStartPoint;
float pageStartInset;
CGRect switcherFrame;

- (id)init {
    if (kCFCoreFoundationVersionNumber >= 1443.00) {
        iOS = 11;
    } else {
        iOS = 10;
    }
    
    int regToken;
    
    notify_register_dispatch(
                             "com.kaneb.HomeSwitcher/HSCollectionViewPrefChanged", &regToken,
                             dispatch_get_main_queue(), ^(int token) {
                                 [self loadPrefs];
                             });
    
    [self loadPrefs];
    [self layoutViews];
    
    layout = [UICollectionViewFlowLayout new];
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    
    if (self.verticalMode) {
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
    } else {
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    
    if (self = [super initWithFrame:switcherFrame
               collectionViewLayout:layout]) {
        
        /// Settings require view reload in HSSetup
        
        self.pagingEnabled = NO;
        
        [self
         setValue:[NSValue valueWithCGSize:CGSizeMake(0.996000f, 0.996000f)]
         forKey:@"_decelerationFactor"];
        self.userInteractionEnabled = YES;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.alwaysBounceHorizontal = NO;
        self.clipsToBounds = NO;
        self.backgroundColor = [UIColor colorWithRed:0
                                               green:0
                                                blue:0
                                               alpha:0.01];
        /// self.decelerationRate = UIScrollViewDecelerationRateNormal;
        [self registerClass:[HSAppCardCell class]
 forCellWithReuseIdentifier:@"switcherCell"];
        
        self.dataSource = self;
        self.delegate = self;
    }
    return self;
}

- (void)loadPrefs {
    preferences =
    [[NSUserDefaults alloc] initWithSuiteName:@"com.kaneb.HomeSwitcher"];
    
    [preferences registerDefaults:@{
     @"shadowRadius" : [NSNumber numberWithFloat:50],
     
     }];
    
    [preferences registerDefaults:@{
     @"appcardSize" : [NSNumber numberWithFloat:30],
     
     }];
    [preferences registerDefaults:@{
     @"freeFlowScrolling" : @YES,
     }];
    [preferences registerDefaults:@{
     @"verticalMode" : @NO,
     }];
    
    self.blurAppsList = [preferences objectForKey:@"selectedApps"];
    
    shadowRadius = [preferences floatForKey:@"shadowRadius"];
    
    appcardSizePercentage = [preferences floatForKey:@"appcardSize"];
    
    freeFlowScrolling = [preferences boolForKey:@"freeFlowScrolling"];
    
    self.verticalMode = [preferences boolForKey:@"verticalMode"];
}

- (void)layoutViews {
    
    viewAreaWidth = [[UIScreen mainScreen] bounds].size.width;
    
    viewAreaHeight = [[UIScreen mainScreen] bounds].size.height * 0.8;
    
    cellWidth = viewAreaWidth * (appcardSizePercentage / 100);
    imageViewSize = cellWidth;
    iconSize = imageViewSize / 4;
    cellHeight = cellWidth + (iconSize / 2);
    
    NSLog(@"cellWidth:%f", cellWidth);
    NSLog(@"viewAreaWidth:%f", viewAreaWidth);
    
    if (self.verticalMode) {
        scrollStartPoint = cellHeight;
        pageStartInset = viewAreaHeight / 2 - cellHeight / 2;
        switcherFrame = CGRectMake(0, 0, cellWidth, viewAreaHeight);
        
    } else {
        scrollStartPoint = cellWidth;
        pageStartInset = viewAreaWidth / 2 - cellWidth / 2;
        switcherFrame = CGRectMake(0, 0, viewAreaWidth, cellHeight);
    }
    self.frame = switcherFrame;
}

- (void)reloadSwitcher {
    NSMutableArray *holding = [NSMutableArray new];
    
    if (iOS == 11) {
        SBRecentAppLayouts *recentLayouts =
        [%c(SBRecentAppLayouts) sharedInstance];
        NSMutableArray *recentAppLayouts = [NSMutableArray new];
        recentAppLayouts = [recentLayouts _recentsFromPrefs];
        for (SBAppLayout *appLayout in recentAppLayouts) {
            [holding addObjectsFromArray:appLayout.allItems];
        }
    } else {
        SBAppSwitcherModel *switcherModel =
        [%c(SBAppSwitcherModel) sharedInstance];
        holding = [switcherModel _recentsFromPrefs];
    }
    
    if ([holding count] == 0 && [self.switcherItems count] == 0) {
        self.switcherItems = nil;
        [self reloadData];
    } else {
        self.switcherItems = holding;
        
        [self reloadData];
        [self layoutIfNeeded];
        [self updateCellsLayout];
    }
}
- (void)reloadAndScroll {
    NSMutableArray *holding = [NSMutableArray new];
    
    if (iOS == 11) {
        SBRecentAppLayouts *recentLayouts =
        [%c(SBRecentAppLayouts) sharedInstance];
        NSMutableArray *recentAppLayouts = [NSMutableArray new];
        recentAppLayouts = [recentLayouts _recentsFromPrefs];
        for (SBAppLayout *appLayout in recentAppLayouts) {
            [holding addObjectsFromArray:appLayout.allItems];
        }
    } else {
        SBAppSwitcherModel *switcherModel =
        [%c(SBAppSwitcherModel) sharedInstance];
        holding = [switcherModel _recentsFromPrefs];
    }
    
    if ([holding count] == 0 && [self.switcherItems count] == 0) {
        self.switcherItems = nil;
        [self reloadData];
    } else {
        
        self.switcherItems = holding;
        [UIView animateWithDuration:0.5
                              delay:0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
         [self reloadData];
         [self layoutIfNeeded];
         [self updateCellsLayout];
         }
                         completion:^(BOOL finished) {
         [UIView animateWithDuration:0.3
                               delay:0
                             options:UIViewAnimationOptionCurveEaseInOut
                          animations:^{
          [self updateCellsLayout];
          }
                          completion:nil];
         }];
    }
}
- (UIImage *)squareImageFromImage:(UIImage *)image {
    return [[UIImage alloc]
            initWithCGImage:CGImageCreateWithImageInRect(
                                                         image.CGImage, CGRectMake(0, 0, image.size.width,
                                                                                   image.size.width))];
}

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
- (NSInteger)numberOfSectionsInCollectionView:
(UICollectionView *)collectionView {
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
numberOfItemsInSection:(NSInteger)section {
    int count = self.switcherItems.count;
    
    if (count > 0) {
        return count;
    } else {
        return 1;
    }
}
/////https://stackoverflow.com/a/29266983
- (NSArray *)mainColoursInImage:(UIImage *)image detail:(int)detail {
    
    // 1. determine detail vars (0==low,1==default,2==high)
    // default detail
    float dimension = 10;
    float flexibility = 2;
    float range = 60;
    
    // low detail
    if (detail == 0) {
        dimension = 4;
        flexibility = 1;
        range = 100;
        
        // high detail (patience!)
    } else if (detail == 2) {
        dimension = 100;
        flexibility = 10;
        range = 20;
    }
    
    // 2. determine the colours in the image
    NSMutableArray *colours = [NSMutableArray new];
    CGImageRef imageRef = [image CGImage];
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char *rawData = (unsigned char *)calloc(dimension * dimension * 4,
                                                     sizeof(unsigned char));
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * dimension;
    NSUInteger bitsPerComponent = 8;
    CGContextRef context = CGBitmapContextCreate(
                                                 rawData, dimension, dimension, bitsPerComponent, bytesPerRow,
                                                 colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    CGContextDrawImage(context, CGRectMake(0, 0, dimension, dimension),
                       imageRef);
    CGContextRelease(context);
    
    float x = 0;
    float y = 0;
    for (int n = 0; n < (dimension * dimension); n++) {
        
        int index = (bytesPerRow * y) + x * bytesPerPixel;
        int red = rawData[index];
        int green = rawData[index + 1];
        int blue = rawData[index + 2];
        int alpha = rawData[index + 3];
        NSArray *a = [NSArray
                      arrayWithObjects:[NSString stringWithFormat:@"%i", red],
                      [NSString stringWithFormat:@"%i", green],
                      [NSString stringWithFormat:@"%i", blue],
                      [NSString stringWithFormat:@"%i", alpha], nil];
        [colours addObject:a];
        
        y++;
        if (y == dimension) {
            y = 0;
            x++;
        }
    }
    free(rawData);
    
    // 3. add some colour flexibility (adds more colours either side of the
    // colours in the image)
    NSArray *copyColours = [NSArray arrayWithArray:colours];
    NSMutableArray *flexibleColours = [NSMutableArray new];
    
    float flexFactor = flexibility * 2 + 1;
    float factor = flexFactor * flexFactor * 3; //(r,g,b) == *3
    for (int n = 0; n < (dimension * dimension); n++) {
        
        NSArray *pixelColours = copyColours[n];
        NSMutableArray *reds = [NSMutableArray new];
        NSMutableArray *greens = [NSMutableArray new];
        NSMutableArray *blues = [NSMutableArray new];
        
        for (int p = 0; p < 3; p++) {
            
            NSString *rgbStr = pixelColours[p];
            int rgb = [rgbStr intValue];
            
            for (int f = -flexibility; f < flexibility + 1; f++) {
                int newRGB = rgb + f;
                if (newRGB < 0) {
                    newRGB = 0;
                }
                if (p == 0) {
                    [reds addObject:[NSString stringWithFormat:@"%i", newRGB]];
                } else if (p == 1) {
                    [greens
                     addObject:[NSString stringWithFormat:@"%i", newRGB]];
                } else if (p == 2) {
                    [blues addObject:[NSString stringWithFormat:@"%i", newRGB]];
                }
            }
        }
        
        int r = 0;
        int g = 0;
        int b = 0;
        for (int k = 0; k < factor; k++) {
            
            int red = [reds[r] intValue];
            int green = [greens[g] intValue];
            int blue = [blues[b] intValue];
            
            NSString *rgbString =
            [NSString stringWithFormat:@"%i,%i,%i", red, green, blue];
            [flexibleColours addObject:rgbString];
            
            b++;
            if (b == flexFactor) {
                b = 0;
                g++;
            }
            if (g == flexFactor) {
                g = 0;
                r++;
            }
        }
    }
    
    // 4. distinguish the colours
    // orders the flexible colours by their occurrence
    // then keeps them if they are sufficiently disimilar
    
    NSMutableDictionary *colourCounter = [NSMutableDictionary new];
    
    // count the occurences in the array
    NSCountedSet *countedSet =
    [[NSCountedSet alloc] initWithArray:flexibleColours];
    for (NSString *item in countedSet) {
        NSUInteger count = [countedSet countForObject:item];
        [colourCounter setValue:[NSNumber numberWithInteger:count] forKey:item];
    }
    
    // sort keys highest occurrence to lowest
    NSArray *orderedKeys = [colourCounter
                            keysSortedByValueUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                            return [obj2 compare:obj1];
                            }];
    
    // checks if the colour is similar to another one already included
    NSMutableArray *ranges = [NSMutableArray new];
    for (NSString *key in orderedKeys) {
        NSArray *rgb = [key componentsSeparatedByString:@","];
        int r = [rgb[0] intValue];
        int g = [rgb[1] intValue];
        int b = [rgb[2] intValue];
        bool exclude = false;
        for (NSString *ranged_key in ranges) {
            NSArray *ranged_rgb = [ranged_key componentsSeparatedByString:@","];
            
            int ranged_r = [ranged_rgb[0] intValue];
            int ranged_g = [ranged_rgb[1] intValue];
            int ranged_b = [ranged_rgb[2] intValue];
            
            if (r >= ranged_r - range && r <= ranged_r + range) {
                if (g >= ranged_g - range && g <= ranged_g + range) {
                    if (b >= ranged_b - range && b <= ranged_b + range) {
                        exclude = true;
                    }
                }
            }
        }
        
        if (!exclude) {
            [ranges addObject:key];
        }
    }
    
    // return ranges array here if you just want the ordered colours high to low
    NSMutableArray *colourArray = [NSMutableArray new];
    for (NSString *key in ranges) {
        NSArray *rgb = [key componentsSeparatedByString:@","];
        float r = [rgb[0] floatValue];
        float g = [rgb[1] floatValue];
        float b = [rgb[2] floatValue];
        UIColor *colour = [UIColor colorWithRed:(r / 255.0f)
                                          green:(g / 255.0f)
                                           blue:(b / 255.0f)
                                          alpha:1.0f];
        [colourArray addObject:colour];
    }
    
    // if you just want an array of colours of most common to least, return here
    return colourArray;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HSAppCardCell *cell;
    
    cell =
    [collectionView dequeueReusableCellWithReuseIdentifier:@"switcherCell"
                                              forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    
    int count = [self.switcherItems count];
    if (count == 0) {
        
        cell.bundleID = nil;
        cell.indexPath = nil;
        cell.iconImageView.image = nil;
        cell.appNameLabel.text = nil;
        cell.appImageView.image = nil;
        cell.appImageView.backgroundColor = UIColor.clearColor;
        cell.zoomView.layer.shadowColor = UIColor.clearColor.CGColor;
        cell.blurView.hidden = YES;
    } else {
        
        NSString *bundleID =
        [self.switcherItems[indexPath.row] displayIdentifier];
        cell.bundleID = bundleID;
        cell.indexPath = indexPath;
        
        if ([self.blurAppsList containsObject:cell.bundleID]) {
            cell.blurView.hidden = NO;
            
        } else {
            cell.blurView.hidden = YES;
        }
        
        LSApplicationProxy *appProxy =
        [%c(LSApplicationProxy) applicationProxyForIdentifier:bundleID];
        
        cell.iconImageView.image = [UIImage
                                    _applicationIconImageForBundleIdentifier:bundleID
                                    format:1
                                    scale:UIScreen.mainScreen.scale];
        
        cell.appNameLabel.text = appProxy.localizedName;
        
        NSURL *appDocs = appProxy.dataContainerURL;
        NSString *pathToSnaps;
        if (appDocs) {
            pathToSnaps = [NSString
                           stringWithFormat:@"%@/Library/Caches/Snapshots/%@/downscaled",
                           appDocs.path, bundleID];
        } else {
            pathToSnaps =
            [NSString stringWithFormat:@"/private/var/mobile/Library/"
             @"Caches/Snapshots/%@/%@/downscaled",
             bundleID, bundleID];
        }
        NSArray<NSString *> *appSnaps =
        [NSFileManager.defaultManager contentsOfDirectoryAtPath:pathToSnaps
                                                          error:NULL];
        
        UIImage *snapshotImage = [UIImage
                                  imageWithContentsOfFile:[pathToSnaps stringByAppendingPathComponent:
                                                           appSnaps.firstObject]];
        
        if (snapshotImage.size.width > snapshotImage.size.height) {
            snapshotImage = [UIImage
                             imageWithContentsOfFile:
                             [pathToSnaps
                              stringByAppendingPathComponent:appSnaps.lastObject]];
        }
        
        UIImage *squareSnapshotImage =
        [self imageWithImage:snapshotImage
                scaledToSize:CGSizeMake(cell.appImageView.frame.size.width,
                                        cell.appImageView.frame.size.width *
                                        1.78)];
        cell.appImageView.contentMode = UIViewContentModeTopLeft;
        
        cell.appImageView.image = squareSnapshotImage;
        
        UIColor *leastCommon =
        [[self mainColoursInImage:cell.iconImageView.image
                           detail:0] lastObject];
        
        cell.appImageView.backgroundColor = leastCommon;
        
        cell.zoomView.layer.shadowColor = leastCommon.CGColor;
        cell.zoomView.layer.shadowRadius = shadowRadius;
    }
    
    if (self.verticalMode) {
        
        double centerY = self.contentOffset.y + (self.bounds.size.height) / 2;
        
        double offsetY = centerY - cell.center.y;
        if (offsetY < 0) {
            offsetY *= -1;
        }
        cell.transform = CGAffineTransformIdentity;
        double offsetPercentage = offsetY / viewAreaHeight;
        CGFloat scaleY = (CGFloat)(1.0f - offsetPercentage);
        
        cell.transform = CGAffineTransformMakeScale(scaleY, scaleY);
        
    } else {
        
        double centerX = self.contentOffset.x + (self.frame.size.width) / 2;
        
        double offsetX = centerX - cell.center.x;
        if (offsetX < 0) {
            offsetX *= -1;
        }
        
        cell.transform = CGAffineTransformIdentity;
        double offsetPercentage = offsetX / viewAreaWidth;
        CGFloat scaleX = (CGFloat)(1.0f - offsetPercentage);
        
        cell.transform = CGAffineTransformMakeScale(scaleX, scaleX);
    }
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
layout:(UICollectionViewLayout *)collectionViewLayout
sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(cellWidth, cellHeight);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
layout:(UICollectionViewLayout *)collectionViewLayout
insetForSectionAtIndex:(NSInteger)section {
    if (self.verticalMode) {
        return UIEdgeInsetsMake(pageStartInset, 0, pageStartInset, 0);
    } else {
        return UIEdgeInsetsMake(0, pageStartInset, 0, pageStartInset);
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    float currentOffset;
    if (self.verticalMode) {
        currentOffset = scrollView.contentOffset.y;
    } else {
        currentOffset = scrollView.contentOffset.x;
    }
    if (currentOffset < 0) {
        
        [self scrollToStart];
        [self updateCellsLayout];
    } else {
        [self updateCellsLayout];
    }
}
- (void)scrollToStartAnimated {
    [UIView animateWithDuration:0.5
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
     [self scrollToStart];
     }
                     completion:^(BOOL finished) {
     [UIView animateWithDuration:0.5
                           delay:0
                         options:UIViewAnimationOptionCurveEaseInOut
                      animations:^{
      [self updateCellsLayout];
      }
                      completion:nil];
     }];
}
- (void)scrollToStart {
    
    [self setContentOffset:CGPointMake(0, 0) animated:NO];
}

- (void)scrollToCenterAnimated {
    [UIView animateWithDuration:0.8
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
     [self scrollToCenter];
     }
                     completion:^(BOOL finished) {
     [UIView animateWithDuration:0.5
                           delay:0
                         options:UIViewAnimationOptionCurveEaseInOut
                      animations:^{
      [self updateCellsLayout];
      }
                      completion:nil];
     }];
}

- (void)scrollToCenter {
    
    if ([self.switcherItems count] == 1) {
        [self setContentOffset:CGPointMake(0, 0) animated:NO];
    } else {
        if (self.verticalMode) {
            [self
             setContentOffset:CGPointMake(
                                          0, cellHeight *
                                          floor(([self.switcherItems count] -
                                                 1) /
                                                2))
             animated:NO];
        } else {
            [self setContentOffset:CGPointMake(
                                               cellWidth *
                                               floor(([self.switcherItems count] -
                                                      1) /
                                                     2),
                                               0)
                          animated:NO];
        }
    }
}

- (void)scrollToEndAnimated {
    [UIView animateWithDuration:0.5
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
     [self scrollToEnd];
     [self updateCellsLayout];
     }
                     completion:^(BOOL finished) {
     [UIView animateWithDuration:0.5
                           delay:0
                         options:UIViewAnimationOptionCurveEaseInOut
                      animations:^{
      [self updateCellsLayout];
      }
                      completion:nil];
     }];
}

- (void)scrollToEnd {
    
    if (self.verticalMode) {
        [self setContentOffset:CGPointMake(0, self.contentSize.height -
                                           viewAreaHeight)
                      animated:NO];
    } else {
        [self setContentOffset:CGPointMake(
                                           self.contentSize.width - viewAreaWidth, 0)
                      animated:NO];
    }
}
- (void)updateCellsLayout {
    
    if (self.verticalMode) {
        
        double centerY = self.contentOffset.y + (self.bounds.size.height) / 2;
        for (HSAppCardCell *cell in self.visibleCells) {
            
            double offsetY = centerY - cell.center.y;
            if (offsetY < 0) {
                offsetY *= -1;
            }
            
            cell.transform = CGAffineTransformIdentity;
            double offsetPercentage = offsetY / viewAreaHeight;
            CGFloat scaleY = (CGFloat)(1.0f - offsetPercentage);
            
            cell.transform = CGAffineTransformMakeScale(scaleY, scaleY);
        }
    } else {
        
        double centerX = self.contentOffset.x + (self.frame.size.width) / 2;
        for (HSAppCardCell *cell in self.visibleCells) {
            
            double offsetX = centerX - cell.center.x;
            if (offsetX < 0) {
                offsetX *= -1;
            }
            
            cell.transform = CGAffineTransformIdentity;
            double offsetPercentage = offsetX / viewAreaWidth;
            CGFloat scaleX = (CGFloat)(1.0f - offsetPercentage);
            
            cell.transform = CGAffineTransformMakeScale(scaleX, scaleX);
        }
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView
withVelocity:(CGPoint)velocity
targetContentOffset:(inout CGPoint *)targetContentOffset {
    if (!freeFlowScrolling) {
        
        if (self.verticalMode) {
            float currentOffset = scrollView.contentOffset.y;
            float targetOffset = targetContentOffset->y;
            float newTargetOffset = 0;
            
            if (targetOffset > currentOffset) {
                newTargetOffset =
                ceilf(currentOffset / scrollStartPoint) * scrollStartPoint;
            } else {
                newTargetOffset =
                floorf(currentOffset / scrollStartPoint) * scrollStartPoint;
            }
            if (newTargetOffset < 0) {
                newTargetOffset = 0;
            } else if (newTargetOffset > scrollView.contentSize.height) {
                newTargetOffset = scrollView.contentSize.height;
            }
            targetContentOffset->y = currentOffset;
            [scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x,
                                                     newTargetOffset)
                                animated:YES];
            float target = targetContentOffset->x;
            float remainder = target / cellHeight;
            targetCellIndex = lroundl(remainder);
        } else {
            
            float currentOffset = scrollView.contentOffset.x;
            float targetOffset = targetContentOffset->x;
            float newTargetOffset = 0;
            
            if (targetOffset > currentOffset) {
                newTargetOffset =
                ceilf(currentOffset / scrollStartPoint) * scrollStartPoint;
            } else {
                newTargetOffset =
                floorf(currentOffset / scrollStartPoint) * scrollStartPoint;
            }
            if (newTargetOffset < 0) {
                newTargetOffset = 0;
            } else if (newTargetOffset > scrollView.contentSize.width) {
                newTargetOffset = scrollView.contentSize.width;
            }
            targetContentOffset->x = currentOffset;
            [scrollView setContentOffset:CGPointMake(newTargetOffset,
                                                     scrollView.contentOffset.y)
                                animated:YES];
            float target = targetContentOffset->x;
            float remainder = target / cellWidth;
            targetCellIndex = lroundl(remainder);
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (!freeFlowScrolling) {
        [self
         scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:targetCellIndex
                                                    inSection:0]
         atScrollPosition:
         UICollectionViewScrollPositionCenteredHorizontally
         animated:YES];
    }
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    
    for (UIView *subview in self.subviews) {
        if ([subview hitTest:[self convertPoint:point toView:subview]
                   withEvent:event] != nil) {
            return YES;
        }
    }
    return NO;
}

@end

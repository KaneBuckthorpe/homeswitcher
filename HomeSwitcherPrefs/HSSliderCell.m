#import "HSSliderCell.h"

@implementation HSSliderCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(id)identifier specifier:(PSSpecifier*)specifier {
	self = [super initWithStyle:style reuseIdentifier:identifier specifier:specifier];
    if (self) {


        UISlider *slider = (UISlider *)[self control];
        [slider addTarget:specifier.target action:@selector(sliderMoved:) forControlEvents:UIControlEventAllTouchEvents];

slider.maximumValue=10;
    }
    return self;
}

- (void)refreshCellContentsWithSpecifier:(PSSpecifier *)specifier {
  [super refreshCellContentsWithSpecifier:specifier];

}

@end
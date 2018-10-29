#import <Preferences/PSSliderTableCell.h>
#import <Preferences/PSControlTableCell.h>
#import <Preferences/PSSpecifier.h>
#import <objc/runtime.h>
@interface HSSliderCell : PSSliderTableCell
    @end

@interface UISpecifierSlider : UISlider {
    id userData;
}
    
    @property (nonatomic, readwrite, retain) id userData;
    @end


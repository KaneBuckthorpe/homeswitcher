#import <Preferences/PSControlTableCell.h>
#import <Preferences/PSSpecifier.h>
@interface PSStepperCell : PSControlTableCell {
    NSString *title;
    
}
    @property (nonatomic, retain) UIStepper *control;
    @end

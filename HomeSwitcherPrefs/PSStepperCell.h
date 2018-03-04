#import <Preferences/PSControlTableCell.h>

@interface PSStepperCell : PSControlTableCell {
    NSString *title;
}
@property (nonatomic, retain) UIStepper *control;
@end

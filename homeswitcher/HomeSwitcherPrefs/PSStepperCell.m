#import "PSStepperCell.h"

@implementation PSStepperCell
    
    @dynamic control;
    
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier specifier:(PSSpecifier *)specifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier specifier:specifier]) {
        self.accessoryView = self.control;
        self.detailTextLabel.hidden = NO;
        self.control.minimumValue = [[specifier propertyForKey:@"minValue"] doubleValue];
        
    }
    return self;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    
    CGRect detailTextLabelFrame = self.detailTextLabel.frame;
    detailTextLabelFrame =CGRectMake(15, 0, 200, self.frame.size.height);
    self.detailTextLabel.frame = detailTextLabelFrame;
    
    CGRect accessoryViewFrame = self.accessoryView.frame;
    accessoryViewFrame.origin.x = self.frame.size.width-(self.accessoryView.frame.size.width+15);
    accessoryViewFrame.size.height = self.frame.size.height;
    self.accessoryView.frame = accessoryViewFrame;
    
    
    self.detailTextLabel.textColor = [UIColor blackColor];
    self.detailTextLabel.textAlignment = 0;
    
    self.textLabel.textColor = [UIColor redColor];
    CGRect numberFrame=CGRectMake(detailTextLabelFrame.size.width+detailTextLabelFrame.origin.x, 0, 100 ,self.frame.size.height);
    self.textLabel.frame=numberFrame;
}
    
- (void)refreshCellContentsWithSpecifier:(PSSpecifier *)specifier {
    [super refreshCellContentsWithSpecifier:specifier];
    title = [specifier propertyForKey:@"label"];
    
    [self _updateLabel];
    self.detailTextLabel.text = title;
    self.textLabel.textColor = [UIColor redColor];
}
    
- (UIStepper *)newControl {
    UIStepper *stepper = [[UIStepper alloc] initWithFrame:CGRectZero];
    
    stepper.continuous = NO;
    stepper.maximumValue = 100;
    stepper.stepValue=10;
    stepper.value =50;
    ///stepper.minimumValue = 0;
    return stepper;
}
    
- (NSNumber *)controlValue {
    return @(self.control.value);
}
    
- (void)setValue:(NSNumber *)value {
    [super setValue:value];
    self.control.value = value.doubleValue;
}
    
- (void)controlChanged:(UIStepper *)stepper {
    [super controlChanged:stepper];
    [self _updateLabel];
}
    
- (void)_updateLabel {
    if (!self.control) {
        return;
    }
    
    float value =self.control.value;
    
    self.textLabel.text = [NSString stringWithFormat:@"%.0f%%", value];
    [self setNeedsLayout];
}
    
    @end

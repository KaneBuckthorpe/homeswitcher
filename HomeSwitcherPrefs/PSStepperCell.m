#import "PSStepperCell.h"

@implementation PSStepperCell

@dynamic control;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier specifier:(PSSpecifier *)specifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier specifier:specifier]) {
        self.accessoryView = self.control;
        self.detailTextLabel.hidden = NO;
    }
    return self;
}
-(void)layoutSubviews{
[super layoutSubviews];

CGRect accessoryViewFrame = self.accessoryView.frame;
accessoryViewFrame.origin.x = (self.frame.size.width-self.accessoryView.frame.size.width)-14;
accessoryViewFrame.size.height = self.frame.size.height;
self.accessoryView.frame = accessoryViewFrame;

CGRect detailTextLabelFrame = self.detailTextLabel.frame;
detailTextLabelFrame =CGRectMake(14, 0, self.frame.size.width/2, self.frame.size.height);
self.detailTextLabel.frame = detailTextLabelFrame;
    self.detailTextLabel.text = @"AppCard Size Scale:";
self.detailTextLabel.textColor = [UIColor blackColor]; 
self.detailTextLabel.textAlignment = 0; 

self.textLabel.textColor = [UIColor redColor]; 
CGRect numberFrame=CGRectMake(detailTextLabelFrame.size.width+detailTextLabelFrame.origin.x+14, 0, 40 ,self.frame.size.height);
self.textLabel.frame=numberFrame;
}

- (void)refreshCellContentsWithSpecifier:(PSSpecifier *)specifier {
    [super refreshCellContentsWithSpecifier:specifier];
    title = [specifier propertyForKey:@"label"];
    [self _updateLabel];
self.textLabel.textColor = [UIColor redColor]; 
}

- (UIStepper *)newControl {
    UIStepper *stepper = [[UIStepper alloc] initWithFrame:CGRectZero];
    stepper.continuous = NO;
    stepper.value = 3;
stepper.stepValue=1;
    stepper.minimumValue =1;
stepper.maximumValue = 10;

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

    float value =self.control.value/10;

    self.textLabel.text = [NSString stringWithFormat:@"%.1f", value];
    [self setNeedsLayout];
}

@end

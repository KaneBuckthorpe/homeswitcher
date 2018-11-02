#import "KBAppListCell.h"

@implementation KBAppListCell
- (id)initWithStyle:(UITableViewCellStyle)style
reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        float cellHeight = 60;
        float cellWidth = self.contentView.frame.size.width;
        
        self.contentView.frame = self.frame;
        
        self.appIconView = [[UIImageView alloc]
                            initWithFrame:CGRectMake(10, 10, cellHeight - 20, cellHeight - 20)];
        
        self.appName = [[UILabel alloc]
                        initWithFrame:CGRectMake(self.appIconView.frame.origin.x +
                                                 self.appIconView.frame.size.width + 10,
                                                 10, cellWidth, cellHeight - 20)];
        self.appName.textColor = [UIColor blackColor];
        self.appName.font = [UIFont fontWithName:@"Arial" size:18.0f];
        
        self.checkBoxView = [[UIImageView alloc]
                             initWithFrame:CGRectMake(cellWidth - 15, (cellHeight / 2) - 7.5, 15,
                                                      15)];
        
        [self.contentView addSubview:self.checkBoxView];
        
        [self.contentView addSubview:self.appName];
        [self.contentView addSubview:self.appIconView];
    }
    return self;
}

@end

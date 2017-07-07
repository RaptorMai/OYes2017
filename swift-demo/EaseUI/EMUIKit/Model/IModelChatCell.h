
#import <Foundation/Foundation.h>

#import "IModelCell.h"

@protocol IModelChatCell <NSObject,IModelCell>

@required

@property (strong, nonatomic) id model;

@optional

- (BOOL)isCustomBubbleView:(id)model;

- (void)setCustomBubbleView:(id)model;

- (void)setCustomModel:(id)model;

- (void)updateCustomBubbleViewMargin:(UIEdgeInsets)bubbleMargin model:(id)mode;

@optional

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
                        model:(id)model;

@end

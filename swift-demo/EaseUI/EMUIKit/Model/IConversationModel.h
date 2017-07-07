
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@class EMConversation;
@protocol IConversationModel <NSObject>

@property (strong, nonatomic, readonly) EMConversation *conversation;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *avatarURLPath;
@property (strong, nonatomic) UIImage *avatarImage;

- (instancetype)initWithConversation:(EMConversation *)conversation;

@end

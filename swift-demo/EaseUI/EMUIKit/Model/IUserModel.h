
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@class EMusername;
@protocol IUserModel <NSObject>

@property (strong, nonatomic, readonly) NSString *username;
@property (strong, nonatomic) NSString *nickname;
@property (strong, nonatomic) NSString *avatarURLPath;
@property (strong, nonatomic) UIImage *avatarImage;
@property (nonatomic) int unreadMessageCount;

- (instancetype)initWithUsername:(NSString *)username;

@end

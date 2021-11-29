#import "BaseObject.h"

@interface Plan : BaseJSONModel

@property (nonatomic , assign) NSInteger              duration;
@property (nonatomic , copy) NSString              * stage;

- (BOOL)isEqualToPlan:(Plan *)plan;

@end

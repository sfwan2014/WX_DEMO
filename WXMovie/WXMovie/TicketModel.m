//
//  TicketListModel.m
//  WXMovie
//
//  Created by wei.chen on 13-9-9.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "TicketModel.h"

@implementation TicketModel

- (void)setAttributes:(NSDictionary *)dic {
    [super setAttributes:dic];
    
    self.ticketId = [dic objectForKey:@"id"];
}
@end

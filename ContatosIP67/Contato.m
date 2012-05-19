//
//  Contato.m
//  ContatosIP67
//
//  Created by ios2736 on 12/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Contato.h"

@implementation Contato
@synthesize nome, email, telefone, endereco, site, twitter, imagem;

- (NSString *)description
{
    NSString *string = [[NSString alloc] initWithFormat:@"%@ - %@", email, twitter];
    return string;
}

@end

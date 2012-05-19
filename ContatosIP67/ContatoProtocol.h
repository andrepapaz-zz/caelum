//
//  ContatoProtocol.h
//  ContatosIP67
//
//  Created by ios2736 on 12/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Contato.h"

@protocol ContatoProtocol <NSObject>

- (void) contatoAdicionado: (Contato *) contato;

- (void) contatoAlteradoComSucesso;

@end

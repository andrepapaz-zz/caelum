//
//  ListagemContatosController.h
//  ContatosIP67
//
//  Created by ios2736 on 12/05/05.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <MessageUI/MFMessageComposeViewController.h>
#import "ContatoProtocol.h"

@interface ListagemContatosController : UITableViewController <ContatoProtocol, UIActionSheetDelegate, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate>
{
    Contato* contatoSelecionado;
}

@property (strong, nonatomic) NSMutableArray *contatos;

- (void) exibeMaisAcoes:(UIGestureRecognizer *) gesture;

@end

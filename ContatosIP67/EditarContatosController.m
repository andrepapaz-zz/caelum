//
//  EditarContatosController.m
//  ContatosIP67
//
//  Created by ios2736 on 12/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EditarContatosController.h"
#import "Contato.h"

@interface EditarContatosController()

@property(nonatomic,strong) Contato *contato;

- (void) preencheFormularioComContato;

@end

@implementation EditarContatosController

@synthesize contato;

- (id)initWithContato:(Contato *)_contato
{
    self = [super initWithNibName:@"FormularioContatoController" bundle:[NSBundle mainBundle]];
    
    if (self) {
        [self setContato:_contato];
        
    }
    
    return self;
}

- (void)viewDidLoad
{
    [self setTitle:@"Editar Contato"];
    
    UIBarButtonItem *alterar = [[UIBarButtonItem alloc] initWithTitle:@"Alterar" style:UIBarButtonItemStylePlain target:self action:@selector(alterar)];
    
    [[self navigationItem] setRightBarButtonItem:alterar];
    
    [self preencheFormularioComContato];
    
}

- (void) preencheFormularioComContato
{
    [[self nome] setText:[contato nome]];
    [[self endereco] setText:[contato endereco]];
    [[self site] setText:[contato site]];
    [[self email] setText:[contato email]];
    [[self telefone] setText:[contato telefone]];
    [[self twitter] setText:[contato twitter]];
    
    UIImage *img = [contato imagem];
    
    [[self botaoAdicionaImagem] setImage:img forState:UIControlStateNormal];
}

- (void) alterar
{
    [contato setNome:[[self nome] text]];
    [contato setEndereco:[[self endereco] text]];
    [contato setEmail:[[self email] text]];
    [contato setTelefone:[[self telefone] text]];
    [contato setSite:[[self site] text]];
    [contato setTwitter:[[self twitter] text]];
    
    [contato setImagem:self.botaoAdicionaImagem.imageView.image];
    
    [[self delegate] contatoAlteradoComSucesso];
    [[self navigationController] popViewControllerAnimated:YES];
    
}

@end

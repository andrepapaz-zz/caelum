//
//  FormularioContatoController.m
//  ContatosIP67
//
//  Created by ios2736 on 12/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FormularioContatoController.h"
#import "Contato.h"

@implementation FormularioContatoController

@synthesize delegate;

@synthesize nome;
@synthesize email;
@synthesize telefone;
@synthesize endereco;
@synthesize site;
@synthesize twitter;
@synthesize botaoAdicionaImagem;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"Adicionar Contato"];
    UIBarButtonItem *voltar = [[UIBarButtonItem alloc] initWithTitle:@"Voltar" style:UIBarButtonItemStylePlain target:self action:@selector(voltar)];
    
    [[self navigationItem] setLeftBarButtonItem:voltar];
    
    UIBarButtonItem *adicionar = [[UIBarButtonItem alloc] initWithTitle:@"Adicionar" style:UIBarButtonItemStylePlain target:self action:@selector(adicionar)];
    
    [[self navigationItem] setRightBarButtonItem:adicionar];
    
    // Do any additional setup after loading the view from its nib.
}

- (void) voltar
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void) adicionar
{
    Contato *contato = [[Contato alloc] init];
    
    [contato setNome:[nome text]];
    [contato setEndereco:[endereco text]];
    [contato setEmail:[email text]];
    [contato setTelefone:[telefone text]];
    [contato setSite:[site text]];
    [contato setTwitter:[twitter text]];
    
    [delegate contatoAdicionado:contato];
    
    [self dismissModalViewControllerAnimated:YES];
}

- (Contato *) criaContaComDadosDoFormulario
{
    Contato *contato = [[Contato alloc] init];
    
    [contato setNome:[nome text]];
    [contato setEndereco:[endereco text]];
    [contato setEmail:[email text]];
    [contato setTelefone:[telefone text]];
    [contato setSite:[site text]];
    [contato setTwitter:[twitter text]];
    [contato setImagem:botaoAdicionaImagem.imageView.image];
    
    return contato;
}

- (void)viewDidUnload
{
    [self setNome:nil];
    [self setEmail:nil];
    [self setTelefone:nil];
    [self setEndereco:nil];
    [self setSite:nil];
    [self setTwitter:nil];
    [self setBotaoAdicionaImagem:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)selecionaFoto:(id)sender {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"Escolha a foto do contato" delegate:self cancelButtonTitle:@"Cancelar" destructiveButtonTitle:nil otherButtonTitles:@"Tirar Foto", @"Escolher na Biblioteca", nil];
        
        [sheet showInView:[self view]];
        
    } else {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        [picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        [picker setAllowsEditing:YES];
        [picker setDelegate:self];
        [self presentModalViewController:picker animated:YES];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    [picker setDelegate:self];
    [picker setAllowsEditing:YES];
    
    switch (buttonIndex) {
        case 0:
            [picker setSourceType:UIImagePickerControllerSourceTypeCamera];
            break;
        case 1:
            [picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
            break;
        default:
            return;
    }
    
    [self presentModalViewController:picker animated:YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *imagemSelecionada = [info valueForKey:UIImagePickerControllerEditedImage];
    [botaoAdicionaImagem setImage:imagemSelecionada forState:UIControlStateNormal];
    [picker dismissModalViewControllerAnimated:YES];
}

@end

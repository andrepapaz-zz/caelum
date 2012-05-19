//
//  ListagemContatosController.m
//  ContatosIP67
//
//  Created by ios2736 on 12/05/05.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ListagemContatosController.h"
#import "Contato.h"
#import "FormularioContatoController.h"
#import "EditarContatosController.h"

@interface ListagemContatosController()
// Outro exemplo de versão de xcode que não entende a chamada de metodo que está abaixo da chamada, então declaro ele aqui como metodo privado e consigo utilizar.
- (void) abrirSite;
- (void) mostrarMapa;
- (void) enviarEmail;
- (void) enviarSMS;
@end

@implementation ListagemContatosController

@synthesize contatos;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"Contatos"];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(exibeMaisAcoes:)];
    
    [[self tableView] addGestureRecognizer:longPress];
    
    [[self navigationItem] setLeftBarButtonItem:[self editButtonItem]];
    
    UIBarButtonItem *adicionar = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(mostraFormContato)];
    [[self navigationItem] setRightBarButtonItem:adicionar];

}

- (void)exibeMaisAcoes:(UIGestureRecognizer *)gesture
{
    if ([gesture state] == UIGestureRecognizerStateBegan) {
        CGPoint ponto = [gesture locationInView:[self tableView]];
        NSIndexPath *index = [[self tableView] indexPathForRowAtPoint:ponto];
        
        Contato *contato = [contatos objectAtIndex:[index row]];
        
        contatoSelecionado = contato;
        
        UIActionSheet *opcoes = [[UIActionSheet alloc] initWithTitle:[contato nome] delegate:self cancelButtonTitle:@"Cancelar" destructiveButtonTitle:nil otherButtonTitles:@"Ligar", @"Enviar Email", @"Visualizar site", @"Abrir mapa", @"Enviar SMS", nil];
        [opcoes showInView:[self view]];
    }
}

// Foi necessário definir antes do metodo ligar pois dependendo da versão do Xcode ele vai ler de cima para baixo e não entende que está declarado.
- (void)abrirAplicativoComURL:(NSString *)url
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}


- (void) ligar
{
    UIDevice *device = [UIDevice currentDevice];
    if ([[device model] isEqualToString:@"iPhone"]) {
        NSString *numero = [NSString stringWithFormat:@"tel:%@", [contatoSelecionado telefone]];
        // Como está chamando depois da declaração ele concegue achar
        [self abrirAplicativoComURL:numero];
    } else
    {
        UIAlertView *alerta =  [[UIAlertView alloc] initWithTitle:@"Impossível fazer ligação" message:@"Seu dispositivo não é um iPhone" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alerta show];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    switch (buttonIndex) {
        case 0:
            [self ligar];
            break;
        case 1:
            [self enviarEmail];
            break;
        case 2:
            [self abrirSite];
            break;
        case 3:
            [self mostrarMapa];
            break;
        case 4:
            [self enviarSMS];
            break;
        default:
            break;
    }
    
}

// Como eu declarei ele lá em cima para que entendece a chamada no método acima, ele consegue entender aqui.
- (void) abrirSite
{
    NSString *url = [contatoSelecionado site];
    [self abrirAplicativoComURL:url];
}

- (void)mostrarMapa
{
    NSString *url = [[NSString stringWithFormat:@"http://maps.google.com/maps?q=%@", [contatoSelecionado endereco]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self abrirAplicativoComURL:url];
}

- (void)enviarEmail
{
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *enviadorEmail = [[MFMailComposeViewController alloc] init];
        [enviadorEmail setMailComposeDelegate:self];
        
        [enviadorEmail setToRecipients:[NSArray arrayWithObject:[contatoSelecionado email]]];
        [enviadorEmail setSubject:@"Caelum"];
        
        [self presentModalViewController:enviadorEmail animated:YES];
        
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ops" message:@"You cannot send an email" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        
        [alert show];
    }
}

- (void)enviarSMS
{
    if ([MFMessageComposeViewController canSendText]) {
        MFMessageComposeViewController *enviadorSMS = [[MFMessageComposeViewController alloc]init];
        
        [enviadorSMS setMessageComposeDelegate:self];
        [enviadorSMS setTitle:@"Caelum"];
        [enviadorSMS setRecipients:[NSArray arrayWithObject:[contatoSelecionado telefone]]];
        
        
        [self presentModalViewController:enviadorSMS animated:YES];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ops" message:@"You cannot send an SMS" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        
        [alert show];

    }
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Contato *c = [contatos objectAtIndex:[indexPath row]];
    
    EditarContatosController *editarContato = [[EditarContatosController alloc] initWithContato:c];
    
    [editarContato setDelegate:self];
    
    [[self navigationController] pushViewController:editarContato animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [contatos removeObjectAtIndex:[indexPath row]];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    Contato *c = [contatos objectAtIndex:[sourceIndexPath row]];
    
    [contatos removeObjectAtIndex:[sourceIndexPath row]];
    
    [contatos insertObject:c atIndex:[destinationIndexPath row]];
    
}

- (void) mostraFormContato
{
    FormularioContatoController *formularioContatos = [[FormularioContatoController alloc] init];
    
    [formularioContatos setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    
    [formularioContatos setDelegate:self];
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:formularioContatos];
    
    [self presentModalViewController:navigationController animated:YES];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [contatos count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    Contato *c = [contatos objectAtIndex:[indexPath row]];
    
    [[cell textLabel] setText:[c nome]];
    [[cell detailTextLabel] setText:[c description]];
    
    return cell;
}

- (void) contatoAdicionado:(Contato *)contato
{
    [contatos addObject:contato];
    [[self tableView] reloadData];
}

- (void) contatoAlteradoComSucesso
{
    [[self tableView] reloadData];
}

@end

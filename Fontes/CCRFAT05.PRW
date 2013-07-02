#include "rwmake.ch"                                                                                                              
/*                                      
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±          
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CCRFAT05  ºAutor  ³Paulo Elias         º Data ³  04/06/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Gatilho que verifica o estado do cliente de entrega X       º±±          
±±º          ³estado do cliente de faturamento.                           º±±             
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifica CCAB                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CCRFAT05()                        

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Guarda Ambiente                                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

_cAlias1	:= ALIAS()
_nRecno1	:= RECNO()
_nOrdem1	:= INDEXORD()
 
_cEstCli	:= GetAdvFval("SA1","A1_EST",M->C5_FILIAL+M->C5_CLIENTE+M->C5_LOJACLI,1,1)
_cEstCliE	:= GetAdvFval("SA1","A1_EST",M->C5_FILIAL+M->C5_CLIENT+M->C5_LOJAENT,1,1)
 
//_cCodCli  := M->C5_CLIENTE                                                              
//_cLojaCli := M->C5_LOJACLI                                                             
  
_cCodCliE := M->C5_CLIENT
_cLojaEnt := M->C5_LOJAENT
_cLojaCli := M->C5_LOJACLI 

//If Empty(_cLojaCli) .And. M->C5_XTPPED<>"2"
//   M->C5_LOJACLI :=Posicione("SC5",1, xFilial("SC5") + M->C5_NUM, "C5_LOJACLI")           
//EndIf 

//_cLojaEnt := GetAdvFval("SA1","A1_LOJAENT",M->C5_FILIAL+M->C5_CLIENT+M->C5_LOJAENT,1,1)

IF (_cEstCliE <> _cEstCli) .And. (M->C5_XTPPED<>"2")            // Alterado por Valdemir Jose 01/07/2013
//  Alert("CCAB -> Estado do Cliente de Entrega DIFERENTE do Estado do Cliente de Faturamento. Operação Não pode ser realizada.")
    IF Aviso("Cliente de Entrega X Cliente de Faturamento","CCAB -> Estado do Cliente de Entrega DIFERENTE do Estado do Cliente de Faturamento. Operação Não pode ser realizada. Deseja Continuar?",{"Sim","Não"},,) == 1
	   _cCodCliE     := M->C5_CLIENT
       M->C5_LOJAENT := _cLojaEnt
	Else
	   _cCodCliE     := ""
	   M->C5_LOJAENT := ""
	EndIf
Else
	_cCodCliE := M->C5_CLIENT
	M->C5_LOJAENT := _cLojaEnt
EndIf	

DbselectArea(_cAlias1)
Dbsetorder(_nOrdem1)
Dbgoto(_nRecno1)

Return( _cCodCliE )
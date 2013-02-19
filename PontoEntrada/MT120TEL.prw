#Include "Protheus.ch"
#Include "Topconn.ch"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT120TEL  ºAutor  ³Denison Soares      º Data ³  22/11/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³P.E Disponibiliza o objeto e as coordenadas da Dialog.	  º±±
±±º          ³															  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Pedido de Compra		                                      º±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ PROGRAMADOR      ³  DATA      ³ MOTIVO DA ALTERACAO                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Eduardo Cseh      ³ 26/11/2012 ³ #ECV20121126 - Alteracao para validar ³±±
±±³(Agility)         ³            ³ se a observacao pode ser alterada.    ³±±
±±³                  ³            ³ 									  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function MT120TEL()

Local aArea		:= GetArea()
Local oDlg		:= PARAMIXB[1]
Local aPosGet	:= PARAMIXB[2]   
Local nOpcx		:= PARAMIXB[4]    
Local nRecPC	:= PARAMIXB[5]   
Local lEdit 	:= IIF(nOpcx == 3 /*Inclusao*/ .Or. nOpcx == 4/*Alteracao*/ .Or. nOpcx == 6/*Copia*/,.T.,.F.) //#ECV20121126.o 
Public _cObs
              
SC7->(DbGoTo(nRecPC))

//#ECV20121126.bn 
//Funcao que verifica se o pedido foi atendido 
If lEdit .And. nOpcX <> 3 
	lEdit := fVerAtend(SC7->C7_NUM) 
EndIf
//#ECV20121126.en

_cObs := IIF(nOpcx == 3,CriaVar("C7_XOBS",.F.),SC7->C7_XOBS)

@ 056,	aPosGet[1,1] SAY Alltrim(RetTitle("C7_XOBS"))OF oDlg PIXEL SIZE 050,006
@ 055,	aPosGet[1,2] MSGET _cObs WHEN   lEdit;
 		PICTURE PesqPict('SC7','C7_XOBS') OF oDlg PIXEL SIZE 230,006

RestArea(aArea)

Return()



/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ão    ³fVerAtend ³ Autor ³Eduardo Cseh Vasques   ³ Data ³ 26/11/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrição ³ Rotina que verifica se um pedido de compras foi total ou   ³±±
±±³          ³parcialmente atendido.                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³fVerAtend(Num. Pedido)                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³MT120TEL   												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function fVerAtend(_cPedido)

Local _lRet		:= .T.
Local _cQuery	:= ""
Local _nCount	:= 0

//Query que verifica se existem itens atendidos para o pedido em questao
_cQuery := "SELECT C7_NUM"
_cQuery += " FROM "+RetSqlName("SC7")+" SC7" 
_cQuery += " WHERE SC7.D_E_L_E_T_ = ''"
_cQuery += "	AND C7_FILIAL = '"+xFilial("SC7")+"'"
_cQuery += "	AND C7_NUM = '"+_cPedido+"'"
_cQuery += "	AND (C7_QUJE > 0 "
_cQuery += "	OR C7_RESIDUO <> '' "
_cQuery += "	OR C7_ENCER <> '') "

If Select ("TMP") > 0
	TMP->(DbCloseArea())
EndIf     

TCQUERY _cQuery NEW ALIAS "TMP"

TMP->(DbGoTop())

Count To _nCount

If _nCount > 0 //Caso retorne algum registro
	_lRet	:= .F.
EndIf

Return _lRet

#include "protheus.ch"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CCRFAT16  ºAutor ³ Felipe Aurélio de Melo º Data ³ 26/06/09 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Esta função irá validar se o campo poderá ser editado,     º±±
±±º          ³ devido item origidado do pré-pedido                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ X3_VLDUSER                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CCRFAT16()

Local nPosPrePed := aScan(aHeader,{ |x| Upper(AllTrim(x[2])) == "C6_PRENUM" })   
Local lRetorno   := .T.
Local cReadVar   := ReadVar()

If !Empty(aCols[n][nPosPrePed])
	ShowHelpDlg("PREPED",{"Este item foi originado de um pré-pedido","e por isto não pode ser alterado."},5,;
   		                 {"Este item só pode ser alterado pela rotina","de pré-pedido, então caso seja necessário","alteração, deletar o item e realizar","a alteração na rotina do pré-pedido."},5)
	lRetorno := .F.
EndIf 

If !Empty(cReadVar)                                            
	if cReadVar $ "M->C6_PRODUTO"
		lRetorno := GetProdTab(M->C5_TABELA, M->C6_PRODUTO )			// Adicionado por Valdemir Jose 11/06/2013
	Endif
Endif
Return(lRetorno)              







/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GetProdTabºAutor  ³Valdemir Jose       º Data ³  11/06/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Valida Tabela de Produtos                                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GetProdTab(pTabela, pProduto)
	Local lRET       := .T.
	Local aArea      := GetArea()                                 
	Local nPosProd   := aScan(aHeader,{ |x| Upper(AllTrim(x[2])) == "C6_PRODUTO" })   
	Local nPosDescri := aScan(aHeader,{ |x| Upper(AllTrim(x[2])) == "C6_DESCRI" })   
	     
	dbSelectArea('DA1')
	dbSetOrder(1)

	if pTabela = "000"
	   lRET := dbSeek(	xFilial('DA1')+pTabela)
		if !lRET
			Alert('Tabela: '+pTabela+', não cadastrada. Por favor verifique.')
		Endif
		IF EMPTY(pProduto)
			M->C6_PRODUTO        := ''                                       
			aCols[n][nPosDescri] := ''                         
			aCols[n][nPosProd]   := SPACE(TAMSX3('C6_PRODUTO')[1])
		ENDIF
		Return lRET
	Endif                                                                         
	
	IF !Empty(pProduto)
		lRET := dbSeek(	xFilial('DA1')+pTabela+pProduto)
		
		if !lRET
			Alert('Produto: '+pProduto+' informado, não faz parte da tabela: '+pTabela+', Por favor verifique.')
			M->C6_PRODUTO        := ''                                       
			aCols[n][nPosDescri] := ''                         
			aCols[n][nPosProd]   := SPACE(TAMSX3('C6_PRODUTO')[1])
		Endif
	ELSE
		aCols[n][nPosDescri] := ''                         
		aCols[n][nPosProd]   := SPACE(TAMSX3('C6_PRODUTO')[1])
	Endif
	RestArea( aArea )
	
Return lRET
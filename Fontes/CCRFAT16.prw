#include "protheus.ch"


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CCRFAT16  �Autor � Felipe Aur�lio de Melo � Data � 26/06/09 ���
�������������������������������������������������������������������������͹��
���Desc.     � Esta fun��o ir� validar se o campo poder� ser editado,     ���
���          � devido item origidado do pr�-pedido                        ���
�������������������������������������������������������������������������͹��
���Uso       � X3_VLDUSER                                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function CCRFAT16()

Local nPosPrePed := aScan(aHeader,{ |x| Upper(AllTrim(x[2])) == "C6_PRENUM" })   
Local lRetorno   := .T.
Local cReadVar   := ReadVar()

If !Empty(aCols[n][nPosPrePed])
	ShowHelpDlg("PREPED",{"Este item foi originado de um pr�-pedido","e por isto n�o pode ser alterado."},5,;
   		                 {"Este item s� pode ser alterado pela rotina","de pr�-pedido, ent�o caso seja necess�rio","altera��o, deletar o item e realizar","a altera��o na rotina do pr�-pedido."},5)
	lRetorno := .F.
EndIf 

If !Empty(cReadVar)                                            
	if cReadVar $ "M->C6_PRODUTO"
		lRetorno := GetProdTab(M->C5_TABELA, M->C6_PRODUTO )			// Adicionado por Valdemir Jose 11/06/2013
	Endif
Endif
Return(lRetorno)              







/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GetProdTab�Autor  �Valdemir Jose       � Data �  11/06/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Valida Tabela de Produtos                                  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
			Alert('Tabela: '+pTabela+', n�o cadastrada. Por favor verifique.')
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
			Alert('Produto: '+pProduto+' informado, n�o faz parte da tabela: '+pTabela+', Por favor verifique.')
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
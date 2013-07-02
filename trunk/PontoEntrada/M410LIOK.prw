#include "rwmake.ch"

/*/
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������Ŀ��
���Programa  �  M410LIOK  � Autor �Fernando Kruszynski    �Data  � 28/06/11 ���
���������������������������������������������������������������������������Ĵ��
���Descricao � PE Valida��o PV. Apenas seguran�a para que em uma possivel	���
���          � falha do sistema n�o permite excluir item de PV ja faturado.	���
����������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
/*/

User Function M410LIOK()
Local lEnd      := .T.
Local nPosSTrib := aScan(aHeader,{|x| Upper(AllTrim(x[2])) == "C6_CLASFIS"})    // Valdemir Jose 19/06/2013 
Local nPosCF    := aScan(aHeader,{|x| Upper(AllTrim(x[2])) == "C6_CF"})         // Valdemir Jose 19/06/2013 
Local nPosARM   := aScan(aHeader,{|x| Upper(AllTrim(x[2])) == "C6_LOCAL"})      // Valdemir Jose 19/06/2013 
Local _cCFOP    := GETMV("MV_CFOP410")                                          // Valdemir Jose 01/07/2013
Local _cARM     := GETMV("MV_ARMZ410")                                          // Valdemir Jose 01/07/2013

lc6_nota   := aScan( aHeader, { |aVal|aVal[2] = "C6_NOTA" } )


if acols[n,len(aheader)+1] == .T. .and. !Empty(aCols[n,lc6_nota]) //PARA VERIFICAR SE A LINHA ESTA DELETADA E O PEDIDO GEROU NF.
	Alert("N�o � possivel excluir um item que j� foi faturado. O item ser� recuperado novamente.")
	aCols[n,len(aheader)+1] := .F.
	Return .F.
Endif


If Inclui .Or. Altera
	// Valdemir Jose 01/07/2013
	IF SF4->F4_PODER3 = 'R' .and. (alltrim(aCols[n,nPosCF]) $ _cCFOP)
	   IF  !(alltrim(aCols[n,nPosARM]) $ _cARM) 
	   		Alert("CFOP n�o pode ser utilizada com armazem "+aCols[n,nPosARM]+", por favor verifique...")
	   		Return .F.
	   Endif
	ENDIF
	
	// Valdemir Jose 19/06/2013
	if Len(alltrim(aCols[n,nPosSTrib])) < 3
		Alert("Situa��o Tribut�ria com informa��o errada. Por favor, Informe o Produto e TES novamente...")
		Return .F.	
	endif
	If M->C5_TIPO$"DB"
		DbSelectArea("SA2")
		SA2->(DbSetOrder(1))
		SA2->(DbGoTop())
		If SA2->(DbSeek(XFilial("SA2")+M->C5_CLIENTE+M->C5_LOJACLI))
			cUFCli := SA2->A2_EST
			If Alltrim(Posicione("SA2",1,XFilial("SA2")+M->C5_CLIENT+M->C5_LOJAENT,"SA2->A2_EST")) != Alltrim(cUFCli)
				If GetMv("MV_ESTADO") != Alltrim(cUFCli)
					Processa({|lEnd| UPDCfop()},OemToAnsi("CCAB - Aguarde!"),OemToAnsi("Analisando/Corrigindo CFOP do Produto..."))
				Endif
			Endif
		Endif
	Else
		DbSelectArea("SA1")
		SA1->(DbSetOrder(1))
		SA1->(DbGoTop())
		If SA1->(DbSeek(XFilial("SA1")+M->C5_CLIENTE+M->C5_LOJACLI))
			cUFCli := SA1->A1_EST
			If Alltrim(Posicione("SA1",1,XFilial("SA1")+M->C5_CLIENT+M->C5_LOJAENT,"SA1->A1_EST")) != Alltrim(cUFCli)
				If GetMv("MV_ESTADO") != Alltrim(cUFCli)
					Processa({|lEnd| UPDCfop()},OemToAnsi("CCAB - Aguarde!"),OemToAnsi("Analisando/Corrigindo CFOP do Produto..."))
				Endif
			Endif
		Endif
	Endif
Endif

Return .T.


Static Function UPDCfop()
aCols[n,aScan( aHeader, { |aVal|aVal[2] = "C6_CF" } )] := "6"+SubStr(aCols[n,aScan( aHeader, { |aVal|aVal[2] = "C6_CF" } )],2,3)
Return
#INCLUDE "RwMake.ch"                 
#INCLUDE "TopConn.ch"

/*
���������������������������������������������������������������������������������
���������������������������������������������������������������������������������
�����������������������������������������������������������������������������Ŀ��
���Fun��o    � SFI100I  � Autor � Paulo Elias           � Data � 13/03/2008   ���
�����������������������������������������������������������������������������Ĵ��
���Descri��o � Ponto de Entrada ap�s a grava�ao da Nota de Entrada.           ���
���          �                                                                ���
������������������������������������a����������������������������������������Ĵ��
���Observacao�                                                                ���
�����������������������������������������������������������������������������Ĵ��
���Cliente   � CCAB                                                           ���
������������������������������������������������������������������������������ٱ�
���������������������������������������������������������������������������������
���������������������������������������������������������������������������������
*/

User Function SF1100I
//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������
Local aArea			:= GetArea()  
Local _aAreaSE2

// Daniel 04/06/2009
Local nPosProd	 	:= Ascan(aHeader, {|n| Alltrim(n[2]) = "D1_COD"})							// Posicao do codigo do produto
Local nPosQuan	 	:= Ascan(aHeader, {|n| Alltrim(n[2]) = "D1_QUANT"})						// Posicao da quantidade
Local nPosRat 	 	:= Ascan(aHeader, {|n| Alltrim(n[2]) = "D1_RATEIO"})						// Posicao do rateio
Local nPosCC   	 	:= Ascan(aHeader, {|n| Alltrim(n[2]) = "D1_CC"})							// Posicao do centro de custo
Local _nPosNFOri  	:= Ascan(aHeader, {|n| Alltrim(n[2]) = "D1_NFORI"})
Local _nPosSerOri 	:= Ascan(aHeader, {|n| Alltrim(n[2]) = "D1_SERIORI"})
Local _nPosTes 		:= Ascan(aHeader, {|n| Alltrim(n[2]) = "D1_TES"})
Local nPLiqui	 	:= 0
Local nPBruto	 	:= 0

// Daniel 04/06/2009
For _x := 1 to Len(aCols)
	nPesoL	:= Posicione("SB1",1,xFiliaL("SB1")+aCols[_x][nPosProd],"B1_PESO")
	nPesoB	:= Posicione("SB1",1,xFiliaL("SB1")+aCols[_x][nPosProd],"B1_PESBRU")
	nPLiqui += aCols[_x][nPosQuan] * nPesoL
	nPBruto += aCols[_x][nPosQuan] * nPesoB
Next

//������������������������������������������������������������������������������������������������Ŀ
//�Verifica se a nota em questao eh devolucao de vendas e gerou titulo no finaneceiro.  			|
//��������������������������������������������������������������������������������������������������
If SF1->F1_TIPO == "D" .and. SF1->F1_FILIAL + SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA == SE1->E1_FILORIG + SE1->E1_NUM + SE1->E1_PREFIXO + SE1->E1_CLIENTE + SE1->E1_LOJA
	
	//������������������������������������������������������������������������������������������������Ŀ
	//�Busca o titulo no financeiro                        										       |
	//��������������������������������������������������������������������������������������������������
	dbSelectArea("SA1")
	dbSetOrder(1)
	If dbSeek(xFilial("SA1") + SE1->E1_CLIENTE+SE1->E1_LOJA)
		
		//������������������������������������������������������������������������������������������������Ŀ
		//�Gravacao dos dados nos titulos gerados                            							   |
		//��������������������������������������������������������������������������������������������������
		RecLock("SE1",.F.)
		SE1->E1_HIST   	:= "NF DEV VENDA"
		SE1->E1_XRAZAOS	:= SA1->A1_NOME
		SE1->E1_XCGC   	:= SA1->A1_CGC
		SE1->E1_XESPECI	:= SF1->F1_ESPECIE
		SE1->E1_XGESTOR	:= SA1->A1_XGESTOR
		SE1->E1_VEND1  	:= SA1->A1_VEND        	// Alterado por Samir
		SE1->E1_VEND2  	:= SA1->A1_XVEND2		// Alterado por Samir
		SE1->E1_VEND3  	:= SA1->A1_XVEND3  		// Alterado por Samir
		SE1->E1_XTPPED 	:= SC5->C5_XTPPED 		// Solicitado por Reinaldo
		SE1->E1_XCOND	:= SC5->C5_CONDPAG		// Solicitado por Luiz 03/08/10
		SE1->E1_XCONDDE	:= Posicione("SE4", 1, xFilial("SE4") + SC5->C5_CONDPAG, "E4_DESCRI") 		
		//SE1->(MsUnlock())
		MsUnLock()
	EndIf
EndIf

//���������������������������������������������������������������������������������������������Ŀ
//�Verifica se a nota em questao eh beneficiamento e gerou titulo no finaneceiro.   			|
//�����������������������������������������������������������������������������������������������
If SF1->F1_TIPO == "B" .and. SF1->F1_FILIAL + SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA == SE1->E1_FILORIG + SE1->E1_NUM + SE1->E1_PREFIXO + SE1->E1_CLIENTE + SE1->E1_LOJA
	//�����������������������������������������������������������������������������������������Ŀ
	//�Busca o titulo no financeiro                        										|
	//�������������������������������������������������������������������������������������������
	dbSelectArea("SA1")
	dbSetOrder(1)
	If dbSeek(xFilial("SA1") + SE1->E1_CLIENTE+SE1->E1_LOJA)		
		//�������������������������������������������������������������������������������������Ŀ
		//�Gravacao dos dados nos titulos gerados                            				    |
		//���������������������������������������������������������������������������������������
		RecLock("SE1",.F.)
		SE1->E1_HIST     := "NF BENEFICIAMENTO"
		SE1->E1_XRAZAOS  := SA1->A1_NOME
		SE1->E1_XCGC     := SA1->A1_CGC
		SE1->E1_XESPECI  := SF1->F1_ESPECIE
		//SE1->(MsUnlock())
		MsUnLock()
	EndIf
	
EndIf

//���������������������������������������������������������������������������������������������Ŀ
//�Verifica se a nota em questao n�o � beneficiamento e gerou titulo no finaneceiro.   			|
//�����������������������������������������������������������������������������������������������
If !(AllTrim(SF1->F1_TIPO)$"D/B") .and. SF1->F1_FILIAL + SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA == SE2->E2_FILORIG + SE2->E2_NUM + SE2->E2_PREFIXO + SE2->E2_FORNECE + SE2->E2_LOJA
	
	_cCCusto := ""
	For _y:=1 to Len(aCols)
		If aCols[_y][nPosRat]=="1?"
			DbSelectArea("SDE")
			SDE->(DbSetOrder(1)) //DE_FILIAL+DE_DOC+DE_SERIE+DE_FORNECE+DE_LOJA+DE_ITEMNF+DE_ITEM
			DbSeek(xFilial("SDE")+SF1->(F1_DOC + F1_SERIE + F1_FORNECE + F1_LOJA))
			While SDE->(Eof()) .and. SDE->(DE_DOC+DE_SERIE+DE_FORNECE+DE_LOJA)==SF1->(F1_DOC + F1_SERIE + F1_FORNECE + F1_LOJA)
				If !(SDE->DE_CC $ _cCCusto)
					_cCCusto += SDE->DE_CC + If(_y<Len(aCols),"/","")
				Endif
				SDE->(DbSkip())
			End
		Else
			_cCCusto += aCols[_y][nPosCC] + If(_y<Len(aCols),"/","")
		Endif
	Next
	
	While SE2->(!Eof()) .AND. SF1->(F1_FILIAL + F1_DOC + F1_SERIE + F1_FORNECE + F1_LOJA) == SE2->(E2_FILORIG + E2_NUM + E2_PREFIXO + E2_FORNECE + E2_LOJA)
		RecLock("SE2",.F.)                                                        
		SE2->E2_XESPECI	:= SF1->F1_ESPECIE
		SE2->E2_XNOME  	:= Posicione("SA2",1,xFilial("SA2")+SE2->(E2_FORNECE+E2_LOJA),"A2_NOME")
		SE2->E2_XCGC	:= Posicione("SA2",1,xFilial("SA2")+SE2->(E2_FORNECE+E2_LOJA),"A2_CGC")
		SE2->E2_XCCUSTO	:= _cCCusto
		MsUnLock()
		SE2->(DbSkip())
	End
EndIf

If Type("l103Auto") != "L"
	// Daniel 04/06/2009
	If MsgYesNo("Deseja informar Obs. Financeira ?")
		U_ObsFin()
	Endif
	If MsgYesNo("Deseja informar dados complementares?")
		U_EEST006(nPLiqui,nPBruto)
	Endif
	If MsgYesNo("Deseja informar dados desconto de pontualidade?")
		U_ObsDes()
	Endif		
Else
	If l103Auto == .F.
		If MsgYesNo("Deseja informar Obs. Financeira ?")
			U_ObsFin()
		Endif	
		If MsgYesNo("Deseja informar dados complementares?")
			U_EEST006(nPLiqui,nPBruto)
		Endif
		If MsgYesNo("Deseja informar dados desconto de pontualidade?")
			U_ObsDes()
		Endif		
	EndIf
EndIf 

// Daniel Franciulli - Tratamento do custo nas moedas 2, 3 e 4 de acordo com a ptax da emiss�o da nf original
/* FAVARO - ESTAVA ALTERANDO A TAXA NEGOCIADA
For _x := 1 to Len(aCols)
	
	If !Empty(aCols[_x][_nPosNFOri])
		
			If SF1->F1_TIPO == "D"
				_dEmisOri 	:= Posicione("SF2",1,xFilial("SF2")+aCols[_x][_nPosNFOri]+aCols[_x][_nPosSerOri],"F2_EMISSAO")
			Else
			    _dEmisOri 	:= SD1->D1_EMISSAO-1
			Endif

			_nPtax2		:= Posicione("SM2",1,_dEmisOri,"M2_MOEDA2")
			_nPtax3		:= Posicione("SM2",1,_dEmisOri,"M2_MOEDA3")
			_nPtax4		:= Posicione("SM2",1,_dEmisOri,"M2_MOEDA4")
			
			DbSelectArea("SD1")
			SD1->(DbSetOrder(1))
			If SD1->(DbSeek(xFilial("SD1")+SD1->(D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+StrZero(_x,4))))
				RecLock("SD1",.F.)
				SD1->D1_CUSTO2 := SD1->D1_CUSTO * _nPtax2
				SD1->D1_CUSTO3 := SD1->D1_CUSTO * _nPtax3
				SD1->D1_CUSTO4 := SD1->D1_CUSTO * _nPtax4
				SD1->(MsUnlock())
			Endif
	Endif	
Next
*/               
    

//*******************************************************************************************************
// AJUSTE DEVIDO A PROBLEMAS NO DOLAR REFERENTE A NOTA COM OS TITULOS - Valdemir Jose 28/06/2013
//*******************************************************************************************************
Dbselectarea("SD1")
SD1->(Dbgotop())
SD1->(Dbsetorder(1))
lEncontrou := SD1->(Dbseek(xFilial("SF1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA))
if lEncontrou
	Dbselectarea("SC7")
	SC7->(Dbsetorder(1))
	IF SC7->(Dbseek(xFilial("SD1")+SD1->D1_PEDIDO+SD1->D1_ITEMPC)) 
	    nMoedaCor     := SC7->C7_MOEDA
	    nTaxa         := SC7->C7_TXMOEDA
	
		// Ajusta Dolar na Nota
		RECLOCK("SF1",.F.)
		SF1->F1_MOEDA    :=  SC7->C7_MOEDA
		SF1->F1_TXMOEDA  :=  SC7->C7_TXMOEDA
		MsUnlock()             
		
		// Ajusta Contas a Pagar
		DbSelectArea("SE2")
		DbSetOrder(6)
		If SE2->(dbSeek(xFilial("SE2")+SF1->(F1_FORNECE+F1_LOJA+F1_SERIE+F1_DOC),.f.))
			While SE2->(Eof()) == .f. .and. SE2->(E2_FILORIG+E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM) == SF1->(F1_FILIAL+F1_FORNECE+F1_LOJA+F1_SERIE+F1_DOC)
				RecLock('SE2',.F.)
				SE2->E2_MOEDA   := SC7->C7_MOEDA
				SE2->E2_TXMOEDA := SC7->C7_TXMOEDA
				SE2->E2_VALOR   := (SE2->E2_VLCRUZ / SC7->C7_MOEDA)
				MsUnlock()
				dbSkip()
			EndDo
		Endif
	ENDIF
endif

/*
���������������������������������������������������������������������������������
���������������������������������������������������������������������������������
�����������������������������������������������������������������������������Ŀ��
���Programa  � SF1100I  � Autor � Rodrigo Cirne de Andrade� Data � 28/01/2010 ���
�����������������������������������������������������������������������������Ĵ��
���Descricao � Grava Dados Complementares no Contas a Pagar                   ���
�����������������������������������������������������������������������������Ĵ��
���Observacao�                                                                ���
�����������������������������������������������������������������������������Ĵ��
���Uso       � CCAB                                                           ���
�����������������������������������������������������������������������������Ĵ��
���                                                                           ���
���             INSERIDO PARA TRATAMENTO DO ENCONTRO DE CONTAS                ���
���                                                                           ���
�����������������������������������������������������������������������������Ĵ��
���Programador   �  Data  �              Motivo da Alteracao                  ���
�����������������������������������������������������������������������������Ĵ��
���              �        �                                                   ���
������������������������������������������������������������������������������ٱ�
���������������������������������������������������������������������������������
���������������������������������������������������������������������������������
*/

IF SF1->F1_TIPO $ "N"
	_aArea1:= GetArea()            
	_xEncc := ''             
	_xDtencc := cTod('  /  /  ')
	Dbselectarea("SD1")
	SD1->(Dbgotop())
	SD1->(Dbsetorder(1))
	IF SD1->(Dbseek(xFilial("SF1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA))
		Dbselectarea("SC7")
		SC7->(Dbsetorder(1))
		IF SC7->(Dbseek(xFilial("SD1")+SD1->D1_PEDIDO+SD1->D1_ITEMPC))
			_xEncc    :=  SC7->C7_XENCC
			_xDtencc  :=  SC7->C7_XDTENCC
		ENDIF
	ENDIF
	RestArea(_aArea1)
	RECLOCK("SF1",.F.)
	SF1->F1_XENCC    :=  _xEncc
	SF1->F1_XDTENCC  :=  _xDtencc
	SF1->(MSUNLOCK())
	
	_aAreaSE2 := GetArea()
	DbSelectArea("SE2")
	DbSetOrder(6)
	If SE2->(dbSeek(xFilial("SE2")+SF1->(F1_FORNECE+F1_LOJA+F1_SERIE+F1_DOC),.f.))
		While SE2->(Eof()) == .f. .and. SE2->(E2_FILORIG+E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM) == SF1->(F1_FILIAL+F1_FORNECE+F1_LOJA+F1_SERIE+F1_DOC)
			RecLock("SE2",.f.)
			SE2->E2_NOMFOR				:=		POSICIONE("SA2",1,xFilial("SA2")+SE2->E2_FORNECE+SE2->E2_LOJA,"A2_NREDUZ")
			SE2->E2_CCD					:=		SD1->D1_CC
			// ********** INSERIDO PARA TRATAMENTO DO ENCONTRO DE CONTAS.....
			SE2->E2_XENCC               :=      SF1->F1_XENCC
			SE2->E2_XDTENCC             :=      SF1->F1_XDTENCC
			IF (SF1->F1_XENCC <> "N") .AND. (!EMPTY(SF1->F1_XENCC))
				SE2->E2_PORTADO := IIF(SF1->F1_XENCC='C',"CAP","ENC")     // IIF ACRESCENTADO POR VALDEMIR 29/05/13
   				SE2->E2_XBCOPAG := IIF(SF1->F1_XENCC='C',"CAP","ENC")
				SE2->E2_XAGNPAG := "00001" 
				SE2->E2_XCTAPAG := "0000000001" 
			Endif
			SE2->(MsUnLock())
			SE2->(dbSkip())
			
		EndDo
	EndIf
	//----> retorna a posicao original antes do PONTO DE ENTRADA
	RestArea(_aAreaSE2)
EndIf 

RestArea(aArea)                             

Return()
   
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ObsDes  �Autor  �Microsiga           � Data �  06/04/09   ���
�������������������������������������������������������������������������͹��
���Desc.     �Gera a tela para informa��es complementares                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function ObsDes()

Private _xObsDes := Space(150)

@ 000,000 to 190,450 dialog _oDlg title "Observacao de Pontualidade"
@ 014,010 say "Observa��es:"
@ 014,045 get _xObsDes 	size 150,20 Picture ("@!") 

@ 080,080 BmpButton type 1 action GravaObs()
@ 080,110 BmpButton type 2 action (_oDlg:end())

Activate Dialog _oDlg Center

Return() 

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ObsFin  �Autor  �Microsiga           � Data �  06/04/09   ���
�������������������������������������������������������������������������͹��
���Desc.     �Gera a tela para informa��es complementares                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function ObsFin()

Private _xObsFin := Space(150)

@ 000,000 to 190,450 dialog _oDlgx title "Observacao Financeira"
@ 014,010 say "Observa��es:"
@ 014,045 get _xObsFin 	size 150,20 Picture ("@!") 

@ 080,080 BmpButton type 1 action GrvObsFin()
@ 080,110 BmpButton type 2 action (_oDlgx:end())

Activate Dialog _oDlgx Center

Return()



/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �geratela  �Autor  �Microsiga           � Data �  06/04/09   ���
�������������������������������������������������������������������������͹��
���Desc.     �Gera a tela para informa��es complementares                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function GeraTela(nPLiqui,nPBruto)

Private _xTransp := Space(6)
Private _xQtdVol := 0
Private _xEspeci := Space(10)
Private _xObs	 := Space(500)
Private _nPLiqui := nPLiqui
Private _nPBruto := nPBruto

@ 000,000 to 190,450 dialog _oDlg title "Informa��es complentares"
@ 014,010 say "Peso L�quido:"
@ 014,045 get _nPLiqui 	size 50,10 	Picture ("@e 999,999.99") //Valid _xQtdVol>0
@ 030,010 say "Peso Bruto  :"
@ 030,045 get _nPBruto 	size 50,10  Picture ("@e 999,999.99") //Valid _xQtdVol>0
@ 046,010 say "Observa��es :"
@ 046,045 get _xObs 	size 150,20 Memo

@ 080,080 BmpButton type 1 action Grava()
@ 080,110 BmpButton type 2 action (_oDlg:end())

Activate Dialog _oDlg Center

Return()

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Grava     �Autor  �Microsiga           � Data �  06/04/09   ���
�������������������������������������������������������������������������͹��
���Desc.     �Grava os dados                                              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function Grava()

Close(_oDlg)

RecLock("SF1",.f.)
//SF1->F1_XTRANSP	:= _xTransp
//SF1->F1_XVOLUME	:= _xQtdVol
//SF1->F1_XESPECI	:= _xEspeci
SF1->F1_XOBSERV	:= _xObs
SF1->F1_PLIQUI	:= _nPLiqui
SF1->F1_PBRUTO	:= _nPBruto
SF1->(MsUnlock())

Return()
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GravaObs  �Autor  �Microsiga           � Data �  06/04/09   ���
�������������������������������������������������������������������������͹��
���Desc.     �Grava os dados                                              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function GravaObs()

RecLock("SF1",.f.)
SF1->F1_XOBSDES	:= _xObsDes
SF1->(MsUnlock())
                 
DbSelectArea("SE2")
SE2->(DbSetOrder(6))
If SE2->(dbSeek(xFilial("SE2")+SF1->(F1_FORNECE+F1_LOJA+F1_SERIE+F1_DOC),.f.))
		While SE2->(Eof()) == .f. .and. SE2->(E2_FILORIG+E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM) == SF1->(F1_FILIAL+F1_FORNECE+F1_LOJA+F1_SERIE+F1_DOC)
		SE2->(RecLock("SE2", .F.))
		SE2->E2_XOBSDES := _xObsDes
		SE2->(MsUnlock())	
		SE2->(DbSkip())
	EndDo
EndIf

Close(_oDlg)

Return() 



/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GravaObs  �Autor  �Microsiga           � Data �  06/04/09   ���
�������������������������������������������������������������������������͹��
���Desc.     �Grava os dados                                              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function GrvObsFin()

RecLock("SF1",.f.)
SF1->F1_XOBSFIN	:= _xObsFin
SF1->(MsUnlock())
                 
DbSelectArea("SE2")
SE2->(DbSetOrder(1))
If SE2->(DbSeek( xFilial("SE2") + SF1->F1_SERIE + SF1->F1_DOC))
	While SE2->(!Eof()) .AND. SF1->(F1_DOC + F1_SERIE) == SE2->(E2_NUM + E2_PREFIXO)
		SE2->(RecLock("SE2", .F.))
		SE2->E2_XOBSERV := _xObsFin
		SE2->(MsUnlock())	
		SE2->(DbSkip())
	EndDo
EndIf

Close(_oDlgx)

Return()
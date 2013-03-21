#include "Protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �WFW120P   �Autor  �Valdemir Jos�       � Data �  21/05/12   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de Entrada Ap�s Grava��o do Pedido de Compra         ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function WFW120P()
	Local cObsPed := u_ObsPed()   
	Local cCodEntr:= SelEntr()
   
	// Grava observa��es no final do pedido
	if cObsPed != '*'	
		RecLock('SC7',.F.)
		SC7->C7_XOBSPED := cObsPed
		msUnlock()       
	Endif  
	
	// Chamada para informar o local de entrega
	if cCodEntr != ''	
		RecLock('SC7',.F.)
		SC7->C7_XCODENT := cCodEntr
		msUnlock()       
	Endif  
	
Return                  




/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ObsMsg    �Autor  �Valdemir Jose       � Data �  31/01/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Gravar Mensagem Ddo Pedido                                 ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function ObsPed(pObs)
Local oObsMsg
Local cObsMsg := pObs
Local osBTOk
Local osBTSair
Local cRet := '*'
Static oDlg      
                     
  IF EMPTY(pObs)
	  IF !MSGYESNO('Deseja Adicionar uma Observa��o ao pedido?','Mensagem')
		  Return
	  endif         
  ENDIF

  DEFINE MSDIALOG oDlg TITLE "Observa��o Pedido (limite 254 caracteres)" FROM 000, 000  TO 480, 481 COLORS 0, 16777215 PIXEL

    @ 007, 012 GET oObsMsg VAR cObsMsg OF oDlg MULTILINE SIZE 216, 195 COLORS 0, 16777215 HSCROLL PIXEL
    DEFINE SBUTTON osBTSair FROM 216, 126 TYPE 02 OF oDlg ONSTOP "Sair" ENABLE ACTION oDlg:End()
    DEFINE SBUTTON osBTOk   FROM 216, 097 TYPE 01 OF oDlg ONSTOP "Ok" ENABLE ACTION {|| cRet := cObsMsg, oDlg:End()}

  ACTIVATE MSDIALOG oDlg CENTERED

Return cRet 




/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �WFW120P   �Autor  �Valdemir Jose       � Data �  01/02/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Seleciona Local de Entrega que ser� gravado no SC7         ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
STATIC Function SelEntr()
	Local cRET := ''                                              

	LOCAL aSZ1	:= {}
	LOCAL cCampo
	LOCAL cValid
	LOCAL cWhen
	LOCAL nLinha := 5
	LOCAL nCol   := 50    
	LOCAL nCol2  := 250   //235
	LOCAL cChave
	LOCAL oWbr1
	LOCAL oBtn ,oBtn1
	Local cTitulo       := "Selecione o local de entrega"
	//  
	Local aCabec        := {'Codigo','Nome','Endere�o','Estado'}
	Local aAdvSize		:= {}
	Local aInfoAdvSize	:= {}
	Local aObjSize		:= {}
	Local aObjCoords	:= {} 
	Local aButtons      := {} 
	Local aVetor        := {}
	Local nReg          := 0
	Local oDlg

	/*
	��������������������������������������������������������������Ŀ
	� Monta as Dimensoes dos Objetos         					   �
	����������������������������������������������������������������*/
	aAdvSize		:= MsAdvSize()
	aInfoAdvSize	:= { aAdvSize[1] , aAdvSize[2] , aAdvSize[3] , aAdvSize[4] , 0 , 0 }
	
	aAdd( aObjCoords , { 000 , 300 , .T. , .T. } )  
	aObjSize		:= MsObjSize( aInfoAdvSize , aObjCoords )
     
    // Cria Formulario
	oDlg         := MSDialog():New(000,000,400,700,cTitulo,,,,,CLR_BLACK,CLR_WHITE,,,.T.)  

	oPanel       := TPanel():New(0,0,"",oDlg,NIL,.T.,.F.,NIL,NIL,0,10,.T.,.F.)
	oPanel:Align := CONTROL_ALIGN_TOP
	
	// Carrega Local de Entrega
	aVetor       := CarregaSZ1()
	
	if Len(aVetor) = 0
	    Alert('Aten��o, ainda n�o foi feito refer�ncia ao local de entrega (Tabela: SZ1)')
		Return cRET	
	endif

	// Monta o Browse na tela
	oWbr1:= TWBrowse():New(nLinha,aObjSize[1,2],aObjSize[1,3]+230,aObjSize[1,4]-250,,aCabec,,oDlg,,,,,,,,,,,,.F.,,.T.,,.F.,,.T.,)
	oWbr1:Align := CONTROL_ALIGN_ALLCLIENT
	oWbr1:SetArray( aVetor )
	oWbr1:bLine := {|| aEval(aVetor[oWbr1:nAt],{|z,w| aVetor[oWbr1:nAt,w] } ) }  
	oWbr1:bLDblClick := {|| cRET := aVetor[oWbr1:nAt][1], oDlg:End() }
                   
	oPanel1      := TPanel():New(0,0,"",oDlg,NIL,.T.,.F.,NIL,NIL,0,20,.T.,.F.)
	oPanel1:Align := CONTROL_ALIGN_BOTTOM
                                                
	oBtn1 		 := TButton():New(0,0,"&OK",oPanel1,{|| cRET := aVetor[oWbr1:nAt][1], oDlg:End() },42,16,,,.F.,.T.,.F.,,.F.,{||.T.},,.F.)
	oBtn1:Align  := CONTROL_ALIGN_LEFT  
	oBtn1:cToolTip := "Confirma Sele��o"

	oBtn 		 := TButton():New(0,0,"&Sair",oPanel1,{|| oDlg:End() },42,11,,,.F.,.T.,.F.,,.F.,{||.T.},,.F.)
	oBtn:Align   := CONTROL_ALIGN_LEFT   
	oBtn:cToolTip:= "Sai da tela"

	oDlg:lCentered := .T.
	oDlg:Activate()

	
Return cRET



/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �WFW120P   �Autor  �Valdemir Jose       � Data �  01/02/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Carrega informa��es da tabela SZ1                          ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function CarregaSZ1()
	Local aRET      := {}                            
	Local aArea     := GetArea()	
	Local cCondicao := ''              
	Local cCODSZ1   := SuperGetMV('ES_CODSZ1',.F.,'555001')
		
	dbSelectArea('SZ1')
	                                          
	cCondicao := "Z1_COD >='"+ALLTRIM(cCODSZ1)+"'"
	SZ1->( dbSetFilter({|| &cCondicao}, cCondicao) )
	dbGotop()
	                                          
	While !Eof()
	    aAdd(aRET, {SZ1->Z1_COD, SZ1->Z1_NOME, SZ1->Z1_END, SZ1->Z1_EST} )
	     
		dbSkip()
	EndDo	
	
	SZ1->( dbClearFilter() )  
	
	SZ1->( dbCloseArea() )
	
	RestArea( aArea )
	
Return aRET
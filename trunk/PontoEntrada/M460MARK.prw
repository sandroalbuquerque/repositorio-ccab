#INCLUDE "Protheus.ch"
#INCLUDE "TopConn.ch"
#DEFINE ENTER CHR(13) + CHR(10) 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ M460MARK บAutor  ณEmerson Tamborilo   บ Data ณ 08/08/08    บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบ          ณPreenche o campo quantidade e volume no SC5                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณExclusivo para o cliente CCAB                               บฑฑ            
ฑฑฬออออออออออฯอออออออัออออออออออออัอออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ PROGRAMADOR      ณ  DATA      ณ MOTIVO DA ALTERACAO                   บฑฑ
ฑฑฬฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤนฑฑ
ฑฑบEduardo Cseh      ณ 12/12/2012 ณ #ECV20121212 - Preenchimento dos volu-บฑฑ
ฑฑบ(Agility)         ณ            ณ mes retirado para ser tratado na gera-บฑฑ
ฑฑบ                  ณ            ณ cao da NF.  						  บฑฑ
ฑฑศออออออออออออออออออฯออออออออออออฯอออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function M460MARK()
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณDeclaracao de variaveis                                                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
Local lRet 		:= .T.
Local cQuery	:= ""
Local lDtMenor	:= .F.
Local lDtMaior	:= .F.
Local cMarca  	:= ParamIXB[1]
Local lInver  	:= ParamIXB[2]
Local cAgDe   	:= mv_par09
Local cAgAte  	:= mv_par10
Local aArea     := GetArea()
Local aAreaSC5  := SC5->(GetArea())
Local nX		:= 0
//Local nVolume   := 0 #ECV20121212.o
Local nArmazem
Local lAchou    := .F.
Local cMsg      := ""    
Local _cTpPedido := 0 
Private xRet := .F.
Private lxRet := .F. 

//=======================================================
// Chamada do Programa que identifica Pedidos Identicos
// para faturamento
//=======================================================
//lConFatOk := U_PRESELFAT()
//If !lConFatOk
//	Return .F.
//EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณMonta query para selecao dos itens do pedido liberados para faturamento ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
//_cTipo 		:= Posicione("SC5",1, xFilial("SC5") + SC9->C9_PEDIDO, "C5_TIPO")
//_nMoeda	   	:= Posicione("SC5",1, xFilial("SC5") + SC9->C9_PEDIDO, "C5_MOEDA")

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณChama a Rotina de valida็ใo para Verificar se o Campo NF do Cliente Foi preenchido ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

SC5->(DbSetOrder(1))
If SC5->(DbSeek(xFilial("SC5")+SC9->C9_PEDIDO))
	If SC5->C5_TPPDORI == "2" .AND. ALLTRIM(SC5->C5_XNFCLI) == ""
	   lxRet := BlqPedNF(SC5->C5_MENNOTA,SC5->C5_MENNOT1,xRet)                         
	   If !lxRet
	   		Return .F.
	   EndIf
	EndIf           
EndIf

/*
If _cTipo == "D" .And. _nMoeda == 2
  	DbSelectArea("SM2")
	SM2->(DbSetOrder(1))
	If SM2->(DbSeek(DtoS(dDataBase)))
		nTaxaOld := SM2->M2_MOEDA2
		If SM2->(RecLock("SM2",.F.))
			Replace M2_MOEDA2  With 1
			Replace M2_XTXMOED With nTaxaOld
			SM2->(MsUnLock())
		EndIf
	EndIf
EndIf
*/


cQuery := " SELECT C9_LOCAL,C9_PEDIDO,C9_PRODUTO, SUM(C9_QTDLIB)   as QTDLIB, C9_TRANSP     		" + ENTER
cQuery += " FROM " + RetSQLName("SC9") + " SC9 (NOLOCK) 						" + ENTER
cQuery += " WHERE C9_FILIAL = '"+ xFilial("SC9") +"' 							" + ENTER
cQuery += "   AND C9_AGREG BETWEEN '"+ cAgDe +"' AND '"+ cAgAte +"' 		" + ENTER
cQuery += "   AND C9_BLEST = '  ' 													" + ENTER
cQuery += "   AND C9_BLCRED = '  ' 													" + ENTER
cQuery += "   AND " + IIf(lInver,"C9_OK <> '","C9_OK = '") + cMarca + "' " + ENTER
cQuery += "   AND D_E_L_E_T_ = ' ' 													" + ENTER
cQuery += "   GROUP BY  C9_LOCAL,C9_PEDIDO,C9_PRODUTO, C9_TRANSP                  	" + ENTER


If Select("TMP") > 0
	dbSelectArea("TMP")
	dbCloseArea()
EndIf

MemoWrite("m460mark.sql",cQuery)

TcQuery cQuery New Alias "TMP"

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Inicio da Personalizacao Por EDGAR SERRANO - Personalizacao para Pedidos Conta e Ordem          ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
//Verifica saldo em estoque para pedidos Conta e Ordem

If lRet
	DbSelectArea("SC9")
	SC9->(DbSetOrder(1))
	SC9->(DbGoTop())
	While !Eof()		
		If SC9->C9_OK == PARAMIXB[1]
			//==========================================================================
			// Retirada por Favaro Causava inconsistencia na Hora de Faturar 
			// a Fun็ใo Calcest Retorna o Campo B2_QATU
			// Foi trocada pela SaldoSb2 que trata exatamente a necessidade do Cliente
			//==========================================================================
			//aSaldo 	:= CalcEst(SC9->C9_PRODUTO, SC9->C9_LOCAL, dDataBase+1)
			//nTotQtd := aSaldo[1]                                                      
			//==========================================================================
			dbSelectArea("SB2")
			dbSetOrder(1)
			If dbSeek(xFilial("SB2")+PADR(SC9->C9_PRODUTO,LEN(SC9->C9_PRODUTO))+SC9->C9_LOCAL)
				nTotQtd := SaldoSb2(,GetNewPar("MV_QEMPV",.T.)) //(SB2->B2_QATU - SB2->B2_RESERVA - SB2->B2_QACLASS - SB2->B2_QEMP)
			EndIf
			_cTpPedido := Val(Posicione("SC5",1, xFilial("SC5") + SC9->C9_PEDIDO, "C5_XTPPED"))
			If _cTpPedido == 2
				If nTotQtd < SC9->C9_QTDLIB
					cMsg := "Conta e ordem: " + Alltrim(SC9->C9_PEDIDO) + ENTER + ENTER
					cMsg += "O Produto "+Alltrim(SC9->C9_PRODUTO)+" do armaz้m "+Alltrim(SC9->C9_LOCAL)+" selecionado nใo contem saldo suficiente para o faturamento do pedido remessa."
					Alert(cMsg)                                                                                                                                                         
				    MaViewSB2(SC9->C9_PRODUTO)
					Return .F.
				EndIf
			EndIf
			Exit
		EndIf
		SC9->(DbSkip())
	EndDo
EndIf
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Fim da Personalizacao Por EDGAR SERRANO - Personalizacao para Pedidos Conta e Ordem             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
    
// Valida็ใo para verificar se existe FCI para produto industrializado - 25/04/2013
DbSelectArea("SC9")
SC9->(DbGoTop())
While !Eof()		
	If SC9->C9_OK == PARAMIXB[1]
	   dbSelectArea('SC6')
	   dbSetOrder(1)
	   if dbSeek(xFilial('SC6')+SC9->C9_PEDIDO+SC9->C9_ITEM+SC9->C9_PRODUTO)
	   	if Substr(SC6->C6_CF,1,1)='6' .AND. (Posicione('SB1',1,xFilial('SB1')+SC9->C9_PRODUTO,'B1_INDUSTR')='S')   // Verifica se estแ dentro da condi็ใo  
	   	   cNumFCI := U_FiltraFCI(SC9->C9_PRODUTO)
	   	   if Empty(alltrim(cNumFCI))
	   	      	Alert("Produto ("+SC9->C9_PRODUTO+") encontra-se sem Numero de FCI. Por favor, cadastre o numero FCI para dar continuidade.")			              
	   	      	lRET := .F.
				Return lRET
	   	   endif
	   	endif
	   endif
    Endif 
    DbSelectArea("SC9")
	dbSkip()    
EndDo
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณPosiciona arquivos auxiliares a validaao                                ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
dbSelectArea("TMP")
dbGoTop()
nArmazem := TMP->C9_LOCAL
_aNumPed := {}
_cProdPai := ""
_aProdMsg := {}
_nQdBase  := 0
_nQdPai   := 0
While !(TMP->(EOF()))  //.AND. nArmazem == TMP->C9_LOCAL
	
	//nVolume += ( (TMP->QTDLIB/ Posicione("SB1",1,xFilial("SB1")+TMP->C9_PRODUTO,"B1_QE")) / Posicione("SB5",1,xFilial("SB5")+TMP->C9_PRODUTO,"B5_QE1")) #ECV20121212.o
	cNumPed := TMP->C9_PEDIDO
	_ctransp := TMP->C9_TRANSP
	
	If nArmazem <> 	TMP->C9_LOCAL //.and. TMP->C9_LOCAL <> ""
		MsgAlert("Item com armazem diferente.")
		lRet := .F.
		
	EndIf
	
	IF !lRet
		EXIT
	ENDIF
	
	TMP->(dbSkip())
	
	If  cNumPed <> TMP->C9_PEDIDO
		dbSelectArea("SC5")
		dbSetOrder(1)
		dbSeek(xFilial("SC5") + cNumPed)
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณVERIFICA SE A DATA DO VENCIMENTO ษ MENOR QUE A DATA BASE o ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		
		IF SC5->C5_DATA1 < dDataBase .and. !Empty(SC5->C5_DATA1)
			Alert ("Data de Vencimento da parcela 1 do pedido "+Alltrim(cNumPed)+" nใo pode ser menor que a data  base." )
			lRet := .F.
		ElseIF SC5->C5_DATA2 < dDataBase .and. !Empty(SC5->C5_DATA2)
			Alert ("Data de Vencimento da parcela 2 do pedido "+Alltrim(cNumPed)+" nใo pode ser menor que a data  base." )
			lRet := .F.
		ElseIF SC5->C5_DATA3 < dDataBase .and. !Empty(SC5->C5_DATA3)
			Alert ("Data de Vencimento da parcela 3 do pedido "+Alltrim(cNumPed)+"  nใo pode ser menor que a data  base." )
			lRet := .F.
		ElseIF SC5->C5_DATA4 < dDataBase .and. !Empty(SC5->C5_DATA4)
			Alert ("Data de Vencimento da parcela 4 do pedido "+Alltrim(cNumPed)+" nใo pode ser menor que a data base.")
			lRet := .F.
		Endif
		
		IF !lRet
			EXIT
		ENDIF
		

		Reclock("SC5",.F.)
		//SC5->C5_VOLUME1 := nVolume #ECV20121212.o
		SC5->C5_TRANSP  :=	_ctransp
		MsUnlock()

		//nVolume := 0 #ECV20121212.o
		
		IF (nPos := (ASCAN(_aNumPed,{|X|X[1]==cNumPed}))) == 0
			Aadd(_aNumPed, {cNumPed,.F.})
		ENDIF
		
		cQuery2 := "  SELECT C6_NUM,C6_PRODUTO,C6_ITEM,C6_TES,C5_XESTCLI, C6_TES " 	+ ENTER
		cQuery2 += "  FROM "+RetSQLName("SC6")+" SC6 "                            	+ ENTER
		cQuery2 += "  LEFT JOIN "+RetSQLName("SC5")+" SC5 ON SC5.D_E_L_E_T_ = ' '"	+ ENTER
		cQuery2 += "                      AND SC5.C5_FILIAL  = SC6.C6_FILIAL "    	+ ENTER
		cQuery2 += "                      AND SC5.C5_NUM     = SC6.C6_NUM "       	+ ENTER
		cQuery2 += "                      AND SC5.C5_CLIENTE = SC6.C6_CLI "       	+ ENTER
		cQuery2 += "                      AND SC5.C5_LOJACLI = SC6.C6_LOJA "      	+ ENTER
		cQuery2 += "  WHERE C6_FILIAL = '"+xFilial("SC6")+"' "                    	+ ENTER
		cQuery2 += "    AND C6_NUM  = '"+cNumPed+"' "                             	+ ENTER
		cQuery2 += "    AND SC6.D_E_L_E_T_ = ' ' "                                	+ ENTER
		
		
		If Select("TMP2") > 0
			dbSelectArea("TMP2")
			dbCloseArea()
		EndIf
		
		TcQuery cQuery2 New Alias "TMP2"
		
		_lKit := .F.
		TMP2->(DBGOTOP())
		DO WHILE TMP2->(!EOF())
			IF SBG->(DBSEEK(xFILIAL("SBG")+TMP2->C6_PRODUTO))
				_lKit := .T.
			ENDIF
			
			//ALTERADO POR SAMIR PARA VALIDAR A TES
			If lRet
				dbSelectArea("ZZ1")
				ZZ1->(DbSetOrder(3))
				If ZZ1->(dbSeek(xFilial("ZZ1")+TMP2->C6_PRODUTO))
					While  ZZ1->(!EOF()) .And. ZZ1->(ZZ1_FILIAL+ZZ1_PROD) == xFilial("ZZ1")+TMP2->C6_PRODUTO
						IF ZZ1->ZZ1_TES == TMP2->C6_TES
							If TMP2->C5_XESTCLI <> SM0->M0_ESTENT .And. ZZ1->ZZ1_TIPO == "F" .Or.;
								TMP2->C5_XESTCLI == SM0->M0_ESTENT .And. ZZ1->ZZ1_TIPO == "D"
								lAchou := .T.
							EndIf
						EndIf
						ZZ1->(dbSkip())
					End
					If !lAchou .And. SC5->C5_TIPO == "N" .AND. SC5->C5_XTPPED == "001"
						lRet := .F.
						Alert("CCAB -> TES nใo cadastrada na tabela Produtos Vs TES. P.E. M460MARK")
					EndIf
				EndIf
			EndIf
			
			TMP2->(DBSKIP())
		ENDDO
		
		IF _lKit
			IF (nPos := (ASCAN(_aNumPed,{|X|X[1]==cNumPed}))) <> 0
				_aNumPed[nPos,2] := .T.
			ENDIF
			TMP2->(DBGOTOP())
			DO WHILE TMP2->(!EOF())
				cQuery := " SELECT C9_LOCAL,C9_PEDIDO,C9_PRODUTO, SUM(C9_QTDLIB)   as QTDLIB, C9_TRANSP, C9_OK     		" + ENTER
				cQuery += " FROM " + RetSQLName("SC9") + " SC9 (NOLOCK) 						" + ENTER
				cQuery += " WHERE C9_FILIAL = '"+ xFilial("SC9") +"' 							" + ENTER
				cQuery += "   AND C9_AGREG BETWEEN '"+ cAgDe +"' AND '"+ cAgAte +"' 		" + ENTER
				cQuery += "   AND C9_BLEST = '  ' 													" + ENTER
				cQuery += "   AND C9_BLCRED = '  ' 													" + ENTER
				cQuery += "   AND C9_PEDIDO = '"+TMP2->C6_NUM+"' 													" + ENTER
				//cQuery += "   AND C9_ITEM = '"+TMP2->C6_ITEM+"' 													" + ENTER
				cQuery += "   AND " + IIf(lInver,"C9_OK <> '","C9_OK = '") + cMarca + "' " + ENTER
				cQuery += "   AND D_E_L_E_T_ = ' ' 													" + ENTER
				cQuery += "   GROUP BY  C9_LOCAL,C9_PEDIDO,C9_PRODUTO, C9_TRANSP, C9_OK                  	" + ENTER
				
				memowrite("paulo.txt", cquery)
				
				If Select("TMP3") > 0
					dbSelectArea("TMP3")
					dbCloseArea()
				EndIf
				
				TcQuery cQuery New Alias "TMP3"
				
				IF TMP3->(BOF()) .AND. TMP3->(EOF())
					Alert("Kit nใo estแ completo para faturamento. "+TMP2->C6_NUM)
					lRet 		:= .F.
					EXIT
				ENDIF
				//				_cProdPai := ""
				//				_nQdBase  := 0
				// 				_nQdPai   := 0
				
				_lPai := .F.
				
				TMP3->(DBGOTOP())
				DO WHILE TMP3->(!EOF())
					IF SBG->(DBSEEK(xFilial("SBG")+TMP3->C9_PRODUTO))
						_cProdPai := TMP3->C9_PRODUTO
						_nQdBase  := SBG->BG_XQUANT
						_nQdPai   := TMP3->QTDLIB
						_lPai := .T.
						EXIT
					ENDIF
					TMP3->(DBSKIP())
				ENDDO
				
				TMP3->(DBGOTOP())
				SBH->(DBSETORDER(1))
				SB1->(DBSETORDER(1))
				DO WHILE TMP3->(!EOF())
					SBH->(DBSEEK(xFilial("SBH")+_cProdPai+TMP3->C9_PRODUTO))
					If TMP3->C9_PRODUTO == _cProdPai
						TMP3->(DBSKIP())
						LOOP
						//			              _nQuantPai := TMP3->QTDLIB
						//			              _lPai := .T.
					EndIf
					SB1->(DBSEEK(xFILIAL("SB1")+TMP3->C9_PRODUTO))
					_nQtdeTemp := (_nQdPai / _nQdBase) *  SBH->BH_QUANT
					
					IF Mod( _nQtdeTemp, SB1->B1_CONV ) > 0 .And. _lPai
						
						IF _nQtdeTemp <> TMP3->QTDLIB
							_nQtdeProp := (_nQtdeTemp - TMP3->QTDLIB) //* -1
							if _nQtdeProp < -1
								_nQtdeProp := _nQtdeProp * -1
							endif
							
							IF _nQtdeProp > SB1->B1_CONV
								AADD(_aProdMsg,"Quantidade Liberada do Item "+Alltrim(TMP3->C9_PRODUTO)+" invalida.")
								//            			         Alert("Quantidade Liberada do Item "+Alltrim(TMP3->C9_PRODUTO)+" invalida.")
								//             			    	lRet := .F.
								//             		    	    EXIT
							ENDIF
						ENDIF
					ELSEIF _nQtdeTemp <> TMP3->QTDLIB .And. _lPai
						AADD(_aProdMsg,"Quantidade na embalagem invalida Produto : "+Alltrim(TMP3->C9_PRODUTO))
						//            	    	   Alert("Quantidade na embalagem invalida Produto : "+Alltrim(TMP3->C9_PRODUTO))
						//              			   lRet := .F.
						//            		       EXIT
					ENDIF
					
					//			              If (_nQdPai / _nQdBase) *  SBH->BH_QUANT <>  TMP3->QTDLIB
					//			                 Alert('A quantidade do item '+AllTrim(TMP3->C9_PRODUTO)+' nใo condiz com a quantidade do produto pai ('+Alltrim(Str(_nQdPai))+' para cada '+Alltrim(Str(SBH->BH_QUANT))+' do '+AllTrim(_cProdPai)+').'+Chr(13)+Chr(10))
					//              	  			lRet := .F.
					//			        	  	EXIT
					//			              EndIf
					TMP3->(DBSKIP())
				ENDDO
				
				If Select("TMP3") > 0
					dbSelectArea("TMP3")
					dbCloseArea()
				EndIf
				
				IF !lRet
					EXIT
				ENDIF
				
				TMP2->(DBSKIP())
			ENDDO
		ENDIF
		
	Endif
	
EndDo

FOR _IY:=1 TO LEN(_aProdMsg)
	Alert(_aProdMsg[_IY])
	lRet := .F.
NEXT

IF LEN(_aNumPed) > 1
	FOR _I:=1 TO LEN(_aNumPed)
		IF _aNumPed[_I,2]
			Alert("Pedido de kit nao pode ser faturado com outro Pedido")
			lRet := .F.
			EXIT
		ENDIF
	NEXT
ENDIF


If Select("TMP") > 0
	dbSelectArea("TMP")
	dbCloseArea()
EndIf

RestArea(aAreaSC5)
RestArea(aArea)

Return(lRet)




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณNOVO2     บAutor  ณFavaro              บ Data ณ  12/15/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Ponto de Entrada para Bloquear o Faturamento de Pedidos    บฑฑ
ฑฑบ          ณ Conta e Ordem onde a NF do Cliente nใo foi informada       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function BlqPedNF(cMenNota,cMenNot1,xRet)

Private cMensOri1 := cMenNota
Private cMensOri2 := cMenNot1
Private Mensagem 
Private Mensagem2                                                  
Private NFCLI
Private lPassou := .F.

Private cGet1 := cMenNota
Private cGet2 := cMenNot1
Private cGet3 := SPACE(9)
Private cGet4 := Space(50)
                           
Private oGet1
Private oGet2
Private oGet3
Private oGet4

Private oSay1
Private oButton1
Private oButton2
Private oDlgx               

xRet := iif(lpassou,.T.,.F.)

  DEFINE MSDIALOG oDlgx TITLE "Informa็๕es da Nota Fiscal do CLiente" FROM 000, 000  TO 140, 600 COLORS 0, 16777215 PIXEL

    @ 014, 003 SAY Mensagem PROMPT "Mensagem p/ Nota :" SIZE 050, 007 OF oDlgx COLORS 0, 16777215 PIXEL
    @ 010, 053 MSGET oGet1 VAR cGet1 SIZE 242, 010 OF oDlgx COLORS 0, 16777215 PIXEL
    
    @ 025, 003 SAY Mensagem2 PROMPT "Mensagem p/ NF 1 :" SIZE 050, 007 OF oDlgx COLORS 0, 16777215 PIXEL
    @ 022, 053 MSGET oGet2 VAR cGet2 SIZE 242, 010 OF oDlgx COLORS 0, 16777215 PIXEL
    
    @ 037, 014 SAY NFCLI PROMPT "NF do Cliente :" SIZE 037, 007 OF oDlgx COLORS 0, 16777215 PIXEL
    @ 034, 053 MSGET oGet3 VAR cGet3 SIZE 059, 010 OF oDlgx PICTURE "@999999999" VALID confnot(cGet3,xRet,iif(!lPassou,.T.,.F.)) COLORS 0, 16777215 PIXEL
    
    @ 037, 114 SAY oSay1 PROMPT "Complemento :" SIZE 037, 007 OF oDlgx COLORS 0, 16777215 PIXEL
	@ 034, 151 MSGET oGet4 VAR cGet4 SIZE 144, 010 OF oDlgx VALID confext(cGet4,cGet3,xRet) COLORS 0, 16777215 PIXEL
    
    @ 051, 175 BUTTON oButton1 PROMPT "Confirmar" SIZE 037, 012 OF oDlgx ACTION(xRet:=confFat(xRet),oDlgx:End()) PIXEL     
	@ 051, 215 BUTTON oButton2 PROMPT "Refazer"   SIZE 037, 012 OF oDlgx ACTION(confRef(cMensOri1,cMensOri2,xRet)) PIXEL        
    @ 051, 255 BUTTON oButton3 PROMPT "Cancelar"  SIZE 037, 012 OF oDlgx ACTION(cancFat(xRet)) PIXEL

  ACTIVATE MSDIALOG oDlgx CENTERED

Return(xRet)
                                                                  
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณBLQPEDNF  บAutor  ณFavaro              บ Data ณ  12/19/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function confnot(cGet3,xRet)

If alltrim(cGet3) <> ""
	If int(Val(cGet3)) > 0
		xRet := .T.
		dlgRefresh(oDlgx)
	Else
		MsgStop("Digite um numero vแlido para Nota Fiscal")
		dlgRefresh(oDlgx)		
	EndIf
Else           
	MsgAlert("Nใo foi enformado Numero de Nota Fiscal, este pedido nใo pode ser faturado !")	
	dlgRefresh(oDlgx)	
EndIf

Return xRet
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณBLQPEDNF  บAutor  ณFavaro           บ Data ณ  12/19/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function confext(cGet4,cGet3,xRet)

xRet := .F.
If Alltrim(cGet4) <> "" 
	If !lPassou 
		nTamtx := len(alltrim(cGet2)) 
		nTamto := len(cGet2) - nTamtx
		cGet2 := Alltrim(cGet2) + " " + alltrim(cGet4) + " " + alltrim(cGet3)
		lPassou := .T.
		xRet := .T.
		oGet2:Refresh()
		dlgRefresh(oDlgx)
	EndIf
Else
   MsgStop("Este campo nใo pode estar em Branco !")
	lPassou := .F.
	xRet := .F.          
	dlgRefresh(oDlgx)
EndIf
Return xRet                    


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณBLQPEDNF  บAutor  ณFavaro           บ Data ณ  12/19/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function conffat(xRet)
//    Local lProcC5 := .T.  // Valdemir Jose
    
	If Len(Alltrim(cGet2)) > Len(Alltrim(cMensOri2))     
		If 	Alltrim(cGet3) <> ''
		    lProcC5 := MsgSimNao("Confirma Grava็ใo dos Dados no Pedido ? ")     // Adicionado por Valdemir 18/02/13
			//lProcC5 := ApMsgYesNo("Confirma Grava็ใo dos Dados no Pedido ? ",{"Sim","Nใo"})
			If lProcC5 //== .T.
				DbSelectArea("SC5")
				IF SC5->C5_FILIAL+SC5->C5_NUM  ==  SC9->C9_FILIAL+SC9->C9_PEDIDO
					Reclock("SC5",.F.)			
					SC5->C5_MENNOT1 := Alltrim(cGet2)
					SC5->C5_XNFCLI  := cGet3
					MsUnlock()
					xRet := .T.
				Else
					MsgStop("Pedido nใo Localizado !!!")
					xRet := .F.
				EndIf
			Else
				xRet := .F.
			EndIf
		Else
			xRet := .F.
		EndIf
		xRet := .T.
	Else
		xRet := .F.
	EndIF
Return xRet                   

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณBLQPEDNF  บAutor  ณFavaro              บ Data ณ  12/19/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function cancFat(xRet)

oDlgx:End()
xRet := .F.                  

Return xRet  
                                                                   
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณBLQPEDNF  บAutor  ณFavaro              บ Data ณ  12/19/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function confref(cMensOri1,cMensOri2,xRet)

cGet1 := cMensOri1
cGet2 := cMensOri2
lpassou := .F. 
xRet    := .F.
dlgRefresh(oDlgx)
Return xRet 



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณM460MARK  บAutor  ณValdemir Jose       บ Data ณ  02/18/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Adicionado uma rotina que farแ a fun็ใo de sim / nใo       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CCAB                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function MsgSimNao(pMSG)
Local oButton1
Local oOK
Local oTexto
Local lRET
Static oDlg

  DEFINE MSDIALOG oDlg TITLE "Mensagem" FROM 000, 000  TO 140, 300 COLORS 0, 16777215 PIXEL

    @ 043, 029 BUTTON oOK PROMPT "&Sim" SIZE 037, 012 OF oDlg ACTION {|| lRET := .T., oDlg:End()} PIXEL
    @ 043, 073 BUTTON oButton1 PROMPT "&Nใo" SIZE 037, 012 OF oDlg ACTION {|| lRET := .F., oDlg:End()} PIXEL
    @ 009, 016 SAY oTexto PROMPT pMSG SIZE 114, 027 OF oDlg COLORS 0, 16777215 PIXEL

  ACTIVATE MSDIALOG oDlg CENTERED

Return lRET




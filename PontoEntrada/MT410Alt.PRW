#INCLUDE "protheus.ch"
#INCLUDE "TopConn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT410Alt  º Autor ³                    º Data ³  24/10/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Registra Espelho de Pedido de Venda quando Exclusão        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/                                                           '

User Function MT410Alt

Local lRet := .T.

U_EspelhoPV(SC5->C5_FILIAL, SC5->C5_NUM, 'A')

IF !ALTERA
	Return .T.
EndIf

If ALTERA
	nPosTesx := aScan(aHeader,{|x| Upper(AllTrim(x[2])) == "C6_TES"})
	xTes := aCols[1][nPosTesx]
	xFaz := POSICIONE("SF4",1,xFilial("SF4")+xTes,"F4_DUPLIC")
	If  xFaz == "N"
		Return .T.
	EndIf
	If SC5->C5_CONDPAG <> SC5->C5_CONDANT
		
		cQuerAtu := "BEGIN TRANSACTION" + CHR(13) + CHR(10)
		cQuerAtu += "UPDATE "+RETSQLNAME("SC6")
		cQuerAtu += " SET C6_XJALIB = 'N', C6_XVALLIB = 0 "
		cQuerAtu += " WHERE C6_FILIAL = '"+xFilial("SC6")+"' AND C6_NUM  = '"+SC5->C5_NUM+"' AND C6_QTDEMP = 0 AND C6_QTDENT = 0"  + CHR(13) + CHR(10)
		cQuerAtu += "COMMIT"
		TCSQLEXEC(cQuerAtu)
		
		cQuerAtu := "BEGIN TRANSACTION" + CHR(13) + CHR(10)
		cQuerAtu += "UPDATE "+RETSQLNAME("SC5")
		cQuerAtu += " SET C5_TOTPANT = 0"
		cQuerAtu += " WHERE C5_FILIAL = '"+xFilial("SC5")+"' AND C5_NUM  = '"+SC5->C5_NUM+"'"  + CHR(13) + CHR(10)
		cQuerAtu += "COMMIT"
		TCSQLEXEC(cQuerAtu)
		nPosValT := aScan(aHeader,{|x| Upper(AllTrim(x[2])) == "C6_QTDLIB"})
		nTemLib  := 0
		For ntx := 1 to Len(aCols)
			nTemLib := nTemLib + aCols[ntx][nPosValT]
			If nTemLib <> 0
				MSGSTOP("Foi alterado a Condição de Pagamento deste pedido" + CHR(10)+CHR(13) +;
				" O Pedido será bloqueado no Crédito !! ")
				cQuerAtu := "BEGIN TRANSACTION" + CHR(13) + CHR(10)
				cQuerAtu += "UPDATE "+RETSQLNAME("SC6")
				cQuerAtu += " SET C6_XJALIB = 'N', C6_XVALLIB = 0 "
				cQuerAtu += " WHERE C6_FILIAL = '"+xFilial("SC6")+"' AND C6_NUM  = '"+SC5->C5_NUM+"' AND C6_QTDEMP = 0 AND C6_QTDENT = 0"  + CHR(13) + CHR(10)
				cQuerAtu += "COMMIT"
				TCSQLEXEC(cQuerAtu)
			EndIf
		Next ntx
		Return .T.
	Else
		nPosValT := aScan(aHeader,{|x| Upper(AllTrim(x[2])) == "C6_QTDLIB"})
		nPosPRCT := aScan(aHeader,{|x| Upper(AllTrim(x[2])) == "C6_PRCVEN"})
		nPosItem := aScan(aHeader,{|x| Upper(AllTrim(x[2])) == "C6_ITEM"})
		nValToTP := 0
		nValinha := 0
		For nTx := 1 to Len(aCols)
			If aCols[nTx][Len(aHeader)+1] <> .T.
				nValinha := aCols[nTx][nPosValT] * aCols[nTx][nPosPRCT]
				nValToTP := nValToTP + nValinha
			EndIf
		Next nTx
	EndIf
	
	IF SELECT('SC5TMPP') > 0
		SC5TMPP->(DBCLOSEAREA())
	EndIF
	cQUERY := ""
	cQUERY += "SELECT SUM(C6_PRCVEN * C6_QTDEMP) AS TOTAL "
	cQUERY += " FROM "+RETSQLNAME("SC6")
	cQUERY += " WHERE C6_FILIAL = '"+xFilial("SC6")+"'"
	cQUERY += " AND C6_QTDENT < C6_QTDVEN AND C6_NUM = '"+SC5->C5_NUM+"' AND D_E_L_E_T_ <> '*' AND (C6_BLQ IN ('N',' '))"
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'SC5TMPP', .F., .T.)
	If SC5TMPP->TOTAL > SC5->C5_TOTPANT .AND. SC5->C5_TOTPANT > 0
		nDifer   := GETMV("MV_PERLPED")
		nMaxValL := (SC5->C5_TOTPANT * (100+nDifer)) / 100   /// Valor maximo que pode ser alterado o pedido
		If SC5TMPP->TOTAL > nMaxValL
			nPosValT := aScan(aHeader,{|x| Upper(AllTrim(x[2])) == "C6_QTDLIB"})
			nPosSALT := aScan(aHeader,{|x| Upper(AllTrim(x[2])) == "C6_SLDALIB"})
			nPosSBLQ := aScan(aHeader,{|x| Upper(AllTrim(x[2])) == "C6_BLQ"})
			nPosSVLB := aScan(aHeader,{|x| Upper(AllTrim(x[2])) == "C6_XVALLIB"})
			nTemLib  := 0
			For ntx := 1 to Len(aCols)
				
				If aCols[ntx][nPosSBLQ] $ "C//R//S"
					If aCols[ntx][nPosSBLQ] == "C"
						U_EspelhoPV(SC6->C6_FILIAL, SC6->C6_NUM, 'C')
					EndIf
					If aCols[ntx][nPosSBLQ] == "R"
						U_EspelhoPV(SC6->C6_FILIAL, SC6->C6_NUM, 'R')
					EndIf
					If aCols[ntx][nPosSBLQ] == "S"
						U_EspelhoPV(SC6->C6_FILIAL, SC6->C6_NUM, 'S')
					EndIf
					loop
				EndIf
				
				If aCols[ntx][Len(aCols[ntx])] == .T.
					U_EspelhoPV(SC6->C6_FILIAL, SC6->C6_NUM, 'E')
					loop
				EndIf
				
				If aCols[ntx][nPosSALT] == 0
					loop
				EndIf     
				
				nTemLib := nTemLib + aCols[ntx][nPosValT]
				
				If nTemLib <> 0
					MSGSTOP("Este Pedido ultrapassou o valor Limite de "+ALLTRIM(STR(nDifer))+"% do Valor Original" + CHR(10)+CHR(13) +;
					" O Pedido permanecerá bloqueado no Crédito !! ")
					cQuerAtu := "BEGIN TRANSACTION" + CHR(13) + CHR(10)
					cQuerAtu += "UPDATE "+RETSQLNAME("SC6")
					cQuerAtu += " SET C6_XJALIB = 'N', C6_XVALLIB = 0 "
					cQuerAtu += " WHERE C6_FILIAL = '"+xFilial("SC6")+"' AND C6_NUM  = '"+SC5->C5_NUM+"' AND C6_QTDEMP = 0 AND C6_QTDENT = 0"  + CHR(13) + CHR(10)
					cQuerAtu += "COMMIT"
					TCSQLEXEC(cQuerAtu)
				EndIf
			Next ntx
			Return .T.
		Else
			LiberC9X()
		EndIf
	Else
		LiberC9X()
	EndIf
EndIf
Return




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT410ALT  ºAutor  ³Microsiga           º Data ³  12/14/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function LiberC9X()

aRegSC6 := {}
cPedido := SC9->C9_PEDIDO
dbSelectArea("SC9")
dbSetOrder(1)
lQuery := .T.
lProcessa := .F.
cAliasSC9 := "A450LIBMAN"
cAliasSC5 := "A450LIBMAN"
cAliasSC6 := "A450LIBMAN"
cQuery := "SELECT C9_FILIAL,C9_PEDIDO,C9_BLCRED,C9_ITEM,SC9.R_E_C_N_O_ SC9RECNO,SC5.C5_TIPLIB,"
cQuery += "SC5.R_E_C_N_O_ SC5RECNO,SC6.R_E_C_N_O_ SC6RECNO,C6_XJALIB "
cQuery += "FROM "+RetSqlName("SC9")+" SC9,"
cQuery += RetSqlName("SC5")+" SC5,"
cQuery += RetSqlName("SC6")+" SC6 "
cQuery += "WHERE SC9.C9_FILIAL = '"+xFilial("SC9")+"' AND "
cQuery += "SC9.C9_PEDIDO = '"+SC5->C5_NUM+"' AND "
cQuery += "SC9.D_E_L_E_T_ = '  ' AND "
cQuery += "SC5.C5_FILIAL='"+xFilial("SC5")+"' AND "
cQuery += "SC5.C5_NUM=SC9.C9_PEDIDO AND "
cQuery += "SC5.D_E_L_E_T_ = ' ' AND "
cQuery += "SC6.C6_FILIAL='"+xFilial("SC6")+"' AND "
cQuery += "SC6.C6_NUM=SC5.C5_NUM AND "
cQuery += "SC6.C6_ITEM=SC9.C9_ITEM AND "
cQuery += "SC6.C6_PRODUTO=SC9.C9_PRODUTO AND "
cQuery += "SC6.C6_XJALIB = 'S' AND "
cQuery += "SC6.D_E_L_E_T_ = ' ' "
cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSC9,.T.,.T.)

While ( !Eof() .And. (cAliasSC9)->C9_FILIAL == xFilial("SC9") .And.;
	(cAliasSC9)->C9_PEDIDO == SC5->C5_NUM )
	aadd(aRegSC6,SC6->(RecNo()))
	If !lQuery
		dbSelectArea("SC5")
		dbSetOrder(1)
		MsSeek(xFilial("SC5")+SC9->C9_PEDIDO)
	Else
		SC5->(MsGoto((cAliasSC5)->SC5RECNO))
	EndIf
	If (cAliasSC5)->C5_TIPLIB == "2"
		If !lQuery
			dbSelectArea("SC6")
			dbSetOrder(1)
			MsSeek(xFilial("SC6")+SC9->C9_PEDIDO+SC9->C9_ITEM+SC9->C9_PRODUTO)
			aadd(aRegSC6,SC6->(RecNo()))
		Else
			aadd(aRegSC6,(cAliasSC6)->SC6RECNO)
		EndIf
	Else
		If lQuery
			SC9->(MsGoto((cAliasSC9)->SC9RECNO))
		EndIf
		a450Grava(1,.T.,.F.,,,.F.)
		lProcessa := .T.
	EndIf
	dbSelectArea(cAliasSC9)
	dbSkip()
EndDo

If lQuery
	dbSelectArea(cAliasSC9)
	dbCloseArea()
	dbSelectArea("SC9")
EndIf

dbSelectArea("SC9")
DbClearFilter()
dbSetOrder(1)

If 	lProcessa == .T.
	Begin Transaction
	MaAvalSC5("SC5",3,.F.,.F.,,,,,,SC5->C5_NUM,aRegSC6,.T.,.F.)
	End Transaction
EndIf
Return

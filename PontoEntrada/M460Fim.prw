#INCLUDE 'PROTHEUS.CH'
#include "TBICONN.CH"
#include "RWMAKE.CH"             
#include "TOPCONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³M460FIM   ºAutor  ³Rodrigo Seiti Mitaniº Data ³  31/07/07   º±±
±±ºPrograma  ³			ºAutor  ³Edgar Serrano       º Data ³  05/01/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³Atualiza campos de desconto financeiro no contas a receber  º±±
±±º          ³Por Rodrigo Seiti											  º±±
±±º          ³                                                            º±±
±±ºDescricao ³Ponto de entrada responsavel por gerar pedido de entrega    º±±
±±º          ³automaticamente caso o mesmo seja Conta e Ordem.            º±±
±±º          ³Por Edgar Serrano									          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico CCAB                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function M460FIM()
//
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local _AREA := GetArea()
Local _DOC
Local _SERIE
Local _PEDIDO
Local _TOTDES
Local _TOTGER
Local _DTEMIS
Local aParc

Local _aCab		:= {}
Local _aItens	:= {}
Local _nCount	:= 0
Local _cNumPed 	:= ""
Local _cTes		:= ""
Local _cObsPedido:=""
Local _cCondPag := ""
Local _lEmp		:= .F.

Local nPercSyn   := 0
Local cPortadSyn := AllTrim(GetMV("MV_XSYNPOR"))
Local nPercLimit := GetMV("MV_XSYNPER")
Local cAgencSyn  := Posicione("SA6", 1, xFilial("SA6") + cPortadSyn, "A6_AGENCIA")
Local cContaSyn  := Posicione("SA6", 1, xFilial("SA6") + cPortadSyn, "A6_NUMCON")

_DOC	 := SD2->D2_DOC
_SERIE	 := SF2->F2_PREFIXO
_PEDIDO  := SD2->D2_PEDIDO
_DTEMIS  := SD2->D2_EMISSAO           	

nMoedaCor 		:= SC5->C5_MOEDA
nTaxa		    := RecMoeda(_DTEMIS,nMoedaCor)

If Select("BRT") > 0
	DbSelectArea("BRT")
	DbCloseArea("BRT")
End If

BeginSql Alias "BRT"
	%noparser%
	Select D2_PEDIDO, D2_ITEMPV, Sum(D2_QUANT) As QUANT, Sum(D2_TOTAL) As Total, C6_XDESFIN as DESCONTO From %Table:SD2% SD2, %Table:SC6% SC6, %Table:SF4% SF4
	Where SD2.%NotDel% and SC6.%NotDel% and SF4.%NotDel% and D2_DOC = %Exp:SF2->F2_DOC% and D2_SERIE = %Exp:SF2->F2_SERIE% and D2_FILIAL = %Exp:SF2->F2_FILIAL%
	and D2_FILIAL+D2_PEDIDO+D2_ITEMPV = C6_FILIAL+C6_NUM+C6_ITEM and D2_TES = F4_CODIGO and F4_AGREG <> 'N'
	Group By D2_PEDIDO, D2_ITEMPV, C6_XDESFIN
EndSql

_xmoeda   := GetAdvFval("SC5","C5_MOEDA",SD2->D2_FILIAL+SD2->D2_PEDIDO,1,1)
_TOTDES   :=  0
_TOTGER   :=  0

DbSelectArea("BRT")
Do While !Eof("BRT")
	_TOTDES :=  _TOTDES + Round(BRT->(IIf(QUANT==0,1,QUANT)*DESCONTO),2)
	_TOTGER :=  _TOTGER + BRT->TOTAL
	DbSkip()
EndDo

If _xmoeda <> 1
	_TOTDES := Round(_TOTDES*IIf(_xMoeda <> 1,nTaxa,1),2)
End If

_cUpd := "Update "+RetSqlName("SE1")+" Set E1_DESCFIN = "+STR((_TOTDES/_TOTGER)*100)+" Where E1_PREFIXO = '"+AllTrim(_SERIE)+"' and E1_NUM = '"+_DOC+"'"
_cUpd := _cUpd + "and D_E_L_E_T_ =  ' ' and E1_ORIGEM = 'MATA460' "

TcSqlExec(_cUpd)

If Select("BRT") > 0
	DbSelectArea("BRT")
	DbCloseArea("BRT")
EndIf
                        
nPercSyn := PerProdSyn()

DbSelectArea("SA1")
DbSelectArea("SE1")
SA1->(dbSetOrder(1))
SE1->(dbSetOrder(1))
SA1->(dbSeek(xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA))
SE1->(dbSeek(xFilial("SE1")+SF2->F2_PREFIXO+SF2->F2_DOC))


Do While SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_CLIENTE+SE1->E1_LOJA == SF2->F2_PREFIXO+SF2->F2_DOC+SF2->F2_CLIENTE+SF2->F2_LOJA
	If SF2->F2_TIPO == "N"
		cTipoProd := ""
		If !Empty(Select("PRODUTO"))
			dbSelectArea("PRODUTO")
			dbCloseArea()                               
		Endif
		Reclock("SE1",.f.)
		SE1->E1_HIST     := "NF NORMAL"                                       
		SE1->E1_XRAZAOS  := SA1->A1_NOME
		SE1->E1_XCGC     := SA1->A1_CGC
		SE1->E1_XESPECI  := SF2->F2_ESPECIE
		SE1->E1_XTPPED   := SF2->F2_XTPPED
		SE1->E1_XGESTOR  := SA1->A1_XGESTOR
		SE1->E1_XCOND	 := SF2->F2_COND
		SE1->E1_XCONDDE	 := Posicione("SE4", 1, xFilial("SE4") + SF2->F2_COND, "E4_DESCRI")
		SE1->E1_XCLIENT  := SF2->F2_CLIENT
		SE1->E1_XLOJENT  := SF2->F2_LOJENT
		SE1->E1_XDCLIEN  := Posicione("SA1", 1, xFilial("SA1") + SF2->F2_CLIENT + SF2->F2_LOJENT, "A1_NOME")
		If nPercSyn >= nPercLimit
			SE1->E1_PORTADO  := cPortadSyn
			SE1->E1_AGEDEP	 := cAgencSyn
			SE1->E1_CONTA	 := cContaSyn
		Else
			SE1->E1_PORTADO  := SC5->C5_XTPFIN
		EndIf
		SE1->E1_XTIPOB1  := POSICIONE("SD2",3,xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA,"D2_TP")
		SE1->E1_XPERNOT  := nPercSyn
		SE1->(MsUnlock())
		SE1->(dbSkip())
	EndIf
	If SF2->F2_TIPO == "C"
		Reclock("SE1",.f.)
		SE1->E1_HIST  := "NF COMPL PRECO"
		SE1->E1_XRAZAOS  := SA1->A1_NOME
		SE1->E1_XCGC     := SA1->A1_CGC
		SE1->E1_XESPECI  := SF2->F2_ESPECIE
		SE1->E1_XTPPED   := SF2->F2_XTPPED
		SE1->E1_XGESTOR  := SA1->A1_XGESTOR
		SE1->E1_XCOND	 := SF2->F2_COND
		SE1->E1_XCONDDE	 := Posicione("SE4", 1, xFilial("SE4") + SF2->F2_COND, "E4_DESCRI")
		SE1->E1_XCLIENT  := SF2->F2_CLIENT
		SE1->E1_XLOJENT  := SF2->F2_LOJENT
		SE1->E1_XDCLIEN  := Posicione("SA1", 1, xFilial("SA1") + SF2->F2_CLIENT + SF2->F2_LOJENT, "A1_NOME")
		If nPercSyn >= nPercLimit
			SE1->E1_PORTADO  := cPortadSyn
			SE1->E1_AGEDEP	 := cAgencSyn
			SE1->E1_CONTA	 := cContaSyn
		Else
			SE1->E1_PORTADO  := SC5->C5_XTPFIN
		EndIf
		SE1->E1_XTIPOB1  := POSICIONE("SD2", 3 ,xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA ,"D2_TP")
		SE1->E1_XPERNOT  := nPercSyn
		SE1->(MsUnlock())
		SE1->(dbSkip())
	EndIf
	If SF2->F2_TIPO == "I"
		Reclock("SE1",.f.)
		SE1->E1_HIST  := "NF COMPL ICMS"
		SE1->E1_XRAZAOS  := SA1->A1_NOME
		SE1->E1_XCGC     := SA1->A1_CGC
		SE1->E1_XESPECI  := SF2->F2_ESPECIE
		SE1->E1_XTPPED   := SF2->F2_XTPPED
		SE1->E1_XGESTOR  := SA1->A1_XGESTOR
		SE1->E1_XCOND	 := SF2->F2_COND
		SE1->E1_XCONDDE	 := Posicione("SE4", 1, xFilial("SE4") + SF2->F2_COND, "E4_DESCRI")
		SE1->E1_XCLIENT  := SF2->F2_CLIENT
		SE1->E1_XLOJENT  := SF2->F2_LOJENT
		SE1->E1_XDCLIEN  := Posicione("SA1", 1, xFilial("SA1") + SF2->F2_CLIENT + SF2->F2_LOJENT, "A1_NOME")
		If nPercSyn >= nPercLimit
			SE1->E1_PORTADO  := cPortadSyn
			SE1->E1_AGEDEP	 := cAgencSyn
			SE1->E1_CONTA	 := cContaSyn
		Else
			SE1->E1_PORTADO  := SC5->C5_XTPFIN
		EndIf
		SE1->E1_XTIPOB1  := POSICIONE("SD2",3,xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA,"D2_TP")
		SE1->E1_XPERNOT  := nPercSyn		
		SE1->(MsUnlock())                                                                                                   
		SE1->(dbSkip())
	EndIf
	If SF2->F2_TIPO == "P"
		Reclock("SE1",.f.)
		SE1->E1_HIST  := "NF COMPL IPI"
		SE1->E1_XRAZAOS  := SA1->A1_NOME
		SE1->E1_XCGC     := SA1->A1_CGC
		SE1->E1_XESPECI  := SF2->F2_ESPECIE
		SE1->E1_XTPPED   := SF2->F2_XTPPED
		SE1->E1_XGESTOR  := SA1->A1_XGESTOR
		SE1->E1_XCOND	 := SF2->F2_COND
		SE1->E1_XCONDDE	 := Posicione("SE4", 1, xFilial("SE4") + SF2->F2_COND, "E4_DESCRI")
		SE1->E1_XCLIENT  := SF2->F2_CLIENT
		SE1->E1_XLOJENT  := SF2->F2_LOJENT
		SE1->E1_XDCLIEN  := Posicione("SA1", 1, xFilial("SA1") + SF2->F2_CLIENT + SF2->F2_LOJENT, "A1_NOME")
		If nPercSyn >= nPercLimit
			SE1->E1_PORTADO  := cPortadSyn
			SE1->E1_AGEDEP	 := cAgencSyn
			SE1->E1_CONTA	 := cContaSyn
		Else
			SE1->E1_PORTADO  := SC5->C5_XTPFIN
		EndIf
		SE1->E1_XTIPOB1  := POSICIONE("SD2",3,xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA,"D2_TP")		
		SE1->E1_XPERNOT  := nPercSyn		
		SE1->(MsUnlock())
		SE1->(dbSkip())
	EndIf
EndDo

DbSelectArea("SA2")
DbSelectArea("SE2")
SA2->(dbSetOrder(1))
SE2->(dbSetOrder(1))
SA2->(dbSeek(xFilial("SA2")+SF2->F2_CLIENTE+SF2->F2_LOJA))
SE2->(dbSeek(xFilial("SE2")+SF2->F2_PREFIXO+SF2->F2_DOC))
Do While SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_FORNECE+SE2->E2_LOJA == SF2->F2_PREFIXO+SF2->F2_DOC+SF2->F2_CLIENTE+SF2->F2_LOJA
	If SF2->F2_TIPO == "D"
		Reclock("SE2",.f.)
		SE2->E2_HIST  := SF2->F2_MENNOTA
		SE2->(MsUnlock())
		SE2->(dbSkip())
	EndIf
	If SF2->F2_TIPO == "B"
		Reclock("SE2",.f.)
		SE2->E2_HIST  := SF2->F2_MENNOTA
		SE2->(MsUnlock())
		SE2->(dbSkip())
	EndIf
EndDo

RestArea(_AREA)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicio da Personalizacao Por EDGAR SERRANO - Personalizacao para Pedidos Conta e Ordem                                    ³
//³ Localiza o Pedido de Venda, caso o mesmo seja do Tipo (E5_XTPPED) 2 = Conta e Ordem, sera gerado o pedido de entrega      ³
//³ para o cliente referente no Pedido Original, com referencia nos dados da Nota Fiscal. 									  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Begin Transaction

//DbSelectArea("SA1")
DbSelectArea("SC5")
SC5->(DbSetOrder(3))
If SC5->(DbSeek( xFilial("SC5") + SD2->D2_CLIENTE + SD2->D2_LOJA + SD2->D2_PEDIDO ))
	
	//*********************** INICIO DO TRATAMENTO DA MENSAGEM SAIDA DE ARMAZEM...... - FERNANDO K. - AGILITY
	//If Alltrim(Xfilial("SC5")) == "01" //Somente se São Paulo... //ALTERADO PARA ENTRADA PARA FILIAL 06 ALDEMIR ALAN-- AGILITY
	If Alltrim(Xfilial("SC5")) == "01" .OR. Alltrim(Xfilial("SC5")) == "06" //AMBAS TRATAM O ESPEFICICO 
		cMensg := SPACE(200)
		cMsg := SPACE(34)
		aMsg := {}
		
		AADD(aMsg," ")
		
		Dbselectarea("SM4")
		SM4->(Dbsetorder(1))
		If SM4->(Dbseek(Xfilial("SM4")+"X01"))
			cMsg := SM4->M4_CODIGO+"-"+SM4->M4_DESCR
			While !SM4->(EOF()) .AND. UPPER(Substr(SM4->M4_CODIGO,1,1)) == "X" .AND. SM4->M4_FILIAL = Xfilial("SM4")
				AADD(aMsg,SM4->M4_CODIGO+"-"+SM4->M4_DESCR)
				SM4->(Dbskip())
			End
		Endif
		
		@ 0,0 TO 150,470 DIALOG oDlg1 TITLE "Mensagem de Saída de Armazém"
		@ 10,10 Say "Informe qual mensagem utilizada para a saida do Armazém: "
		@ 25,10 Say "Mensagem:"
		@ 25,50 COMBOBOX cMsg ITEMS aMsg SIZE 115,08
		
		@ 40,10 GET cMensg SIZE 220,08 WHEN Mudacpo()
		
		@ 60,200 BMPBUTTON TYPE 01 ACTION Close(oDlg1)
		ACTIVATE DIALOG oDlg1 CENTER
		
		Reclock("SC5",.F.)
		REPLACE SC5->C5_MENPAD2 WITH Substr(cMsg,1,3)
		SC5->(MSUNLOCK())
	Endif
	//*********************** FIM DO TRATAMENTO DA MENSAGEM SAIDA DE ARMAZEM...... - FERNANDO K. - AGILITY
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se o pedido da Nota em questao e Conta/Ordem       															  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ( SC5->C5_XTPPED == "1" ) .Or. ( SC5->C5_XTPPED == "2" .And. SC5->C5_CLIENTE + SC5->C5_LOJACLI # SC5->C5_CLIENT + SC5->C5_LOJAENT )
		
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ TES/Condicao de Pagamento condicional para cada UF via paremetros  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		_cNumPed	:= GetSx8Num("SC5", "C5_NUM")
		_nMoeda		:= SC5->C5_MOEDA
		_cObsPedido 	:= " Pedido Venda: " + SC5->C5_NUM
		ConfirmSX8()
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Altera/Adiciona Mensagem da Nota Fiscal original conforme especificacao        ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If SC5->C5_XTPPED == "2" // Conta e Ordem
			
			If SC5->(RecLock("SC5", .F.))
				Replace SC5->C5_MENNOT1 With " Simples Faturamento de " + Alltrim(Upper(Posicione("SA1", 1, xFilial("SA1") + SC5->C5_CLIENT + SC5->C5_LOJAENT, "A1_NREDUZ"))) //A1_NREDUZ
				Replace SC5->C5_XOBSERV With Alltrim(SC5->C5_XOBSERV)+" Ped. Rem.: "+_cNumPed
				SC5->(MsUnLock())
			EndIf
			If SF2->(RecLock("SF2", .F.))
				Replace SF2->F2_MENNOT1 With " Simples Faturamento de " + Alltrim(Upper(Posicione("SA1", 1, xFilial("SA1") + SC5->C5_CLIENT + SC5->C5_LOJAENT, "A1_NREDUZ")))//A1_NREDUZ
				SF2->(MsUnLock())
			EndIf
			
			_cTes := SubStr( GetMV("MV_XTESC"), At(Posicione("SA1", 1, xFilial("SA1") + SC5->C5_CLIENT + SC5->C5_LOJAENT, "A1_EST"), GetMV("MV_XTESC")) + 2, 3)
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Cria mensagem para nota fiscal referenciando o Pedido Original     ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			_cMenNota := "Mercadoria entregue por conta e ordem de: "
			_cMenNota += Alltrim(Upper(Posicione("SA1", 1, xFilial("SA1") + SC5->C5_CLIENTE + SC5->C5_LOJACLI, "A1_NOME")))
			_cMenNota += " CNPJ: " + Posicione("SA1", 1, xFilial("SA1") + SC5->C5_CLIENTE + SC5->C5_LOJACLI, "A1_CGC")
			_cMenNota += " IE: "   + Posicione("SA1", 1, xFilial("SA1") + SC5->C5_CLIENTE + SC5->C5_LOJACLI, "A1_INSCR")
			_cMenNota += " NF CCAB: " + SD2->D2_DOC
			
			_lEmp := .T.
			
		ElseIf SC5->C5_XTPPED == "1" // Entrega Futura
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Cria mensagem para nota fiscal Entrega Futura				       ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			_cMenNota := "Simples remessa de mercadoria faturada atraves da NFE " + Alltrim(SF2->F2_DOC) + "/" + Alltrim(SF2->F2_SERIE) + " em " + DtoC(dDatabase)
			_cTes 	  := SubStr( GetMV("MV_XTESF"), At(Posicione("SA1", 1, xFilial("SA1") + SC5->C5_CLIENTE + SC5->C5_LOJACLI, "A1_EST"), GetMV("MV_XTESF")) + 2, 3)
			If SC5->(RecLock("SC5", .F.))
				Replace SC5->C5_XOBSERV With Alltrim(SC5->C5_XOBSERV)+" Ped. Rem.: "+_cNumPed
				SC5->(MsUnLock())
			EndIf
		EndIf
		cTABELA := SC5->C5_TABELA     // Adicionado por Valdemir Jose 14/05/2013
		cXTPPED := SC5->C5_XTPPED     // Adicionado por Valdemir Jose
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Cria cabecalho do Pedido de Entrega com base no Pedido Original    ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aAdd( _aCab,{"C5_FILIAL"	, xFilial("SC5")		      				, NIL})
		aAdd( _aCab,{"C5_NUM"		, _cNumPed									, NIL})
		aAdd( _aCab,{"C5_TIPO"		, SC5->C5_TIPO				    			, NIL})
		If SC5->C5_XTPPED == "2" // Conta e Ordem
			aAdd( _aCab,{"C5_CLIENTE"	, SC5->C5_CLIENT			            , NIL})
			aAdd( _aCab,{"C5_LOJACLI"	, SC5->C5_LOJAENT			            , NIL})
			aAdd( _aCab,{"C5_CLIENT"	, SC5->C5_CLIENT			            , NIL})       //ALTERADO POR SAMIR
			aAdd( _aCab,{"C5_LOJAENT"	, SC5->C5_LOJAENT			            , NIL})		//ALTERADO POR SAMIR
		ElseIf SC5->C5_XTPPED == "1" // Entrega Futura
			aAdd( _aCab,{"C5_CLIENTE"	, SC5->C5_CLIENTE			            , NIL})
			aAdd( _aCab,{"C5_LOJACLI"	, SC5->C5_LOJACLI			            , NIL})
			aAdd( _aCab,{"C5_CLIENT"	, SC5->C5_CLIENT			            , NIL})       //ALTERADO POR SAMIR
			aAdd( _aCab,{"C5_LOJAENT"	, SC5->C5_LOJAENT			            , NIL})		//ALTERADO POR SAMIR
		EndIf
		aAdd( _aCab,{"C5_CONDPAG"	, SC5->C5_CONDPAG	 		                , NIL})
		aAdd( _aCab,{"C5_TRANSP"      ,"000001"                             	, NIL})
		aAdd( _aCab,{"C5_TIPOCLI"	, SC5->C5_TIPOCLI		             		, NIL})
		aAdd( _aCab,{"C5_TABELA"	, "000"                             		, NIL})   // "000" - TROCADO POR VALDEMIR JOSE 13/05/2013
		aAdd( _aCab,{"C5_VEND1"		, SC5->C5_VEND1		             			, NIL})
		aAdd( _aCab,{"C5_COMIS1"	, SC5->C5_COMIS1		             		, NIL})
		aAdd( _aCab,{"C5_VEND2"		, SC5->C5_VEND2		             			, NIL})
		aAdd( _aCab,{"C5_COMIS2"	, SC5->C5_COMIS2		             		, NIL})
		aAdd( _aCab,{"C5_VEND3"		, SC5->C5_VEND3		             			, NIL})
		aAdd( _aCab,{"C5_COMIS3"	, SC5->C5_COMIS3		             		, NIL})
		aAdd( _aCab,{"C5_VEND4"		, SC5->C5_VEND4		             			, NIL})
		aAdd( _aCab,{"C5_COMIS4"	, SC5->C5_COMIS4		             		, NIL})
		aAdd( _aCab,{"C5_DESC1"		, SC5->C5_DESC1		             			, NIL})
		aAdd( _aCab,{"C5_DESC2"		, SC5->C5_DESC2		             			, NIL})
		aAdd( _aCab,{"C5_DESC3"		, SC5->C5_DESC3		             			, NIL})
		aAdd( _aCab,{"C5_DESC4"		, SC5->C5_DESC4		             			, NIL})
		aAdd( _aCab,{"C5_EMISSAO"	, dDataBase		             				, NIL})
		aAdd( _aCab,{"C5_PARC1"		, SC5->C5_PARC1		             			, NIL})
		aAdd( _aCab,{"C5_DATA1"		, SC5->C5_DATA1  	             			, NIL})
		aAdd( _aCab,{"C5_PARC2"		, SC5->C5_PARC2		             			, NIL})
		aAdd( _aCab,{"C5_DATA2"		, SC5->C5_DATA2  	             			, NIL})
		aAdd( _aCab,{"C5_PARC3"		, SC5->C5_PARC3		             			, NIL})
		aAdd( _aCab,{"C5_DATA3"		, SC5->C5_DATA3  	             			, NIL})
		aAdd( _aCab,{"C5_PARC4"		, SC5->C5_PARC4		             			, NIL})
		aAdd( _aCab,{"C5_DATA4"		, SC5->C5_DATA4  	             			, NIL})
		aAdd( _aCab,{"C5_TPFRETE"	, SC5->C5_TPFRETE		             		, NIL})
		aAdd( _aCab,{"C5_MOEDA"		, 1					             			, NIL})
		aAdd( _aCab,{"C5_MENNOTA"	, SubStr(_cMenNota, 1, 128)            		, NIL})
		aAdd( _aCab,{"C5_TPCARGA"	, SC5->C5_TPCARGA		             		, NIL})
		aAdd( _aCab,{"C5_TXMOEDA"	, SC5->C5_TXMOEDA		             		, NIL})
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Campos de personalizados CCAB 									   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aAdd( _aCab,{"C5_MENNOT1"	, SubStr(_cMenNota, 129)            		, NIL})
		aAdd( _aCab,{"C5_XTABDES"	, SC5->C5_XTABDES		             		, NIL})
		aAdd( _aCab,{"C5_XDVEND2"	, SC5->C5_XDVEND2		             		, NIL})
		aAdd( _aCab,{"C5_XTES"		, _cTes					             		, NIL})
		If SC5->C5_XTPPED == "2" // Conta e Ordem
			aAdd( _aCab,{"C5_XCLIENT" ,  Posicione("SA1", 1, xFilial("SA1") + SC5->(C5_CLIENT+C5_LOJAENT) , "A1_NOME"), NIL})
		ElseIf SC5->C5_XTPPED == "1" // Entrega Futura
			aAdd( _aCab,{"C5_XCLIENT" ,  Posicione("SA1", 1, xFilial("SA1") + SC5->(C5_CLIENTE+C5_LOJACLI), "A1_NOME"), NIL})
		EndIf
		aAdd( _aCab,{"C5_XOBSERV"	, _cObsPedido			            		, NIL})
		aAdd( _aCab,{"C5_XESPECI"	, SC5->C5_XESPECI		             		, NIL})
		aAdd( _aCab,{"C5_XESTCLI"	, SC5->C5_XESTCLI		             		, NIL})
		aAdd( _aCab,{"C5_XDESPER"	, SC5->C5_XDESPER		             		, NIL})
		aAdd( _aCab,{"C5_XDOCORI"	, SF2->F2_DOC			             		, NIL})
		aAdd( _aCab,{"C5_XSERORI"	, SF2->F2_SERIE			             		, NIL})
		aAdd( _aCab,{"C5_XTPPED"	, "3"					             		, NIL})
		
		
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Tratamento para Garvar o Tipo do Pedido Original e o Numero para futuras consultas             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If SC5->C5_XTPPED == "2" .OR. SC5->C5_XTPPED == "1"    // Conta e Ordem e Venda Futura	
			aAdd( _aCab,{"C5_TPPDORI"	, SC5->C5_XTPPED	             		, NIL})
			aAdd( _aCab,{"C5_PEDGORI"	, SC5->C5_NUM 		             		, NIL})				
		EndIf

		
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Cria array dos Itens do Pedido de Entrega com base no(s) Iten(s) gerado(s) pela Nota Fiscal    ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		_nPrcUnit 	:= 0
		_nPrcVen	:= 0
		_nTotal		:= 0
		
		
		DbSelectArea("SD2")
		SD2->(DbGoTop())
		SD2->(DbSetOrder(3))
		If DbSeek( xFilial("SD2") + SF2->(F2_DOC + F2_SERIE + F2_CLIENTE + F2_LOJA))
			While !SD2->(Eof()) .And. 	SD2->D2_FILIAL	== 	SF2->F2_FILIAL 	.And. ;
				SD2->D2_DOC		== 	SF2->F2_DOC 	.And. ;
				SD2->D2_SERIE	== 	SF2->F2_SERIE 	.And. ;
				SD2->D2_CLIENTE	== 	SF2->F2_CLIENTE .And. ;
				SD2->D2_LOJA	==	SD2->D2_LOJA
				
				
				_nPrcUnit := Posicione("SC6",1 ,xFilial("SC6") + SD2->D2_PEDIDO  + SD2->D2_ITEMPV + SD2->D2_COD, "C6_PRUNIT")
				_nPrcVen  := Posicione("SC6",1 ,xFilial("SC6") + SD2->D2_PEDIDO  + SD2->D2_ITEMPV + SD2->D2_COD, "C6_PRCVEN")
				_cLocal   := Posicione("SC6",1 ,xFilial("SC6") + SD2->D2_PEDIDO  + SD2->D2_ITEMPV + SD2->D2_COD, "C6_LOCAL")
				_dEntreg  := Posicione("SC6",1 ,xFilial("SC6") + SD2->D2_PEDIDO  + SD2->D2_ITEMPV + SD2->D2_COD, "C6_XENTREG")
				
				If _nMoeda <> 1
					_nPrcUnit	:= _nPrcUnit * RecMoeda(dDataBase, _nMoeda)
					_nPrcVen  	:= _nPrcVen  * RecMoeda(dDataBase, _nMoeda)
				EndIf
				
				_nTotal		:= Round(SD2->D2_QUANT * _nPrcVen ,2)
				
				_cTransp := ""
			    IF SC5->C5_XTPPED == "2" .and. SC5->C5_TPFRETE == "C"  // Se for CIF e Tipo Conta e Ordem....
   		   		    _cTransp := Posicione("SZ4",3,Xfilial("SZ4")+SF2->F2_EST+SM0->M0_CODFIL+_cLocal,"Z4_TRANSP")
                Endif                                                                                           
			    IF SC5->C5_XTPPED == "1"
   		   		    _cTransp := Posicione("SC6",1 ,xFilial("SC6") + SD2->D2_PEDIDO  + SD2->D2_ITEMPV + SD2->D2_COD, "C6_TRANSP")
                Endif                                                                                                           
                
				_aRet := {}
				_nCount++
				aAdd( _aRet, {"C6_FILIAL"	, xFilial("SC6")											 		, NIL})
				aAdd( _aRet, {"C6_ITEM"		, StrZero(_nCount,2)									 	 		, NIL})
				aAdd( _aRet, {"C6_PRODUTO"	, SD2->D2_COD											 			, NIL})
				aAdd( _aRet, {"C6_DESCRI"	, Posicione("SB1",1 ,xFilial("SB1") + SD2->D2_COD,  "B1_DESC")		, NIL})
				aAdd( _aRet, {"C6_UM" 		, Posicione("SB1",1 ,xFilial("SB1") + SD2->D2_COD,  "B1_UM") 		, NIL})
				aAdd( _aRet, {"C6_QTDVEN" 	, SD2->D2_QUANT 													, NIL})
				aAdd( _aRet, {"C6_PRUNIT" 	, _nPrcUnit															, NIL})
				aAdd( _aRet, {"C6_PRCVEN"	, _nPrcVen															, NIL})
				aAdd( _aRet, {"C6_VALOR"    , _nTotal								   						    , NIL})
				aAdd( _aRet, {"C6_LOCAL"	, _cLocal  															, NIL})
				aAdd( _aRet, {"C6_TES"		, _cTes            										 			, NIL})
				aAdd( _aRet, {"C6_NUM"		, _cNumPed															, NIL})
				If _lEmp // Conta e Ordem
					aAdd( _aRet, {"C6_QTDEMP"	, SD2->D2_QUANT													, NIL})
					aAdd( _aRet, {"C6_QTDLIB"	, SD2->D2_QUANT													, NIL})
				EndIf
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Campos de personalizados CCAB 									   ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				aAdd( _aRet, {"C6_ABSCINS"	, SD2->D2_ABSCINS							 						, NIL})
				
				If SC5->C5_XTPPED == "2"     // Conta e Ordem
					aAdd( _aRet,{"C6_XENTREG"	, dDataBase		             				, NIL})
				ElseIf SC5->C5_XTPPED == "1" // Entrega Futura
					aAdd( _aRet,{"C6_XENTREG"	, _dEntreg		             				, NIL})
				EndIf
				
				aAdd( _aRet, {"C6_XDESFIN"	, SD2->D2_XDESFIN							 						, NIL})
				aAdd( _aRet, {"C6_XTABELA"	, SD2->D2_XTABELA							 						, NIL})
				aAdd( _aRet, {"C6_ABATISS"	, SD2->D2_ABATISS							 						, NIL})
				aAdd( _aRet, {"C6_ABATMAT"	, SD2->D2_ABATMAT							 						, NIL})
				aAdd( _aRet, {"C6_TRANSP"	, _cTransp 									 						, NIL})
				aAdd( _aRet, {"C6_XDESPER"	, SD2->D2_XDESCON							 						, NIL})
				aAdd( _aRet, {"C6_XDOCORI"	, SF2->F2_DOC   											 		, NIL})
				aAdd( _aRet, {"C6_XSERORI"	, SF2->F2_SERIE														, NIL})
				aAdd( _aItens, _aRet)
				SD2->(DbSkip())
			EndDo
		EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Realiza o ExecAuto para insercao automatica do Pedido de Entrega - Referenciado pelo Pedido Original e Nota Fiscal gerada 	   ³								   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		lMsErroAuto := .F.
		//------------------------------------
		//Tentativa de solucionar dificuldade
		//de reserva de registro no SA1 (EOF)
		//------------------------------------
		//SA1->(DbSetOrder(1))
		//SA1->(DbSeek(xFilial("SA1")+_aCab[4,2]+_aCab[5,2]))
		//------------------------------------
		MSExecAuto({|x,y,z|Mata410(x,y,z)},_aCab,_aItens,3)
		
		If lMsErroAuto
			DisarmTransaction()
			MostraErro()
		Else
			ConfirmSX8()
			If (cXTPPED = '1') .OR. (cXTPPED = '2')    //  Adicionado por Valdemir Jose 14/05/2013
				dbSelectArea('SC5')
				dbSetOrder(1)
				if SC5->(DbSeek( xFilial("SC5") + _cNumPed ))
					RecLock('SC5')
					SC5->C5_TABELA := cTABELA         // Volta Tabela para o código anterior
					MsUnlock()
				EndIf
			EndIf
			/* 
			If _lEmp // Conta e Ordem
				DbSelectArea("SC6")
				SC6->(DbSetOrder(1))
				If SC6->(DbSeek( xFilial("SC6") + _cNumPed ))
					While !SC6->(Eof()) .And. xFilial("SC6") == SC6->C6_FILIAL .And. SC6->C6_NUM == _cNumPed
						MaLibDoFat(SC6->(RecNo()),SC6->C6_QTDVEN,.F.,.F.,.F.,.T.,.F.,.F.)
						a450Grava(1,.T.,.T.)
						SC6->(MaLiberOk({_cNumPed},.F.))
						SC6->(DbSkip())
					EndDo
				EndIf
			EndIf
			*/
		EndIf
	EndIf
Else
	Alert("M460FIM - Pedido de origem não encontrado.")
EndIf

End Transaction


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Fim da Personalizacao Por EDGAR SERRANO - Personalizacao para Pedidos Conta e Ordem             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//RestArea(_AREA)
SA1->(dbSeek(xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA))
SE1->(dbSeek(xFilial("SE1")+SF2->F2_PREFIXO+SF2->F2_DOC))

Return()

// *********************** INICIO DE TRATAMENTO DE VALIDADOR DA MENSAGEM DE SAIDA DE ARMAZEM - FERNANDO K. - AGILITY
Static Function Mudacpo()
If Empty(cMsg)
	cMensg := " "
	Return .F.
Endif
cMensg := Formula(Substr(cMsg,1,3))
oDlg1:refresh()
Return .F.
// *********************** FIM DE TRATAMENTO DE VALIDADOR DA MENSAGEM DE SAIDA DE ARMAZEM - FERNANDO K. - AGILITY

// *********************** PERSONALIZAÇÃO SYNGENTA COM PEDIDO DE VENDA MAIOR QUE 80% QUE GRAVA NO FINANCEIRO
// NAO ESTÁ FUNCIONANDO PORQUE OS 3 PARAMETROS MV_XSYN... FORAM PREENCHIDOS COM BRANCO POIS REINALDO FINANCEIRO SOLICITOU PARA TIRAR A PERSONALIZAÇÃO

Static Function PerProdSyn
	Local aArea      := GetArea()
	Local cQuery     := ""       
	Local nTotalSyn  := 0   
	Local nTotalNF   := 0
	Local cCodSyn    := AllTrim(GetMv("MV_XSYNCOD"))
	Local nPercSyn   := 0
	
	If Select("TMP") > 0
		dbSelectArea("TMP")
		dbCloseArea("TMP")
	EndIf
	
	cQuery += "SELECT D2_COD, D2_TOTAL, B1_XCODFAB FROM "+RetSqlName("SD2")+" SD2, "+RetSqlName("SB1")+" SB1
	cQuery += " WHERE SD2.D_E_L_E_T_ = ' ' AND SB1.D_E_L_E_T_ = ' '" 
	cQuery += " AND D2_FILIAL = '"+xFilial("SD2")+"'"
	cQuery += " AND B1_FILIAL = '"+xFilial("SB1")+"'"
	cQuery += " AND D2_COD = B1_COD"
	cQuery += " AND D2_DOC = '"+SF2->F2_DOC+"'"
	cQuery += " AND D2_SERIE = '"+SF2->F2_SERIE+"'"
	cQuery += " AND D2_CLIENTE ='"+SF2->F2_CLIENTE+"'"
	cQuery += " AND D2_LOJA = '"+SF2->F2_LOJA+"'"
	cQuery += " AND D2_FORMUL = '"+SF2->F2_FORMUL+"'"
	cQuery += " AND D2_TIPO = '"+SF2->F2_TIPO+"'"   
	
	TCQUERY cQuery NEW ALIAS "TMP"
	
	While !EoF()
		If B1_XCODFAB == cCodSyn
			nTotalSyn += D2_TOTAL
		EndIf
		nTotalNF += D2_TOTAL
	    DbSkip()
	EndDo 
	If nTotalSyn > 0 .And. nTotalNF > 0 
		nPercSyn := Round((nTotalSyn / nTotalNF) * 100, 2)
	EndIf

	If Select("TMP") > 0
		dbSelectArea("TMP")
		dbCloseArea("TMP")
	EndIf
	
	RestArea(aArea)
Return nPercSyn
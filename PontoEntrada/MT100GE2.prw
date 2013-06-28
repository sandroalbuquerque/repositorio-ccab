#Include "rwmake.ch"
#Include "topconn.ch"  
#INCLUDE 'PROTHEUS.CH'
#include "TBICONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ MT100GE2 ³ Autor ³ AGILITY                 ³ Data ³ 18/05/2011 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Grava Dados Complementares no Contas a Pagar                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³                                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ CCAB                                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³             ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador   ³  Data  ³              Motivo da Alteracao                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³        ³                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MT100GE2()

Local _aArea    := GETAREA()
Local _AREA2    := GetArea()
Local _aAreaSF1 := SF1->(GETAREA())
Local _aAreaSD1 := SD1->(GETAREA())
Local _aAreaSE2 := SE2->(GETAREA())
Local lExistBco	:= If(!Empty(SA2->A2_BANCO), .T., .F.) 
Local lExistIde	:= If(!Empty(SA2->A2_XIDENTI), .T., .F.) 

Local _xEncc   := ""
Local _xDtencc := CTOD("  /  /  ")
LOcal aAreaSA2 := SA2->(GetArea())

// ********** INSERIDO PARA TRATAMENTO DO ENCONTRO DE CONTAS.....
_aArea1:= GetArea()
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

dbSelectArea("SE2")
dbSetOrder(6)
If dbSeek(xFilial("SE2")+SF1->(F1_FORNECE+F1_LOJA+F1_SERIE+F1_DOC),.f.)	                                
	While !Eof() .and. SE2->(E2_FILORIG+E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM) == SF1->(F1_FILIAL+F1_FORNECE+F1_LOJA+F1_SERIE+F1_DOC)
		RecLock("SE2",.f.)
		SE2->E2_XESPECI	 := SF1->F1_ESPECIE 	
		SE2->E2_CCD		 :=	SD1->D1_CC
		SE2->E2_XENCC    := _xEncc
		SE2->E2_XDTENCC  := _xDtencc
		IF (_xEncc <> "N") .AND. (!EMPTY(_xEncc))     // VALDEMIR JOSE 11/06/2013 AJUSTADO
			SE2->E2_PORTADO := IIF(_xEncc='C',"CAP","ENC")
   			SE2->E2_XBCOPAG := IIF(_xEncc='C',"CAP","ENC")
			SE2->E2_XAGNPAG := "00001" 
			SE2->E2_XCTAPAG := "0000000001" 
		Endif     		
		DbSelectArea("SA2")
		SA2->(DbSetOrder(1))
		If SA2->(DbSeek(xFilial("SA2")+SF1->F1_FORNECE+SF1->F1_LOJA))
			If lExistBco 		
				SE2->E2_XBCO 	:= SA2->A2_BANCO
				SE2->E2_XAGENC	:= SA2->A2_AGENCIA
				SE2->E2_XDIGAGE	:= SA2->A2_XDIGAGE
				SE2->E2_XCTAC	:= SA2->A2_NUMCON
				SE2->E2_XDIGCC	:= SA2->A2_XDIGCC
				SE2->E2_XCGC	:= SA2->A2_CGC
				SE2->E2_XNOME	:= SA2->A2_NOME
				SE2->E2_NOMFOR	:= SA2->A2_NREDUZ				 
			EndIf
		EndIf  
		// Elaborado por Paulo Elias em 09/05/08.
		// Solicitado por Patrícia Ramos.
		If lExistIde
		    DbSelectArea("SE2")
		    If RecLock("SE2",.F.)  
			    SE2->E2_XIDENTI	:= SA2->A2_XIDENTI
		        MsUnLock()
		    EndIf
		EndIf      	
		// ********** ATE AQUI TRATAMENTO DO ENCONTRO DE CONTAS.....
		SE2->(MsUnLock())
		SE2->(dbSkip())
		
	EndDo
EndIf      

RestArea(_AREA2)
RestArea(_aAreaSE2)
RestArea(_aAreaSD1)
RestArea(_aAreaSF1)
RestArea(aAreaSA2)
RestArea(_aArea)

Return                                                          
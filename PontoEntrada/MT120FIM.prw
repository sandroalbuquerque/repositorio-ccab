#include "rwmake.ch"


User Function MT120FIM()

xPar01 := PARAMIXB[1]
xPar02 := PARAMIXB[2]
xPar03 := PARAMIXB[3]

IF (INCLUI .OR. ALTERA) .AND. (alltrim(FUNNAME()) <> "MATA103") .AND. (!EMPTY(ca120forn))
	
	aAreaF := GetArea()
	aTp := {}
	aTp := {"NAO","ENC","CAP"}						// Acrescentado por Valdemir Jose 30/01/2013
	cTp := "NAO" 
	dData := CTOD("99/99/99")
	
	@ 0,0 TO 150,350 DIALOG oDlg1 TITLE "TIPO DE VENCIMENTO"
	@ 10,10 Say "Selecione o tipo de vencimento para o pedido"
	@ 25,10 Say "Tipo de vencimento"
	@ 25,100 COMBOBOX cTp ITEMS aTp SIZE 55,08
	@ 40,10 Say "Data Vencto."
	@ 40,100 GET dData SIZE 55,08
	
	@ 60,140 BMPBUTTON TYPE 01 ACTION Close(oDlg1)
	ACTIVATE DIALOG oDlg1 CENTER
	                                   
	IF Substr(UPPER(cTp),1,1) <> "N"   // Acrescentado por Valdemir Jose 30/01/2013
		// Gravando no Pedidos de Compra....
		cFl := ""
		cPd := ""
		cFl := xFilial("SC7")
		cPd := xPar02
		Dbselectarea("SC7")
		SC7->(Dbgotop())
		SC7->(Dbsetorder(1))
		IF SC7->(Dbseek(cFl+cPd))
			While !SC7->(EOF()) .AND. cFl == SC7->C7_FILIAL .AND. cPd == SC7->C7_NUM
				Reclock("SC7",.F.)
				REPLACE SC7->C7_XENCC WITH Substr(UPPER(cTp),1,1)
				REPLACE SC7->C7_XDTENCC WITH dData
				SC7->(MSUNLOCK())
				SC7->(Dbskip())
			End
		Endif
	Endif

	Restarea(aAreaF)
	
EndIf                        

Return .T.

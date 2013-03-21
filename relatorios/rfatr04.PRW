#include "protheus.ch"
#include "topconn.ch"


/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥ RFATR04  ∫Autor  ≥Felipe AurÈlio de Melo ∫ Data ≥ 09/04/09 ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥Relatorio de Pedidos de venda x Notas Fiscais               ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ MP8->SIGAFAT-RELATORIOS->FATURAMENTO                       ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/

User Function RFATR04()

Private cProg     := "RFATR04"
Private cPerg     := "RFATR4"
Private aRetor    := {}
Private aEstru    := {}
Private aItens    := {}
Private aCtbMoeda := {}
Private aSetOfBook:= {}
Private oReport
Private oSection1

//Cria perguntas caso n„o exista
fCriaSx1()

//verifica se relatorios personalizaveis esta disponivel
If TRepInUse(.F.)
	Pergunte(cPerg,.F.)
	oReport:=ReportDef()
	oReport:PrintDialog()
EndIf

Return

/*/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±
±±≥FunáÖo	 ≥ ReportDef≥ Autor ≥ Felipe AurÈlio de Melo ≥ Data ≥ 09/04/09 ≥±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±
±±≥DescriáÖo ≥                                                             ≥±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±
±±∫Uso       ≥ RFATR04                                                    ∫±±
±±¿ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
/*/

Static Function ReportDef()

Local aOrd    := {"Pedidos Vs Notas","Notas Vs Pedido","PrÈ-PV Vs Pedidos"}
Local cTitulo := "Pedidos de venda x Notas Fiscais"
Local cDescri := "Este programa ir· imprimir a relaÁ„o de pedido vs nota e nota vs pedido."+Chr(10)+Chr(13)+"Ser· impresso de acordo com os parametros solicitados pelo usuario."
Local bReport := { |oReport|	ReportPrint( oReport ) }

oReport:= TReport():New(cProg, cTitulo, cPerg , bReport, cDescri,.T.,,.F.,,.T.)
oReport:oPage:lLandScape := .T.
oReport:oPage:lPortRait := .F.      
oReport:SetTotalInLine(.F.)
oSection1:= TRSection():New(oReport  ,OemToAnsi(""),{"",""},aOrd,,,,.T.)

Return(oReport)

/*/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±
±±≥FunáÖo	 ≥ReportPrint≥Autor ≥ Felipe AurÈlio de Melo ≥ Data ≥ 09/04/09 ≥±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±
±±≥DescriáÖo ≥                                                             ≥±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±
±±∫Uso       ≥ RFATR04                                                    ∫±±
±±¿ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
/*/

Static Function ReportPrint(oReport)

Local x := 0
Local y := 0
Local oBreak1
Local cItemAnt1 := ""
Local nOrdRpt   := oSection1:GetOrder() //"Pedidos Vs Notas"###"Notas Vs Pedido"
Local nTipoImpr := oReport:nDevice //"Arquivo"###"Spool"###"E-mail"###"Planilha"###"HTML"

If nOrdRpt == 1
   oReport:SetTitle(oReport:Title()                   +"   [ "+DtoC(mv_par15)+" - "+DtoC(mv_par16)+" ] [ "+IIf(mv_par23==1,"REAL","DOLAR")+" ]" )
ElseIf nOrdRpt == 2
   oReport:SetTitle("Notas Fiscais x Pedidos de venda"+"   [ "+DtoC(mv_par13)+" - "+DtoC(mv_par14)+" ] [ "+IIf(mv_par23==1,"REAL","DOLAR")+" ]" )
ElseIf nOrdRpt == 3
   oReport:SetTitle("PrÈ-Pedidos x Pedidos de venda"  +"   [ "+DtoC(mv_par13)+" - "+DtoC(mv_par14)+" ] [ "+IIf(mv_par23==1,"REAL","DOLAR")+" ]" )
EndIf

//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥ Grava registros do arquivo tempor·rio num array              ≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
aRetor := fCriaArray()
aEstru := aRetor[1]
aItens := aRetor[2]

//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥ Cria seÁ„o, cabeÁalho                                        ≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
If Len(aEstru) > 0
	For x:=1 To Len(aEstru)
		TRCell():New(oSection1,aEstru[x][1],"",aEstru[x][2],aEstru[x][5],aEstru[x][4],.T.,,IIf(aEstru[x][3]$"N|D","RIGHT","LEFT"),,IIf(aEstru[x][3]$"N|D","RIGHT","LEFT"),,,IIf(nTipoImpr==4,.F.,.T.),CLR_WHITE,CLR_BLACK)
	Next x
EndIf


//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥ Oculta a 1∫ coluna, respons·vel pela quebra          ≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
If Len(aEstru) > 0
	oSection1:Cell(aEstru[1][1]):Hide()
EndIf

//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥ Cria quebra                                                  ≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
If Len(aEstru) > 0
	x := Len(aItens) + 1
	oBreak1 := TRBreak():New( oSection1, {|| IIf(Len(aItens)>=x,aItens[x][1],) } , {|| oReport:IncRow((-1)*oReport:nLineHeight) , "" })
EndIf

//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥ Cria totalizador                                             ≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
For x:=1 To Len(aEstru)
	//Totalizador da section conforme definiÁ„o da estrutura
	If aEstru[x][6]
		TRFunction():New ( oSection1:Cell(aEstru[x][1]),,"SUM",oBreak1,"",,,.F.,.T.,.F.)
	EndIf
Next x

//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥ Reinicia regua de impress„o                                  ≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
If Len(aItens) > 0
	oReport:nMeter:=0
	oReport:oMeter:nTotal:=0
	oReport:oMeter:Refresh()
	
	oReport:SetMeter(Len(aItens))
	oReport:SetMsgPrint("Imprimindo")
	oSection1:Init()
	
	//ForÁa impress„o do cabeÁalho
	//oSection1:PrintLine()
	oReport:PrintText("")
	oReport:IncRow((-1)*oReport:nLineHeight)
EndIf

//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥ Impress„o do itens                                           ≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
For x:=1 To Len(aItens)
	If oReport:Cancel()
		x:=Len(aItens)
	EndIf

	If nTipoImpr != 4
		If Empty(cItemAnt1)
			If !Empty(aItens[x][1])
				oSection1:PrintLine()
				cItemAnt1 := aItens[x][1]
				oReport:PrintText(Upper(aItens[x][1]))
				oReport:ThinLine()
			EndIf
		ElseIf cItemAnt1 != aItens[x][1]
			cItemAnt1 := aItens[x][1]
			oReport:SkipLine(1)
	
			//ForÁa impress„o do Totalizador
			For y:=1 To Len(aItens[x])
				oSection1:Cell(oSection1:aCell[y]:cName):SetValue()
			Next y
			oSection1:PrintLine()
	
			//Imprime cabeÁalho da seÁ„o
			oReport:PrintText(Upper(aItens[x][1]))
			oReport:ThinLine()
		EndIf
	EndIf
	
	For y:=1 To Len(aItens[x])
		oSection1:Cell(oSection1:aCell[y]:cName):SetValue(aItens[x][y])
	Next y

	//Imprime definiÁıes realizadas acima
	oSection1:PrintLine()
	oReport:IncMeter()

	//Tratamento para ultima linha n„o ser sobreposta pelo totalizador
	If x = Len(aItens)
		oReport:SkipLine(1)
	EndIf

Next x

//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥ Finaliza seÁ„o de impress„o                                  ≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
oSection1:Finish()

//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥ Imprime mensagem caso n„o tenha registros a serem impressos  ≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
If Len(aItens) == 0
	oReport:PrintText("Nao ha dados a serem exibidos")
EndIf

Return

/*/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±
±±≥FunáÖo	 ≥fCriaArray≥ Autor ≥ Felipe AurÈlio de Melo ≥ Data ≥ 02.02.09 ≥±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±
±±≥DescriáÖo ≥                                                             ≥±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥±
±±∫Uso       ≥ RFATR04                                                    ∫±±
±±¿ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
/*/

Static Function fCriaArray()

Local aCabec      := {}
Local aExibe      := {}
Local aLinhas     := {}
Local aStruct     := {}
Local cQuery      := ""
Local cCtrlSld    := ""
Local lSldPdte    := ""
Local nPvQtdSaldo := 0
Local nPvPrcUnit  := 0
Local nPvMoeda    := 0
Local cPvArmazem  := ""
Local cPvTes      := ""
Local cPcCfop     := ""
Local cKebra      := Chr(13)+Chr(10)
Local nOrdRpt     := oSection1:GetOrder() //"Pedidos Vs Notas"###"Notas Vs Pedido"
Local nTipoImpr   := oReport:nDevice //"Arquivo"###"Spool"###"E-mail"###"Planilha"###"HTML"


//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥ Monta cabeÁalho do relatorio     ≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
aAdd(aExibe,{"QUEBRA1"        ,"              ","C",00,"@!"                      ,.F.})
//Campos abaixo sÛ ser„o visiveis na exportaÁ„o para o excel

If nTipoImpr == 4
	If nOrdRpt == 1
		aAdd(aExibe,{"PV_PEDIDO"      ,"Fil/Pedido    ","C",12,"@!"              ,.F.})
		aAdd(aExibe,{"PV_DT_EMIS"     ,"Dt.Emiss„o    ","D",12,"@D"              ,.F.})
	ElseIf nOrdRpt == 2
		aAdd(aExibe,{"NF_NOTAESER"    ,"Nota/Serie    ","C",15,"@!"              ,.F.})
		aAdd(aExibe,{"NF_DT_EMIS"     ,"Dt.Emiss„o    ","D",12,"@D"              ,.F.})
	ElseIf nOrdRpt == 3
		aAdd(aExibe,{"PRE_PEDIDO"     ,"PrÈ-Pedido    ","C",10,"@!"              ,.F.})
		aAdd(aExibe,{"PRE_EMIS"       ,"Dt.Emiss„o    ","D",12,"@D"              ,.F.})
		aAdd(aExibe,{"PRE_NUMSFA"     ,"Num. SFA      ","C",12,"@!"              ,.F.})
	EndIf
EndIf

aAdd(aExibe,{"CLIENTE"        ,"Cliente       ","C",60,"@!"                      ,.F.})

If nOrdRpt == 1
	aAdd(aExibe,{"PRE_PEDIDO"     ,"PrÈ-PV        ","C",10,"@!"                      ,.F.})
	aAdd(aExibe,{"PRE_EMIS"       ,"Emis.PrÈ      ","D",12,"@D"                      ,.F.})
	aAdd(aExibe,{"NF_NOTAESER"    ,"Nota/Serie    ","C",15,"@!"                      ,.F.})
	aAdd(aExibe,{"NF_DT_EMIS"     ,"Emis.Nota     ","D",16,"@D"                      ,.F.})
ElseIf nOrdRpt == 2
	aAdd(aExibe,{"PRE_PEDIDO"     ,"PrÈ-PV        ","C",10,"@!"                      ,.F.})
	aAdd(aExibe,{"PRE_EMIS"       ,"Emis.PrÈ      ","D",12,"@D"                      ,.F.})
	aAdd(aExibe,{"PV_PEDIDO"      ,"Fil/Pedido    ","C",12,"@!"                      ,.F.})
	aAdd(aExibe,{"PV_DT_EMIS"     ,"Emis.Ped.     ","D",12,"@D"                      ,.F.})
ElseIf nOrdRpt == 3
	aAdd(aExibe,{"PV_PEDIDO"      ,"Fil/Pedido    ","C",12,"@!"                      ,.F.})
	aAdd(aExibe,{"PV_DT_EMIS"     ,"Emis.Ped.     ","D",12,"@D"                      ,.F.})
	aAdd(aExibe,{"NF_NOTAESER"    ,"Nota/Serie    ","C",15,"@!"                      ,.F.})
	aAdd(aExibe,{"NF_DT_EMIS"     ,"Emis.Nota     ","D",16,"@D"                      ,.F.})
EndIf

aAdd(aExibe,{"PV_TABPRC"      ,"Tab.          ","C",08,"@!"                      ,.F.})
aAdd(aExibe,{"PV_DT_VCTO"     ,"Ped.Vcto      ","D",14,"@D"                      ,.F.})
If mv_par24 == 1
aAdd(aExibe,{"PV_2VENDEDOR"   ,"Vend.2        ","C",08,"@!"                      ,.F.})
Else
aAdd(aExibe,{"PV_3VENDEDOR"   ,"Vend.3        ","C",08,"@!"                      ,.F.})
EndIf
aAdd(aExibe,{"PRODUTO"        ,"Produto       ","C",60,"@!"                      ,.F.})
aAdd(aExibe,{"UNIDMED"        ,"UM            ","C",04,"@!"                      ,.F.})
aAdd(aExibe,{"PV_MOEDA"       ,"Moeda         ","C",07,"@!"                      ,.F.})
aAdd(aExibe,{"NF_QTDVEND"     ,"Quantidade    ","N",17,"@E 999,999,999,999.99"   ,.T.})
aAdd(aExibe,{"NF_PRCUNIT"     ,"Vlr Unit.     ","N",17,"@E 999,999,999,999.99"   ,.F.})
aAdd(aExibe,{"NF_PRCTOTAL"    ,"Vlr Total     ","N",17,"@E 999,999,999,999.99"   ,.T.})
aAdd(aExibe,{"NF_ARMAZEM"     ,"Arm.          ","C",05,"@!"                      ,.F.})
aAdd(aExibe,{"NF_TES"         ,"TES           ","C",05,"@!"                      ,.F.})
aAdd(aExibe,{"NF_CFOP"        ,"CFOP          ","C",07,"@!"                      ,.F.})

//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥ Monta query do relatorio         ≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
cQuery := cKebra+" SELECT "
cQuery += cKebra+"        SubString(A1_COD+'/'+A1_LOJA+' - '+A1_NOME, 1, 40) CLIENTE, "
cQuery += cKebra+"        A1_NOME     NOMCLI, "
cQuery += cKebra+"        B1_COD      CODIGPROD, "
cQuery += cKebra+"        B1_DESC     DESCRPROD, "
cQuery += cKebra+"        SubString(B1_COD+' - '+B1_DESC, 1, 60) PRODUTO, "
cQuery += cKebra+"        B1_UM       UNIDMED, "
cQuery += cKebra+"        TRB.*
cQuery += cKebra+" FROM "
cQuery += cKebra+" ( "
cQuery += cKebra+" SELECT "

cQuery += cKebra+" --CONFORME PRE-PEDIDO OU PEDIDO "
cQuery += cKebra+" CASE WHEN Z3_PRODUTO  IS NULL THEN C6_PRODUTO ELSE Z3_PRODUTO       END XCODPRD,
cQuery += cKebra+" CASE WHEN Z3_CLI      IS NULL THEN C6_CLI     ELSE Z3_CLI           END XCODCLI,
cQuery += cKebra+" CASE WHEN Z3_LOJA     IS NULL THEN C6_LOJA    ELSE Z3_LOJA          END XLOJCLI,

cQuery += cKebra+" --CONFORME PRE-PEDIDO "
cQuery += cKebra+" CASE WHEN Z3_ITEM    IS NULL THEN '' ELSE Z3_ITEM              END PRE_ITEM,
cQuery += cKebra+" CASE WHEN Z3_NUM     IS NULL THEN '' ELSE Z3_NUM               END PRE_PEDIDO,
cQuery += cKebra+" CASE WHEN Z2_EMISSAO IS NULL THEN '' ELSE Z2_EMISSAO           END PRE_EMIS,
cQuery += cKebra+" CASE WHEN Z2_NUMSFA  IS NULL THEN '' ELSE Z2_NUMSFA            END PRE_NUMSFA,
cQuery += cKebra+" CASE WHEN Z2_MOEDA   IS NULL THEN 00 ELSE Z2_MOEDA             END PRE_MOEDA,
cQuery += cKebra+" CASE WHEN Z3_QTDVEN  IS NULL THEN 00 ELSE Z3_QTDVEN            END PRE_QTDVEND,
cQuery += cKebra+" CASE WHEN Z3_PRCVEN  IS NULL THEN 00 ELSE Z3_PRCVEN            END PRE_PRCUNIT,
cQuery += cKebra+" CASE WHEN Z3_VALOR   IS NULL THEN 00 ELSE Z3_VALOR             END PRE_PRCTOTAL,
cQuery += cKebra+" CASE WHEN Z3_BLQ     IS NULL THEN 00 ELSE  CASE WHEN Z3_BLQ = 'R' THEN 00 ELSE Z3_QTDVEN-Z3_QTDLIB END  END PRE_QTDSALDO,

cQuery += cKebra+" --CONFORME PEDIDO "
cQuery += cKebra+" CASE WHEN C6_FILIAL  IS NULL THEN '' ELSE C6_FILIAL            END PV_FILIAL,
cQuery += cKebra+" CASE WHEN C6_NUM     IS NULL THEN '' ELSE C6_NUM               END PV_FILTROPV,
cQuery += cKebra+" CASE WHEN C6_NUM     IS NULL THEN '' ELSE C6_FILIAL+'/'+C6_NUM END PV_PEDIDO,
cQuery += cKebra+" CASE WHEN C6_ITEM    IS NULL THEN '' ELSE C6_ITEM              END PV_ITEM,
cQuery += cKebra+" CASE WHEN C5_MOEDA   IS NULL THEN 00  ELSE C5_MOEDA            END PV_MOEDA,
cQuery += cKebra+" CASE WHEN C5_TABELA  IS NULL THEN '' ELSE C5_TABELA            END PV_TABPRC,
cQuery += cKebra+" CASE WHEN E4_DESCRI  IS NULL THEN '' ELSE E4_DESCRI            END PV_CONDPAG,
cQuery += cKebra+" CASE WHEN C5_DATA1   IS NULL THEN '' ELSE C5_DATA1             END PV_DT_VCTO,
cQuery += cKebra+" CASE WHEN C5_VEND1   IS NULL THEN '' ELSE C5_VEND1             END PV_1VENDEDOR,
cQuery += cKebra+" CASE WHEN C5_VEND2   IS NULL THEN '' ELSE C5_VEND2             END PV_2VENDEDOR,
cQuery += cKebra+" CASE WHEN C5_VEND3   IS NULL THEN '' ELSE C5_VEND3             END PV_3VENDEDOR,
cQuery += cKebra+" CASE WHEN C5_EMISSAO IS NULL THEN '' ELSE C5_EMISSAO           END PV_DT_EMIS,
cQuery += cKebra+" CASE WHEN C6_BLQ     IS NULL THEN '' ELSE C6_BLQ               END PV_RESIDUO,
cQuery += cKebra+" CASE WHEN C6_BLQ     IS NULL THEN 00 ELSE  CASE WHEN C6_BLQ = 'R' THEN 00 ELSE C6_QTDVEN-C6_QTDENT END  END PV_QTDSALDO,
cQuery += cKebra+" CASE WHEN C6_QTDVEN  IS NULL THEN 00 ELSE C6_QTDVEN            END PV_QTDVEND,
cQuery += cKebra+" CASE WHEN C6_PRCVEN  IS NULL THEN 00 ELSE C6_PRCVEN            END PV_PRCUNIT,
cQuery += cKebra+" CASE WHEN C6_VALOR   IS NULL THEN 00 ELSE C6_VALOR             END PV_PRCTOTAL,
cQuery += cKebra+" CASE WHEN C6_LOCAL   IS NULL THEN '' ELSE C6_LOCAL             END PV_ARMAZEM,
cQuery += cKebra+" CASE WHEN C6_TES     IS NULL THEN '' ELSE C6_TES               END PV_TES,
cQuery += cKebra+" CASE WHEN C6_CF      IS NULL THEN '' ELSE C6_CF                END PV_CFOP,
cQuery += cKebra+" CASE WHEN C5_TIPO    IS NULL THEN '' ELSE C5_TIPO              END PV_TIPO,

cQuery += cKebra+" --CONFORME NOTA "
cQuery += cKebra+" CASE WHEN D2_ITEM    IS NULL THEN '' ELSE D2_ITEM              END NF_ITEM,
cQuery += cKebra+" CASE WHEN D2_SERIE   IS NULL THEN '' ELSE D2_SERIE             END NF_SERIE,
cQuery += cKebra+" CASE WHEN D2_DOC     IS NULL THEN '' ELSE D2_DOC               END NF_NOTA,
cQuery += cKebra+" CASE WHEN D2_DOC     IS NULL THEN '' ELSE Ltrim(Rtrim(D2_DOC+'/'+D2_SERIE))  END NF_NOTAESER,
cQuery += cKebra+" CASE WHEN D2_EMISSAO IS NULL THEN '' ELSE D2_EMISSAO           END NF_DT_EMIS,
cQuery += cKebra+" CASE WHEN D2_QUANT   IS NULL THEN 00 ELSE D2_QUANT             END NF_QTDVEND,
cQuery += cKebra+" CASE WHEN D2_PRCVEN  IS NULL THEN 00 ELSE D2_PRCVEN            END NF_PRCUNIT,
cQuery += cKebra+" CASE WHEN D2_TOTAL   IS NULL THEN 00 ELSE D2_TOTAL             END NF_PRCTOTAL,
cQuery += cKebra+" CASE WHEN D2_LOCAL   IS NULL THEN '' ELSE D2_LOCAL             END NF_ARMAZEM,
cQuery += cKebra+" CASE WHEN D2_TES     IS NULL THEN '' ELSE D2_TES               END NF_TES,
cQuery += cKebra+" CASE WHEN D2_CF      IS NULL THEN '' ELSE D2_CF                END NF_CFOP

If nOrdRpt == 3
cQuery += cKebra+" FROM "+RetSqlName("SZ3")+" SZ3 "
cQuery += cKebra+" FULL OUTER JOIN "+RetSqlName("SC6")+" SC6 ON SC6.D_E_L_E_T_= '' "
cQuery += cKebra+"                                     AND SC6.C6_PRENUM  = SZ3.Z3_NUM "
cQuery += cKebra+"                                     AND SC6.C6_PREITEM = SZ3.Z3_ITEM "
cQuery += cKebra+"                                     AND SC6.C6_PRODUTO = SZ3.Z3_PRODUTO "
cQuery += cKebra+"                                     AND SZ3.D_E_L_E_T_ = '' "
Else
cQuery += cKebra+" FROM "+RetSqlName("SC6")+" SC6 "
cQuery += cKebra+" LEFT JOIN "+RetSqlName("SZ3")+" SZ3 ON SZ3.D_E_L_E_T_= '' "
cQuery += cKebra+"                                     AND SZ3.Z3_FILIAL  = '"+xFilial("SZ3")+"' "
cQuery += cKebra+"                                     AND SZ3.Z3_NUM     = SC6.C6_PRENUM "
cQuery += cKebra+"                                     AND SZ3.Z3_ITEM    = SC6.C6_PREITEM "
cQuery += cKebra+"                                     AND SZ3.Z3_PRODUTO = SC6.C6_PRODUTO "
EndIf

cQuery += cKebra+" LEFT JOIN "+RetSqlName("SZ2")+" SZ2 ON SZ2.D_E_L_E_T_ = '' "
cQuery += cKebra+"                                     AND SZ2.Z2_FILIAL  = '"+xFilial("SZ2")+"' "
cQuery += cKebra+"                                     AND SZ2.Z2_NUM     = SZ3.Z3_NUM "

cQuery += cKebra+" LEFT JOIN "+RetSqlName("SC5")+" SC5 ON SC5.D_E_L_E_T_ = '' "
cQuery += cKebra+"                                     AND SC5.C5_FILIAL  = SC6.C6_FILIAL "
cQuery += cKebra+"                                     AND SC5.C5_CLIENTE = SC6.C6_CLI "
cQuery += cKebra+"                                     AND SC5.C5_LOJACLI = SC6.C6_LOJA "
cQuery += cKebra+"                                     AND SC5.C5_NUM     = SC6.C6_NUM "

cQuery += cKebra+" LEFT JOIN "+RetSqlName("SE4")+" SE4 ON SE4.D_E_L_E_T_ = '' "
cQuery += cKebra+"                                     AND SE4.E4_FILIAL  = '"+xFilial("SE4")+"' "
cQuery += cKebra+"                                     AND SE4.E4_CODIGO  = SC5.C5_CONDPAG "

cQuery += cKebra+" LEFT JOIN "+RetSqlName("SD2")+" SD2 ON SD2.D_E_L_E_T_= '' "
cQuery += cKebra+"                                     AND SD2.D2_FILIAL  = SC6.C6_FILIAL "
cQuery += cKebra+"                                     AND SD2.D2_CLIENTE = SC6.C6_CLI "
cQuery += cKebra+"                                     AND SD2.D2_LOJA    = SC6.C6_LOJA "
cQuery += cKebra+"                                     AND SD2.D2_PEDIDO  = SC6.C6_NUM "
cQuery += cKebra+"                                     AND SD2.D2_ITEMPV  = SC6.C6_ITEM "
cQuery += cKebra+"                                     AND SD2.D2_COD     = SC6.C6_PRODUTO "

cQuery += cKebra+" LEFT JOIN "+RetSqlName("SF2")+" SF2 ON SF2.D_E_L_E_T_ = '' "
cQuery += cKebra+"                                     AND SF2.F2_FILIAL  = SD2.D2_FILIAL "
cQuery += cKebra+"                                     AND SF2.F2_DOC     = SD2.D2_DOC "
cQuery += cKebra+"                                     AND SF2.F2_SERIE   = SD2.D2_SERIE "
cQuery += cKebra+"                                     AND SF2.F2_CLIENTE = SD2.D2_CLIENTE "
cQuery += cKebra+"                                     AND SF2.F2_LOJA    = SD2.D2_LOJA "
/*
If nOrdRpt != 3
cQuery += cKebra+" WHERE SC6.D_E_L_E_T_ = '' "
EndIf
*/
cQuery += cKebra+" ) TRB "

cQuery += cKebra+" LEFT JOIN "+RetSqlName("SB1")+" SB1 ON SB1.D_E_L_E_T_= '' "
cQuery += cKebra+"                                     AND SB1.B1_FILIAL  = '"+xFilial("SB1")+"' "
cQuery += cKebra+"                                     AND SB1.B1_COD     = XCODPRD "

cQuery += cKebra+" LEFT JOIN "+RetSqlName("SA1")+" SA1 ON SA1.D_E_L_E_T_= '' "
cQuery += cKebra+"                                     AND SA1.A1_FILIAL  = '"+xFilial("SA1")+"' "
cQuery += cKebra+"                                     AND SA1.A1_COD     = XCODCLI "
cQuery += cKebra+"                                     AND SA1.A1_LOJA    = XLOJCLI "

cQuery += cKebra+" WHERE 1=1 "

cQuery += cKebra+" AND NF_SERIE >= '"+MV_PAR01+"' "
cQuery += cKebra+" AND NF_SERIE <= '"+MV_PAR02+"' "

cQuery += cKebra+" AND NF_NOTA >= '"+MV_PAR03+"' "
cQuery += cKebra+" AND NF_NOTA <= '"+MV_PAR04+"' "

cQuery += cKebra+" AND PV_FILTROPV >= '"+MV_PAR05+"' "
cQuery += cKebra+" AND PV_FILTROPV <= '"+MV_PAR06+"' "

cQuery += cKebra+" AND XCODCLI >= '"+MV_PAR07+"' "
cQuery += cKebra+" AND XCODCLI <= '"+MV_PAR09+"' "

cQuery += cKebra+" AND XLOJCLI >= '"+MV_PAR08+"' "
cQuery += cKebra+" AND XLOJCLI <= '"+MV_PAR10+"' "

cQuery += cKebra+" AND XCODPRD >= '"+MV_PAR11+"' "
cQuery += cKebra+" AND XCODPRD <= '"+MV_PAR12+"' "

cQuery += cKebra+" AND NF_DT_EMIS >= '"+DtoS(MV_PAR13)+"' "
cQuery += cKebra+" AND NF_DT_EMIS <= '"+DtoS(MV_PAR14)+"' "

cQuery += cKebra+" AND PV_DT_EMIS >= '"+DtoS(MV_PAR15)+"' "
cQuery += cKebra+" AND PV_DT_EMIS <= '"+DtoS(MV_PAR16)+"' "

cQuery += cKebra+" AND PV_DT_VCTO >= '"+DtoS(MV_PAR17)+"' "
cQuery += cKebra+" AND PV_DT_VCTO <= '"+DtoS(MV_PAR18)+"' "

cQuery += cKebra+" AND PV_2VENDEDOR >= '"+MV_PAR19+"' "
cQuery += cKebra+" AND PV_2VENDEDOR <= '"+MV_PAR20+"' "

cQuery += cKebra+" AND PV_3VENDEDOR >= '"+MV_PAR21+"' "
cQuery += cKebra+" AND PV_3VENDEDOR <= '"+MV_PAR22+"' "

cQuery += cKebra+" AND PRE_PEDIDO >= '"+MV_PAR25+"' "
cQuery += cKebra+" AND PRE_PEDIDO <= '"+MV_PAR26+"' "

cQuery += cKebra+" AND PV_FILIAL >= '"+MV_PAR27+"' "
cQuery += cKebra+" AND PV_FILIAL <= '"+MV_PAR28+"' "  


cQuery += cKebra+" AND NF_NOTA <> ' ' AND NF_SERIE <> ' ' "   // Valdemir Jose 01/03/2013

cQuery += cKebra+" AND PV_TIPO NOT IN('B','D') "

If nOrdRpt == 1
cQuery += cKebra+" ORDER BY PV_PEDIDO, PV_DT_EMIS, CODIGPROD "
ElseIf nOrdRpt == 2
cQuery += cKebra+" AND NF_NOTA != '' "
cQuery += cKebra+" ORDER BY NF_NOTA, NF_SERIE, NF_DT_EMIS, CODIGPROD "
ElseIf nOrdRpt == 3
cQuery += cKebra+" ORDER BY PRE_PEDIDO, PRE_ITEM, PRE_EMIS, CODIGPROD "
EndIf

MemoWrite("Rel.Txt", cQuery)


//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥ Fecha Alias se estiver em Uso ≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
If !Empty(Select("SQL"))
   dbSelectArea("SQL")
   dbCloseArea()
Endif

//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥ Monta Area de Trabalho executando a Query ≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
TCQuery cQuery ALIAS "SQL" NEW
TcSetField("SQL","PV_DT_EMIS", "D", 8, 0)
TcSetField("SQL","PV_DT_VCTO", "D", 8, 0)
TcSetField("SQL","NF_DT_EMIS", "D", 8, 0)
TcSetField("SQL","PRE_EMIS"  , "D", 8, 0)

aStruct := SQL->(dbStruct())
oReport:SetMeter(Len(aExibe))
oReport:SetMsgPrint("Montando estrutura")
For x:=1 To Len(aExibe)
	oReport:IncMeter()
	aAdd(aCabec,{aExibe[x,1],aExibe[x,2],aExibe[x,3],aExibe[x,4],aExibe[x,5],aExibe[x,6]})
Next x

//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥ Reinicia regua de impress„o                                  ≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
oReport:nMeter:=0
oReport:oMeter:nTotal:=0
oReport:oMeter:Refresh()

dbSelectArea("SQL")
DbGoTop()
Count To nRegua
oReport:SetMeter(nRegua)
oReport:SetMsgPrint("Coletando registros")
dbGoTop()

While SQL->(!Eof())
	oReport:IncMeter()  
	
	if Empty(SQL->NF_NOTA) .or. Empty(SQL->NF_SERIE)    // Valdemir Jose 01/03/2013
	   SQL->( dbSkip() ) 
	   Loop
	Endif

	//Adiciona nova linha e alimenta colunas
	aAdd(aLinhas,Array(Len(aCabec)))
	For x:=1 To Len(aStruct)
		nScan := aScan(aCabec,{|y| Upper(AllTrim(y[1])) == Upper(AllTrim(aStruct[x,1])) })
		If nScan > 0
			aLinhas[Len(aLinhas)][nScan] := &("SQL->("+aCabec[nScan][1]+")")
		EndIf
	Next x

	//Atualizada no array a coluna respons·vel pela quebra
	nScan := aScan(aCabec,{|y| Upper(AllTrim(y[1])) == Upper(AllTrim("QUEBRA1")) })
	If nOrdRpt == 1
		aLinhas[Len(aLinhas)][nScan] := "Fil/Pedido: "+SQL->PV_PEDIDO+"   Emiss„o: "+DtoC(SQL->PV_DT_EMIS)
	ElseIf nOrdRpt == 2
		aLinhas[Len(aLinhas)][nScan] := "Nota: "+SQL->NF_NOTAESER+"   Emiss„o: "+DtoC(SQL->NF_DT_EMIS)
	ElseIf nOrdRpt == 3
		aLinhas[Len(aLinhas)][nScan] := "PrÈ-Pedido: " + SQL->PRE_PEDIDO + "   Emiss„o: " + DtoC(SQL->PRE_EMIS) + "   Num.SFA: " + SQL->PRE_NUMSFA
	EndIf

	//Atualizada no array a coluna respons·vel pela definiÁ„o da moeda origem
	nScan := aScan(aCabec,{|y| Upper(AllTrim(y[1])) == Upper(AllTrim("PV_MOEDA")) })
	/*
	If Empty(SQL->PV_MOEDA)
		aLinhas[Len(aLinhas)][nScan] := IIf(SQL->PRE_MOEDA==1,"R$","U$")
	Else
		aLinhas[Len(aLinhas)][nScan] := IIf(SQL->PV_MOEDA ==1,"R$","U$")
	EndIf
    */
	If MV_PAR23 == 2
		aLinhas[Len(aLinhas)][nScan] := "U$"
	Else
		aLinhas[Len(aLinhas)][nScan] := "R$"                                                              
	EndIf


	//Atualizada no array a coluna respons·vel pela data de vencimento
	If Empty(DtoS(SQL->PV_DT_VCTO))
		nScan := aScan(aCabec,{|y| Upper(AllTrim(y[1])) == Upper(AllTrim("PV_DT_VCTO" )) })
		aLinhas[Len(aLinhas)][nScan] := SQL->PV_CONDPAG
	EndIf

	nScan := aScan(aCabec,{|y| Upper(AllTrim(y[1])) == Upper(AllTrim("PRE_PEDIDO"))})
	aLinhas[Len(aLinhas)][nScan] := Posicione("SC5", 1, SQL->PV_FILIAL + SQL->PV_FILTROPV, "C5_PRENUM")

	nScan := aScan(aCabec,{|y| Upper(AllTrim(y[1])) == Upper(AllTrim("PRE_EMIS"))})
	aLinhas[Len(aLinhas)][nScan] := DtoC(Posicione("SZ2", 1, xFilial("SZ2") + Posicione("SC5", 1, SQL->PV_FILIAL + SQL->PV_FILTROPV, "C5_PRENUM"), "Z2_EMISSAO"))


	//Atualizada no array a coluna respons·vel pelo saldo pendente do item do pedido
	If Empty(SQL->NF_NOTA)
		If Empty(SQL->PV_PEDIDO)
			nScan := aScan(aCabec,{|y| Upper(AllTrim(y[1])) == Upper(AllTrim("NF_QTDVEND" )) })
			aLinhas[Len(aLinhas)][nScan] := SQL->PRE_QTDVEND
			
			nScan := aScan(aCabec,{|y| Upper(AllTrim(y[1])) == Upper(AllTrim("NF_PRCUNIT" )) })
			aLinhas[Len(aLinhas)][nScan] := xMoeda(SQL->PRE_PRCUNIT,SQL->PRE_MOEDA,1,dDataBase)
			
			nScan := aScan(aCabec,{|y| Upper(AllTrim(y[1])) == Upper(AllTrim("NF_PRCTOTAL")) })
			aLinhas[Len(aLinhas)][nScan] := xMoeda(SQL->PRE_PRCTOTAL,SQL->PRE_MOEDA,1,dDataBase)
			
			nScan := aScan(aCabec,{|y| Upper(AllTrim(y[1])) == Upper(AllTrim("NF_ARMAZEM" )) })
			aLinhas[Len(aLinhas)][nScan] := ""//SQL->PRE_ARMAZEM
			
			nScan := aScan(aCabec,{|y| Upper(AllTrim(y[1])) == Upper(AllTrim("NF_TES"     )) })
			aLinhas[Len(aLinhas)][nScan] := ""//SQL->PRE_TES
			
			nScan := aScan(aCabec,{|y| Upper(AllTrim(y[1])) == Upper(AllTrim("NF_CFOP"    )) })
			aLinhas[Len(aLinhas)][nScan] := ""//SQL->PRE_CFOP
		Else
			nScan := aScan(aCabec,{|y| Upper(AllTrim(y[1])) == Upper(AllTrim("NF_QTDVEND" )) })
			aLinhas[Len(aLinhas)][nScan] := SQL->PV_QTDVEND
			
			nScan := aScan(aCabec,{|y| Upper(AllTrim(y[1])) == Upper(AllTrim("NF_PRCUNIT" )) })
			aLinhas[Len(aLinhas)][nScan] := xMoeda(SQL->PV_PRCUNIT,SQL->PV_MOEDA,1,dDataBase)
			
			nScan := aScan(aCabec,{|y| Upper(AllTrim(y[1])) == Upper(AllTrim("NF_PRCTOTAL")) })
			aLinhas[Len(aLinhas)][nScan] := xMoeda(SQL->PV_PRCTOTAL,SQL->PV_MOEDA,1,dDataBase)
			
			nScan := aScan(aCabec,{|y| Upper(AllTrim(y[1])) == Upper(AllTrim("NF_ARMAZEM" )) })
			aLinhas[Len(aLinhas)][nScan] := SQL->PV_ARMAZEM
			
			nScan := aScan(aCabec,{|y| Upper(AllTrim(y[1])) == Upper(AllTrim("NF_TES"     )) })
			aLinhas[Len(aLinhas)][nScan] := SQL->PV_TES
			
			nScan := aScan(aCabec,{|y| Upper(AllTrim(y[1])) == Upper(AllTrim("NF_CFOP"    )) })
			aLinhas[Len(aLinhas)][nScan] := SQL->PV_CFOP
		EndIf
	EndIf

	//Atualizada no array as colunas respons·veis pelos valores
	If MV_PAR23 == 2
		//================================================================
		// Ajuste para tratar outras moedas ExportaÁ„o
		// Favaro                                                 
		xnMoeda := Posicione("SC5",1,SQL->PV_FILIAL+SUBSTR(SQL->PV_PEDIDO,4,6),"C5_MOEDA")
		If xnMoeda > 2   // Dollar Outras Taxas                                                                          
			If Empty(SQL->NF_NOTA)
				If Empty(SQL->PV_PEDIDO)
					nScan := aScan(aCabec,{|y| Upper(AllTrim(y[1])) == Upper(AllTrim("NF_PRCUNIT" )) })
					aLinhas[Len(aLinhas)][nScan] := xMoeda(SQL->PRE_PRCUNIT,SQL->PRE_MOEDA,xnMoeda,dDataBase)
					
					nScan := aScan(aCabec,{|y| Upper(AllTrim(y[1])) == Upper(AllTrim("NF_PRCTOTAL")) })
					aLinhas[Len(aLinhas)][nScan] := xMoeda(SQL->PRE_PRCTOTAL,SQL->PRE_MOEDA,xnMoeda,dDataBase)
				Else
					nScan := aScan(aCabec,{|y| Upper(AllTrim(y[1])) == Upper(AllTrim("NF_PRCUNIT" )) })
					aLinhas[Len(aLinhas)][nScan] := xMoeda(SQL->PV_PRCUNIT,SQL->PV_MOEDA,xnMoeda,dDataBase)
					
					nScan := aScan(aCabec,{|y| Upper(AllTrim(y[1])) == Upper(AllTrim("NF_PRCTOTAL")) })
					aLinhas[Len(aLinhas)][nScan] := xMoeda(SQL->PV_PRCTOTAL,SQL->PV_MOEDA,xnMoeda,dDataBase)
				EndIf
			Else
			
				_cDocOri := Posicione("SC6", 1, SQL->PV_FILIAL + SubStr(SQL->PV_PEDIDO, 4, 6), "C6_XDOCORI")
				_cSerOri := Posicione("SC6", 1, SQL->PV_FILIAL + SubStr(SQL->PV_PEDIDO, 4, 6), "C6_XSERORI")
				_dEmissa := Posicione("SF2", 1, SQL->PV_FILIAL + _cDocOri + _cSerOri + SubStr(SQL->CLIENTE, 1, 6) + SubStr(SQL->CLIENTE, 8, 2), "F2_EMISSAO")
				
				If Empty(_dEmissa)
					_dEmissa := Posicione("SF2", 1, SQL->PV_FILIAL + SQL->NF_NOTA + SQL->NF_SERIE + SubStr(SQL->CLIENTE, 1, 6) + SubStr(SQL->CLIENTE, 8, 2), "F2_EMISSAO")
				EndIf
				
				nScan := aScan(aCabec,{|y| Upper(AllTrim(y[1])) == Upper(AllTrim("NF_PRCUNIT" )) })                                                                           
				aLinhas[Len(aLinhas)][nScan] := xMoeda(SQL->NF_PRCUNIT,1,xnMoeda,IIf(!Empty(_dEmissa), _dEmissa, SQL->PV_DT_EMIS)) // Coment Juliano 07/10 - Solict. Tacia.
				
				nScan := aScan(aCabec,{|y| Upper(AllTrim(y[1])) == Upper(AllTrim("NF_PRCTOTAL")) })                                   
				aLinhas[Len(aLinhas)][nScan] := xMoeda(SQL->NF_PRCTOTAL,1,xnMoeda,IIf(!Empty(_dEmissa), _dEmissa, SQL->PV_DT_EMIS))    // Coment Juliano 07/10 - Solict. Tacia.
			EndIf
		Else // Dollar Normal
			If Empty(SQL->NF_NOTA)
				If Empty(SQL->PV_PEDIDO)
					nScan := aScan(aCabec,{|y| Upper(AllTrim(y[1])) == Upper(AllTrim("NF_PRCUNIT" )) })
					aLinhas[Len(aLinhas)][nScan] := xMoeda(SQL->PRE_PRCUNIT,SQL->PRE_MOEDA,MV_PAR23,dDataBase)
					
					nScan := aScan(aCabec,{|y| Upper(AllTrim(y[1])) == Upper(AllTrim("NF_PRCTOTAL")) })
					aLinhas[Len(aLinhas)][nScan] := xMoeda(SQL->PRE_PRCTOTAL,SQL->PRE_MOEDA,MV_PAR23,dDataBase)
				Else
					nScan := aScan(aCabec,{|y| Upper(AllTrim(y[1])) == Upper(AllTrim("NF_PRCUNIT" )) })
					aLinhas[Len(aLinhas)][nScan] := xMoeda(SQL->PV_PRCUNIT,SQL->PV_MOEDA,MV_PAR23,dDataBase)
					
					nScan := aScan(aCabec,{|y| Upper(AllTrim(y[1])) == Upper(AllTrim("NF_PRCTOTAL")) })
					aLinhas[Len(aLinhas)][nScan] := xMoeda(SQL->PV_PRCTOTAL,SQL->PV_MOEDA,MV_PAR23,dDataBase)
				EndIf
			Else
				
				_cDocOri := Posicione("SC6", 1, SQL->PV_FILIAL + SubStr(SQL->PV_PEDIDO, 4, 6), "C6_XDOCORI")
				_cSerOri := Posicione("SC6", 1, SQL->PV_FILIAL + SubStr(SQL->PV_PEDIDO, 4, 6), "C6_XSERORI")
				_dEmissa := Posicione("SF2", 1, SQL->PV_FILIAL + _cDocOri + _cSerOri + SubStr(SQL->CLIENTE, 1, 6) + SubStr(SQL->CLIENTE, 8, 2), "F2_EMISSAO")
				
				If Empty(_dEmissa)
					_dEmissa := Posicione("SF2", 1, SQL->PV_FILIAL + SQL->NF_NOTA + SQL->NF_SERIE + SubStr(SQL->CLIENTE, 1, 6) + SubStr(SQL->CLIENTE, 8, 2), "F2_EMISSAO")
				EndIf
				
				nScan := aScan(aCabec,{|y| Upper(AllTrim(y[1])) == Upper(AllTrim("NF_PRCUNIT" )) })                                                                           
				aLinhas[Len(aLinhas)][nScan] := xMoeda(SQL->NF_PRCUNIT,1,MV_PAR23,IIf(!Empty(_dEmissa), _dEmissa, SQL->PV_DT_EMIS)) // Coment Juliano 07/10 - Solict. Tacia.
				
				nScan := aScan(aCabec,{|y| Upper(AllTrim(y[1])) == Upper(AllTrim("NF_PRCTOTAL")) })                                   
				aLinhas[Len(aLinhas)][nScan] := xMoeda(SQL->NF_PRCTOTAL,1,MV_PAR23,IIf(!Empty(_dEmissa), _dEmissa, SQL->PV_DT_EMIS))    // Coment Juliano 07/10 - Solict. Tacia.
			EndIf                     
		EndIf
	EndIf

	//Verifica se existe saldo pendente deste item
	If SQL->PV_QTDSALDO > 0 .And. !Empty(SQL->NF_NOTA)
		lSldPdte := .T.
		nPvQtdSaldo := SQL->PV_QTDSALDO
		nPvPrcUnit  := SQL->PV_PRCUNIT
		nPvMoeda    := SQL->PV_MOEDA
		cPvArmazem  := SQL->PV_ARMAZEM
		cPvTes      := SQL->PV_TES
		cPcCfop     := SQL->PV_CFOP
	Else
		lSldPdte := .F.
		nPvQtdSaldo := 0
		nPvPrcUnit  := 0
		nPvMoeda    := 0
		cPvArmazem  := ""
		cPvTes      := ""
		cPcCfop     := ""
	EndIf

	SQL->(DbSkip())

	//Tratamento para quando pedido de venda
	If nOrdRpt == 1
		//Controla os itens para criar linha quando existir faturamento parcial
		If cCtrlSld != SQL->(PV_PEDIDO+PV_ITEM+PRODUTO)
			If Empty(cCtrlSld)
				cCtrlSld := SQL->(PV_PEDIDO+PV_ITEM+PRODUTO)
			ElseIf lSldPdte
				cCtrlSld := SQL->(PV_PEDIDO+PV_ITEM+PRODUTO)
				//Adiciona nova linha e alimenta colunas
				aAdd(aLinhas,Array(Len(aCabec)))
				For x:=1 To Len(aCabec)
					Do Case
						Case AllTrim(aCabec[x][1]) == "NF_NOTAESER"
							aLinhas[Len(aLinhas)][x] := ""
	
						Case AllTrim(aCabec[x][1]) == "NF_DT_EMIS"
							aLinhas[Len(aLinhas)][x] := DtoC(StoD(""))//"**"
	
						Case AllTrim(aCabec[x][1]) == "NF_QTDVEND"
							aLinhas[Len(aLinhas)][x] := nPvQtdSaldo
						
						Case AllTrim(aCabec[x][1]) == "NF_PRCUNIT"
							aLinhas[Len(aLinhas)][x] := xMoeda(nPvPrcUnit,nPvMoeda,MV_PAR23,dDataBase)

						Case AllTrim(aCabec[x][1]) == "NF_PRCTOTAL"
							aLinhas[Len(aLinhas)][x] := xMoeda(nPvQtdSaldo*nPvPrcUnit,nPvMoeda,MV_PAR23,dDataBase)
	
						Case AllTrim(aCabec[x][1]) == "NF_ARMAZEM"
							aLinhas[Len(aLinhas)][x] := cPvArmazem
	
						Case AllTrim(aCabec[x][1]) == "NF_TES"
							aLinhas[Len(aLinhas)][x] := cPvTes
	
						Case AllTrim(aCabec[x][1]) == "NF_CFOP"
							aLinhas[Len(aLinhas)][x] := cPcCfop
	
						OtherWise
							aLinhas[Len(aLinhas)][x] := aLinhas[Len(aLinhas)-1][x]
					EndCase
				Next x
			EndIf
		EndIf
	EndIF
End

Return({aCabec,aLinhas})


/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥fCriaSx1  ∫Autor  ≥Felipe AurÈlio de Melo ∫ Data ≥ 09/04/09 ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥ FunÁ„o respons·vel por criar os parametros do relatÛrio    ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ RFATR04                                                    ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/

Static Function fCriaSx1()

Local aPergs := {}

aAdd(aPergs,{"Da Serie"            ,"Da Serie"            ,"Da Serie"            ,"mv_ch1"   , "C" , 03,00,00, "G", "", "mv_par01",""             ,""             ,""             , "", "", ""             , ""             , ""             , "", "", ""             , ""             , ""             , "", "", ""             , ""             , ""             , "","","","","","",""   ,"","S","","",{},{},{}})
aAdd(aPergs,{"AtÈ a Serie"         ,"AtÈ a Serie"         ,"AtÈ a Serie"         ,"mv_ch2"   , "C" , 03,00,00, "G", "", "mv_par02",""             ,""             ,""             , "", "", ""             , ""             , ""             , "", "", ""             , ""             , ""             , "", "", ""             , ""             , ""             , "","","","","","",""   ,"","S","","",{},{},{}})
aAdd(aPergs,{"Da Nota"             ,"Da Nota"             ,"Da Nota"             ,"mv_ch3"   , "C" , 09,00,00, "G", "", "mv_par03",""             ,""             ,""             , "", "", ""             , ""             , ""             , "", "", ""             , ""             , ""             , "", "", ""             , ""             , ""             , "","","","","","",""   ,"","S","","",{},{},{}})
aAdd(aPergs,{"AtÈ a Nota"          ,"AtÈ a Nota"          ,"AtÈ a Nota"          ,"mv_ch4"   , "C" , 09,00,00, "G", "", "mv_par04",""             ,""             ,""             , "", "", ""             , ""             , ""             , "", "", ""             , ""             , ""             , "", "", ""             , ""             , ""             , "","","","","","",""   ,"","S","","",{},{},{}})
aAdd(aPergs,{"Do Pedido"           ,"Do Pedido"           ,"Do Pedido"           ,"mv_ch5"   , "C" , 06,00,00, "G", "", "mv_par05",""             ,""             ,""             , "", "", ""             , ""             , ""             , "", "", ""             , ""             , ""             , "", "", ""             , ""             , ""             , "","","","","","",""   ,"","S","","",{},{},{}})
aAdd(aPergs,{"AtÈ o Pedido"        ,"AtÈ o Pedido"        ,"AtÈ o Pedido"        ,"mv_ch6"   , "C" , 06,00,00, "G", "", "mv_par06",""             ,""             ,""             , "", "", ""             , ""             , ""             , "", "", ""             , ""             , ""             , "", "", ""             , ""             , ""             , "","","","","","",""   ,"","S","","",{},{},{}})
aAdd(aPergs,{"Do Cliente"          ,"Do Cliente"          ,"Do Cliente"          ,"mv_ch7"   , "C" , 06,00,00, "G", "", "mv_par07",""             ,""             ,""             , "", "", ""             , ""             , ""             , "", "", ""             , ""             , ""             , "", "", ""             , ""             , ""             , "","","","","","","SA1","","S","","",{},{},{}})
aAdd(aPergs,{"Da Loja"             ,"Da Loja"             ,"Da Loja"             ,"mv_ch8"   , "C" , 02,00,00, "G", "", "mv_par08",""             ,""             ,""             , "", "", ""             , ""             , ""             , "", "", ""             , ""             , ""             , "", "", ""             , ""             , ""             , "","","","","","",""   ,"","S","","",{},{},{}})
aAdd(aPergs,{"AtÈ o Cliente"       ,"AtÈ o Cliente"       ,"AtÈ o Cliente"       ,"mv_ch9"   , "C" , 06,00,00, "G", "", "mv_par09",""             ,""             ,""             , "", "", ""             , ""             , ""             , "", "", ""             , ""             , ""             , "", "", ""             , ""             , ""             , "","","","","","","SA1","","S","","",{},{},{}})
aAdd(aPergs,{"AtÈ a Loja"          ,"AtÈ a Loja"          ,"AtÈ a Loja"          ,"mv_cha"   , "C" , 02,00,00, "G", "", "mv_par10",""             ,""             ,""             , "", "", ""             , ""             , ""             , "", "", ""             , ""             , ""             , "", "", ""             , ""             , ""             , "","","","","","",""   ,"","S","","",{},{},{}})
aAdd(aPergs,{"Do Produto"          ,"Do Produto"          ,"Do Produto"          ,"mv_chb"   , "C" , 15,00,00, "G", "", "mv_par11",""             ,""             ,""             , "", "", ""             , ""             , ""             , "", "", ""             , ""             , ""             , "", "", ""             , ""             , ""             , "","","","","","","SB1","","S","","",{},{},{}})
aAdd(aPergs,{"Ate o Produto"       ,"Ate o Produto"       ,"Ate o Produto"       ,"mv_chc"   , "C" , 15,00,00, "G", "", "mv_par12",""             ,""             ,""             , "", "", ""             , ""             , ""             , "", "", ""             , ""             , ""             , "", "", ""             , ""             , ""             , "","","","","","","SB1","","S","","",{},{},{}})
aAdd(aPergs,{"Da Emissao da NF"    ,"Da Emissao da NF"    ,"Da Emissao da NF"    ,"mv_chd"   , "D" , 08,00,00, "G", "", "mv_par13",""             ,""             ,""             , "", "", ""             , ""             , ""             , "", "", ""             , ""             , ""             , "", "", ""             , ""             , ""             , "","","","","","",""   ,"","S","","",{},{},{}})
aAdd(aPergs,{"Ate a Emissao da NF" ,"Ate a Emissao da NF" ,"Ate a Emissao da NF" ,"mv_che"   , "D" , 08,00,00, "G", "", "mv_par14",""             ,""             ,""             , "", "", ""             , ""             , ""             , "", "", ""             , ""             , ""             , "", "", ""             , ""             , ""             , "","","","","","",""   ,"","S","","",{},{},{}})
aAdd(aPergs,{"Da Emissao do Ped."  ,"Da Emissao do Ped."  ,"Da Emissao do Ped."  ,"mv_chf"   , "D" , 08,00,00, "G", "", "mv_par15",""             ,""             ,""             , "", "", ""             , ""             , ""             , "", "", ""             , ""             , ""             , "", "", ""             , ""             , ""             , "","","","","","",""   ,"","S","","",{},{},{}})
aAdd(aPergs,{"Ate a Emissao Ped."  ,"Ate a Emissao Ped."  ,"Ate a Emissao Ped."  ,"mv_chg"   , "D" , 08,00,00, "G", "", "mv_par16",""             ,""             ,""             , "", "", ""             , ""             , ""             , "", "", ""             , ""             , ""             , "", "", ""             , ""             , ""             , "","","","","","",""   ,"","S","","",{},{},{}})
aAdd(aPergs,{"Do Vencimento Fat."  ,"Do Vencimento Fat."  ,"Do Vencimento Fat."  ,"mv_chh"   , "D" , 08,00,00, "G", "", "mv_par17",""             ,""             ,""             , "", "", ""             , ""             , ""             , "", "", ""             , ""             , ""             , "", "", ""             , ""             , ""             , "","","","","","",""   ,"","S","","",{},{},{}})
aAdd(aPergs,{"Ate o Venc. da Fat." ,"Ate o Venc. da Fat." ,"Ate o Venc. da Fat." ,"mv_chi"   , "D" , 08,00,00, "G", "", "mv_par18",""             ,""             ,""             , "", "", ""             , ""             , ""             , "", "", ""             , ""             , ""             , "", "", ""             , ""             , ""             , "","","","","","",""   ,"","S","","",{},{},{}})

aAdd(aPergs,{"Do Vendedor 2"       ,"Do Vendedor 2"       ,"Do Vendedor 2"       ,"mv_chj"   , "C" , 06,00,00, "G", "", "mv_par19",""             ,""             ,""             , "", "", ""             , ""             , ""             , "", "", ""             , ""             , ""             , "", "", ""             , ""             , ""             , "","","","","","","SA3","","S","","",{},{},{}})
aAdd(aPergs,{"AtÈ o Vendedor 2"    ,"AtÈ o Vendedor 2"    ,"AtÈ o Vendedor 2"    ,"mv_chl"   , "C" , 06,00,00, "G", "", "mv_par20",""             ,""             ,""             , "", "", ""             , ""             , ""             , "", "", ""             , ""             , ""             , "", "", ""             , ""             , ""             , "","","","","","","SA3","","S","","",{},{},{}})
aAdd(aPergs,{"Do Vendedor 3"       ,"Do Vendedor 3"       ,"Do Vendedor 3"       ,"mv_chm"   , "C" , 06,00,00, "G", "", "mv_par21",""             ,""             ,""             , "", "", ""             , ""             , ""             , "", "", ""             , ""             , ""             , "", "", ""             , ""             , ""             , "","","","","","","SA3","","S","","",{},{},{}})
aAdd(aPergs,{"AtÈ o Vendedor 3"    ,"AtÈ o Vendedor 3"    ,"AtÈ o Vendedor 3"    ,"mv_chn"   , "C" , 06,00,00, "G", "", "mv_par22",""             ,""             ,""             , "", "", ""             , ""             , ""             , "", "", ""             , ""             , ""             , "", "", ""             , ""             , ""             , "","","","","","","SA3","","S","","",{},{},{}})
aAdd(aPergs,{"Moeda"               ,"Moeda"               ,"Moeda"               ,"mv_cho"   , "N" , 01,00,01 ,"C", "", "mv_par23","Real"         ,""             ,""             , "", "", "Dolar"        , ""             , ""             , "", "", ""             , ""             , ""             , "", "", ""             , ""             , ""             , "","","","","","",""   ,"","S","","",{},{},{}})
aAdd(aPergs,{"Mostrar coluna do"   ,"Mostrar coluna do"   ,"Mostrar coluna do"   ,"mv_chp"   , "N" , 01,00,01 ,"C", "", "mv_par24","Vendedor 2"   ,""             ,""             , "", "", "Vendedor 3"   , ""             , ""             , "", "", ""             , ""             , ""             , "", "", ""             , ""             , ""             , "","","","","","",""   ,"","S","","",{},{},{}})
aAdd(aPergs,{"Do PrÈ-Pedido"       ,"Do PrÈ-Pedido"       ,"Do PrÈ-Pedido"       ,"mv_chq"   , "C" , 06,00,00, "G", "", "mv_par25",""             ,""             ,""             , "", "", ""             , ""             , ""             , "", "", ""             , ""             , ""             , "", "", ""             , ""             , ""             , "","","","","","",""   ,"","S","","",{},{},{}})
aAdd(aPergs,{"AtÈ o PrÈ-Pedido"    ,"AtÈ o PrÈ-Pedido"    ,"AtÈ o PrÈ-Pedido"    ,"mv_chr"   , "C" , 06,00,00, "G", "", "mv_par26",""             ,""             ,""             , "", "", ""             , ""             , ""             , "", "", ""             , ""             , ""             , "", "", ""             , ""             , ""             , "","","","","","",""   ,"","S","","",{},{},{}})

aAdd(aPergs,{"Da Filial"           ,"Da Filial"           ,"Da Filial"           ,"mv_chs"   , "C" , 02,00,00, "G", "", "mv_par27",""             ,""             ,""             , "", "", ""             , ""             , ""             , "", "", ""             , ""             , ""             , "", "", ""             , ""             , ""             , "","","","","","",""   ,"","S","","",{},{},{}})
aAdd(aPergs,{"AtÈ a Filial"        ,"AtÈ a Filial"        ,"AtÈ a Filial"        ,"mv_cht"   , "C" , 02,00,00, "G", "", "mv_par28",""             ,""             ,""             , "", "", ""             , ""             , ""             , "", "", ""             , ""             , ""             , "", "", ""             , ""             , ""             , "","","","","","",""   ,"","S","","",{},{},{}})

AjustaSx1(cPerg,aPergs)

Return
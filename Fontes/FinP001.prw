#include "Protheus.ch"
#include "Fileio.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FINP001   ºAutor  ³Henio Brasil        º Data ³  17/11/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Tela de Manutencao de Titulos a Pagar para Montagem de      º±±
±±º          ³Bordero de Pagamentos                                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³CCAB Agro                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function FINP001()

Local aArea1 	:= GetArea()
Local lInverte	:= .f.
Local aSize    	:= {}
Local aObjects 	:= {}
Local aInfo   	:= {}
Local aPosObj 	:= {}
Local cQryFin	:= ""
Local nOpca		:= 0
Local aCampos 	:= {}      
Local cVersion	:= '3.3' 
Local cPerg 	:= 'CCAB02' 
// Local lHavePerg	:= Pergunte(cPerg,.f.)     		// nao esta Ok ainda, se nao existir a pergunta da' Pau!! Ui.
Local lHavePerg	:= FinPPerg(cPerg,.f.)
Local aStru		:= SE2->(DbStruct())             
Local cSelecao	:= cMarcados := ''

Private cAliasSE2	:= "QRYSE2"    
Private cMarca	:= GetMark()
Private oDlg1
Private oValor 
Private oQtdTit 
Private nValor 	:= 0
Private nQtdTit := 0


/*                                   
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Verifica se as perguntas existem, caso negativo cria automaticamente    ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/ 
//If !lHavePerg 
//	Return .T.
// 	FinPPerg(cPerg)
//EndIf             

If !Pergunte(cPerg,.t.) 
	Return .T.
Endif	
cSelecao	:= MV_PAR10 		// Se traz os registros anteriormente atualizados  	
cMarcados	:= MV_PAR11 		// Se traz todos os reg. marcados para evitar trabalho 
nValMoeda	:= MV_PAR09 		// Valida se existe taxa na Moeda 2... 

/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Valida a existencia da Moeda solicitada no Parametro                    ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/  
If nValMoeda<>1 
	DbSelectArea('SM2')                     
	DbSetOrder(1) 
	If DbSeek(dDataBase, .f.) 
		cMoed:= 'SM2->M2_MOEDA'+Str(nValMoeda,1)   
		cMens:= " Não existe taxa para a Moeda "+StrZero(nValMoeda,1) 
		If Empty(&cMoed) 
		   MsgAlert(cMens) 
		   Return
		Endif 
	 Else 
	   MsgAlert(" Moeda não cadastrada nesta data. Atualize o sistema!") 
	   Return
	Endif    
Endif 	
/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Mapeamento das colunas da Tela                                          ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/  
aEval(aStru,{|x| cQryFin += ","+AllTrim(x[1])})

Aadd(aCampos,{"E2_FLAG"		,"","Mark"		,""})
Aadd(aCampos,{"E2_PREFIXO"	,"","Prefixo"	,"@!"})
Aadd(aCampos,{"E2_NUM"		,"","Titulo"	,"@!"})
Aadd(aCampos,{"E2_PARCELA"	,"","Parcela"	,"@!"})
Aadd(aCampos,{"E2_TIPO"		,"","Tipo"		,"@!"})
Aadd(aCampos,{"E2_FORNECE"	,"","Cod.Forn."	,"@!"})
Aadd(aCampos,{"E2_NOMFOR"	,"","Fornecedor","@!"})
Aadd(aCampos,{"E2_PORTADO"	,"","Portador"		,""})
Aadd(aCampos,{"E2_XESPECI"	,"","Especie"	,"@!"})
Aadd(aCampos,{"E2_XENCC"	,"","Encontro Conta"		,""})
Aadd(aCampos,{"E2_XDTENCC"	,"","Data Enc Cta"		,""})
Aadd(aCampos,{"E2_VENCREA"	,"","Vencimento",""})
Aadd(aCampos,{"E2_VALOR"	,"","Valor"		,"@E 999,999,999.99"})	// "@E 999,999,999.99"
Aadd(aCampos,{"E2_XIDENTI"	,"","Cod Identif.","@!"})
Aadd(aCampos,{"E2_MOEDA"	,"","Moeda"		,""})
Aadd(aCampos,{"E2_VLCRUZ"	,"","Valor R$"	,"@E 999,999,999.99"})			
Aadd(aCampos,{"E2_XMODELO"	,"","Forma Pgto",""})
Aadd(aCampos,{"E2_XBCOPAG"	,"","Banco"		,""})
Aadd(aCampos,{"E2_XAGNPAG"	,"","Agencia"	,""})
Aadd(aCampos,{"E2_XCTAPAG"	,"","Conta"		,""})


/*                                   
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Parametros para filtro de titulos no Contas a Pagar                     ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/  
nValorInicio 	:= Str(mv_par07,12,2)
nValorFinal 	:= Str(mv_par08,12,2)
                          
DbSelectArea('SE2')                     
DbSetOrder(1) 

cQryFin := "SELECT * FROM  "+ RetSqlName("SE2")		
cQryFin += "		 WHERE D_E_L_E_T_ ='' AND E2_SALDO <> 0 AND "
cQryFin += "		 E2_VENCREA >= '"+ Dtos(mv_par01)	+"' AND "
cQryFin += "		 E2_VENCREA <= '"+ Dtos(mv_par02) 	+"' AND "  
cQryFin += "		 E2_PREFIXO >= '"+ mv_par03 	  	+"' AND "
cQryFin += "		 E2_PREFIXO <= '"+ mv_par04 		+"' AND "  
cQryFin += "		 E2_FORNECE >= '"+ mv_par05 		+"' AND "
cQryFin += "		 E2_FORNECE <= '"+ mv_par06 		+"' AND "  
cQryFin += "		 E2_VALOR   >= '"+ nValorInicio		+"' AND "
cQryFin += "		 E2_VALOR   <= '"+ nValorFinal 		+"' AND "  
cQryFin += "		 E2_MOEDA   =  '"+ Str(mv_par09,2) 	+"' AND "  
//cQryFin += "		 E2_PORTADO =  ' ' AND E2_NUMBOR = ' ' 	AND " 
cQryFin += "		 E2_NUMBOR = ' ' 	AND "   

If cSelecao == 1               
	cQryFin += "E2_XMODELO <> '' " 
Elseif cSelecao == 2 
	cQryFin += "E2_XMODELO = '' " 
Else
	cQryFin += "(E2_XMODELO <> '' OR E2_XMODELO = '')" 
Endif   

/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Processa Arquivo de Trabalhdo de acordo com a Query                  ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/ 
cArqTrab := CriaTrab(aStru,.T.) 		
dbUseArea(.T.,__LocalDriver,cArqTrab,cAliasSe2,.F.)
Processa({|| SqlToTrb(cQryFin,aStru,cAliasSe2)}) 	

dbSelectArea(cAliasSe2)
DbGoTop() 
If Eof() 
	MsgAlert(" Não foram encontrados registros para os parametros informados !") 
	DbCloseArea()         
	RestArea(aArea1)
	Return 
Endif 	
If cMarcados == 1			// Trazer itens marcados 
	FinPFun01(cAliasSe2,cMarca,oValor,oQtdTit,@nValor,@nQtdTit)
Endif
/* 
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³Calculo das dimensoes da Janela                                            ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/ 
aSize    := MsAdvSize()
aObjects := {}
AAdd( aObjects, { 015, 015, .T., .F. } )
AAdd( aObjects, { 120, 100, .T., .T. } )

aInfo   := { aSize[ 1 ],aSize[ 2 ],aSize[ 3 ],aSize[ 4 ],02,02 }
aPosObj := MsObjSize( aInfo, aObjects, .F. )

Define MsDialog oDlg1 Title "Seleção de Títulos para Borderô - Vr "+cVersion From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL
@ 1.6 , 01	Say "Valor Selecionado " 	Size 50,12 
@ 1.6 , 24	Say "Títulos Selecionados " Size 50,12 
@ 1.6 , 10	Say oValor		Var nValor		Picture "@E 999,999,999.99" 
@ 1.6 , 34	Say oQtdTit 	Var nQtdTit 	Picture "999"  
										// "E2_DATALIB",
oMark:= MsSelect():New(cAliasSe2,"E2_FLAG",,aCampos,@lInverte,@cMarca,{aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4]})
oMark:bMark := {|| FinPFun02(cAliasSE2,cMarca,oValor,oQtdTit,@nValor,@nQtdTit)}	
oMark:oBrowse:lhasMark		:= .t.
oMark:oBrowse:lCanAllmark	:= .t.
oMark:oBrowse:bAllMark		:= { || FinPFun03(cMarca,cAliasSe2,oValor,oQtdTit,@nValor,@nQtdTit)}

Activate MsDialog oDlg1 On Init EnchoiceBar( oDlg1,{|| nOpca := 1, FinPFun04(cMarca)},{|| nOpca := 0,ODlg1:End()} ) CENTER
       
/* 
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Limpa Filtro e reabre indices com RetIndex                           ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/ 
DbSelectArea(cAliasSe2)
DbCloseArea()
DbSelectArea('SE2') 
Return



/* 
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³FinPFun01 ³ Autor ³ Alessandro B. Freire  ³ Data ³ 21/11/95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Trata o valor	para marcar e desmarcar item			  	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³Fa580Marca(ExpN1,ExpD1,ExpD2) 							  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³FINP001 													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/                  
Static Function FinPFun01(cAlias,cMarca,oValor,oQtdTit,nValor,nQtdTit)
Local aArea2 := GetArea()

dbSelectArea(cAlias)
DbGoTop()
While !Eof()
	RecLock(cAlias)
	(cAlias)->E2_FLAG := cMarca
	MsUnLock()
	nValor += Round(NoRound(xMoeda((cAlias)->(E2_SALDO+E2_SDACRES-E2_SDDECRE),(cAlias)->E2_MOEDA,1,,3),3),2)
	nQtdTit++
	dbSkip()
EndDo
RestArea(aArea2)
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³FinPFun02 ³ Autor ³ Mauricio Pequim Jr.   ³ Data ³ 19/05/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Exibe Totais de titulos selecionados						  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³FA580Exibe()												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³FINP001 													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FinPFun02(cAlias,cMarca,oValor,oQtdTit,nValor,nQtdTit)
If (cAlias)->E2_FLAG == cMarca
	nValor += Round(NoRound(xMoeda((cAlias)->(E2_SALDO+E2_SDACRES-E2_SDDECRE),(cAlias)->E2_MOEDA,1,,3),3),2)
	nQtdTit++
Else
	nValor -= Round(NoRound(xMoeda((cAlias)->(E2_SALDO+E2_SDACRES-E2_SDDECRE),(cAlias)->E2_MOEDA,1,,3),3),2)
	nQtdTit--
Endif
nQtdTit:= Iif(nQtdTit<0,0,nQtdTit)
oValor:Refresh()
oQtdTit:Refresh()
Return                                      

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³FinPFun03 ³ Autor ³ Fernando Dourado		³ Data ³ 19/03/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Marca / Desmarca todos os titulos						  	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³Fa580Inverte()											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³FINP001 													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FinPFun03(cMarca,cAlias,oValor,oQtdTit,nValor,nQtdTit)

Local aArea3:= GetArea()

dbSelectArea(cAlias)
DbGoTop()

While !Eof() .and. xFilial("SE2") == (cAlias)->E2_FILIAL
	RecLock(cAlias)
	IF (cAlias)->E2_FLAG == cMarca
		(cAlias)->E2_FLAG	:= "  "
		nValor -= Round(NoRound(xMoeda((cAlias)->(E2_SALDO+E2_SDACRES-E2_SDDECRE),(cAlias)->E2_MOEDA,1,,3),3),2)
		nQtdTit--
	Else
		(cAlias)->E2_FLAG	:= cMarca
		nValor += Round(NoRound(xMoeda((cAlias)->(E2_SALDO+E2_SDACRES-E2_SDDECRE),(cAlias)->E2_MOEDA,1,,3),3),2)
		nQtdTit++
	Endif
	MsUnlock()
	dbSkip()
Enddo
RestArea(aArea3)
nQtdTit:= Iif(nQtdTit<0,0,nQtdTit)
oValor:Refresh()
oQtdTit:Refresh()
oMark:oBrowse:Refresh(.t.)
Return Nil


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³FinPFun04 ³ Autor ³Henio Brasil           ³ Data ³ 17/11/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Executa Rotina para escolha do banco e modelo de bordero    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³Especifico Ccab Agro                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
                
Static Function FinPFun04(cMarca)

Local cModPgto  := CriaVar("E2_XMODELO")
Local cBancoF01	:= CriaVar("A6_COD")
Local cAgencF01	:= CriaVar("A6_AGENCIA")
Local cContaF01	:= CriaVar("A6_NUMCON")
Local nOpcx 	:= 0
Local lNoMark	:= .T. 
Local oModPgto
Local oBcoPgto
Local oDlg2 

DbGoTop() 
While QRYSE2->(!Eof()) .And. lNoMark    
	  lNoMark:= If(Empty(QRYSE2->E2_FLAG), .t., .f.) 
	  QRYSE2->(DbSkip()) 	                     
Enddo 
If lNoMark 
	MsgAlert(" É preciso escolher registros !") 
    DbGoTop() 
    Return
Endif 
   
Private cDescMod:= 'CREDITO EM CONTA CORRENTE' 

Define MsDialog oDlg2 From	15,6 To 217,597 Title "Direciona Borderô" Pixel

@  2,  1 To  35, 294 LABEL " Modelo de Pagamento " 	Of oDlg2 Pixel  
@ 44,  1 To  76, 294 LABEL " Banco Pagador "		Of oDlg2 Pixel  
@ 14, 13 Say	"Modelo"	Size	22, 07			Of oDlg2 Pixel     
@ 12, 42 MsGet 	oModPgto    Var 	cModPgto 	F3 "58"  ; 
	Valid If(FinPFun05("58",cModPgto,@cDescMod),.T.,oModPgto:SetFocus()); 
  	Size 	18, 10 	Of oDlg2  	Pixel Picture "@!"   
@ 14, 87 Say	"Descrição"	Size	 27, 10		Of oDlg2 PIXEL  
@ 12,122 MsGet  cDescMod	Size	134, 10		Of oDlg2 PIXEL When .f. 

@ 55, 13 Say	"Banco :"	Size 	26, 7 		Of oDlg2 Pixel  
@ 53, 42 MsGet 	oBcoPgto 	Var 	cBancoF01 	F3 "SA6" Valid (Empty() .or. CarregaSA6(@cBancoF01,@cAgencF01,@cContaF01)) ;
  	Size 25, 10 	Of oDlg2 Pixel
	// Valid FinPFun06(cBancoF01,@cAgencF01,@cContaF01) 	Size   25, 10 	Of oDlg2  Pixel 
@ 55, 87 Say	"Agência"	Size 	26, 7 Of oDlg2 Pixel  
@ 53,122 MsGet 	cAgencF01   Size 	35, 10 	Of oDlg2 	Pixel  When .f. 
@ 55,170 Say	"Conta"		Size 	26, 7 Of oDlg2 Pixel  
@ 53,195 MSGET  cContaF01	Size 	50,	10 	Of oDlg2 	Pixel  When .f. 

Define SButton From 080, 227 Type 1 Action (nOpcx:=1,;
       ( Processa({ || FinPFun07(cModPgto,cBancoF01,cAgencF01,cContaF01)},"Aguarde...","Atualizando Registros...",.f.),oDlg2:End()) );
		Enable Of oDlg2              

Define SButton From 080, 263 Type 2 Action (nOpcx=0,oDlg2:End()) Enable Of oDlg2 
Activate MsDialog oDlg2 Centered

If nOpcx != 2
	Return 
EndIf
oDlg1:Refresh()
oDlg1:End()
Return                   


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³FinPFun05 ³ Autor ³Henio Brasil           ³ Data ³ 17/11/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Escolha o Modelo de Pagamento sera feito                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³Especifico Ccab Agro                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FinPFun05(cTabela,cModelo,cDescMod)

Local lRetorna 	:= .t.
/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Monta a tabela de situa‡”es de T¡tulos							 ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/ 
//If Empty(cModelo)
//	MsgAlert(" Escolher o Modelo de Pagamento !") 
//	lRetorna := .F.
//Endif 
DbSelectArea("SX5")
If !Found(DbSeek(cFilial+cTabela+cModelo)) .and. !Empty(cModelo)
    MsgAlert("Modelo não encontrado")
	lRetorna:=.F.
Else
	cDescMod := X5Descri() 
EndIf

Return(lRetorna) 


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³FinPFun06 ³ Autor ³Henio Brasil           ³ Data ³ 17/11/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Valida o Banco que foi escolhido via F3                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³Especifico Ccab Agro                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß                           
Agora funciona, depois que corrigi a variavel do SA6
*/

Static Function FinPFun06(cBancoF01,cAgencF01,cContaF01)

Local lRetorna := .t.
Local cAliasAnt:= Alias()
If Empty(cBancoF01)
	MsgAlert(" Precisa escolher o banco !") 
	lRetorna := .F.
	
  Else 
	DbSelectArea("SA6")
	If DbSeek(cFilial+cBancoF01)
		cAgencF01:= SA6->A6_AGENCIA
		cContaF01:= SA6->A6_NUMCON 
	EndIf
EndIf
DbSelectArea(cAliasAnt)
Return lRetorna


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³FinPFun07 ³ Autor ³Henio Brasil           ³ Data ³ 17/11/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Atualiza o Modelo de Pgto e o Banco Pagador dos Titulos     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³Especifico Ccab Agro                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
                                                   // ,lEnd)
Static Function FinPFun07(cMod,cBco,cAgn,cCta)
Local lRetorna 	:= .t. 
Local lFound	:= .f. 
Local cChvSe2  	:= ''
Local cMarkSe2 	:= ''
   
DbSelectArea(cAliasSe2)
DbGoTop() 
ProcRegua(RecCount()) 
While QRYSE2->(!Eof())        
	  cMarkSe2 	:= QRYSE2->E2_FLAG 			// Tratamento da Marca 
 	  cChvSe2	:= QRYSE2->E2_PREFIXO+QRYSE2->E2_NUM+QRYSE2->E2_PARCELA+QRYSE2->E2_TIPO+QRYSE2->E2_FORNECE+QRYSE2->E2_LOJA

	  // Para matar o registro Temporario que foi utilizado para gravar o SE2 
	  DbSelectArea(cAliasSe2)
	  If !Empty(cMarkSe2) .And. RecLock("QRYSE2", .f.) 
   	  	  DbDelete()                                    
   	  	  MsUnlock() 
      Endif  	  
	  nValor := 0	
	  nQtdTit:= 0

	  If !Empty(cMarkSe2) 
		  DbSelectArea("SE2")	
		  lFound:= DbSeek(cFilial+cChvSE2,.f.) 
		  If RecLock("SE2", .f.) .And. lFound 		// .And. !Empty(cMarkSe2) 
		     If (Alltrim(cBco) == "ENC") .OR. (Alltrim(cBco) == "CAP")    // ADICIONADO POR VALDEMIR JOSE 11/06/2013
			     E2_PORTADO := Alltrim(cBco)             //"ENC"
		     Else
		         E2_PORTADO := "   "
		     Endif
		     E2_XMODELO := cMod         // 2 
			 E2_XBCOPAG := cBco			// 3 
			 E2_XAGNPAG := cAgn			// 5 
			 E2_XCTAPAG := cCta 		// 10 
	         MsUnlock() 
		  Endif                       
	  Endif 
	  QRYSE2->(DbSkip()) 
	  IncProc()
Enddo 

// Se for para todos os registros, deve sair da tela (*) 
// Posiciona no 1o registro para apresentar o restante dos registros 
QRYSE2->(DbGoTop()) 
oValor:Refresh()
oQtdTit:Refresh()
oMark:oBrowse:Refresh(.t.)
Return 



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³FINPPERG  ³ Autor ³Henio Brasil           ³ Data ³ 17/11/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Verifica as perguntas incluIndo-as caso n„o existam        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico Ccab Agro                                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/ 

Static Function FinPPerg(cParam,lLogic)

// cAreasAnt := GetArea() 
cAliasAnt := Alias()
DbSelectArea("SX1")
DbSetOrder(1)                         
/* 
If lLogic<>Nil 
	Return( If(DbSeek(cParam+'01'), .t., .f.)) 
Endif 				*/  
cParam 	:= Padr(cParam,6)
aRegs	:= {}

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
Aadd(aRegs,{cParam,"01","Da Data Vencimento  ","","","mv_ch1","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cParam,"02","Ate Data Vencimento ","","","mv_ch2","D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cParam,"03","Do Prefixo          ","","","mv_ch3","C",03,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cParam,"04","Ate Prefixo         ","","","mv_ch4","C",03,0,0,"G","","mv_par04","","ZZZ","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cParam,"05","Do Fornecedor       ","","","mv_ch5","C",06,0,0,"G","","mv_par05","","      ","","","","","","","","","","","","","","","","","","","","","","","SA2","","","","",""})
Aadd(aRegs,{cParam,"06","Ate Fornecedor      ","","","mv_ch6","C",06,0,0,"G","","mv_par06","","ZZZZZZ","","","","","","","","","","","","","","","","","","","","","","","SA2","","","","",""})
Aadd(aRegs,{cParam,"07","De Valor            ","","","mv_ch7","N",12,2,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cParam,"08","Ate Valor           ","","","mv_ch8","N",12,2,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cParam,"09","Qual Moeda ?        ","","","mv_ch9","N",01,0,1,"C","","mv_par09","Moeda 1"  ,"","","","","Moeda 2" ,"","","","","Moeda 3" ,"","","","","Moeda 4" ,"","","","","Moeda 5","","","","","","","","",""})
Aadd(aRegs,{cParam,"10","Já Atualizados  	 ?","","","mv_chA","N",01,0,1,"C","","mv_par10","Sim","","","","","Não","","","","","Ambos","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cParam,"11","Titulos Já Marcados ?","","","mv_chB","N",01,0,0,"C","","mv_par11","Sim","","","","","Não","","","","","","","","","","","","","","","","","","","","","","","",""})
      
For i:=1 to Len(aRegs)
	If !DbSeek(Padr(cParam,Len(SX1->X1_GRUPO))+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			FieldPut(j,aRegs[i,j])
		Next
		MsUnlock()
	Endif
Next

DbSelectArea(cAliasAnt)
Return
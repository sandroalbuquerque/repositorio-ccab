#include "rwmake.ch"
#include "protheus.ch"
#INCLUDE "TopConn.ch"
#define cENTER Chr(10)+Chr(13)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Função    ³ CCFIN001 ³ Autor ³ Rodrigo Seiti   		³ Data ³ 10/10/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Novacao de divida/credito rural                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CCFIN001()                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CCFIN001()

Private lAltera := .F.
Private aRotina :=	{{ "Pesquisar"	,"AxPesqui"  					, 0 , 1 },;
{ "Visualizar"	,"FA280Visua"					, 0 , 2 },;
{ "Selecionar"	,'ExecBlock("CCFININC",.T.,.T.)', 0 , 3 },;
{ "Exclui"		,'ExecBlock("CCFINEXC",.T.,.T.)', 0 , 4 }}
Private cFatura		:=CRIAVAR("E1_NUM")
Private cCli1		:=Space(6)
Private cLoja1		:=Space(2)
Private cPrefix		:=Space(3)
Private dVencto		:=Ctod(Space(8))
Private dDataDe		:=dDataBase
Private dDataAte	:=dDataBase
Private cNat		:=Space(10)
Private nTotAbat	:=0
Private nValorFat 	:=0
Private nValorF		:=0
Private nValor 		:=0
Private nVLCruz		:=0
Private nVARURV		:=0
Private nQtdTit		:=0
Private nValtot		:=0
Private nMoedFat	:=1
Private nVlrAtu 	:=0
Private cCadastro   := "Novação" //"Faturas a Receber"
Private _cMoed		:= Space(1)
Private aVenc,aGets[0]
Private oGet1       
Private oFont15B   	:= TFont():New("Arial",,15,,.T.,,,,.T.,.F.) 
Private oFont13B   	:= TFont():New("Arial",,13,,.T.,,,,.T.,.F.) 
Private _nColAtu	:= 0
Private aAux        := {}
Private oValor		
Private oQtdTit 		


If xFilial("SC5") == '01'
	dbSelectArea("SE1")
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Endereca a Fun‡„o de BROWSE									 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	mBrowse( 6, 1,22,75,"SE1",,"!E1_SALDO")
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Recupera a Integridade dos dados							 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SE1")
	dbSetOrder(1)
Else
	Alert("Filial invalida")
EndIf

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ão    ³ CCFININC ³ Autor ³ Rodrigo Seiti		   	³ Data ³ 10/10/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrição ³ Marca‡„o dos titulos para emiss„o Novacao de divida/       ³±±
±±³          ³credito rural                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CCFININC()                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico 											      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CCFININC()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis			³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cArquivo  	:= " "
Local nTotal		:= 0
Local nHdlPrv		:= 0
Local cLote     	:= "777777"
Local cPadrao   	:= "620"
Local nValSaldo 	:= nTotal := 0
Local cPrograma 	:= "NFIN01"
Local nW 			:= 1
Local dDatCont		:= dDatabase
Local cCondicao 	:= Space(3)
Local cIndex		:= ""
Local nOpca 		:= 0
Local oDlg, oDlg1,oDlg2
Local oGet
Local oValorFat 	:= 0
Local aMoedas		:= {}
Local cVar,nO
Local OCbx, nRegE1
Local lUsado		:= .F.
Local aCampos 		:= {}
Local aTam 			:= {}
Local cAliasSE1 	:= "SE1"
Local lHead 		:= .F.
Local nValTotal 	:= 0
Local cFatAnt
Local oTimer
Local nTimeOut  	:= SuperGetMv("MV_FATOUT",,900)*1000 // Estabelece 15 minutos para que o usuarios selecione os titulos a faturar
Local _aCab 		:= {}
Local _aItens		:= {}
Local aPvlNfs 		:= {}
Local aMata520Cab	:={}
Local aBaixa		:={}
Local E1_MOEDA		// Criada para exibir o conteudo do Help correto quando o usuario pressionar F1 sobre o campo
Local E1_TIPOFAT	// Criada para exibir o conteudo do Help correto quando o usuario pressionar F1 sobre o campo
Local lFa280Qry 	:= ExistBlock("FA280QRY")
Local cQuery
Local cQueryADD
Local aStru			:= SE1->(DbStruct())

Private oValor		:= 0
Private oQtdTit 	:= 0
Private cMarca		:= GetMark()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa array com as moedas existentes.						  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

aMoedas := FDescMoed()
dbSelectArea( "SE1" )

Private aHeader   := {}
Private aCols	  := {}
Private oValTot
Private nValTot   := 0
Private nUsado 	  := 0
Private nValCruz  := 0
Private nVarURV   := 0
Private lInverte  := .F.
Private cTipo	  := Criavar ("E1_TIPOFAT")
Private cLote
Private nOrdSE1	  := 0
Private nVlrAtu   := 0
Private _aCombo   := {}
Public  aVlCruz	  := {} 		// Deve ficar como Public por causa do FINA290(GravaDp)

M->E1_TIPOFAT := cTipo			// Criada para exibir o conteudo do Help correto quando o usuario pressionar F1 sobre o campo

If !DtMovFin() 					// Verifica se data do movimento n„o ‚ menor que data limite de movimentacao no financeiro    										  ³
	Return
Endif

_aCombo := U_RetMoedas()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se o campo A1_CLIFAT est  em uso   				 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SX3")
dbSetOrder( 2 )
dbSeek("A1_CLIFAT")
lUsado := x3uso(X3_USADO)

dbGotop()
dbSeek("E1_PREFIXO")
cPictPref := AllTrim(X3_PICTURE)
dbSetOrder(1)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica o numero do Lote 									 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LoteCont("FIN")

cPrefix	 	:= Space(3)
cNat	 	:= Space(10)
dDataDe	 	:= dDataBase
dDataAte 	:= dDataBase
nValorFat	:= 0
aTam		:= TamSX3("E1_CLIENTE")
cCli1		:= Space(aTam[1])
aTam		:= TamSX3("E1_LOJA")
cLoja 		:= Space(aTam[1])

dbSelectArea("SE1")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Recebe dados a serem digitados										  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cVar 		:= aMoedas[1]
M->E1_MOEDA	:= cVar
aTam 		:= TamSx3("E1_NUM")

DEFINE MSDIALOG oDlg FROM	C(022),C(009) TO C(140),C(540) TITLE "Novação" PIXEL
@ C(004),C(007) TO 	C(051), C(225) OF oDlg PIXEL
@ C(009),C(014) Say			"Cliente / Loja" 																SIZE C(060), C(040) OF oDlg PIXEL
@ C(015),C(014) MSGET 		cCli1			 F3 "SA1" 	Valid Iif(!Empty(cCli1),ExistCpo("SA1",cCli1),.T.)	SIZE C(035), C(011) OF oDlg PIXEL
@ C(015),C(060) MSGET 		cLoja1  		 																SIZE C(010), C(011) OF oDlg PIXEL
@ C(015),C(080) Say 		Posicione("SA1",1 ,xFilial("SA1") + cCli1,  "A1_NOME")							SIZE C(065), C(090) OF oDlg PIXEL
@ C(029),C(014) Say			"Moeda"          																SIZE C(060), C(040) OF oDlg PIXEL
@ C(035),C(014) ComboBox	_cMoed		Items _aCombo 											   			SIZE C(055), C(011) OF oDlg PIXEL
/*- criar filtro de moeda na selecao dos titulos
- Verificar motivo de conversao incorreta de titulos (Sempre converte pela taxa do dia)
*/


DEFINE SBUTTON FROM C(07), C(230) TYPE 1 ACTION (nOpca:=1,IF(FA280NUM() .and. Fa280Ok(oDlg),oDlg:End(),nOpca:=0)) ENABLE OF oDlg
DEFINE SBUTTON FROM C(22), C(230) TYPE 2 ACTION oDlg:End() ENABLE OF oDlg

ACTIVATE MSDIALOG oDlg CENTERED

IF nOpca == 0
	Return
End

cTipo 	:= M->E1_TIPOFAT
cVar	:= M->E1_MOEDA

nMoedFat := Val(Substr(cVar,1,2))
DbSelectArea("SA1")
DbSetOrder(1)
DbGoTop()
DbSeek(xFilial("SA1")+cCli1+cLoja1)
If Found()
	_LOJACLI := cLoja1
	_CODCLI  := cCli1
EndIf
If Select("QRYSE1") > 0
	DbSelectArea("QRYSE1")
	DbCloseArea("QRYSE1")
EndIf

cAliasSE1 := "QRYSE1"

cQuery := ""
aEval(aStru,{|x| cQuery += ","+AllTrim(x[1])})
cQuery  := "SELECT "+SubStr(cQuery,2) + ","+cENTER
cQuery  += "SE1.R_E_C_N_O_ RECNO "+cENTER
cQuery	+= "FROM "+cENTER
cQuery	+= RetSqlName("SE1")+ " SE1 "+cENTER
cQuery	+= "WHERE "+cENTER
cQuery 	+= "E1_FILIAL='"+ xFilial("SE1") + "' "+cENTER
cQuery 	+= "AND E1_CLIENTE In ('"	+ cCli1+ "') "+cENTER
cQuery	+= "AND E1_SITUACA IN ('0','F','G') "+cENTER			//Carteira, Carteira Protesto e Carteira Acordo
cQuery	+= "AND E1_SALDO>0 "+cENTER
cQuery	+= "AND E1_MOEDA= "+Substr(_cMoed,1,1)+" "+cENTER
cQuery	+= "AND D_E_L_E_T_ = ' ' "+cENTER
cQuery	+= "AND E1_TIPO IN ('NF','DP') "+cENTER
cQuery	+= "AND E1_ORIGEM = 'MATA460' "+cENTER
cQuery  += "ORDER BY " + SqlOrder(SubStr(SE1->(IndexKey(1)),1,At("E1_TIPO",SE1->(IndexKey(1)))-2)+"+RECNO")

MemoWrit('NFIN01.SQL', cQuery)

Aadd(aStru, {"RECNO","N",10,0})
cArqTrab := CriaTrab(aStru,.T.) // Nome do arquivo temporario
dbUseArea(.T.,__LocalDriver,cArqTrab,cAliasSe1,.F.)
Processa({||SqlToTrb(cQuery, aStru, cAliasSe1)}) // Cria arquivo temporario

DbGoTop()

If BOF() .and. EOF()
	Help(" ",1,"RECNO")
	RetIndex("SE1")
	Set Filter to
	dbSetOrder(1)
	DbGoTop()
	FErase(cIndex+OrdBagExt())
	Return
EndIF

nOpcA := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta array com capos a serem mostrados na marcacao de titulos ³
//³ Utiliza os capos em uso do SE1 mais o E1_SALDO que apesar de   ³
//³ nao estar em uso deve ser mostrado na tela.                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

AADD(aCampos,{"E1_OK","","  ",""})
dbSelectArea("SX3")
dbSeek("SE1")
While !EOF() .And. (x3_arquivo == "SE1")
	IF ( X3USO(x3_usado) .or. X3_CAMPO == "E1_SALDO  ") .AND. cNivel >= X3_NIVEL .AND. X3_CONTEXT != "V"
		AADD(aCampos,{X3_CAMPO,"",X3Titulo(),X3_PICTURE})
	Endif
	dbSkip()
Enddo

dbSelectArea(cAliasSe1)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Marca os titulos ate o valor informado para a fatura 		  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nValor  := 0
nQtDTit := 0

nValorF := nValorFat

DEFINE MSDIALOG oDlg1 TITLE "Novação" From C(9),C(0) To C(28),C(80) OF oMainWnd
oTimer:= TTimer():New(nTimeOut,{|| oDlg1:End() },oDlg1) 			// Ativa timer
oTimer:Activate()
  
@ C(1.0) , C(0.3)	To C(3.35),C(39) OF oDlg1
@ C(1.6) , C(25	)	Say "Valor Selecionado" FONT oDlg1:oFont //"Valor Selecionado"
@ C(1.6) , C(34	)	Say "T¡t. Selec." FONT oDlg1:oFont //"T¡t. Selec."
@ C(2.4) , C(25	)	Say oValor		VAR nValor		Picture "@E 99,999,999,999.99" FONT oDlg1:oFont
@ C(2.4) , C(34)	Say oQtdTit 	VAR nQtdTit 	Picture "999"  FONT oDlg1:oFont SIZE C(20),C(11)   

oMark :=MsSelect():New(cAliasSe1,"E1_OK","!E1_SALDO",aCampos,@lInverte,@cMarca,{C(50),C(2),C(200),C(520)})
oMark:bMark := {||Fa280Exibe(cAliasSe1,cMarca,oValor,oQtdTit,oMark,@nValor), nValor := AtualizaValor(cAliasSe1,cMarca,@nValor)}
oMark:oBrowse:lhasMark := .t.
oMark:oBrowse:lCanAllmark := .t.
oMark:oBrowse:bAllMark := {|| _ALL(cMarca,@oMark,cAliasSe1,@nValor,oDlg1)}
oMark:oBrowse:Refresh()	
                       

//@ C(205), C(20) BUTTON "Marca Todos" Size 35,11 ACTION (MARCATODOS(cMarca,cAliasSe1)) OF oDlg Pixel
//@ C(205), C(50) BUTTON "Desm. Todos" Size 35,11 ACTION (MARCATODOS(cMarca,cAliasSe1)) OF oDlg Pixel

ACTIVATE MSDIALOG oDlg1 ON INIT EnchoiceBar(oDlg1,{|| nOpca := 1,;
IIF(Fa280ValOK(),IF(Fa280Soma(),oDlg1:End(),;
Iif(Fa280Val(oValorFat),nOpca:=0,nOpca:=0)),nOpca:=0)},;
{|| nOpca := 2,oDlg1:End()});
VALID (oTimer:End(),.T.)
dbSelectArea("SE1")

If nOpcA == 1
	
	_nSaldo:= 0
	
	_xSaldo:= 0
	
	_nCruz:= 0
	
	_nComis1:= 0
	_nComis2:= 0
	_nComis3:= 0
	_nComis4:= 0
	_nComis5:= 0
	
	_nBase1:= 0
	_nBase2:= 0
	_nBase3:= 0
	_nBase4:= 0
	_nBase5:= 0
	
	_nTP9:= 0
	
	_nTotTit:= 0
	
	_nValJur:= 0
	
	_nPorcJur:= 0
	
	_nDescFint:= 0
	
	_xTaxM2:= 0
	_xTaxM3:= 0
	_xTaxM4:= 0
	_xTaxM5:= 0
	
	DbSelectArea("QRYSE1")
	DbGoTop()
	Do While !Eof("QRYSE1")
		
		If QRYSE1->E1_OK == cMarca
			
			_nSaldo	 := _nSaldo + QRYSE1->E1_SALDO
			_nCruz	 := _nCruz + QRYSE1->E1_VLCRUZ
			_cVend1	 := QRYSE1->E1_VEND1
			_cVend2	 := QRYSE1->E1_VEND2
			_cVend3	 := QRYSE1->E1_VEND3
			_cVend4	 := QRYSE1->E1_VEND4
			_cVend5	 := QRYSE1->E1_VEND5
			_nComis1 := _nComis1 + QRYSE1->E1_COMIS1
			_nComis2 := _nComis2 + QRYSE1->E1_COMIS2
			_nComis3 := _nComis3 + QRYSE1->E1_COMIS3
			_nComis4 := _nComis4 + QRYSE1->E1_COMIS4
			_nComis5 := _nComis5 + QRYSE1->E1_COMIS5
			_cMoeda	 := QRYSE1->E1_MOEDA
			_nBase1	 := _nBase1 + GetAdvFVal("SE1","E1_BASCOM1",xFilial("SE1")+QRYSE1->E1_PREFIXO+QRYSE1->E1_NUM+QRYSE1->E1_PARCELA+QRYSE1->E1_TIPO,1,0)
			_nBase2	 := _nBase2 + GetAdvFVal("SE1","E1_BASCOM2",xFilial("SE1")+QRYSE1->E1_PREFIXO+QRYSE1->E1_NUM+QRYSE1->E1_PARCELA+QRYSE1->E1_TIPO,1,0)
			_nBase3	 := _nBase3 + GetAdvFVal("SE1","E1_BASCOM3",xFilial("SE1")+QRYSE1->E1_PREFIXO+QRYSE1->E1_NUM+QRYSE1->E1_PARCELA+QRYSE1->E1_TIPO,1,0)
			_nBase4	 := _nBase4 + GetAdvFVal("SE1","E1_BASCOM4",xFilial("SE1")+QRYSE1->E1_PREFIXO+QRYSE1->E1_NUM+QRYSE1->E1_PARCELA+QRYSE1->E1_TIPO,1,0)
			_nBase5	 := _nBase5 + GetAdvFVal("SE1","E1_BASCOM5",xFilial("SE1")+QRYSE1->E1_PREFIXO+QRYSE1->E1_NUM+QRYSE1->E1_PARCELA+QRYSE1->E1_TIPO,1,0)
			_nTotTit := _nTotTit + 1
			
		EndIf
		DbSelectArea("QRYSE1")
		DbSkip()
	EndDo
	
	U_MontaTela() 			// Tela de informaçoes dos novos titulos
	
EndIf

Return()


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Processa  ºAutor  ³Daniel Franciulli   º Data ³  07/11/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Processa a fatura                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function _Processa()
LOCAL aArray := {}

_nTipo := If(Substr(_cTipo,1,1)=="C",1,2)
_nTaxa := If(Substr(_cTaxa,1,1)=="D",1,2)

If Aviso("Confirma a execução?","Confirma a execução?",{"Sim","Não"},,) == 1
	_xTipo := AllTrim(Posicione("SE4",1,xFilial("SE4")+_cCond,"E4_TIPO"))
	_xCond := AllTrim(Posicione("SE4",1,xFilial("SE4")+_cCond,"E4_COND"))
	If !Empty(_xTipo)
		aAux := {}
		If AllTrim(_xTipo) == '9'
			_xTpNove := AllTrim(_xCond)
			_nParc := 0
			
			If nValP1 <> 0
				_nParc := 1
				Aadd ( aAux ,{nValP1,dVencP1,nDescP1})
			EndIf
			
			If nValP2 <> 0
				_nParc := 2
				Aadd ( aAux ,{nValP2,dVencP2,nDescP2})
			EndIf
			
			If nValP3 <> 0
				_nParc := 3
				Aadd ( aAux ,{nValP3,dVencP3,nDescP3})
			EndIf
			
			If nValP4 <> 0
				_nParc := 4
				Aadd ( aAux ,{nValP4,dVencP4,nDescP4})
			EndIf
		Else
			aAux 	  := Condicao(nValor, _cCond)
			nParcelas := Len(aAux)
		EndIf
	EndIf
	
	If _cMoeda == 2
		nTaxa := Iif(_nTaxa == 1, GetAdvFVal("SM2","M2_MOEDA2",dDataBase,1,1),(_nCruz/_nSaldo))
	ElseIf _cMoeda == 3
		nTaxa := Iif(_nTaxa == 1, GetAdvFVal("SM2","M2_MOEDA3",dDataBase,1,1),(_nCruz/_nSaldo))
	ElseIf _cMoeda == 4
		nTaxa := Iif(_nTaxa == 1, GetAdvFVal("SM2","M2_MOEDA4",dDataBase,1,1),(_nCruz/_nSaldo))
	ElseIf _cMoeda == 5
		nTaxa := Iif(_nTaxa == 1, GetAdvFVal("SM2","M2_MOEDA5",dDataBase,1,1),(_nCruz/_nSaldo))'
	Else
		nTaxa := _nCruz/_nSaldo
	EndIf
	
	_nComis1:= _nComis1 / _nTotTit
	_nComis2:= _nComis2 / _nTotTit
	_nComis3:= _nComis3 / _nTotTit
	_nComis4:= _nComis4 / _nTotTit
	_nComis5:= _nComis5 / _nTotTit
	
	
	_nBase1:= _nBase1 / _nSaldo
	_nBase2:= _nBase2 / _nSaldo
	_nBase3:= _nBase3 / _nSaldo
	_nBase4:= _nBase4 / _nSaldo
	_nBase5:= _nBase5 / _nSaldo
	
	/*
	If _xTipo == '9'
		
		If _nParc <> 0
			For _i := 1 To _nParc
				_xSaldo := _nSaldo
				_nvalapp := aAux[_i,1]
				
				aTitulo := {}
				aTitulo :=	{{"E1_PREFIXO" ,AllTrim(Iif(_nTipo == 1,GETMV("MV_XSERCRD"),GETMV("MV_XSERREN"))) 		,Nil},;
				{"E1_NUM"		,_cTitulo																,Nil},;
				{"E1_PARCELA"	,AllTrim(Str(_i))														,Nil},;
				{"E1_TIPO"		,"NF "																	,Nil},;
				{"E1_NATUREZ"	,AllTrim(Iif(_nTipo == 1,GETMV("MV_XNATCRD"),GETMV("MV_XNATREN")))		,Nil},;
				{"E1_CLIENTE"	,_CODCLI																,Nil},;
				{"E1_LOJA"		,_LOJACLI																,Nil},;
				{"E1_EMISSAO"	,dDataBase																,Nil},;
				{"E1_VENCTO"	,aAux[_i,2]																,Nil},;
				{"E1_VENCREA"	,DataValida(aAux[_i,2])													,Nil},;
				{"E1_VALOR"		, _nvalapp																,Nil},;
				{"E1_VLCRUZ"	,(_nvalapp *nTaxa)														,Nil},;
				{"E1_VEND1"		,_cVend1																,Nil},;
				{"E1_VEND2"		,_cVend2																,Nil},;
				{"E1_VEND3"		,_cVend3																,Nil},;
				{"E1_VEND4"		,_cVend4																,Nil},;
				{"E1_VEND5"		,_cVend5																,Nil},;
				{"E1_COMIS1"	,_nComis1																,Nil},;
				{"E1_COMIS2"	,_nComis2																,Nil},;
				{"E1_COMIS3"	,_nComis3																,Nil},;
				{"E1_COMIS4"	,_nComis4																,Nil},;
				{"E1_COMIS5"	,_nComis5																,Nil},;
				{"E1_MOEDA"		,_cMoeda																,Nil},;
				{"E1_BASCOM1"	,(_nvalapp *_nTaxa)*_nBase1												,Nil},;
				{"E1_BASCOM2"	,(_nvalapp *_nTaxa)*_nBase2												,Nil},;
				{"E1_BASCOM3"	,(_nvalapp *_nTaxa)*_nBase3												,Nil},;
				{"E1_BASCOM4"	,(_nvalapp *_nTaxa)*_nBase4												,Nil},;
				{"E1_BASCOM5"	,(_nvalapp *_nTaxa)*_nBase5												,Nil},;
				{"E1_DESCFIN"	,aAux[_i,3]																,Nil},;
				{"E1_TXMOEDA"	,nTaxa																	,Nil}}
				
				lMsHelpAuto := .t.
				lMsErroAuto := .f.
				MSExecAuto({|x,y| FINA040(x,y)},aTitulo,3)
				
				If lMsErroAuto
					DisarmTransaction()
					Mostraerro()
				else
					alert('Gerou um Titulo Nº '+_cTitulo+' Tipo: 9')
				EndIf
				
			Next
		EndIf
	Else
		For _i := 1 To Len(aAux)
			_nvalapp := aAux[1,2]
			aTitulo :=  {}
			aTitulo := 	{{"E1_PREFIXO" ,AllTrim(Iif(_nTipo == 1,GETMV("MV_XSERCRD"),GETMV("MV_XSERREN")))     	,Nil},;
			{"E1_NUM"		,_cTitulo																,Nil},;
			{"E1_PARCELA"	,AllTrim(Str(_i))														,Nil},;
			{"E1_TIPO"		,"NF "																	,Nil},;
			{"E1_NATUREZ"	,AllTrim(Iif(_nTipo == 1,GETMV("MV_XNATCRD"),GETMV("MV_XNATREN")))		,Nil},;
			{"E1_CLIENTE"	,_CODCLI																,Nil},;
			{"E1_LOJA"		,_LOJACLI																,Nil},;
			{"E1_EMISSAO"	,dDataBase																,Nil},;
			{"E1_VENCTO"	,aAux[_i,1]																,Nil},;
			{"E1_VENCREA"	,DataValida(aAux[_i,1])													,Nil},;
			{"E1_VALOR"		, _nvalapp																,Nil},;
			{"E1_VLCRUZ"	,(_nvalapp *_nTaxa)														,Nil},;
			{"E1_VEND1"		,_cVend1																,Nil},;
			{"E1_VEND2"		,_cVend2																,Nil},;
			{"E1_VEND3"		,_cVend3																,Nil},;
			{"E1_VEND4"		,_cVend4																,Nil},;
			{"E1_VEND5"		,_cVend5																,Nil},;
			{"E1_COMIS1"	,_nComis1																,Nil},;
			{"E1_COMIS2"	,_nComis2																,Nil},;
			{"E1_COMIS3"	,_nComis3																,Nil},;
			{"E1_COMIS4"	,_nComis4																,Nil},;
			{"E1_COMIS5"	,_nComis5																,Nil},;
			{"E1_MOEDA"		,_cMoeda																,Nil},;
			{"E1_BASCOM1"	,(_nvalapp *_nTaxa)*_nBase1												,Nil},;
			{"E1_BASCOM2"	,(_nvalapp *_nTaxa)*_nBase2												,Nil},;
			{"E1_BASCOM3"	,(_nvalapp *_nTaxa)*_nBase3												,Nil},;
			{"E1_BASCOM4"	,(_nvalapp *_nTaxa)*_nBase4												,Nil},;
			{"E1_BASCOM5"	,(_nvalapp *_nTaxa)*_nBase5												,Nil},;
			{"E1_DESCFIN"	,_nValdesc																,Nil},;
			{"E1_TXMOEDA"	,_nTaxa																	,Nil}}
			
			lMsHelpAuto := .t.
			lMsErroAuto := .f.
			MSExecAuto({|x,y| FINA040(x,y)},aTitulo,3)
			
			If lMsErroAuto
				DisarmTransaction()
				Mostraerro()
			else
					alert('Gerou ('+alltrim(Str(_i))+') Titulo Nº '+_cTitulo+' Tipo Diferente de 9')
			EndIf
			
		Next
		
	EndIf
	
	*/  
	aCols := aClone(oGet1:aCols)
	Begin Transaction 
	                   
	_XCHAVE := AllTrim(_CODCLI)+AllTrim(_LOJACLI)+AllTrim(Iif(_nTipo == 1,GETMV("MV_XSERCRD"),GETMV("MV_XSERREN")))+_cTitulo
	
	_cMotBx :=Iif(_nTipo == 1,GETMV("MV_XMOTBXC"),GETMV("MV_XMOTBXR"))
	
	DbSelectArea("QRYSE1")
	DbGoTop()
	Do While !Eof("QRYSE1")
		
		If QRYSE1->E1_OK == cMarca
			
			DbSelectArea("SE1")
			DbSetOrder(1)
			DbSeek(xFilial("SE1")+QRYSE1->E1_PREFIXO+QRYSE1->E1_NUM+QRYSE1->E1_PARCELA+QRYSE1->E1_TIPO)
			_cSaldo   := 0
			
			_cUpd := "Update "+RetSqlName('SE1')+" Set E1_XDESCON =   E1_DESCFIN,E1_VALJUR = 0, E1_PORCJUR = 0, E1_DESCFIN = 0  Where E1_NUM= '"+QRYSE1->E1_NUM+"' And E1_PREFIXO = '"+QRYSE1->E1_PREFIXO+"' And E1_PARCELA = '"+QRYSE1->E1_PARCELA+"' And E1_TIPO = '"+QRYSE1->E1_TIPO+"'"
			TcSqlExec(_cUpd)
			
			_cSaldo   := SaldoTit(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_TIPO,SE1->E1_NATUREZ,"R",SE1->E1_CLIENTE,1,dDataBase,dDataBase,SE1->E1_LOJA,xFilial("SE1"))
			
			_nAbatin  := SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",1,dDataBase,SE1->E1_CLIENTE,SE1->E1_LOJA,SE1->E1_FILIAL)
			
			If STR(_cSaldo,17,2) == STR(_nAbatin,17,2)
				_cSaldo := 0
			Else
				_cSaldo-= _nAbatin
			Endif
			
			aBaixa := {	{"E1_PREFIXO"	,QRYSE1->E1_PREFIXO	,Nil},;
			{"E1_NUM"		,QRYSE1->E1_NUM    	,Nil},;
			{"E1_PARCELA"	,QRYSE1->E1_PARCELA	,Nil},;
			{"E1_TIPO"	    ,QRYSE1->E1_TIPO   	,Nil},;
			{"AUTMOTBX"	    ,_cMotBx			,Nil},;
			{"AUTDTBAIXA"	,dDataBase         	,Nil},;
			{"AUTDTCREDITO"	,dDataBase         	,Nil},;
			{"AUTHIST"	    ,'Baixa Automatica'	,Nil},;
			{"AUTVALREC"	,_cSaldo			,Nil }}
			
			lMsErroAuto := .f.
			
			MSExecAuto({|x,y| FINA070(x,y)},aBaixa, 3)
			
			If lMsErroAuto
				MostraErro()
				DbSelectArea("PA1")
				DbSetOrder(1)
				RecLock("PA1",.T.)
				PA1->PA1_FILIAL := xFilial("PA1")
				PA1->PA1_E1FIL  := QRYSE1->E1_FILIAL
				PA1->PA1_E1CLI  := QRYSE1->E1_CLIENTE
				PA1->PA1_E1LOJ  := QRYSE1->E1_LOJA
				PA1->PA1_E1TIP  := QRYSE1->E1_TIPO
				PA1->PA1_E5DTA  := dDataBase
				PA1->PA1_E1PRE  := QRYSE1->E1_PREFIXO
				PA1->PA1_E1NUM  := QRYSE1->E1_NUM
				PA1->PA1_E1PAR  := QRYSE1->E1_PARCELA
				PA1->PA1_E1FIL  := xFilial("SE1")
				PA1->PA1_E1APRE := AllTrim(Iif(_nTipo == 1,GETMV("MV_XSERCRD"),GETMV("MV_XSERREN")))   // Foi adicionado por Valdemir Jose 06/12/12
				PA1->PA1_E1ANUM := _cTitulo																 // Foi adicionado por Valdemir Jose 06/12/12
				PA1->PA1_E1TIP  := "NF "
				MsUnlock()
				
			Else
				
				DbSelectArea("PA1")
				DbSetOrder(1)
				RecLock("PA1",.T.)
				PA1->PA1_FILIAL := xFilial("PA1")
				PA1->PA1_E1FIL  := QRYSE1->E1_FILIAL
				PA1->PA1_E1CLI  := QRYSE1->E1_CLIENTE
				PA1->PA1_E1LOJ  := QRYSE1->E1_LOJA
				PA1->PA1_E1TIP  := QRYSE1->E1_TIPO
				PA1->PA1_E5DTA  := dDataBase
				PA1->PA1_E1PRE  := QRYSE1->E1_PREFIXO
				PA1->PA1_E1NUM  := QRYSE1->E1_NUM
				PA1->PA1_E1PAR  := QRYSE1->E1_PARCELA
				PA1->PA1_E1FIL  := xFilial("SE1")
				PA1->PA1_E1APRE := AllTrim(Iif(_nTipo == 1,GETMV("MV_XSERCRD"),GETMV("MV_XSERREN")))   // Foi adicionado por Valdemir Jose 06/12/12
				PA1->PA1_E1ANUM := _cTitulo																// Foi adicionado por Valdemir Jose 06/12/12
				PA1->PA1_E1TIP  := "NF "

				MsUnlock()

			EndIf
		EndIf
		DbSelectArea("QRYSE1")
		DbSkip()
	EndDo
	
	// Irá gerar os titulos com os novos valores
	For _i := 1 To Len(aCols)
			//_nvalapp := aAux[1,2]
			dbSelectArea('SE1')
			dbSetOrder(1)
			aTitulo :=  {}
			aTitulo := 	{{"E1_PREFIXO"  ,AllTrim(Iif(_nTipo == 1,GETMV("MV_XSERCRD"),GETMV("MV_XSERREN")))     	,Nil},;
						 {"E1_NUM"		,_cTitulo																,Nil},;
						 {"E1_PARCELA"	,Right(aCols[_i][1],2)													,Nil},;
						 {"E1_TIPO"		,"NF "																	,Nil},;
						 {"E1_NATUREZ"	,AllTrim(Iif(_nTipo == 1,GETMV("MV_XNATCRD"),GETMV("MV_XNATREN")))		,Nil},;
						 {"E1_CLIENTE"	,_CODCLI																,Nil},;
						 {"E1_LOJA"		,_LOJACLI																,Nil},;
						 {"E1_EMISSAO"	,dDataBase																,Nil},;
						 {"E1_VENCTO"	,aCols[_i][7]															,Nil},;
						 {"E1_VENCREA"	,DataValida(aCols[_i][7])												,Nil},;
						 {"E1_VALOR"	, aCols[_i][2]															,Nil},;
						 {"E1_VLCRUZ"	,(aCols[_i][2] *_nTaxa)												,Nil},;
						 {"E1_JUROS" 	,aCols[_i][4]	 														,Nil},;
						 {"E1_CORREC" 	,aCols[_i][5]	 														,Nil},;
						 {"E1_MULTA" 	,aCols[_i][6]	 														,Nil},;
						 {"E1_DESCONT" 	,aCols[_i][3]	 														,Nil},;
						 {"E1_VEND1"	,_cVend1																,Nil},;
						 {"E1_VEND2"	,_cVend2																,Nil},;
						 {"E1_VEND3"	,_cVend3																,Nil},;
						 {"E1_VEND4"	,_cVend4																,Nil},;
						 {"E1_VEND5"	,_cVend5																,Nil},;
						 {"E1_COMIS1"	,_nComis1																,Nil},;
						 {"E1_COMIS2"	,_nComis2																,Nil},;
						 {"E1_COMIS3"	,_nComis3																,Nil},;
						 {"E1_COMIS4"	,_nComis4																,Nil},;
						 {"E1_COMIS5"	,_nComis5																,Nil},;
						 {"E1_MOEDA"	,_cMoeda																,Nil},;
						 {"E1_BASCOM1"	,(aCols[_i][2] *_nTaxa)*_nBase1										,Nil},;
						 {"E1_BASCOM2"	,(aCols[_i][2] *_nTaxa)*_nBase2										,Nil},;
						 {"E1_BASCOM3"	,(aCols[_i][2] *_nTaxa)*_nBase3										,Nil},;
						 {"E1_BASCOM4"	,(aCols[_i][2] *_nTaxa)*_nBase4										,Nil},;
						 {"E1_BASCOM5"	,(aCols[_i][2] *_nTaxa)*_nBase5										,Nil},;
						 {"E1_DESCFIN"	,_nValdesc																,Nil},;
						 {"E1_TXMOEDA"	,_nTaxa																	,Nil}}
						
			lMsHelpAuto := .t.
			lMsErroAuto := .f.

			MSExecAuto({|x,y| FINA040(x,y)},aTitulo,3)
			
			If lMsErroAuto
				DisarmTransaction()
				Mostraerro()
			EndIf	

	Next
	
	End Transaction
	
	U_CCFI01A(_XCHAVE, _nTaxa, _nTaxa)
	
	
Else
	// Destrava os registros.
	
	dbSelectArea(cAliasSe1)
	dbGoTop()
	While !EOF() .and. (cAliasSE1)->E1_EMISSAO >= dDataDe .and. (cAliasSE1)->E1_EMISSAO <= dDataAte
		IF (cAliasSE1)->E1_FILIAL != xFilial("SE1")
			dbSkip()
			Loop
		Endif
		#IFDEF TOP
			If (cAliasSe1)->(FieldPos("RECNO")) > 0
				DbSelectArea("SE1")
				MsGoto((cAliasSe1)->RECNO)
				DbSelectArea(cAliasSe1)
			Endif
		#ENDIF
		SE1->(MsUnlock())
		dbSkip()
	Enddo
	
Endif


Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ CCFINEXC ³ Autor ³ Rodrigo Seiti  		³ Data ³ 10/10/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Exclusa dos movimento de Novacao de divida/credito rural   ³±±
±±³			 ³  							  							  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ CCFINEXC()												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Generico 												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CCFI01A(CHAVE, TAX, CALC)

Private aHeader	:= {}
Private aCols	:= {}
Private nUsado	:= 0
Private _nOpca 	:= 0

AADD(aHeader,{ "Prf" 				,"E1_PREFIXO"	,"@!"							,TamSx3("E1_PREFIXO")[1]+2	,0,"U_CCFI01C()"						,"û","C","SE1","R" } ) //"Prf"
AADD(aHeader,{ "N£mero"				,"E1_NUM"		,"@!"							,TamSx3("E1_NUM")[1]		,0,"U_CCFI01C()"						,"û","C","SE1","R" } ) //"N£mero"
AADD(aHeader,{ "Ord" 				,"E1_PARCELA"	,PesqPict("SE1","E1_PARCELA")	,TamSx3("E1_PARCELA")[1]	,0,"U_CCFI01C()"						,"û","C","SE1","R" } ) //"Ord"
AADD(aHeader,{ "Tipo" 				,"E1_TIPO"		,"@!"							,TamSx3("E1_TIPO")[1]		,0,"U_CCFI01C()"						,"û","C","SE1","R" } ) //"Tipo"
AADD(aHeader,{ "Vencimento"			,"E1_VENCTO"	,PesqPict("SE1","E1_VENCTO")	,8  						,0,"&(ReadVar()) >= dDataBase"			,"û","D","SE1","R" } ) //"Vencimento"
AADD(aHeader,{ "Valor Duplicata"	,"E1_SALDO"		,"@E 9,999,999,999.99"			,14							,2,"U_CCFI01B(1)"						,"û","N","SE1","R" } ) //"Valor Duplicata"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Grava aCols com os valores das duplicatas			 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nValTot := 0
If Select("BRT") > 0
	DbSelectArea("BRT")
	DbCloseArea("BRT")
EndIf

_xCount := 0

DbSelectArea("SE1")
DbSetOrder(2)
If DbSeek(xFilial("SE1")+CHAVE)
	Do While !Eof("SE1") .and. SE1->(E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM) == CHAVE
		nValTot += SE1->E1_VALOR
		_xCount ++
		AADD(aCols,Array(Len(aHeader)+1))
		For nCntFor:=1 To Len(aHeader)
			If ( aHeader[nCntFor,10] <>  "V" )
				aCOLS[Len(aCols)][nCntFor] := FieldGet(FieldPos(aHeader[nCntFor,2]))
			Else
				aCOLS[Len(aCols)][nCntFor] := CriaVar(aHeader[nCntFor,2])
			EndIf
		Next nCntFor
		aCols[Len(aCols)][Len(aHeader)+1] := .F.
		DbSkip()
	EndDo
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Mostra tela com os diversos titulos						³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	DEFINE MSDIALOG oDlg2 TITLE "Dados da Novação"	From 9,0 To 28,80 OF oMainWnd 	// "Dados Cont beis Financeiros"
	@ 1.4 , 00.8	SAY "Data Emissao : " 											// "Data Contabiliza‡„o : "
	@ 1.4 , 07.4	Say dDatabase FONT oDlg2:oFont
	@ 1.4 , 27		Say "Valor Total:" 												// "Valor Total:"
	@ 1.4 , 32		Say oValTot VAR nValTot Picture "@E 9,999,999,999.99" FONT oDlg2:oFont
	oGetd:=MsGetDados():New(34,5,128,315,3    , ,        , ,.F.     ,      ,       ,      ,  ,        ,         ,,      ,    )
	
	ACTIVATE MSDIALOG oDlg2 ON INIT EnchoiceBar(oDlg2,{||_nOpca:=1,if(oGetd:TudoOk() .AND. U_CCFI01B(2),oDlg2:End(), _nOpca := 0)},{||oDlg2:End()})
EndIf

If _nOpca == 1
	
	For _x := 1 To Len(aCols)
		DbSelectArea("SE1")
		DbSetOrder(1)
		DbSeek(xFilial("SE1")+aCols[_x][1]+aCols[_x][2]+aCols[_x][3]+aCols[_x][4])
		If Found()
			RecLock("SE1",.F.)
			SE1->E1_VALOR		:= aCols[_x][6]
			SE1->E1_VLCRUZ		:= aCols[_x][6]
			SE1->E1_SALDO		:= aCols[_x][6]
			SE1->E1_VENCTO		:= aCols[_x][5]
			SE1->E1_VENCREA		:= aCols[_x][5]
			MsUnlock()
		Endif
	Next
	
EndIf

If CALC == 2       `
	_cUpd := "UPDATE "
	_cUpd += RetSqlName("SE1")+" "
	_cUpd += "SET E1_BASCOM2 = (E1_VALOR * "+Alltrim(STR(TAX))+"), "
	_cUpd += "E1_VLCRUZ = (E1_VALOR * "+STR(TAX)+"), "
	_cUpd += "E1_TXMOEDA = " + Alltrim(STR(TAX))
	_cUpd += "WHERE "
	_cUpd += "D_E_L_E_T_= '' "
	_cUpd += "AND E1_PREFIXO = '"+AllTrim(aCols[1][1])+"' "
	_cUpd += "AND E1_NUM = '"+AllTrim(aCols[1][2])+"'"
	MemoWrit('UPD.SQL', _cUpd)
	TcSqlExec(_cUpd)
EndIf

For _x := 1 To Len(aCols)
	DbSelectArea("SE1")
	DbSetOrder(1)
	DbGoTop()
	DbSeek(xFilial("SE1")+aCols[_x][1]+aCols[_x][2]+aCols[_x][3]+aCols[_x][4])
	
	If Found()
		RecLock("SE1",.F.)
		If _nTipo <> 1
			SE1->E1_NATUREZ	:= GetMv("MV_XNATREN")
		Else
			SE1->E1_NATUREZ	:= GetMv("MV_XNATCRD")
		EndIf
		
		MsUnlock()
	Endif
Next

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ CCFINEXC ³ Autor ³ Rodrigo Seiti  		³ Data ³ 10/10/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Exclusa dos movimento de Novacao de divida/credito rural   ³±±
±±³			 ³  							  							  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ CCFINEXC()												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Generico 												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CCFI01B(xopc)
nValx:= 0
_ret := .T.

If xopc == 1
	If &(ReadVar()) > 0
		For _x := 1 To Len(aCols)
			If _x = n
				nValx+= &(ReadVar())
			Else
				nValx+= aCols[_x][6]
			Endif
		Next
		
		If nValTot < nValx
			_ret := .F.
			Alert("Valor maior que o total da Novação")
		EndIf
		
	Else
		_ret := .F.
		Alert("Informar um valor")
	EndIf
Else
	
	For _x := 1 To Len(aCols)
		If !aCols[_x,7]
			nValx+= aCols[_x][6]
		Endif
	Next
	If nValTot > nValx
		_ret := .F.
		Alert("Valor menor que o total da Novação")
	EndIf
EndIf
Return(_ret)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ CCFINEXC ³ Autor ³ Rodrigo Seiti  		³ Data ³ 10/10/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Exclusa dos movimento de Novacao de divida/credito rural   ³±±
±±³			 ³  							  							  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ CCFINEXC()												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Generico 												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CCFI01C()
_ret := .F.
Alert("Este campo não pode ser alterado")
Return(_ret)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ CCFINEXC ³ Autor ³ Rodrigo Seiti  		³ Data ³ 10/10/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Exclusa dos movimento de Novacao de divida/credito rural   ³±±
±±³			 ³  							  							  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ CCFINEXC()												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Generico 												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function CCFINEXC()
Local lRET := .T.

If AllTrim(SE1->E1_ORIGEM) == "FINA040" .and. AllTrim(SE1->E1_PREFIXO) $(AllTrim(GETMV("MV_XSERCRD"))+"/"+AllTrim(GETMV("MV_XSERREN")))
	

	If !MsgYesNo("Deseja realmente excluir titulo Nº "+SE1->E1_NUM,"Atenção!!!")			              // Adicionado por Valdemir Jose 05/12/2012
	   Return
	endif

	_cMotBx:=Iif(AllTrim(GETMV("MV_XSERCRD")) == SE1->E1_PREFIXO,GETMV("MV_XMOTBXC"),GETMV("MV_XMOTBXR"))
	
	
    AbreTRB()         // Valdemir Jose 05/12/2012  Arraração de PA1 com SE5
    
	DbSelectArea("TRB")
	DbGoTop()
	
	If Select("EXC") > 0
		DbSelectArea("EXC")
		DbCloseArea("EXC")
	EndIf
	                                    
	// FILTRA OS REGISTROS, BUSCANDO O NUMERO DO TITULO NOVO NA TABELA PA1, POSICIONANDO NA TABELA SE1
	BeginSql Alias "EXC"
		%noparser%
		Select * From %Table:SE1% SE1
		Where SE1.%NotDel% and E1_FILIAL+E1_PREFIXO+E1_NUM+E1_TIPO = %Exp:TRB->PA1_E1FIL+TRB->PA1_E1APRE+TRB->PA1_E1ANUM+TRB->PA1_E1TIP%
	EndSql

	Processa( {|| lRET := EstornaTit()},"Processando","Processo em andamento..." )
	  
	if lRET
	   Alert("Registro estornado com sucesso")
	else
	   Alert("Houve problemas ao tentar estornar o registro, por favor verifique...")
	endif
	
	
EndIf

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MontaTela ºAutor  ³Daniel franciulli   º Data ³  13/07/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Montagem da tela de informacoes dos titulos                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MontaTela()  

Local aButtons		:= {}
                  	
Private	nValP1 	  	:= 0
Private	nValP2 	  	:= 0
Private	nValP3 	  	:= 0
Private	nValP4 	  	:= 0
Private	nDescP1   	:= 0
Private	nDescP2	  	:= 0
Private	nDescP3	  	:= 0
Private	nDescP4	  	:= 0
Private	dVencP1   	:= CtoD("  /  /  ")
Private	dVencP2   	:= CtoD("  /  /  ")
Private	dVencP3   	:= CtoD("  /  /  ")
Private	dVencP4   	:= CtoD("  /  /  ")
Private lValD1    	:= "dVencP1>=dDataBase"
Private lValD2    	:= "nValP2==0 .or. dVencP2>=dVencP1"
Private lValD3    	:= "nValP3==0 .or. dVencP3>=dVencP2"
Private lValD4    	:= "nValP4==0 .or. dVencP4>=dVencP3"
Private _cCond    	:= Space(3)	// Condicao de pagamento
Private _cTaxa    	:= Space(1) 	// Crd.Rural/Renegociacao
Private _cTipo    	:= Space(1) 	// Crd.Rural/Renegociacao
Private _cTitulo  	:= Space(TamSX3("E1_NUM")[1])//Space(6)	// Numero de Documento //Alterado por Eduardo
Private _nValdesc 	:= 0  		// Desconto
Private _nTaxa    	:= 0  		// Taxa
Private _aCombo1  	:= {}
Private _aCombo2  	:= {}
Private oDlg1 
Private _nSomaPar	:= _nSomaOri	:= 0
Private _oSomaPar,_oSomaOri

Aadd(_aCombo1, "D - Do Dia")
Aadd(_aCombo1, "N - Da Nota Original")
Aadd(_aCombo2, "C - Crd.Rural")
Aadd(_aCombo2, "R - Renegociaçào")

nValP1 	  	:= QRYSE1->E1_SALDO
_nSomaOri	:= nValor 

_cTitoDlg1 := "Informações dos títulos - Valor Selecionado: "+AllTrim(Transform(nValor, "@E 999,999,999.99"))

DEFINE MSDIALOG oDlg1 TITLE _cTitoDlg1 FROM C(022),C(009) TO C(280),C(540) PIXEL

@ C(012),C(002) TO C(127), C(266) OF oDlg1 PIXEL

@ C(015),C(005) Say "Num. Título"													   			SIZE C(040),C(008) COLOR CLR_BLACK	Font oFont13B	PIXEL OF oDlg1
@ C(021),C(005) MSGET 	_cTitulo	Picture "@!" 				Valid (!Empty(_cTitulo))  		SIZE C(040),C(007) OF oDlg1 PIXEL
@ C(015),C(050) Say "% Desconto"                                           		   				SIZE C(040),C(008) COLOR CLR_BLACK	Font oFont13B	PIXEL OF oDlg1
@ C(021),C(050) MSGET 	_nValdesc	Picture PesqPict("SE1","E1_DESCFIN") Valid (_nValdesc>=0)	SIZE C(040),C(007) OF oDlg1 PIXEL
@ C(015),C(095) Say "Taxa"                                                    		   			SIZE C(040),C(008) COLOR CLR_BLACK	Font oFont13B	PIXEL OF oDlg1
@ C(021),C(095) ComboBox	_cTaxa		Items _aCombo1 											SIZE C(040),C(008) OF oDlg1 PIXEL
@ C(015),C(140) Say "Cred. Rural / Reneg."                                     		   			SIZE C(040),C(008) COLOR CLR_BLACK	Font oFont13B	PIXEL OF oDlg1
@ C(021),C(140) ComboBox _cTipo 		Items _aCombo2 											SIZE C(040),c(008) OF oDlg1 PIXEL 
@ C(015),C(185) Say "Soma dos títulos selecionados"                            		   			SIZE C(060),C(008) COLOR CLR_BLACK	Font oFont13B	PIXEL OF oDlg1
@ C(021),C(185) MsGet _oSomaOri		Var _nSomaOri	Picture "@E 9,999,999.99"					Size C(060),C(008) COLOR CLR_RED 					PIXEL OF oDlg1	

@ C(035),C(005) Say "Parcelas:"																	Size C(050),C(008) COLOR CLR_BLACK	Font oFont15B	PIXEL OF oDlg1 //Texto parcela antes da getdados
@ C(117),C(005) Say "Soma das parcelas:"											   			SIZE C(050),C(008) COLOR CLR_BLACK	Font oFont13B	PIXEL OF oDlg1
@ C(116),C(060) MsGet _oSomaPar 	Var _nSomaPar	Picture "@E 9,999,999.99"					Size C(050),C(008) COLOR CLR_RED 					PIXEL OF oDlg1	

RegToMemory('SE1',.F.)
fGetDados1()

_oSomaPar:bWhen		:= {|| .F. }
_oSomaOri:bWhen		:= {|| .F. }

ACTIVATE MSDIALOG oDlg1 CENTERED ON INIT EnchoiceBar(oDlg1,{|| IIF(VldTela(),oDlg1:End(),nil) }, {||( oDlg1:End() )},,aButtons)

/*                                       
DEFINE MSDIALOG oDlg1 FROM	22,9 TO 280,540 TITLE _cTitoDlg1 						   							   PIXEL
@ 010, 030 Say   	"Valor"                      									   		SIZE 055, 011 OF oDlg1 PIXEL
@ 010, 095 Say   	"Desc. Pont."													   		SIZE 055, 011 OF oDlg1 PIXEL
@ 010, 175 Say   	"Vencimento"                                              		   		SIZE 055, 011 OF oDlg1 PIXEL
@ 022, 010 Say	 	"Parc. 1"                                                  		   		SIZE 055, 011 OF oDlg1 PIXEL
@ 020, 030 MSGET 	nValP1		Picture "@E 999,999,999.99" Valid (Entre(0,nValor))	   		SIZE 055, 011 OF oDlg1 PIXEL
@ 020, 095 MSGET 	nDescP1		Picture "@E 999,999,999.99" Valid (nDescP1>=0)		   		SIZE 055, 011 OF oDlg1 PIXEL
@ 020, 175 MSGET 	dVencP1									Valid (&(lValD1))		   		SIZE 035, 011 OF oDlg1 PIXEL
@ 042, 010 Say	 	"Parc. 2"                                                  		   		SIZE 055, 011 OF oDlg1 PIXEL
@ 040, 030 MSGET 	nValP2		Picture "@E 999,999,999.99" Valid (Entre(0,nValor))	   		SIZE 055, 011 OF oDlg1 PIXEL
@ 040, 095 MSGET 	nDescP2		Picture "@E 999,999,999.99" Valid (nDescP2>=0)		   		SIZE 055, 011 OF oDlg1 PIXEL
@ 040, 175 MSGET 	dVencP2									Valid (&(lValD2))		   		SIZE 035, 011 OF oDlg1 PIXEL
@ 062, 010 Say	 	"Parc. 3"                                                  		   		SIZE 055, 011 OF oDlg1 PIXEL
@ 060, 030 MSGET 	nValP3		Picture "@E 999,999,999.99" Valid (Entre(0,nValor))	   		SIZE 055, 011 OF oDlg1 PIXEL
@ 060, 095 MSGET 	nDescP3		Picture "@E 999,999,999.99" Valid (nDescP3>=0)		   		SIZE 055, 011 OF oDlg1 PIXEL
@ 060, 175 MSGET 	dVencP3									Valid (&(lValD3))		   		SIZE 035, 011 OF oDlg1 PIXEL
@ 082, 010 Say	 	"Parc. 4"                                                  		   		SIZE 055, 011 OF oDlg1 PIXEL
@ 080, 030 MSGET 	nValP4		Picture "@E 999,999,999.99" Valid (Entre(0,nValor))	   		SIZE 055, 011 OF oDlg1 PIXEL
@ 080, 095 MSGET 	nDescP4		Picture "@E 999,999,999.99" Valid (nDescP4>=0)		   		SIZE 055, 011 OF oDlg1 PIXEL
@ 080, 175 MSGET 	dVencP4									Valid (&(lValD4))		   		SIZE 035, 011 OF oDlg1 PIXEL
@ 102, 010 Say   	"Cond. Pag."                 									   		SIZE 055, 011 OF oDlg1 PIXEL
@ 102, 055 Say   	"Num. Título"													   		SIZE 055, 011 OF oDlg1 PIXEL
@ 102, 095 Say   	"% Desc."                                              		   			SIZE 055, 011 OF oDlg1 PIXEL
@ 102, 155 Say   	"Taxa"                                                    		   		SIZE 055, 011 OF oDlg1 PIXEL
@ 102, 210 Say   	"Cred. Rural/Reneg."                                       		   		SIZE 055, 011 OF oDlg1 PIXEL
@ 110, 010 MSGET 	_cCond		F3 "SE4"					Valid ExistCpo("SE4")	   		SIZE 035, 011 OF oDlg1 PIXEL
@ 110, 055 MSGET 	_cTitulo	Picture "@!" 				Valid (!Empty(_cTitulo))  		SIZE 035, 011 OF oDlg1 PIXEL
@ 110, 095 MSGET 	_nValdesc	Picture PesqPict("SE1","E1_DESCFIN") Valid (_nValdesc>=0)	SIZE 055, 011 OF oDlg1 PIXEL
@ 110, 155 ComboBox	_cTaxa		Items _aCombo1 												SIZE 055, 011 OF oDlg1 PIXEL
@ 110, 210 ComboBox _cTipo 		Items _aCombo2 												SIZE 055, 011 OF oDlg1 PIXEL
@ 004, 007 TO 																	             	 100, 225 OF oDlg1 PIXEL
DEFINE SBUTTON FROM 07, 230 TYPE 1 ACTION VldTela() 		ENABLE OF oDlg1
DEFINE SBUTTON FROM 19, 230 TYPE 2 ACTION oDlg1:End()		ENABLE OF oDlg1
ACTIVATE MSDIALOG oDlg1 CENTERED
*/
Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VldTela   ºAutor  ³Microsiga           º Data ³  07/11/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Valida os valores informados                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function VldTela()

Local _nTot 	:= 0
Local _cErro	:= ""
Local _aArea	:= GetArea()
Local _nPosVcto	:= Ascan(oGet1:aHeader,{ |X| Upper( Alltrim( X[2])) == "E1_VENCTO" }) 
Local _nPosItem	:= Ascan(oGet1:aHeader,{ |X| Upper( Alltrim( X[2])) == "C7_ITEM" })

_nTipo := If(Substr(_cTipo,1,1)=="C",1,2)
_nTaxa := If(Substr(_cTaxa,1,1)=="D",1,2)

//Valida se o total das parcelas digitadas eh igual ao total de titulos selecionados
If _nSomaPar > _nSomaOri
	MsgBox("A soma das parcelas digitadas é maior que a soma dos títulos selecionados.","Atenção")
	Return .F.
ElseIf _nSomaPar < _nSomaOri
	MsgBox("A soma das parcelas digitadas é menor que a soma dos títulos selecionados.","Atenção")
	Return .F. 
EndIf	

//Valida se todas as parcelas estao com os vencimentos preenchidos
For _nI := 1 To Len(oGet1:aCols)
	If Empty(oGet1:aCols[_nI,_nPosVcto])
		_cErro += "O item "+oGet1:aCols[_nI,_nPosItem]+" está com o vencimento em branco. "+ Chr(10)+chr(13)
	EndIf
Next

If !Empty(_cErro)
	MsgBox(_cErro,"Atenção")
	Return .F.
Endif

/*
For _x:=1 to 4
	_nTot += &("nValP"+Alltrim(Str(_x)))
	If &("nValP"+Alltrim(Str(_x))) !=0 .and. Empty(&("dVencP"+Alltrim(Str(_x))))
		_cErro += "Parcela " + Alltrim(Str(_x)) + " não possui vencimento. " + Chr(10)+chr(13)
	Endif
Next _x

If nValor > _nTot
	_cErro += "O total das parcelas é inferior ao selecionado " + Chr(10)+chr(13)
ElseIf nValor < _nTot
	_cErro += "O total das parcelas é superior ao selecionado " + Chr(10)+chr(13)
Endif
*/

DbSelectArea("SE1")
DbSetOrder(1)
DbGoTop()
If DbSeek(xFilial("SE1")+AllTrim(Iif(_nTipo == 1,GETMV("MV_XSERCRD"),GETMV("MV_XSERREN")))+_cTitulo+"1  NF")
	_cErro += "Título "+_cTitulo+" já cadastrado!"
Endif

If !Empty(_cErro)
	Aviso( "Atenção", _cErro, { "Ok" }, 2 )
	Return(.f.)
Endif

oDlg1:End()

U__Processa()

Return .T.


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  |RetMoedas ºAutor  ³Daniel Franciulli   º Data ³  29/07/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Carrega um array com as moedas do sistema                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RetMoedas()

Local aRet		:= {}
Local nQtdMoed  := MoedFin()

For nI := 1 To nQtdMoed
	If !Empty(SuperGetMV("MV_MOEDA"+Str(nI,1,0)))
		AAdd(aRet,Alltrim(Str(nI,1))+" - "+Alltrim(SuperGetMv("MV_MOEDA"+Str(nI,1,0))))
	EndIf
Next nI

Return(aRet)



/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³fGetDados1()³ Autor ³ Eduardo Cseh Vasques      ³ Data ³ 22.11.12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao  ³ Montagem da GetDados                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao ³ O Objeto oGetDados1 foi criado como Private no inicio do Fonte   ³±±
±±³           ³ desta forma voce podera trata-lo em qualquer parte do            ³±±
±±³           ³ seu programa:                                                    ³±±
±±³           ³                                                                  ³±±
±±³           ³ Para acessar o aCols desta MsNewGetDados: oGetDados1:aCols[nX,nY]³±±
±±³           ³ Para acessar o aHeader: oGetDados1:aHeader[nX,nY]                ³±±
±±³           ³ Para acessar o "n"    : oGetDados1:nAT                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
**************************
Static Function fGetDados1()
**************************
// Variaveis deste Form                                                                                                         
Local nX			:= 0                                                                                                              
Local aGetAux1	    := {"C7_ITEM","E1_VLCRUZ","E1_DESCONT","E1_JUROS","E1_CORREC","E1_MULTA","E1_VENCTO"}  
Local aCpoGDa      	:= aGetAux1 				// Vetor responsavel pela montagem da aHeader       
Local aAlter       	:= {"E1_VLCRUZ","E1_DESCONT","E1_VENCTO","E1_JUROS","E1_CORREC","E1_MULTA","NOUSER"}	// Vetor com os campos que poderao ser alterados                                                                                 
Local nOpc         	:= GD_INSERT+GD_UPDATE+GD_DELETE // Posicao do elemento do vetor aRotina que a MsNewGetDados usara como referencia  
Local cLinOk       	:= "AllwaysTrue"    		// Funcao executada para validar o contexto da linha atual do aCols                  
Local cTudoOk      	:= "AllwaysTrue"    		// Funcao executada para validar o contexto geral da MsNewGetDados (todo aCols)      
Local cIniCpos     	:= "++C7_ITEM"        		// Nome dos campos do tipo caracter que utilizarao incremento automatico.            
												// Este parametro deve ser no formato "+<nome do primeiro campo>+<nome do            
           										// segundo campo>+..."
Local nFreeze      	:= 000              		// Campos estaticos na GetDados.                                                               
Local nMax         	:= 999              		// Numero maximo de linhas permitidas. Valor padrao 99                           
Local cFieldOk     	:= "AllwaysTrue"   			// Funcao executada na validacao do campo                                           
Local cSuperDel    	:= ""              			// Funcao executada quando pressionada as teclas <Ctrl>+<Delete>                    
Local cDelOk       	:= "AllwaysTrue"   			// Funcao executada para validar a exclusao de uma linha do aCols                   
Local oWnd         	:= oDlg1          			// Objeto no qual a MsNewGetDados sera criada                                      
Local cTit, cTam
Local nCorBack      := RGB(255,255,255)
Private aHead      	:= {}               		// Array a ser tratado internamente na MsNewGetDados como aHeader                    
Private aCol       	:= {} 						// Array a ser tratado internamente na MsNewGetDados como aCols                                                                                                                                          

// Carrega aHead                                                                                                                
DbSelectArea("SX3")                                                                                                             
SX3->(DbSetOrder(2)) // Campo                                                                                                   
For nX := 1 to Len(aCpoGDa)                                                                                                     
	If SX3->(DbSeek(aCpoGDa[nX]))
		If 	   nX == 1;	cTit := "Item"
		ElseIf nX == 2;	cTit := "Valor"
		ElseIf nX == 3;	cTit := "Desconto"
		ElseIf nX == 4;	cTit := "Juros"
		ElseIf nX == 5;	cTit := "Correção"
		ElseIf nX == 6;	cTit := "Multa"
		ElseIf nX == 7;	cTit := "Vencimento"
        EndIf
		
		If nX == 2 //Valor
			Aadd(aHead,{ cTit,;                                                                                         
				SX3->X3_CAMPO	,;                                                                                                       
				SX3->X3_PICTURE,;                                                                                                                                                                                                    
				SX3->X3_TAMANHO,;
				SX3->X3_DECIMAL,;                                                                                                       
				SX3->X3_VALID,;                                                                                                      
				/*SX3->X3_USADO*/""	,;                                                                                                       
				SX3->X3_TIPO	,;                                                                                                       
				SX3->X3_F3 		,;                                                                                                
				SX3->X3_CONTEXT,;                                                                                                       
				SX3->X3_CBOX	,;                                                                                                       
				SX3->X3_RELACAO})                                                                                                       
		ElseIf nX == 3 //Desconto
			Aadd(aHead,{ cTit,;                                                                                         
				SX3->X3_CAMPO	,;                                                                                                       
				SX3->X3_PICTURE,;                                                                                                                                                                                                    
				SX3->X3_TAMANHO,;
				SX3->X3_DECIMAL,;                                                                                                       
				/*SX3->X3_VALID*/"",;                                                                                                       
				/*SX3->X3_USADO*/"",;                                                                                                       
				SX3->X3_TIPO	,;                                                                                                       
				SX3->X3_F3 		,;                                                                                                
				SX3->X3_CONTEXT,;                                                                                                       
				SX3->X3_CBOX	,;                                                                                                       
				SX3->X3_RELACAO})
		ElseIf nX == 4 //Vencimento
			Aadd(aHead,{ cTit,;                                                                                         
				SX3->X3_CAMPO	,;                                                                                                       
				SX3->X3_PICTURE,;                                                                                                                                                                                                    
				SX3->X3_TAMANHO,;
				SX3->X3_DECIMAL,;                                                                                                       
				/*SX3->X3_VALID*/"",;                                                                                                      
				/*SX3->X3_USADO*/"",;                                                                                                       
				SX3->X3_TIPO	,;                                                                                                       
				SX3->X3_F3 		,;                                                                                                
				SX3->X3_CONTEXT,;                                                                                                       
				SX3->X3_CBOX	,;                                                                                                       
				/*SX3->X3_RELACAO*/""})    
		Else
			Aadd(aHead,{ cTit,;                                                                                         
				SX3->X3_CAMPO	,;                                                                                                       
				SX3->X3_PICTURE,;                                                                                                                                                                                                    
				SX3->X3_TAMANHO,;
				SX3->X3_DECIMAL,;                                                                                                       
				SX3->X3_VALID,;                                                                                                      
				SX3->X3_USADO	,;                                                                                                       
				SX3->X3_TIPO	,;                                                                                                       
				SX3->X3_F3 		,;                                                                                                       
				SX3->X3_CONTEXT,;                                                                                                       
				SX3->X3_CBOX	,;                                                                                                       
				SX3->X3_RELACAO}) 
		EndIf                                                                                                                            
	Endif                                                                                                                         
Next nX                                                                                                                         

oGet1:= MsNewGetDados():New(C(042),C(005),C(115),C(264),nOpc,cLinOk,cTudoOk,cIniCpos,aAlter,nFreeze,nMax,cFieldOk,cSuperDel,cDelOk,oWnd,aHead,aCol)                                   

//define as cores da fonte            
oGet1:oBrowse:oFont 		:= oFont15B
oGet1:bChange		      	:= {|| U_TotalAcols(2) } 
oGet1:oBrowse:bDrawSelect	:= {|| U_TotalAcols(1) }


Return Nil 



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Função    ³TotalAcols³ Autor ³ Eduardo Cseh Vasques	³ Data ³ 22/11/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Rotina que totaliza o aCols.                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ TotalAcols()                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function TotalAcols(_nTipo)

Local _nI		:= 0
Local _nPosVlr	:= Ascan(oGet1:aHeader,{ |X| Upper( Alltrim( X[2])) == "E1_VLCRUZ" })

_nSomaPar	:= 0 

For _nI := 1 To Len(oGet1:aCols)
	
	If oGet1:aCols[_nI,Len(oGet1:aHeader)+1] == .F. //Caso a linha nao esteja deletada
		If _nTipo == 3 //Caso seja chamado da validacao do campo o aCols ainda nao foi atualizado, portanto busco da variavel de memoria
			If oGet1:aCols[_nI,_nPosVlr] == 0
				If Type('E1_VLCRUZ') <> 'U'
					_nSomaPar	+= M->E1_VLCRUZ
				Else
					_nSomaPar	+= oGet1:aCols[_nI,_nPosVlr]
				EndIf
			Else
			   	_nSomaPar	+= oGet1:aCols[_nI,_nPosVlr]
			EndIf
		Else		
			_nSomaPar	+= oGet1:aCols[_nI,_nPosVlr]
    	EndIf
   EndIf
    
Next

_oSomaPar:Refresh()


Return .T.  


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³   C()   ³ Autores ³ Norbert/Ernani/Mansano ³ Data ³10/05/2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao  ³ Funcao responsavel por manter o Layout independente da       ³±±
±±³           ³ resolucao horizontal do Monitor do Usuario.                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
**********************
Static Function C(nTam)
**********************
Local nHRes	:=	oMainWnd:nClientWidth	// Resolucao horizontal do monitor
If nHRes == 640	// Resolucao 640x480 (soh o Ocean e o Classic aceitam 640)
	nTam *= 0.8
ElseIf (nHRes == 798).Or.(nHRes == 800)	// Resolucao 800x600
	nTam *= 1
Else	// Resolucao 1024x768 e acima
	nTam *= 1.28
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Tratamento para tema "Flat"³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If "MP8" $ oApp:cVersion
	If (Alltrim(GetTheme()) == "FLAT") .Or. SetMdiChild()
		nTam *= 0.90
	EndIf
EndIf
//Return Round(nTam,2)
Return nTam


      

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CCFIN001A ºAutor  ³Valdemir Jose       º Data ³  04/12/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Atualizara o valor a ser apresentado do total do titulo     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function AtualizaValor(pcAliasSe1,pcMarca,pnValor)
	Local aArea := GetArea()
         
	pnValor := 0
	
	(pcAliasSe1)->( dbGotop() )                 
	While !(pcAliasSe1)->( Eof() )
		if (pcAliasSe1)->E1_OK = pcMarca
			pnValor += 	(pcAliasSe1)->E1_SALDO
	    endif 
		(pcAliasSe1)->( dbSkip() )
	EndDo                        
	
	RestArea( aArea )

Return pnValor


Static Function MARCATODOS(pcMarca, pcAliasSe1)
	Local aArea := GetArea()
	
	(pcAliasSe1)->( dbGotop() )                 
	While !(pcAliasSe1)->( Eof() )
	     ReckLock(pcAliasSe1,.F.)
		 (pcAliasSe1)->E1_OK := if((pcAliasSe1)->E1_OK=pcMarca,'',pcMarca)
	     MsUnlock()
		(pcAliasSe1)->( dbSkip() )
	EndDo                        
    
	RestArea( aArea )

Return


STATIC Function _ALL(cMarca,oMark,cAliasSe1, nValor, oDlg1)
Local nReg := (cAliasSe1)->(Recno())

dbSelectArea(cAliasSe1)
(cAliasSe1)->(dbGoTop())   
nValor  := 0           
nQtdTit := 0
While (cAliasSe1)->(!Eof())
	RecLock(cAliasSe1)
	IF (cAliasSe1)->E1_OK == cMarca
		(cAliasSe1)->E1_OK := "  "
	Else
		(cAliasSe1)->E1_OK := cMarca 
		nValor += (cAliasSe1)->E1_SALDO
		nQtdTit += 1
	Endif
	(cAliasSe1)->(dbSkip())
Enddo                 
(cAliasSe1)->(dbGoto(nReg))

oMark:oBrowse:Refresh(.t.)
//@ C(2.4) , C(25	)	Say oValor		VAR nValor		Picture "@E 999,999,999,999,999.99" FONT oDlg1:oFont SIZE C(30),C(11)   
//@ C(2.4) , C(34)	Say oQtdTit 	VAR nQtdTit 	Picture "999999"  FONT oDlg1:oFont SIZE C(30),C(11)   
oValor:REFRESH()
oQTDTIT:REFRESH()
Return Nil



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AbreTRB() ºAutor  ³Valdemir Jose       º Data ³  05/12/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Abre Query para Buscar Titulos a serem excluidos e estorna-º±±
±±º          ³ dos                                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function AbreTRB()
Local cQry := ''

	If Select("TRB") > 0
		DbSelectArea("TRB")
		DbCloseArea("TRB")
	EndIf

	cQry += "Select  * From "+RetSqlName('PA1')+" PA1, "+RetSqlName('SE5')+" SE5 "+cENTER
	cQry += "Where PA1.D_E_L_E_T_ = ' ' AND SE5.D_E_L_E_T_ = ' ' "+cENTER
	cQry += " AND SE5.E5_NUMERO = PA1.PA1_E1NUM  "+cENTER
	cQry += " AND SE5.E5_FILIAL = PA1.PA1_FILIAL "+cENTER
	cQry += " AND SE5.E5_MOTBX = PA1.PA1_E1APRE  "+cENTER
	cQry += " AND SE5.E5_PARCELA = PA1.PA1_E1PAR "+cENTER
	cQry += " AND SE5.E5_CLIFOR = PA1.PA1_E1CLI  "+cENTER
	cQry += " AND SE5.E5_LOJA = PA1.PA1_E1LOJ    "+cENTER
	cQry += " AND SE5.E5_TIPO = PA1.PA1_E1TIP    "+cENTER
	cQry += " AND SE5.E5_DTDIGIT = PA1_E5DTA "+cENTER
	cQry += " AND SE5.E5_RECPAG = 'R'  "+cENTER
	cQry += " AND SE5.E5_SITUACA = ' ' "+cENTER
	cQry += " AND PA1.PA1_E1ANUM = '"+SE1->E1_NUM+"' "+cENTER
	cQry += " AND PA1.PA1_E1APRE = '"+SE1->E1_PREFIXO+"' "+cENTER

	Memowrite("CCFIN001A.SQL",cQry)
	
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQry), "TRB", .F., .T.)
	
	dbSelectArea("TRB") 
	dbGotop()
	                
Return





/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CCFIN001A ºAutor  ³Valdemir Jose       º Data ³  07/12/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Estorna Titulos                                             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function EstornaTit() 
Local lRet := .F.

	Begin Transaction

	DbSelectArea("EXC")
	DbGoTop()
	Do While !Eof("EXC")
		//		posiciona SE1 para Estornar registros
		dbSelectArea('SE1')
		dbSetOrder(2)
		if dbSeek(xFilial('SE1')+EXC->E1_CLIENTE+EXC->E1_LOJA+TRB->PA1_E1PRE+TRB->PA1_E1NUM+IF(EMPTY(TRB->PA1_E1PAR),'   ',TRB->PA1_E1PAR)+TRB->PA1_E1TIP)
		
			aTitulo := {{"E1_PREFIXO" , SE1->E1_PREFIXO	,Nil},;
			{"E1_NUM"		, SE1->E1_NUM   	,Nil},;
			{"E1_PARCELA"	, SE1->E1_PARCELA	,Nil},;
			{"E1_TIPO"		, SE1->E1_TIPO		,Nil},;
			{"E1_NATUREZ"	, SE1->E1_NATUREZ	,Nil},;
			{"E1_CLIENTE"	, SE1->E1_CLIENTE	,Nil},;
			{"E1_LOJA"		, SE1->E1_LOJA		,Nil},;
			{"E1_EMISSAO"	, SE1->E1_EMISSAO	,Nil},;
			{"E1_VENCTO"	, SE1->E1_VENCTO	,Nil},;
			{"E1_VENCREA"	, SE1->E1_VENCREA	,Nil},;
			{"E1_VALOR"		, SE1->E1_VALOR		,Nil}}
			                                       
			lMsHelpAuto := .t.
			lMsErroAuto := .f.
			
			MSExecAuto({|x,y| FINA070(x,y)},aTitulo,5)      // Estorna Titulos
			
			lRet := (!lMsErroAuto)
		
		endif
		
		DbSelectArea("EXC")
		
		DbSkip()
	EndDo
	
	
	// Exclui os titulos novos com base na referencia do PA1 - Valdemir 07/12/12
	if lRet
		DbSelectArea("EXC")
		DbGoTop()
		Do While !Eof("EXC")
			//		aTitulo := {}
			aTitulo := {{"E1_PREFIXO" , EXC->E1_PREFIXO	,Nil},;
			{"E1_NUM"		, EXC->E1_NUM		,Nil},;
			{"E1_PARCELA"	, EXC->E1_PARCELA	,Nil},;
			{"E1_TIPO"		, EXC->E1_TIPO		,Nil},;
			{"E1_NATUREZ"	, EXC->E1_NATUREZ	,Nil},;
			{"E1_CLIENTE"	, EXC->E1_CLIENTE	,Nil},;
			{"E1_LOJA"		, EXC->E1_LOJA		,Nil},;
			{"E1_EMISSAO"	, EXC->E1_EMISSAO	,Nil},;
			{"E1_VENCTO"	, EXC->E1_VENCTO	,Nil},;
			{"E1_VENCREA"	, EXC->E1_VENCREA	,Nil},;
			{"E1_VALOR"		, EXC->E1_VALOR		,Nil}}
			
			lMsHelpAuto := .t.
			lMsErroAuto := .f.
			MSExecAuto({|x,y| FINA040(x,y)},aTitulo,5)      // Exclusão de Titulos
			                          
			lRet := (!lMsErroAuto)
			
			DbSelectArea("EXC")
			
			DbSkip()
		EndDo
	Endif
    // Exclui Referência entre os novos titulos com os que foram aglutinados - Valdemir 05/12/2012
	if lRet
		DbSelectArea("EXC")
		DbGoTop()
		Do While !Eof("EXC")
			dbSelectArea('PA1')
			dbSetOrder(2)
			if dbSeek(xFilial('PA1')+TRB->PA1_E1FIL+EXC->PA1_EA1NUM+EXC->PA1_EA1PRE+EXC->PA1_EA1TIP)		
				RecLock('PA1',.F.)
				dbDelete()
				MsUnlock()
			endif
			DbSelectArea("EXC")
			dbSkip()
		EndDo	
	Else
		// Caso encontre problemas não efetua nenhuma atualização
		RollBackSX8()
		DisarmTransaction()
	endif
	
	End Transaction

Return lRET
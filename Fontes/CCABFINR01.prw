#include "Protheus.ch"
#define cENTER CHR(13)+CHR(10)
#Define PAD_LEFT            0
#Define PAD_RIGHT           1
#Define PAD_CENTER          2


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCCABFINR01บAutor  ณValdemir Jose       บ Data ณ  10/12/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRelatorio Movimentacao de Titulos                           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CCAB                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function CCABFINR01()
Local cDesc1 			:= "Este programa tem como objetivo imprimir relatorio "
Local cDesc2    		:= "Movimenta็ใo de Titulos, "
Local cDesc3     		:= "respeitando o parโmetro informado."
Local cPict         	:= ""
Local titulo       		:= "RELATำRIO MOVIMENTAวรO DE TITULOS"// 
Local nPos         		:= 0         
Local Cabec1       		:= ""
Local Cabec2       		:= ""
Local imprime      		:= .T.
Local aOrd 				:= {}
LOCAL cConta  			:= ""
Local _Query            := ""     
Local _QryPerda         := ""
Local aP                := {}
Local aHelp             := {}
Local aCabec            := {}            
Local hora_inv          := Substr(Time(),1,2)+Substr(Time(),4,2)+Substr(Time(),7,2)
Local cArqExcel         := ""
Local cNomeArq          := "CCABFR01_"+DTOS(DATE())+"_"+hora_inv

Private nLin            := 1
Private aTmp            
Private aCampo   		:= {}
Private aPosTitulo      := {30, 250, 840, 1390, 1600, 2000}
Private aQuery          := {0,0,0,0,0,0,0,0,0,0}
Private lEnd         	:= .F.
Private lAbortPrint  	:= .F.
Private CbTxt        	:= ""
Private limite          := 80
Private tamanho         := "P"
Private nomeprog        := "CCABFR01"
Private nTipo           := 18
Private aReturn         := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey        := 0
Private cPerg       	:= "CCABFR01"
Private cbcont     		:= 00
Private wnrel      		:= "CCABFR01" 
Private cString 		:= "TMP"                      
Private aCol_           := {}
Private nApresentar     := 0      
Private nLarFolha       := 0 
Private bInstancia      := .F.
Private cSubTit         := ''
Private cSubTit1        := ''

PRIVATE oPrint
PRIVATE lFirst 	:= .F.                                                                                  	
PRIVATE ContFl  := 1
PRIVATE oFont07,oFont08,oFont09,oFont10, oFont10n, oFont11,oFont13,oFont15, oFont16,oFont18
PRIVATE oFont07b,oFont08b, oFont09b, oFont10b, oFont11b, oFont13b,oFont15b, oFont16b, oFont18b


// Configurando fontes para relat๓rio
oFont07	:= TFont():New("Arial",07,07,,.F.,,,,.T.,.F.)
oFont07b:= TFont():New("Arial",07,07,,.T.,,,,.T.,.F.)
oFont08	:= TFont():New("Arial",08,08,,.F.,,,,.T.,.F.)
oFont08b:= TFont():New("Arial",08,08,,.T.,,,,.T.,.F.)
oFont09	:= TFont():New("Arial",09,09,,.F.,,,,.T.,.F.)
oFont09b:= TFont():New("Arial",09,09,,.T.,,,,.T.,.F.)
oFont10	:= TFont():New("Arial",10,10,,.F.,,,,.T.,.F.)
oFontTit:= TFont():New("Arial",09,09,,.T.,,,,.T.,.F.)
oFont10b:= TFont():New("Arial",10,10,,.T.,,,,.T.,.F.)
oFont11	:= TFont():New("Arial",11,11,,.T.,,,,.T.,.F.)		//Normal s/negrito
oFont13	:= TFont():New("Arial",13,13,,.F.,,,,.T.,.F.)		//Normal s/negrito
oFont13b:= TFont():New("Arial",13,13,,.T.,,,,.T.,.F.)		//Normal s/negrito
oFont15	:= TFont():New("Arial",15,15,,.T.,,,,.T.,.F.)
oFont16	:= TFont():New("Arial",16,16,,.T.,,,,.T.,.F.)
oFont18	:= TFont():New("Arial",18,18,,.T.,,,,.T.,.F.)

                                       
//Criar o array com as perguntas e help
aAdd(aP,{"Apresentar como         ?"      ,"N", 02,0,"C", "",""		     , "Relat๓rio","Excel"	  , "Ambos",""   , ""})   //01
aAdd(aP,{"Data Emissใo Inicial    ?"      ,"D", 08,0,"G", "",""		     , ""         ,""	      , ""     ,""   , ""})   //02
aAdd(aP,{"Data Emissใo Final      ?"      ,"D", 08,0,"G", "",""  	    	 , ""         ,""	      , ""     ,""   , ""})   //03
aAdd(aP,{"Data Vencimento Inicial ?"      ,"D", 08,0,"G", "",""		     , ""         ,""	      , ""     ,""   , ""})   //04
aAdd(aP,{"Data Vencimento Final   ?"      ,"D", 08,0,"G", "",""  	    	 , ""         ,""	      , ""     ,""   , ""})   //05
aAdd(aP,{"Cliente Inicial         ?"      ,"C", 06,0,"G", "","SA1" 		 , ""         ,""	      , ""     ,""   , ""})   //06
aAdd(aP,{"Loja Cliente Inicial    ?"      ,"C", 02,0,"G", "","" 			 , ""         ,""	      , ""     ,""   , ""})   //07
aAdd(aP,{"Cliente Final           ?"      ,"C", 06,0,"G", "","SA1" 		 , ""         ,""	      , ""     ,""   , ""})   //08
aAdd(aP,{"Loja Cliente Final      ?"      ,"C", 02,0,"G", "","" 			 , ""         ,""	      , ""     ,""   , ""})   //09
aAdd(aP,{"Vendedor Inicial        ?"      ,"C", 06,0,"G", "",""    		 , ""         ,""	      , ""     ,""   , ""})   //10
aAdd(aP,{"Vendedor Final          ?"      ,"C", 06,0,"G", "",""    		 , ""         ,""	      , ""     ,""   , ""})   //11
aAdd(aP,{"Gestor Inicial          ?"      ,"C", 06,0,"G", "",""    		 , ""         ,""	      , ""     ,""   , ""})   //12
aAdd(aP,{"Gestor Final            ?"      ,"C", 06,0,"G", "",""    		 , ""         ,""	      , ""     ,""   , ""})   //13


// Detalhamento do Help
aAdd(aHelp,{"Informe como deseja apresentar","Relat๓rio","Excel","Ambos"})
aAdd(aHelp,{"Informe a data Emissใo inicial"})
aAdd(aHelp,{"Informe a data Emissใo final"})
aAdd(aHelp,{"Informe a data vencimento inicial"})
aAdd(aHelp,{"Informe a data vencimento final"})
aAdd(aHelp,{"Informe o Cliente Inicial"})
aAdd(aHelp,{"Informe a Loja do Cliente Inicial"})
aAdd(aHelp,{"Informe o Cliente Final"})
aAdd(aHelp,{"Informe a Loja do Cliente Final"})
aAdd(aHelp,{"Informe o Vendedor Inicial"})
aAdd(aHelp,{"Informe o Vendedor Final"})
aAdd(aHelp,{"Informe o Gestor inicial"})
aAdd(aHelp,{"Informe o Gestor final"})

// Cabecalho para exportar para excel
aTmp   := {'PREFIXO','Nบ TITULO','TIPO','PORTADOR','CODCLI','LOCAL','NOME CLIENTE','PJ/PF','CNPJ/CPF','CIDADE','ESTADO','RISCO CCAB','DT.1บ COMPRA','VEND2','GESTOR','EMISSAO','VENCTO','VENCTO.REAL','VLR.TITULO','MOEDA','HISTORICO','DT.BAIXA','DIG.BAIXA','VLR.BAIXA','MOTIVO BAIXA','CORRECAO','JUROS','DESCONTO','SALDO'}
                                                                                        
if !SX1Parametro(aP,aHelp)
 Return
Endif 
                                         
nApresentar := MV_PAR01

_Query := MontaQuery()
Memowrite("CCABFINR01.SQL",_Query)

Processa( {|| QryExec(_Query, "TMP") },"Processando","Processando os Registros...")
            
if TMP->( EOF() )
	MsgInfo('Nใo existe registros a serem apresentados, para este filtro...  Por favor, verifique...')
	CursorArrow()
	TMP->( dbCloseArea() )	                                                                        
	Return
Endif

dbSelectArea("TMP")

dbGotop()            

Processa( {|| GetArrayExcel(cNomeArq) },"Aguarde","Gerando planilha...")




TMP->( dbCloseArea() )	      


Return




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCCABFINR01บAutor  ณValdemir Jose       บ Data ณ  11/12/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCarrega Array para gerar planilha Excel                     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GetArrayExcel(cNomeArq)
Local nVlrBaixa, nCorrecao, nJuros, nDesconto, nSaldo
Local nCnt := 0

nVlrBaixa  := 0
nCorrecao  := 0 
nJuros     := 0 
nDesconto  := 0 
nSaldo     := 0


//nCnt := Conta("TMP","!Eof()")
dbEval( {|x| nCnt++ },,{|| TMP->( !EOF() )})

ProcRegua(nCnt)
dbGotop()
While !Eof()                           

	IncProc('Gerando planilha.... Registro: Titulo: '+TMP->NUMTITULO)

	dbSelectArea('SA1')
	IF dbSeek(xFilial('SA1')+TMP->CODCLI+TMP->LOCAL)
	      cCNPJ_CPF := SA1->A1_CGC
	      cJF       := SA1->A1_PESSOA
	      cPRICOM   := dtoc(SA1->A1_PRICOM)
	ELSE
	      cCNPJ_CPF := 'NOT FOUND'
	      cJF       := 'NOT FOUND'
	      cPRICOM   := ''
	ENDIF
	             
	
	dbSelectArea('TMP')

    aAdd(aCampo,{chr(160)+TMP->PREFIXO,;
                 chr(160)+TMP->NUMTITULO,;
                 chr(160)+TMP->TIPO,;
                 chr(160)+TMP->PORTADOR,;
                 chr(160)+TMP->CODCLI,;
                 chr(160)+TMP->LOCAL,;
                 SA1->A1_NOME,;
                 cJF,;
                 chr(160)+cCNPJ_CPF,;
                 SA1->A1_MUN,;
                 SA1->A1_EST,;
                 chr(160)+SA1->A1_RISCO,;
                 cPRICOM,;
                 chr(160)+TMP->VEND2,;
                 chr(160)+TMP->GESTOR,;
                 DTOC(STOD(TMP->EMISSAO)),;
                 DTOC(STOD(TMP->VENCTO)),;
                 DTOC(STOD(TMP->VENCTOREAL)),;
                 Transform(TMP->VLRTITULO,'@E 999,999,999,999.99'),;
                 chr(160)+STRZERO(TMP->MOEDA,2),;
                 alltrim(TMP->HISTORICO),;
                 DTOC(STOD(TMP->DTBAIXA)),;
                 DTOC(STOD(TMP->DIGBAIXA)),;
                 Transform(TMP->VLRBAIXA,'@E 999,999,999,999.99'),;
                 alltrim(TMP->MOTBAIXA),;
                 Transform(TMP->CORRECAO,'@E 999,999,999,999.99'),;
                 Transform(TMP->JUROS   ,'@E 999,999,999,999.99'),;
                 Transform(TMP->DESCONTO,'@E 999,999,999,999.99'),;
                 Transform(TMP->SALDO   ,'@E 999,999,999,999.99') ;
    })

	nVlrBaixa  += TMP->VLRBAIXA
	nCorrecao  += TMP->CORRECAO
	nJuros     += TMP->JUROS 
	nDesconto  += TMP->DESCONTO
	nSaldo     += TMP->SALDO

	dbSkip()
EndDo                                

// Total Geral
aAdd(aCampo,{'TOTAL',;
                 '',;
                 '',;
                 '',;
                 '',;
                 '',;
                 '',;
                 '',;
                 '',;
                 '',;
                 '',;
                 '',;
                 '',;
                 '',;
                 '',;
                 '',;
                 '',;
                 '',;
                 '',;
                 '',;
                 '',;
                 '',;
                 '',;
                 Transform(nVLRBAIXA,'@E 999,999,999,999.99'),;
                 '',;
                 Transform(nCORRECAO,'@E 999,999,999,999.99'),;
                 Transform(nJUROS   ,'@E 999,999,999,999.99'),;
                 Transform(nDESCONTO,'@E 999,999,999,999.99'),;
                 Transform(nSALDO   ,'@E 999,999,999,999.99') ;
    })


IF (LEN(aCampo) > 0) .AND. ((nApresentar = 2) .or. (nApresentar = 3))
   if !EXISTDIR("C:\Temp")   
    	nResult := MAKEDIR("C:\Temp")
   Endif                                               

   cArqExcel := "C:\Temp\"+cNomeArq+".html"    //+if(MV_PAR05==1,"html","csv")   
   If !GERAARQ(aTmp,aCampo,cArqExcel,'01')
    Return
   Endif

   //+------------------------
   //| Abrir planilha MS-Excel
   //+------------------------
	If ! ApOleClient("MsExcel") 
		MsgAlert("MsExcel nใo instalado")
		Return
	Endif
	oExcelApp := MsExcel():New()
	oExcelApp:WorkBooks:Open( cArqExcel )  
	oExcelApp:SetVisible(.T.)	  
	oExcelApp:Destroy()
ENDIF

CursorArrow()

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMontaQueryบAutor  ณValdemir Jos้       บ Data ณ  10/12/2012 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Prepara Query para Retorno de Registros                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CCAB                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function MontaQuery()
	Local cQuery, cRET := ""    


	#IFDEF TOP
		If TcSrvType() != "AS/400"
			lAsTop := .T.
			cCondicao := ".T."
			cQuery := ""

			// Obtem os registros a serem processados
			cQuery += "SELECT SE1.E1_PREFIXO AS PREFIXO, SE1.E1_NUM AS NUMTITULO, SE1.E1_TIPO AS TIPO, SE1.E1_PORTADO AS PORTADOR, SE1.E1_CLIENTE  AS CODCLI,  "+cENTER
			cQuery += "       SE1.E1_LOJA  AS LOCAL,SE1.E1_VEND2 AS VEND2,SE1.E1_XGESTOR AS GESTOR,SE1.E1_EMISSAO AS EMISSAO, 		  "+cENTER
			cQuery += "       SE1.E1_VENCTO AS VENCTO, SE1.E1_VENCREA AS VENCTOREAL, SE1.E1_VALOR AS VLRTITULO,SE1.E1_MOEDA AS MOEDA, "+cENTER
			cQuery += "       SE1.E1_HIST AS HISTORICO, SE1.E1_BAIXA AS DTBAIXA, A.E5_DTDIGIT AS DIGBAIXA, "+cENTER
			cQuery += "       A.VALOR AS VLRBAIXA, A.E5_HISTOR AS MOTBAIXA, SE1.E1_CORREC AS CORRECAO, SE1.E1_JUROS AS JUROS,SE1.E1_DESCONT AS DESCONTO,SE1.E1_SALDO AS SALDO "+cENTER
			cQuery += "       FROM "+RETSQLNAME("SE1")+" SE1 "+cENTER
			cQuery += "		LEFT OUTER JOIN (  "+cENTER
			cQuery += "		            SELECT E5_NUMERO, E5_FILIAL, E5_PREFIXO, E5_PARCELA, E5_DTDIGIT, E5_HISTOR,SUM(SE5.E5_VALOR) AS VALOR FROM "+RETSQLNAME("SE5")+" SE5 "+cENTER
			cQuery += "					WHERE SE5.D_E_L_E_T_ = ' '  "+cENTER
			cQuery += "					  AND SE5.E5_TIPODOC NOT IN ('RA','DC','D2','JR','J2','TL','MT','M2','CM','C2','TR','TE') "+cENTER
			cQuery += "					  AND SE5.E5_SITUACA NOT IN ('C','E','X') "+cENTER
			cQuery += "					  AND ((E5_TIPODOC = 'CD' AND E5_VENCTO <= E5_DATA) OR (E5_TIPODOC <> 'CD')) "+cENTER
			cQuery += "					 GROUP BY E5_NUMERO, E5_FILIAL, E5_PREFIXO, E5_PARCELA, E5_DTDIGIT, E5_HISTOR "+cENTER
			cQuery += "				         ) A "+cENTER
			cQuery += "		ON A.E5_NUMERO = SE1.E1_NUM AND A.E5_FILIAL = SE1.E1_FILIAL "+cENTER
			cQuery += "		AND A.E5_PREFIXO = SE1.E1_PREFIXO "+cENTER
			cQuery += "		AND A.E5_PARCELA = SE1.E1_PARCELA "+cENTER
			cQuery += "WHERE SE1.D_E_L_E_T_= ' ' "+cENTER 
			cQuery += "  AND SE1.E1_EMISSAO  BETWEEN '" + DTOS(MV_PAR02) + "' AND '" + DTOS(MV_PAR03) + "' "+cENTER      // DATA DE EMISSAO
			cQuery += "  AND SE1.E1_VENCTO   BETWEEN '" + DTOS(MV_PAR04) + "' AND '" + DTOS(MV_PAR05) + "' "+cENTER      // DATA DE VENCTO
			cQuery += "  AND SE1.E1_CLIENTE  BETWEEN '" + MV_PAR06       + "' AND '" + MV_PAR08       + "'  "+cENTER      // CLIENTE 
			IF !EMPTY(MV_PAR07)
				cQuery += "  AND SE1.E1_LOJA >= '" + MV_PAR07+ "' AND SE1.E1_LOJA <= '" + MV_PAR09+ "'  			 "+cENTER      // LOJA 
			ENDIF
			cQuery += "  AND SE1.E1_VEND2    BETWEEN '" + MV_PAR10       + "' AND '" + MV_PAR11       + "'  "+cENTER      // VENDEDOR 2 
			cQuery += "  AND SE1.E1_XGESTOR  BETWEEN '" + MV_PAR12       + "' AND '" + MV_PAR13       + "'  "+cENTER      // GESTOR
			cQuery += "ORDER BY E1_CLIENTE, E1_PREFIXO,SE1.E1_NUM, E1_TIPO, E1_PORTADO,  E1_LOJA, E1_VEND2, E1_XGESTOR, E1_EMISSAO, E1_VENCTO, E1_VENCREA, E1_VALOR "+cENTER

		ENDIF
	#ENDIF             
	
	cRET := cQuery

Return cRET



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ_QryExec  บAutor  ณValdemir Jose       บ Data ณ  07/06/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Executa uma Qry que ้ passada via parametro                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Generico                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function QryExec(_Qry, pAlias)

	dbUseArea(.T., "TOPCONN", TCGenQry(,,_Qry), pAlias, .F., .T.)
	
	dbSelectArea(pAlias)    
	
	dbGotop()                                            

Return                      


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ GERAARQ     บAutor  ณValdemir Jos้    บ Data ณ  30/06/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Metodo para Gerar o arquivo HTML,conforme array passado    บฑฑ
ฑฑบ          ณ como parametro                                             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ 01 - HTML                                                  บฑฑ
ฑฑบ          ณ 02 - CSV                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function GERAARQ(paCabec,paCampos,pcNOMEARQ,pcTIPO) 
	Local lContinua	:= .T.
	Local cLin      := "" 
	Local cTmp      := ""
	Local nX        := 0
	Local nY        := 0 
	Local cSTRING   := 0
	Local lRET      := .T.
	Local bAzul     := .F.
	Private nHdl    := 0
	Private cEOL    := CHR(13)+CHR(10)

	nHdl	:= fCreate(pcNOMEARQ)

	if nHdl == -1
	    MsgAlert("O arquivo de nome "+pcNOMEARQ+" nao pode ser executado! Verifique os parametros.","Atencao!")
	ElseIf lContinua
		IF pcTIPO = '01'
		    // Montando cabe็alho
		    cLin += "<table border=1 cellpadding=0 cellspaccing=0>"+cEOL 
		    if Len(paCabec) > 0
			    cLin += "<tr>"+cEOL 
				For nX := 1 To Len(paCabec)
				  cLin += "<td><font color=blue>"+paCabec[nX]
				Next                                         
				cLin += cEOL         
			Endif	
			// Montando detalhes
			FOR nX := 1 TO LEN(paCAMPOS)
	    	  cLin += "<tr>"+cEOL
	    	  bAzul := .F.
			  For nY := 1 to Len(paCampos[1])	                     
			  	 if upper(alltrim(paCAMPOS[nX][nY])) = 'TOTAL'
			  	  bAzul := .T.
			  	 endif 
				 if bAzul
				     cLin += "<td><font color=blue>"//+if(Empty(alltrim(paCAMPOS[nX][nY]))," ",alltrim(paCAMPOS[nX][nY]))
			     Else
			     	 cLin += "<td>"
			     endif  
				     //cLin += "<td>"+if(Empty(alltrim(paCAMPOS[nX][nY]))," ",alltrim(paCAMPOS[nX][nY]))
				 cLin += if(Empty(alltrim(paCAMPOS[nX][nY]))," ",alltrim(paCAMPOS[nX][nY]))
			     
		         cLin += cEOL 
	    	     fWrite(nHdl,cLin,Len(cLin))
	    	     cLin := ""
   			     if nY > 4  .and. nY < 6
			      bAzul := .F.
			     Endif            

			  Next
			   cLin += "</td>"
			NEXT   
			cLin += cTmp+"</table>"
		ELSE  
		    // Montando cabe็alho      
		    if Len(paCabec) > 0
				For nX := 1 To Len(paCabec)
				  if nX > 1          
				  	cLin += ","
				  Endif
				  cLin += paCabec[nX]
				Next                                         
				cLin += cEOL       
			Endif  
			// Montando detalhes
			FOR nX := 1 TO LEN(paCAMPOS)
			  For nY := 1 to Len(paCabec)//Len(paCAMPOS[1])	                     
			     if nY > 1
			     	cLin += ","
			     Endif
			     if ValType(paCAMPOS[nX][nY]) == "D"
			     	cLin += DTOC(paCAMPOS[nX][nY])
			     Elseif ValType(paCAMPOS[nX][nY]) == "N"   
		    	    cLin += Str(paCAMPOS[nX][nY])
			     Else
				    cLin += paCAMPOS[nX][nY]
			     Endif
	    	      fWrite(nHdl,cLin,Len(cLin))
	    	      cLin := ""
			  Next
    	      cLin += cEOL            
    	      fWrite(nHdl,cLin,Len(cLin))
    	      cLin := ""
			NEXT   
		ENDIF
	    if fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
	        if !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
	            lRET := .F.
	        endif
	    endif
	endif

	fClose(nHdl)

Return lRET



//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤt>ฟ
//ณFun็ใo que criarแ no arquvio de perguntas, respeitando o array que serแ passado como parametro.ณ
//ณExiste dois parametros, um para as perguntas e outro para o help                               ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤt>ู*/
Static Function SX1Parametro(aP,aHelp)
Local i := 0
Local cSeq
Local cMvCh
Local cMvPar
Local bRET

/******
Parametros da funcao padrao
---------------------------
PutSX1(cGrupo,;
cOrdem,;
cPergunt,cPerSpa,cPerEng,;
cVar,;
cTipo,;
nTamanho,;
nDecimal,;
nPresel,;
cGSC,;
cValid,;
cF3,;
cGrpSxg,;
cPyme,;
cVar01,;
cDef01,cDefSpa1,cDefEng1,;
cCnt01,;
cDef02,cDefSpa2,cDefEng2,;
cDef03,cDefSpa3,cDefEng3,;
cDef04,cDefSpa4,cDefEng4,;
cDef05,cDefSpa5,cDefEng5,;
aHelpPor,aHelpEng,aHelpSpa,;
cHelp)

Caracterํstica do vetor p/ utiliza็ใo da fun็ใo SX1
---------------------------------------------------
[n,1] --> texto da pergunta
[n,2] --> tipo do dado
[n,3] --> tamanho
[n,4] --> decimal
[n,5] --> objeto G=get ou C=choice
[n,6] --> validacao
[n,7] --> F3
[n,8] --> definicao 1
[n,9] --> definicao 2
[n,10] -> definicao 3
[n,11] -> definicao 4
[n,12] -> definicao 5
***/

/*  ---------------------------------------- Exemplo de Cria็ใo de Array para os Parametros ------------------------------------------
aAdd(aP,{"Ano Base           ?"      ,"C",  4,0,"G","",""      , ""   ,""   ,"" ,"", ""})
aAdd(aP,{"M๊s De             ?"      ,"C",  2,0,"G","",""      , ""   ,""   ,"" ,"", ""})
aAdd(aP,{"M๊s At้            ?"      ,"C",  2,0,"G","",""      , ""   ,""   ,"" ,"", ""})
aAdd(aP,{"Visใo              ?"      ,"N", 01,0,"C","",""      , "BIO","TEC","" ,"", ""})  //
aAdd(aP,{"C.Custo De         ?"      ,"C",  4,0,"G","","CTT"   , ""   ,""   ,"" ,"", ""})
aAdd(aP,{"C.Custo Ate        ?"      ,"C",  4,0,"G","","CTT"   , ""   ,""   ,"" ,"", ""})
aAdd(aP,{"Conta De           ?"      ,"C", 20,0,"G","","CT1"   , ""   ,""   ,"" ,"", ""})
aAdd(aP,{"Conta Ate          ?"      ,"C", 20,0,"G","","CT1"   , ""   ,""   ,"" ,"", ""})

aAdd(aHelp,{"Digite a data base do Movimento."})
aAdd(aHelp,{"Informe o m๊s inicial"})
aAdd(aHelp,{"Informe o m๊s final"})
aAdd(aHelp,{"Selecione o item contแbil, BIO OU TEC"})
aAdd(aHelp,{"Informe o C.Custo Inicial"})
aAdd(aHelp,{"Informe o C.Custo Final"})
aAdd(aHelp,{"Informe o Numero da Conta Inicial"})
aAdd(aHelp,{"Informe o Numero da Conta Final"})
//  ---------------------------------------- */


For i:=1 To Len(aP)
	cSeq   := StrZero(i,2,0)
	cMvPar := "mv_par"+cSeq
	cMvCh  := "mv_ch"+IIF(i<=9,Chr(i+48),Chr(i+87))
	
	PutSx1(cPerg,;
	cSeq,;
	aP[i,1],aP[i,1],aP[i,1],;
	cMvCh,;
	aP[i,2],;
	aP[i,3],;
	aP[i,4],;
	0,;
	aP[i,5],;
	aP[i,6],;
	aP[i,7],;
	"",;
	"",;
	cMvPar,;
	aP[i,8],aP[i,8],aP[i,8],;
	"",;
	aP[i,9],aP[i,9],aP[i,9],;
	aP[i,10],aP[i,10],aP[i,10],;
	aP[i,11],aP[i,11],aP[i,11],;
	aP[i,12],aP[i,12],aP[i,12],;
	aHelp[i],;
	{},;
	{},;
	"")
Next i

bRET := Pergunte(cPerg,.T.)

Return bRET

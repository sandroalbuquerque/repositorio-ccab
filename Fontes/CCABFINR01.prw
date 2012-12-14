#include "Protheus.ch"
#define cENTER CHR(13)+CHR(10)
#Define PAD_LEFT            0
#Define PAD_RIGHT           1
#Define PAD_CENTER          2

#define COLUNA01			20
#define COLUNA02		   110   
#define COLUNA03		   290
#define COLUNA04		   350
#define COLUNA05          440
#define COLUNA06          590
#define COLUNA07          740
#define COLUNA08          890
#define COLUNA09         1040
#define COLUNA10         1190
#define COLUNA11         1390
#define COLUNA12         1490
#define COLUNA13         1690
#define COLUNA14		  1860
#define COLUNA15		  1980
#define COLUNA16		  2130
#define COLUNA17		  2320
#define COLUNA18		  2480
#define COLUNA19		  2630
#define COLUNA20         2780



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
Local aP                := {}
Local aHelp             := {}
Local aCabec            := {}            
Local hora_inv          := Substr(Time(),1,2)+Substr(Time(),4,2)+Substr(Time(),7,2)
Local cArqExcel         := ""
Local cNomeArq          := "CCABFR01_"+DTOS(DATE())+"_"+hora_inv

Private aTmp            
Private aCampo   		:= {}
Private cPerg       	:= "CCABFR01"
Private aMotBx          := ReadMotBx()    // Carrega todas descri็๕es da baixa
                                       
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
aTmp   := {'PREFIXO','Nบ TITULO','TIPO','PORTADOR','CODCLI','LOCAL','NOME CLIENTE','PJ/PF','CNPJ/CPF','CIDADE','ESTADO','RISCO CCAB','DT.1บ COMPRA','VEND2','GESTOR','EMISSAO','VENCTO','VENCTO.REAL','VLR.TITULO','VLR.REAL','MOEDA','HISTORICO','DT.BAIXA','DIG.BAIXA','VLR.BAIXA','MOTIVO BAIXA','CORRECAO','JUROS','DESCONTO','SALDO'}
                                                                                        
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


if (nApresentar = 1) .or. (nApresentar = 3)
	dbGotop()            
	Processa( {|| CCABFINR01A() },"Aguarde","Montando relat๓rio...")
endif


if (nApresentar = 2) .or. (nApresentar=3)
	dbGotop()            
	Processa( {|| GetArrayExcel(cNomeArq) },"Aguarde","Gerando planilha...")
endif

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
Local nI, nCnt  := 0
Local cMOTBAIXA := ''
Local _nValor   := 0
Local cTitulo   := ''
Local nMostVlrTit  := 0
Local nMostVlrRea  := 0

nVlrTitulo := 0
nVlrTReal  := 0
nVlrBaixa  := 0
nCorrecao  := 0 
nJuros     := 0 
nDesconto  := 0 
nSaldo     := 0

CursorWait()
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
	
   nMostVlrTit := 0
   nMostVlrRea := 0
   if (cTitulo  <> TMP->NUMTITULO) .and. (_nValor <> TMP->VLRTITULO)
	  nMostVlrTit := TMP->VLRTITULO
	  nMostVlrRea := TMP->VLREAL
   endif
	            
	
	
	nI        :=  Ascan(aMotBx, {|x| Substr(x,1,3) == Upper(TMP->MOTBAIXA) })   //Busca a Descri็ใo do Motivo da Baixa
	cMOTBAIXA := if( nI > 0,Substr(aMotBx[nI],07,10),"" )

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
                 chr(160)+SA1->A1_XCLASSE,;
                 cPRICOM,;
                 chr(160)+TMP->VEND2,;
                 chr(160)+TMP->GESTOR,;
                 DTOC(STOD(TMP->EMISSAO)),;
                 DTOC(STOD(TMP->VENCTO)),;
                 DTOC(STOD(TMP->VENCTOREAL)),;
                 Transform(nMostVlrTit,'@E 999,999,999,999.99'),;    
                 Transform(nMostVlrRea,'@E 999,999,999,999.99'),;    
                 chr(160)+STRZERO(TMP->MOEDA,2),;
                 alltrim(TMP->HISTORICO),;
                 DTOC(STOD(TMP->DTBAIXA)),;
                 DTOC(STOD(TMP->DIGBAIXA)),;
                 Transform(TMP->VLRBAIXA,'@E 999,999,999,999.99'),;
                 cMOTBAIXA,;
                 Transform(TMP->CORRECAO,'@E 999,999,999,999.99'),;
                 Transform(TMP->JUROS   ,'@E 999,999,999,999.99'),;
                 Transform(TMP->DESCONTO,'@E 999,999,999,999.99'),;
                 Transform(TMP->SALDO   ,'@E 999,999,999,999.99') ;
    })
                          
   	// Trata em caso de se repetir o titulo
   	if (cTitulo  <> TMP->NUMTITULO) .and. (_nValor <> TMP->VLRTITULO)
    	nVlrTitulo += TMP->VLRTITULO
    	nVlrTReal  += TMP->VLREAL
    endif     
    
	nVlrBaixa  += TMP->VLRBAIXA
	nCorrecao  += TMP->CORRECAO
	nJuros     += TMP->JUROS 
	nDesconto  += TMP->DESCONTO
	nSaldo     += TMP->SALDO

   cTitulo  := TMP->NUMTITULO
   _nValor  := TMP->VLRTITULO

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
                 Transform(nVlrTitulo,'@E 999,999,999,999.99'),;
                 Transform(nVlrTReal,'@E 999,999,999,999.99'),;
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

   IncProc('Carregando planilha.... ')
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
	CursorArrow()
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
			cQuery += "       SE1.E1_VENCTO AS VENCTO, SE1.E1_VENCREA AS VENCTOREAL, SE1.E1_VALOR  AS VLRTITULO, SE1.E1_VLCRUZ AS VLREAL,SE1.E1_MOEDA AS MOEDA, "+cENTER
			cQuery += "       SE1.E1_HIST AS HISTORICO, SE1.E1_BAIXA AS DTBAIXA, A.E5_DTDIGIT AS DIGBAIXA, "+cENTER
			cQuery += "       A.VALOR AS VLRBAIXA, A.E5_MOTBX AS MOTBAIXA, A.E5_VLCORRE AS CORRECAO, A.E5_VLJUROS AS JUROS, A.E5_VLDESCO AS DESCONTO,SE1.E1_SALDO AS SALDO "+cENTER
			cQuery += "       FROM "+RETSQLNAME("SE1")+" SE1 "+cENTER
			cQuery += "		LEFT OUTER JOIN (  "+cENTER
			cQuery += "		            SELECT E5_NUMERO, E5_FILIAL, E5_PREFIXO, E5_PARCELA, E5_DTDIGIT, E5_MOTBX, E5_VLCORRE, E5_VLJUROS, E5_VLDESCO, SUM(SE5.E5_VALOR) AS VALOR FROM "+RETSQLNAME("SE5")+" SE5 "+cENTER
			cQuery += "					WHERE SE5.D_E_L_E_T_ = ' '  "+cENTER
			cQuery += "					  AND SE5.E5_TIPODOC NOT IN ('RA','DC','D2','JR','J2','TL','MT','M2','CM','C2','TR','TE') "+cENTER
			cQuery += "					  AND SE5.E5_SITUACA NOT IN ('C','E','X') "+cENTER
			cQuery += "					  AND ((E5_TIPODOC = 'CD' AND E5_VENCTO <= E5_DATA) OR (E5_TIPODOC <> 'CD')) "+cENTER
			cQuery += "					 GROUP BY E5_NUMERO, E5_FILIAL, E5_PREFIXO, E5_PARCELA, E5_DTDIGIT, E5_MOTBX, E5_VLCORRE, E5_VLJUROS, E5_VLDESCO "+cENTER
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

      

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCCABFINR01บAutor  ณValdemir Jose       บ Data ณ  12/12/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณEmissใo do Relatorio Movimento de Titulos                   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function CCABFINR01A()
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
Private nLin            := 1
Private aPosTitulo      := {COLUNA01,COLUNA02,COLUNA03,COLUNA04,COLUNA05,COLUNA06,COLUNA07,COLUNA08,COLUNA09,COLUNA10,COLUNA11,COLUNA12,COLUNA13,COLUNA14,COLUNA15,COLUNA16,COLUNA17,COLUNA18,COLUNA19,COLUNA20}
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
oFont07	:= TFont():New("Arial Narrow",07,07,,.F.,,,,.T.,.F.)
oFont07b:= TFont():New("Arial Narrow",07,07,,.T.,,,,.T.,.F.)
oFont08	:= TFont():New("Arial Narrow",08,08,,.F.,,,,.T.,.F.)
oFont08b:= TFont():New("Arial Narrow",08,08,,.T.,,,,.T.,.F.)
oFont09	:= TFont():New("Arial Narrow",09,09,,.F.,,,,.T.,.F.)
oFont09b:= TFont():New("Arial Narrow",09,09,,.T.,,,,.T.,.F.)
oFont10	:= TFont():New("Arial Narrow",10,10,,.F.,,,,.T.,.F.)
oFontTit:= TFont():New("Arial Narrow",09,09,,.T.,,,,.T.,.F.)
oFont10b:= TFont():New("Arial Narrow",10,10,,.T.,,,,.T.,.F.)
oFont11	:= TFont():New("Arial Narrow",11,11,,.T.,,,,.T.,.F.)		//Normal s/negrito
oFont13	:= TFont():New("Arial Narrow",13,13,,.F.,,,,.T.,.F.)		//Normal s/negrito
oFont13b:= TFont():New("Arial Narrow",13,13,,.T.,,,,.T.,.F.)		//Normal s/negrito
oFont15	:= TFont():New("Arial Narrow",15,15,,.T.,,,,.T.,.F.)
oFont16	:= TFont():New("Arial Narrow",16,16,,.T.,,,,.T.,.F.)
oFont18	:= TFont():New("Arial Narrow",18,18,,.T.,,,,.T.,.F.)

wnrel := SetPrint(cString,wnrel   ,cPerg,@TITULO,cDesc1,cDesc2,cDesc3,.F.,,.F.,TAMANHO,.F.,.F.)

If nLastKey == 27
	TMP->( dbCloseArea() )
	CursorArrow()
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	TMP->( dbCloseArea() )
	CursorArrow()
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Processamento. RPTSTATUS monta janela com a regua de processamento. ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo )

CursorArrow()

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRunReport   บAutor  ณValdemir Jos้     บ Data ณ  07/06/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Processando Registros                                      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function RunReport(Cabec1,Cabec2,Titulo,nPos)
Local nLin     := 1
Local nVlrBaixa  := 0
Local nCorrecao  := 0 
Local nJuros     := 0 
Local nDesconto  := 0 
Local nSaldo     := 0
Local nVlrTitulo := 0
Local nVlrReal   := 0
Local nTVlrBaixa  := 0
Local nTCorrecao  := 0 
Local nTJuros     := 0 
Local nTDesconto  := 0 
Local nTSaldo     := 0
Local cMOTBAIXA   := ""
Local nVlrTTitulo := 0
Local nVlrTReal   := 0
Local nI          := 0
Local cTitulo     := ''                
Local _nValor     := 0
Private cChave

nTVlrBaixa  := 0
nTCorrecao  := 0 
nTJuros     := 0 
nTDesconto  := 0 
nTSaldo     := 0

TMP->( dbGotop() )	
While TMP->( ! EOF() ) 

    cChave := TMP->CODCLI

	dbSelectArea('SA1')
	dbSeek(xFilial('SA1')+TMP->CODCLI+TMP->LOCAL)
	
	if (nLin > 1)
		SubCabec(oPrint, nLin, oFont08b, cChave)
  	    nLin    += 160
	endif       
	
	nVlrTitulo := 0
	nVlrReal   := 0
	nVlrBaixa  := 0
	nCorrecao  := 0 
	nJuros     := 0 
	nDesconto  := 0 
	nSaldo     := 0
	While TMP->( ! EOF() ) .AND.  (TMP->CODCLI=cChave)
		
		nI        :=  Ascan(aMotBx, {|x| Substr(x,1,3) == Upper(TMP->MOTBAIXA) })   //Busca a Descri็ใo do Motivo da Baixa
		cMOTBAIXA := if( nI > 0,Substr(aMotBx[nI],07,10),"" )

		if (nLin = 1) .or. nLin >= 2250        
		   if nLin >= 2250
		      oPrint:Line(nLin+10,010,nLin+10,aPosTitulo[20]+170)
			  oPrint:EndPage()
			  oPrint:StartPage() 			// Inicia uma nova pagina
		   Endif	           
		   nLin    := CabecCCAB(TITULO,cSubTit,cSubTit1,"", @oPrint, @lFirst, @ContFl)+20
		   nLin    += 40
		Endif  
		                      
		// Impressใo Grafica
	    oPrint:Line(nLin-10, aPosTitulo[01]-20,nLin+50,aPosTitulo[01]-20 ,oFont09)                    
	    oPrint:Line(nLin-10, aPosTitulo[02]-20,nLin+50,aPosTitulo[02]-20 ,oFont09)
	    oPrint:Line(nLin-10, aPosTitulo[03]-20,nLin+50,aPosTitulo[03]-20 ,oFont09)
	    oPrint:Line(nLin-10, aPosTitulo[04]-20,nLin+50,aPosTitulo[04]-20 ,oFont09)
	    oPrint:Line(nLin-10, aPosTitulo[05]-20,nLin+50,aPosTitulo[05]-20 ,oFont09)
	    oPrint:Line(nLin-10, aPosTitulo[06]-20,nLin+50,aPosTitulo[06]-20 ,oFont09)
	    oPrint:Line(nLin-10, aPosTitulo[07]-20,nLin+50,aPosTitulo[07]-20 ,oFont09)
	    oPrint:Line(nLin-10, aPosTitulo[08]-20,nLin+50,aPosTitulo[08]-20 ,oFont09)
	    oPrint:Line(nLin-10, aPosTitulo[09]-20,nLin+50,aPosTitulo[09]-20 ,oFont09)
	    oPrint:Line(nLin-10, aPosTitulo[10]-20,nLin+50,aPosTitulo[10]-20 ,oFont09)
	    oPrint:Line(nLin-10, aPosTitulo[11]-20,nLin+50,aPosTitulo[11]-20 ,oFont09)
	    oPrint:Line(nLin-10, aPosTitulo[12]-20,nLin+50,aPosTitulo[12]-20 ,oFont09)
	    oPrint:Line(nLin-10, aPosTitulo[13]-20,nLin+50,aPosTitulo[13]-20 ,oFont09)
	    oPrint:Line(nLin-10, aPosTitulo[14]-20,nLin+50,aPosTitulo[14]-20 ,oFont09)
	    oPrint:Line(nLin-10, aPosTitulo[15]-20,nLin+50,aPosTitulo[15]-20 ,oFont09)
	    oPrint:Line(nLin-10, aPosTitulo[16]-20,nLin+50,aPosTitulo[16]-20 ,oFont09)
	    oPrint:Line(nLin-10, aPosTitulo[17]-20,nLin+50,aPosTitulo[17]-20 ,oFont09)
	    oPrint:Line(nLin-10, aPosTitulo[18]-20,nLin+50,aPosTitulo[18]-20 ,oFont09)
	    oPrint:Line(nLin-10, aPosTitulo[19]-20,nLin+50,aPosTitulo[19]-20 ,oFont09)
	    oPrint:Line(nLin-10, aPosTitulo[20]-20,nLin+50,aPosTitulo[20]-20 ,oFont09)

		oPrint:Line(nLin-10,aPosTitulo[20]+170,nLin+50,aPosTitulo[20]+170,oFont09)
		  
	    // Impressใo dos Dados
		oPrint:say (nLin , aPosTitulo[01], TMP->PREFIXO							 		  ,oFont08)	
		oPrint:say (nLin , aPosTitulo[02], TMP->NUMTITULO                            		  ,oFont08)	
		oPrint:say (nLin , aPosTitulo[03], TMP->TIPO							     		  ,oFont08)	
		oPrint:say (nLin , aPosTitulo[04], TMP->PORTADOR			                 		  ,oFont08)	
		oPrint:say (nLin , aPosTitulo[05], TMP->VEND2			    				 		  ,oFont08)	
		oPrint:say (nLin , aPosTitulo[06], TMP->GESTOR								 		  ,oFont08)	
		oPrint:say (nLin , aPosTitulo[07], DTOC(STOD(TMP->EMISSAO))				 		  ,oFont08)	
		oPrint:say (nLin , aPosTitulo[08], DTOC(STOD(TMP->VENCTO))					 		  ,oFont08)	                   
		oPrint:say (nLin , aPosTitulo[09], DTOC(STOD(TMP->VENCTOREAL))			 	 		  ,oFont08)	                   
		if (cTitulo <> TMP->NUMTITULO) .and. _nValor <> TMP->VLRTITULO
			oPrint:say (nLin , aPosTitulo[10]+160, Transform(TMP->VLRTITULO,'@E 999,999,999,999.99'), oFont08,,,,1)	                   
		else
			oPrint:say (nLin , aPosTitulo[10]+160, Transform(0,'@E 999,999,999,999.99'), oFont08,,,,1)	                   
		endif
		oPrint:say (nLin , aPosTitulo[11], STRZERO(TMP->MOEDA,2)					 		  ,oFont08)	
		oPrint:say (nLin , aPosTitulo[12], Substr(alltrim(TMP->HISTORICO),1,10)	 		  ,oFont08)	
		oPrint:say (nLin , aPosTitulo[13], DTOC(STOD(TMP->DTBAIXA))				 		  ,oFont08)	
		oPrint:say (nLin , aPosTitulo[14], DTOC(STOD(TMP->DIGBAIXA))				 		  ,oFont08)	
		oPrint:say (nLin , aPosTitulo[15]+120, Transform(TMP->VLRBAIXA,'@E 999,999,999,999.99'), oFont08,,,,1)	                   
		oPrint:say (nLin , aPosTitulo[16], cMOTBAIXA			   					 		 ,oFont08)	
		oPrint:say (nLin , aPosTitulo[17]+130, Transform(TMP->CORRECAO,'@E 99,999,999.99'), oFont08,,,,1)	                   
		oPrint:say (nLin , aPosTitulo[18]+120, Transform(TMP->JUROS   ,'@E 999,999,999,999.99'), oFont08,,,,1)	                   
		oPrint:say (nLin , aPosTitulo[19]+120, Transform(TMP->DESCONTO,'@E 999,999,999,999.99'), oFont08,,,,1)	                   
		oPrint:say (nLin , aPosTitulo[20]+160, Transform(TMP->SALDO   ,'@E 999,999,999,999.99'), oFont08,,,,1)	                   
		nLin += 40
        
	    cChave := TMP->CODCLI

		// Total por grupo de clientes
		if (cTitulo <> TMP->NUMTITULO) .and. _nValor <> TMP->VLRTITULO
			nVlrTitulo += TMP->VLRTITULO
		endif
		nVlrReal   += 0
		nVlrBaixa  += TMP->VLRBAIXA
		nCorrecao  += TMP->CORRECAO
		nJuros     += TMP->JUROS 
		nDesconto  += TMP->DESCONTO
		nSaldo     += TMP->SALDO

		// Total Geral dos Titulos
		if (cTitulo <> TMP->NUMTITULO) .and. _nValor <> TMP->VLRTITULO
			nVlrTTitulo += TMP->VLRTITULO
		endif
		nVlrTReal   += 0
		nTVlrBaixa  += TMP->VLRBAIXA
		nTCorrecao  += TMP->CORRECAO
		nTJuros     += TMP->JUROS 
		nTDesconto  += TMP->DESCONTO
		nTSaldo     += TMP->SALDO                                      
		
		cTitulo := TMP->NUMTITULO
		_nValor := TMP->VLRTITULO
    
		dbSelectArea('TMP')
	    TMP->( dbSkip() )
    EndDo

	// Salta Pagina	
	if (nLin = 1) .or. nLin >= 2250        
	   if nLin >= 2250 
	      oPrint:Line(nLin+10,010,nLin+10,aPosTitulo[06]+170)
		  oPrint:EndPage()
		  oPrint:StartPage() 			// Inicia uma nova pagina
	   Endif	           
	   nLin    := CabecCCAB(TITULO,cSubTit,cSubTit1,"", @oPrint, @lFirst, @ContFl)+20
	   nLin    += 40
	Endif  
    
	oPrint:Line(nLin+10,aPosTitulo[1]-20,nLin+10,aPosTitulo[20]+170)
    nLin    += 20
    oPrint:Line(nLin-10, aPosTitulo[1]-20,nLin+50,aPosTitulo[1]-20 ,oFont09)                    
	oPrint:say (nLin , aPosTitulo[01], " TOTAL: "								  ,oFont08)	
	oPrint:say (nLin , aPosTitulo[10]+160, Transform(nVLRTITULO,'@E 999,999,999,999.99'), oFont08,,,,1)	                   
	oPrint:say (nLin , aPosTitulo[15]+120, TRANSFORM(nVlrBaixa ,"@E 999,999,999.99"),oFont08b,,,,1)	
	oPrint:say (nLin , aPosTitulo[17]+130, TRANSFORM(nCorrecao ,"@E 99,999,999.99"),oFont08b,,,,1)	
	oPrint:say (nLin , aPosTitulo[18]+120, TRANSFORM(nJuros    ,"@E 999,999,999.99"),oFont08b,,,,1)	
	oPrint:say (nLin , aPosTitulo[19]+120, TRANSFORM(nDesconto ,"@E 999,999,999.99"),oFont08b,,,,1)	
	oPrint:say (nLin , aPosTitulo[20]+160, TRANSFORM(nSaldo	,"@E 999,999,999.99"),oFont08b,,,,1)	
	oPrint:Line(nLin-10,aPosTitulo[20]+170,nLin+50,aPosTitulo[20]+170,oFont09)
	oPrint:Line(nLin+50,aPosTitulo[1]-20,nLin+50,aPosTitulo[20]+170)
	nLin += 120

ENDDO
oPrint:Line(nLin+10,aPosTitulo[1]-20,nLin+10,aPosTitulo[20]+170)
nLin    += 20
oPrint:Line(nLin-10, aPosTitulo[1]-20,nLin+50,aPosTitulo[1]-20 ,oFont09)                    
oPrint:say (nLin , aPosTitulo[01], " TOTAL: "								  ,oFont08)	
oPrint:say (nLin , aPosTitulo[10]+160, Transform(nVLRTTITULO,'@E 999,999,999,999.99'), oFont08,,,,1)	                   
oPrint:say (nLin , aPosTitulo[15]+120, TRANSFORM(nTVlrBaixa ,"@E 999,999,999.99"),oFont08b,,,,1)	
oPrint:say (nLin , aPosTitulo[17]+130, TRANSFORM(nTCorrecao ,"@E 99,999,999.99"),oFont08b,,,,1)	
oPrint:say (nLin , aPosTitulo[18]+120, TRANSFORM(nTJuros    ,"@E 999,999,999.99"),oFont08b,,,,1)	
oPrint:say (nLin , aPosTitulo[19]+120, TRANSFORM(nTDesconto ,"@E 999,999,999.99"),oFont08b,,,,1)	
oPrint:say (nLin , aPosTitulo[20]+160, TRANSFORM(nTSaldo	,"@E 999,999,999.99"),oFont08b,,,,1)	
oPrint:Line(nLin-10,aPosTitulo[20]+170,nLin+50,aPosTitulo[20]+170,oFont09)
oPrint:Line(nLin+50,aPosTitulo[1]-20,nLin+50,aPosTitulo[20]+170)
nLin += 120

SET DEVICE TO SCREEN

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Se impressao em disco, chama o gerenciador de impressao...          ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
if bInstancia
   oPrint:Preview()        // Visualiza impressao grafica antes de imprimir
Endif

If aReturn[5]==1
	dbCommitAll()
Endif

MS_FLUSH()

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFER065    บAutor  ณValdemir Jos้       บ Data ณ  09/06/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ SubCabecalho, poderแ fazer a chamada de qualquer lugar     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function SubCabec(oPrint_, nReturn, cCabFonte, cCLIENTE)
   
	oPrint_:Box(nReturn    ,aPosTitulo[1]-20,nReturn+110,aPosTitulo[20]+170)
	oPrint_:say (nReturn+15, aPosTitulo[1] ,"CLIENTE: "+cCLIENTE+" - "+SA1->A1_NOME    ,cCabFonte)
	oPrint_:say (nReturn+15, aPosTitulo[9] ,"CIDADE: "+SA1->A1_MUN    ,cCabFonte)
	oPrint_:say (nReturn+15, aPosTitulo[14],"ESTADO: "+SA1->A1_EST    ,cCabFonte)
	nReturn+=50
	oPrint_:say (nReturn+15, aPosTitulo[1] ,"PJ / PF: "+SA1->A1_PESSOA,cCabFonte)
	oPrint_:say (nReturn+15, aPosTitulo[4] ,"CNPJ/CPF: "+SA1->A1_CGC  ,cCabFonte)
	oPrint_:say (nReturn+15, aPosTitulo[9] ,"RISCO CCAB: "+SA1->A1_XCLASSE,cCabFonte)
	oPrint_:say (nReturn+15, aPosTitulo[14],"DT.1บ COMPRA: "+DTOC(SA1->A1_PRICOM)  ,cCabFonte)
	nReturn+=60
	//oPrint_:Line(nReturn,aPosTitulo[1]-20,nReturn,aPosTitulo[20]+170)
	// Sub Cabe็alho com os  titulos dos campos
    oPrint_:Line(nReturn, aPosTitulo[1]-20,nReturn+50,aPosTitulo[1]-20  ,oFont09)
	oPrint_:say (nReturn+10, aPosTitulo[1],"PRF"    ,cCabFonte)
    oPrint_:Line(nReturn, aPosTitulo[2]-20,nReturn+50  ,aPosTitulo[2]-20 ,oFont09)
	oPrint_:say (nReturn+10, aPosTitulo[2],"TITULO"         ,cCabFonte)
    oPrint_:Line(nReturn, aPosTitulo[3]-20,nReturn+50  ,aPosTitulo[3]-20 ,oFont09)
	oPrint_:say (nReturn+10, aPosTitulo[3]-10,"TP" ,cCabFonte)
    oPrint_:Line(nReturn, aPosTitulo[4]-20,nReturn+50  ,aPosTitulo[4]-20 ,oFont09)
	oPrint_:say (nReturn+10, aPosTitulo[4]-10,"PDOR"	  ,cCabFonte)							// PORTADOR
    oPrint_:Line(nReturn,aPosTitulo[5]-20,nReturn+50   ,aPosTitulo[5]-20,oFont09)
	oPrint_:say (nReturn+10,aPosTitulo[5],"VEND2"  	  ,cCabFonte)
    oPrint_:Line(nReturn,aPosTitulo[6]-20,nReturn+50   ,aPosTitulo[6]-20,oFont09)
	oPrint_:say (nReturn+10,aPosTitulo[6],"GESTOR"  	  ,cCabFonte)
    oPrint_:Line(nReturn,aPosTitulo[7]-20,nReturn+50   ,aPosTitulo[7]-20,oFont09)
	oPrint_:say (nReturn+10,aPosTitulo[7],"EMISSรO"  	  ,cCabFonte)
    oPrint_:Line(nReturn,aPosTitulo[8]-20,nReturn+50   ,aPosTitulo[8]-20,oFont09)
	oPrint_:say (nReturn+10,aPosTitulo[8],"VENCTO."  	  ,cCabFonte)
    oPrint_:Line(nReturn,aPosTitulo[9]-20,nReturn+50   ,aPosTitulo[9]-20,oFont09)
	oPrint_:say (nReturn+10,aPosTitulo[9],"V.REAL" 	  ,cCabFonte)
    oPrint_:Line(nReturn,aPosTitulo[10]-20,nReturn+50   ,aPosTitulo[10]-20,oFont09)
	oPrint_:say (nReturn+10,aPosTitulo[10],"VLR.TIT."  ,cCabFonte)
    oPrint_:Line(nReturn,aPosTitulo[11]-20,nReturn+50   ,aPosTitulo[11]-20,oFont09)
	oPrint_:say (nReturn+10,aPosTitulo[11],"MDA"  	  ,cCabFonte)
    oPrint_:Line(nReturn,aPosTitulo[12]-20,nReturn+50   ,aPosTitulo[12]-20,oFont09)
	oPrint_:say (nReturn+10,aPosTitulo[12],"HIST."  ,cCabFonte)
    oPrint_:Line(nReturn,aPosTitulo[13]-20,nReturn+50   ,aPosTitulo[13]-20,oFont09)
	oPrint_:say (nReturn+10,aPosTitulo[13],"DT.BAIXA"  	  ,cCabFonte)
    oPrint_:Line(nReturn,aPosTitulo[14]-20,nReturn+50   ,aPosTitulo[14]-20,oFont09)
	oPrint_:say (nReturn+10,aPosTitulo[14],"DG.BAI"  ,cCabFonte)
    oPrint_:Line(nReturn,aPosTitulo[15]-20,nReturn+50   ,aPosTitulo[15]-20,oFont09)
	oPrint_:say (nReturn+10,aPosTitulo[15],"VR.BAIX"  ,cCabFonte)
    oPrint_:Line(nReturn,aPosTitulo[16]-20,nReturn+50   ,aPosTitulo[16]-20,oFont09)
	oPrint_:say (nReturn+10,aPosTitulo[16],"MOT.BAI",cCabFonte)
    oPrint_:Line(nReturn,aPosTitulo[17]-20,nReturn+50   ,aPosTitulo[17]-20,oFont09)
	oPrint_:say (nReturn+10,aPosTitulo[17],"CORREว"   ,cCabFonte)
    oPrint_:Line(nReturn,aPosTitulo[18]-20,nReturn+50   ,aPosTitulo[18]-20,oFont09)
	oPrint_:say (nReturn+10,aPosTitulo[18],"JUROS"      ,cCabFonte)
    oPrint_:Line(nReturn,aPosTitulo[19]-20,nReturn+50   ,aPosTitulo[19]-20,oFont09)
	oPrint_:say (nReturn+10,aPosTitulo[19],"DESC."   ,cCabFonte)
    oPrint_:Line(nReturn,aPosTitulo[20]-20,nReturn+50   ,aPosTitulo[20]-20,oFont09)
	oPrint_:say (nReturn+10,aPosTitulo[20],"SALDO TIT." ,cCabFonte)
	
    oPrint_:Line(nReturn,aPosTitulo[20]+170,nReturn+50,aPosTitulo[20]+170,oFont09)
	
    oPrint_:Line(nReturn+50,aPosTitulo[1]-20,nReturn+50,aPosTitulo[20]+170)
	nReturn += 70        
	                         
Return                                              

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFER065    บAutor  ณValdemir Jos้       บ Data ณ  07/06/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function CabecCCAB(pTITULO,pSubTit,pSubTit1,Cabec1, oPrint_, lFirst, ContFl)
	Local nReturn := 0
	Local cCabFonte 
	
	// Cabe็alho de Titulo Padrใo do Relat๓rio
	nReturn += TITULOCABEC(pTITULO,pSubTit, pSubTit1, @oPrint_, @lFirst, @ContFl,'P')
	cCabFonte:=oFont08b   
	nReturn += 40                                 
	//
	SubCabec(oPrint_, nReturn, cCabFonte, cChave)
	nReturn += 100
	
	bInstancia := .T.                               
	
Return nReturn




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTITULOCABEC   บAutor  ณValdemir Jos้   บ Data ณ  07/06/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Cabe็alho para TMSPrinter                                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Dixtal                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function TITULOCABEC(pTITULO,pSubTit ,pSubTit1, oPrint, lFirst, ContFl, pTipo)
	Local cFont            
	Local nReturn  := 045
	Local nColPix
		
	If !lFirst
		lFirst		:= .T.
		oPrint 		:= TMSPrinter():New(pTITULO)
		if pTipo == 'P' 
			oPrint:SetLandscape()            //Define que a impressao deve ser Paisagem - SetLandscape()
		else
			oPrint:SetPortrait()            //Define que a impressao deve ser RETRATO ou SetPortrait()
		endif
	Endif
	
	oPrint:StartPage() 						// Inicia uma nova pagina
	cFont:=oFont10
	                             
    //Cabe็alho 1
	oPrint:say (nReturn ,040 ,"CCAB AGRO SA",oFont10b)
	oPrint:say (nReturn ,if(pTipo=="P",aPosTitulo[Len(aPosTitulo)],(aPosTitulo[Len(aPosTitulo)] / 2)+80),(RPTFOLHA+" "+TRANSFORM(ContFl,'999999')),cFont)
	nReturn += 40
	oPrint:say (nReturn ,040 ,"SIGA / "+FunName()+" - "+SM0->M0_NOME,cFont)
	nReturn += 30
	//-----------------------------
	nColPix := Char2Pix('W',oFont16)
	//-----------------------------
	if pTipo == 'P' 
		oPrint:Say(nReturn,((aPosTitulo[Len(aPosTitulo)]/2)-((len(alltrim(pTITULO))/2)*nColPix)),alltrim(pTITULO),oFont16)	//oFont10
	Else
		oPrint:say (nReturn ,(1000 / 2)+150,Padc(TRIM(pTITULO),80),oFont13b)    //
	endif
	// 1o. Subtitulo
	if TRIM(pSubTit) != ""                        
		nReturn += 80
		oPrint:say (nReturn ,aPosTitulo[1]-20,Padc(TRIM(pSubTit),350),oFont07b,,,,PAD_CENTER) 
	Endif
	nReturn += 30
	oPrint:say (nReturn ,040 ,(RPTHORA+" "+TIME()),cFont)
	// 2o. Subtitulo
	if TRIM(pSubTit1) != ""                        
		oPrint:say (nReturn ,aPosTitulo[1]-20,Padc(TRIM(pSubTit1),350),oFont07b,,,,PAD_CENTER) 
	Endif
	if pTipo == 'P' 
		oPrint:say (nReturn ,aPosTitulo[Len(aPosTitulo)],(RPTEMISS+" "+DTOC(MSDATE())),cFont)
	else
		oPrint:say (nReturn ,(3830 / 2)+80,(RPTEMISS+" "+DTOC(MSDATE())),cFont)
	endif
	nReturn += 60
    oPrint:Line(nReturn,aPosTitulo[1]-20,nReturn,if(pTipo=="P",aPosTitulo[Len(aPosTitulo)]+170,(3880 / 2)+320))
    //
	nReturn += 40
	ContFl += 1
	
Return( nReturn )


// VALDEMIR - TRATAR TAMANHO DA FONTE
Static Function Char2Pix(cTexto,oFont)
Return(GetTextWidht(0,cTexto,oFont)*2)

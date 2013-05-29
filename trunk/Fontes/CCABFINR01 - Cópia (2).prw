#include "Protheus.ch"
#define cENTER CHR(13)+CHR(10)
#Define PAD_LEFT            0
#Define PAD_RIGHT           1
#Define PAD_CENTER          2
#Define  FXZEROS             CHR(160)

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


// Posicao das colunas exporta��o
#define iPREFIXO            1
#define iTITULO             2
#define iTIPO 				 3
#define iPORTADOR			 4
#define iCODCLI			 5
#define iLOCAL				 6
#define iNOMECLIE			 7
#define iPJPF				 8
#define iCNPJCPF			 9
#define iCIDADE			10
#define iESTADO			11
#define iRISCOCCAB			12
#define iDT1COMPRA			13
#define iVEND2				14
#define iGESTOR			15
#define iEMISSAO			16
#define iVENCTO			17
#define iVENCTOREAL		18
#define iVLRTITULO			19
#define iVLRREAL			20
#define iMOEDA				21
#define iHISTORICO			22
#define iDTBAIXA			23
#define iPARCELA			24
#define iVLRBAIXA			25
#define iMOTIVOBAIXA		26
#define iCORRECAO			27
#define iJUROS				28
#define iDESCONTO			29
#define iSALDO				30
#define iSALDOR			31
#define iDOCUMEN			32


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CCABFINR01�Autor  �Valdemir Jose       � Data �  10/12/12   ���
�������������������������������������������������������������������������͹��
���Desc.     �Relatorio Movimentacao de Titulos                           ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � CCAB                                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
Private aMotBx          := ReadMotBx()    // Carrega todas descri��es da baixa
Private nTitReal        := 0
Private lPrimeiro       := .F.
Private oProc
Private lEnd            := .F.
Private hInicial  
                                       
//Criar o array com as perguntas e help
aAdd(aP,{"Apresentar como         ?"      ,"N", 02,0,"C", "",""		     , "Relat�rio","Excel"	  , "Ambos",""   , ""})   //01
aAdd(aP,{"Data Emiss�o Inicial    ?"      ,"D", 08,0,"G", "",""		     , ""         ,""	      , ""     ,""   , ""})   //02
aAdd(aP,{"Data Emiss�o Final      ?"      ,"D", 08,0,"G", "",""  	    	 , ""         ,""	      , ""     ,""   , ""})   //03
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
aAdd(aP,{"Titulo Inicial          ?"      ,"C", 10,0,"G", "",""    		 , ""         ,""	      , ""     ,""   , ""})   //14
aAdd(aP,{"Titulo Final            ?"      ,"C", 10,0,"G", "",""    		 , ""         ,""	      , ""     ,""   , ""})   //15
aAdd(aP,{"Prefixo Inicial         ?"      ,"C", 03,0,"G", "",""    		 , ""         ,""	      , ""     ,""   , ""})   //16
aAdd(aP,{"Prefixo Final           ?"      ,"C", 03,0,"G", "",""    		 , ""         ,""	      , ""     ,""   , ""})   //17


// Detalhamento do Help
aAdd(aHelp,{"Informe como deseja apresentar","Relat�rio","Excel","Ambos"})
aAdd(aHelp,{"Informe a data Emiss�o inicial"})
aAdd(aHelp,{"Informe a data Emiss�o final"})
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
aAdd(aHelp,{"Informe o Titulo inicial"})
aAdd(aHelp,{"Informe o Titulo final"})
aAdd(aHelp,{"Informe o Prefixo inicial"})
aAdd(aHelp,{"Informe o Prefixo final"})

// Cabecalho para exportar para excel
aTmp   := {'PREFIXO','N� TITULO','TIPO','PORTADOR','CODCLI','LOCAL','NOME CLIENTE','PJ/PF','CNPJ/CPF','CIDADE','ESTADO','RISCO CCAB','DT.1� COMPRA','VEND2','GESTOR','EMISSAO','VENCTO','VENCTO.REAL','VLR.TITULO','VLR.REAL','MOEDA','HISTORICO','DT.BAIXA','PARCELA','VLR.BAIXA R$','MOTIVO BAIXA','CORRECAO R$','JUROS R$','DESCONTO R$','SALDO','SALDO R$','DOCUMEN'}
                                                                                        
if !SX1Parametro(aP,aHelp)
 Return
Endif 
                                         
nApresentar := MV_PAR01

_Query := MontaQuery()
Memowrite("CCABFINR01.SQL",_Query)

Processa( {|| QryExec(_Query, "TMP") },"Processando","Processando os Registros...")
            
if TMP->( EOF() )
	MsgInfo('N�o existe registros a serem apresentados, para este filtro...  Por favor, verifique...')
	CursorArrow()
	TMP->( dbCloseArea() )	                                                                        
	Return
Endif

dbSelectArea("TMP")


if (nApresentar = 1) .or. (nApresentar = 3)
	dbGotop()            
	Processa( {|| CCABFINR01A() },"Aguarde","Montando relat�rio...")
endif


if (nApresentar = 2) .or. (nApresentar=3)
	dbGotop()            
	oProc := MsNewProcess():New({|lEnd| GetArrayExcel(lEnd, cNomeArq)},"Aguarde","Gerando planilha...",.T.)
	oProc:Activate()

endif

TMP->( dbCloseArea() )	      

Return




//*********************************************************************************************************************************************************************************
//
//																		E X P O R T A C A O 
//
//*********************************************************************************************************************************************************************************
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CCABFINR01�Autor  �Valdemir Jose       � Data �  11/12/12   ���
�������������������������������������������������������������������������͹��
���Desc.     �Carrega Array para gerar planilha Excel                     ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Exportacao                                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function GetArrayExcel(lEnd, cNomeArq)
Local nVlrBaixa, nCorrecao, nJuros, nDesconto, nSaldo
Local nI, nCnt  := 0
Local cMOTBAIXA := ''
Local _nValor   := 0                       
Local nSaldo    := 0
Local nSaldoR   := 0
Local cTitulo   := ''
Local cPrefixo  := '' 
Local cChave2   := ''
Local cCodCli   := ''
Local cParcela     := ''
Local nMostVlrTit  := 0
Local nMostVlrRea  := 0         
Local nMostSaldo   := 0                                                             
Local nSaldoAtu    := 0
Local lCheque      := .F.       // Variavel para casos de baixa de cheques
Local cMsg         := "Iniciado as "+substr(time(),1,5)+" - "
Local cMsgFim      := "Iniciado as "+substr(time(),1,5)
Local nHoraFim     := 0   
Local nHoraIni     := time() //VAL(STRTRAN(substr(time(),1,5),':','.'))

Private	_nVlrTitulo := 0   
Private	_nVlrTReal  := 0   
Private	_nVLRBAIXA  := 0   
Private	_nCORRECAO  := 0   
Private	_nJUROS     := 0   
Private	_nDESCONTO  := 0   
Private	_nSALDO     := 0   
Private	_nSALDORS   := 0   
Private nSldAtuR    := 0

nVlrTitulo := 0
nVlrTReal  := 0
nVlrBaixa  := 0
nCorrecao  := 0 
nJuros     := 0 
nDesconto  := 0 
nSaldo     := 0
nSaldoR    := 0   
nSaldoRS   := 0            
nTaxa      := 0

CursorWait()

// Verifica Quantos registros tem
dbEval( {|x| nCnt++ },,{|| TMP->( !EOF() )})    

oProc:SetRegua1(nCnt)

// LIMPANDO VARIAVEIS TOTALIZADORES
_nVlrTitulo := 0
_nVlrTReal  := 0
_nVLRBAIXA  := 0
_nCORRECAO  := 0
_nJUROS     := 0
_nDESCONTO  := 0
_nSALDO     := 0
_nSALDORS   := 0

dbGotop()
While !Eof()                           

	oProc:IncRegua1(cMsg+"Criando planilha. Titulo: " + TMP->NUMTITULO)
	
	if lEnd
	 Exit
	endif
	
	dbSelectArea('SA1')
	IF dbSeek(xFilial('SA1')+TMP->CODCLI+TMP->LOCAL)
	      cCNPJ_CPF := SA1->A1_CGC
	      cJF       := SA1->A1_PESSOA
	      cPRICOM   := dtoc(SA1->A1_PRICOM)
	      cMun      := SA1->A1_MUN
	      cUF       := SA1->A1_EST
	      cNome     := SA1->A1_NOME                 
	      dbSeek(xFilial('SA1')+TMP->CODCLI+'01')         // Acrescentado 17/12/2012 - 11:50h, para buscar o risco sempre da loja 01
	ELSE
	      cCNPJ_CPF := 'NOT FOUND'
	      cJF       := 'NOT FOUND'
	      cPRICOM   := ''
	ENDIF
	             
    cTitulo  := TMP->NUMTITULO
    _nValor  := TMP->VLRTITULO                                                             
    cPrefixo := TMP->PREFIXO                 
    cParcela := TMP->PARCELA
    cCodCli  := TMP->CODCLI
    cChave2  := TMP->NUMTITULO+TMP->PREFIXO+Transform(TMP->VLREAL,"@E 999,999,999.99")
    cChave   := TMP->NUMTITULO+TMP->PREFIXO+TMP->TIPO+TMP->PARCELA+TMP->CODCLI
    nMostVlrTit := TMP->VLRTITULO
    nMostVlrRea := TMP->VLREAL
    nMostSaldo  := TMP->SALDO
    nTitReal    := TMP->VLREAL
    nSaldoAtu   := TMP->SALDO 
    
    lPrimeiro   := .F.                              // Garante o primeiro registro do SE1
	
	dbSelectArea('TMP')              
	
	While !Eof() .and. (cChave = TMP->NUMTITULO+TMP->PREFIXO+TMP->TIPO+TMP->PARCELA+TMP->CODCLI)
                                        
	  if lEnd
		 Exit
	  endif
	                           

      IF nMostSaldo > 0                      
		  if (TMP->MOEDA <> 1) 
		      if (TMP->VLRTITULO > 0)
			  	nTaxa       := (TMP->VLREAL / TMP->VLRTITULO)
			  endif
			  
		  	  nSaldoR     :=  if(nTaxa > 0, (TMP->SALDO * nTaxa), TMP->SALDO)
		  else
	     	  nSaldoR     :=  TMP->SALDO
		  endif            
		  nSldAtuR    := nSaldoR
	  ENDIF
	    
	  nMostVlrTit := TMP->VLRTITULO
	  nMostVlrRea := TMP->VLREAL

	  nI        :=  Ascan(aMotBx, {|x| Substr(x,1,3) == Upper(TMP->MOTBAIXA) })   //Busca a Descri��o do Motivo da Baixa
	  cMOTBAIXA := if( nI > 0,Substr(aMotBx[nI],07,10),"" )

	  // Encontra Registros repetidos
	  nPos      := aScan(aCampo,{|X| alltrim(X[iPREFIXO])+ALLTRIM(X[iTITULO])+X[iPARCELA]+X[iTIPO]+alltrim(X[iVLRBAIXA])=FXZEROS+alltrim(TMP->PREFIXO)+FXZEROS+alltrim(TMP->NUMTITULO)+TMP->PARCELA+TMP->TIPO+ALLTRIM(Transform(TMP->VLRBAIXA,'@E 999,999,999,999.99'))} )
	  
	  if  (ALLTRIM(TMP->TIPO) <> 'CH-') //.OR. (nPos=0)          
	   IF (nPos=0)
	  	  // Adiciona uma Linha
	  	  aAdd(aCampo, Array( Len(aTmp)) )
	  	  
	  	  // Alimenta os campos
	  	  aCampo[Len(aCampo)][iPREFIXO]    := FXZEROS+TMP->PREFIXO
	  	  aCampo[Len(aCampo)][iTITULO]     := FXZEROS+TMP->NUMTITULO
		  aCampo[Len(aCampo)][iTIPO]       := FXZEROS+TMP->TIPO
		  aCampo[Len(aCampo)][iPORTADOR]   := FXZEROS+TMP->PORTADOR
		  aCampo[Len(aCampo)][iCODCLI]	   := FXZEROS+TMP->CODCLI             
		  aCampo[Len(aCampo)][iLOCAL]	   := FXZEROS+TMP->LOCAL
		  aCampo[Len(aCampo)][iNOMECLIE]   := cNome
		  aCampo[Len(aCampo)][iPJPF]       := cJF
		  aCampo[Len(aCampo)][iCNPJCPF]    := FXZEROS+cCNPJ_CPF
		  aCampo[Len(aCampo)][iCIDADE]     := cMun
		  aCampo[Len(aCampo)][iESTADO]     := cUF
		  aCampo[Len(aCampo)][iRISCOCCAB]  := FXZEROS+SA1->A1_XCLASSE
		  aCampo[Len(aCampo)][iDT1COMPRA]  := cPRICOM
		  aCampo[Len(aCampo)][iVEND2]      := FXZEROS+TMP->VEND2
		  aCampo[Len(aCampo)][iGESTOR]     := FXZEROS+TMP->GESTOR
		  aCampo[Len(aCampo)][iEMISSAO]    := DTOC(STOD(TMP->EMISSAO))
		  aCampo[Len(aCampo)][iVENCTO]     := DTOC(STOD(TMP->VENCTO))
		  aCampo[Len(aCampo)][iVENCTOREAL] := DTOC(STOD(TMP->VENCTOREAL))
		  aCampo[Len(aCampo)][iVLRTITULO]  := Transform(nMostVlrTit,'@E 999,999,999,999.99')
		  aCampo[Len(aCampo)][iVLRREAL]    := Transform(nMostVlrRea,'@E 999,999,999,999.99')
		  aCampo[Len(aCampo)][iMOEDA]      := FXZEROS+STRZERO(TMP->MOEDA,2)
		  aCampo[Len(aCampo)][iHISTORICO]  := alltrim(TMP->HISTORICO)
		  aCampo[Len(aCampo)][iDTBAIXA]    := DTOC(STOD(TMP->DIGBAIXA))
		  aCampo[Len(aCampo)][iPARCELA]    := TMP->PARCELA
		  aCampo[Len(aCampo)][iVLRBAIXA]   := Transform(0,'@E 999,999,999,999.99')
		  aCampo[Len(aCampo)][iMOTIVOBAIXA]:= cMOTBAIXA
		  aCampo[Len(aCampo)][iCORRECAO]   := Transform(0,'@E 999,999,999,999.99')
		  aCampo[Len(aCampo)][iJUROS]      := Transform(0,'@E 999,999,999,999.99')
		  aCampo[Len(aCampo)][iDESCONTO]   := Transform(0,'@E 999,999,999,999.99')
		  aCampo[Len(aCampo)][iSALDO]      := Transform(TMP->SALDO,'@E 999,999,999,999.99')
		  aCampo[Len(aCampo)][iSALDOR]     := Transform(nSaldoR,'@E 999,999,999,999.99')
		  aCampo[Len(aCampo)][iDOCUMEN]    := ''
		  //
		    // Totalizador
			_nVlrTitulo += VAL(STRTRAN(STRTRAN(aCampo[Len(aCampo)][iVLRTITULO],'.',''),',','.')) 
			_nVlrTReal  += VAL(STRTRAN(STRTRAN(aCampo[Len(aCampo)][iVLRREAL],'.',''),',','.')) 
			_nVLRBAIXA  += VAL(STRTRAN(STRTRAN(aCampo[Len(aCampo)][iVLRBAIXA],'.',''),',','.'))
			_nCORRECAO  += VAL(STRTRAN(STRTRAN(aCampo[Len(aCampo)][iCORRECAO],'.',''),',','.'))
			_nJUROS     += VAL(STRTRAN(STRTRAN(aCampo[Len(aCampo)][iJUROS],'.',''),',','.'))
			_nDESCONTO  += VAL(STRTRAN(STRTRAN(aCampo[Len(aCampo)][iDESCONTO],'.',''),',','.')) 
			_nSALDO     += VAL(STRTRAN(STRTRAN(aCampo[Len(aCampo)][iSALDO],'.',''),',','.'))  
			_nSALDORS   += VAL(STRTRAN(STRTRAN(aCampo[Len(aCampo)][iSALDOR],'.',''),',','.')) 
	   ENDIF	                                          
	  Endif                                                  
	  
	  lCheque   := (ALLTRIM(TMP->TIPO) = 'CH-')
	  
	  CarregaSE5(TMP->PREFIXO, TMP->NUMTITULO, TMP->PARCELA, TMP->TIPO, aCAMPO, 'TMP', lEnd, nMostSaldo, lCheque, nHoraIni)
                                                                                                                                     
	  if lEnd
		 Exit
	  endif

      nMostVlrTit := 0  
      nMostVlrRea := 0
	  nMostSaldo  := 0
	  nSaldoR     := 0

	  dbSkip()

	EndDo

	if lEnd
	   Exit
	endif	
	
	dbSelectArea('TMP')              
    
	nSaldoAtu  := 0

EndDo   

if lEnd
	CursorArrow()
	Return
Endif
                       
/*                                    
// TOTALIZANDO PLANILHA
FOR nI := 1 TO LEN(acampo)

	_nVlrTitulo += VAL(STRTRAN(STRTRAN(aCampo[nI][iVLRTITULO],'.',''),',','.')) 
	_nVlrTReal  += VAL(STRTRAN(STRTRAN(aCampo[nI][iVLRREAL],'.',''),',','.')) 
	_nVLRBAIXA  += VAL(STRTRAN(STRTRAN(aCampo[nI][iVLRBAIXA],'.',''),',','.'))
	_nCORRECAO  += VAL(STRTRAN(STRTRAN(aCampo[nI][iCORRECAO],'.',''),',','.'))
	_nJUROS     += VAL(STRTRAN(STRTRAN(aCampo[nI][iJUROS],'.',''),',','.'))
	_nDESCONTO  += VAL(STRTRAN(STRTRAN(aCampo[nI][iDESCONTO],'.',''),',','.')) 
	_nSALDO     += VAL(STRTRAN(STRTRAN(aCampo[nI][iSALDO],'.',''),',','.'))  
	_nSALDORS   += VAL(STRTRAN(STRTRAN(aCampo[nI][iSALDOR],'.',''),',','.')) 

NEXT                             
*/

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
                 Transform(_nVlrTitulo,'@E 999,999,999,999.99'),;
                 Transform(_nVlrTReal,'@E 999,999,999,999.99'),;
                 '',;
                 '',;
                 '',;
                 '',;
                 Transform(_nVLRBAIXA,'@E 999,999,999,999.99'),;
                 '',;
                 Transform(_nCORRECAO,'@E 999,999,999,999.99'),;
                 Transform(_nJUROS   ,'@E 999,999,999,999.99'),;
                 Transform(_nDESCONTO,'@E 999,999,999,999.99'),;
                 Transform(_nSALDO   ,'@E 999,999,999,999.99'),;
                 Transform(_nSALDORS ,'@E 999,999,999,999.99'), ;
                 '';
    })


IF (LEN(aCampo) > 0) .AND. ((nApresentar = 2) .or. (nApresentar = 3))
   if !EXISTDIR("C:\Temp")   
    	nResult := MAKEDIR("C:\Temp")
   Endif                                               

   oProc:IncRegua1('Carregando planilha.... ')
   oProc:SetRegua2(Len(aCampo))

   cArqExcel := "C:\Temp\"+cNomeArq+".html"    //+if(MV_PAR05==1,"html","csv")   
   If !GERAARQ(aTmp,aCampo,cArqExcel,'01')
    Return
   Endif

   //+------------------------
   //| Abrir planilha MS-Excel
   //+------------------------
	If ! ApOleClient("MsExcel") 
		MsgAlert("MsExcel n�o instalado")
		Return
	Endif
	CursorArrow()
	oExcelApp := MsExcel():New()
	oExcelApp:WorkBooks:Open( cArqExcel )  
	oExcelApp:SetVisible(.T.)	  
	oExcelApp:Destroy()
	                              
	nHoraFim := time()
	            
	nGasto  := ElapTime(nHoraIni, nHoraFim)
	cMsgFim += cENTER+"Finalizado as "+substr(time(),1,5)+cENTER+"Tempo Gasto: "+Alltrim(nGasto)
ENDIF

CursorArrow()

IF (LEN(aCampo) > 0)
 Alert(cMsgFim)
Endif

Return



/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MontaQuery�Autor  �Valdemir Jos�       � Data �  10/12/2012 ���
�������������������������������������������������������������������������͹��
���Desc.     � Prepara Query para Retorno de Registros                    ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � CCAB                                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
			cQuery += "       SE1.R_E_C_N_O_ AS REG, SE1.E1_LOJA  AS LOCAL, E1_TXMOEDA AS TXMOEDA,SE1.E1_VEND2 AS VEND2,SE1.E1_XGESTOR AS GESTOR,SE1.E1_EMISSAO AS EMISSAO, "+cENTER
			cQuery += "       SE1.E1_VENCTO AS VENCTO, SE1.E1_VENCREA AS VENCTOREAL, SE1.E1_VALOR  AS VLRTITULO, SE1.E1_VLCRUZ AS VLREAL,SE1.E1_MOEDA AS MOEDA, "+cENTER
			cQuery += "       SE1.E1_HIST AS HISTORICO, SE1.E1_BAIXA AS DTBAIXA, '' AS DIGBAIXA, SE1.E1_PARCELA AS PARCELA, "+cENTER
			cQuery += "       0 AS VLRBAIXA, '' AS MOTBAIXA, 0 AS CORRECAO, 0 AS JUROS, 0 AS DESCONTO, SE1.E1_SALDO AS SALDO "+cENTER
			cQuery += "       FROM "+RETSQLNAME("SE1")+" SE1 "+cENTER
			cQuery += "WHERE SE1.D_E_L_E_T_= ' ' "+cENTER 
			cQuery += "  AND SE1.E1_EMISSAO  BETWEEN '" + DTOS(MV_PAR02) + "' AND '" + DTOS(MV_PAR03) + "' "+cENTER      // DATA DE EMISSAO
			cQuery += "  AND SE1.E1_VENCTO   BETWEEN '" + DTOS(MV_PAR04) + "' AND '" + DTOS(MV_PAR05) + "' "+cENTER      // DATA DE VENCTO
			cQuery += "  AND SE1.E1_CLIENTE  BETWEEN '" + MV_PAR06       + "' AND '" + MV_PAR08       + "'  "+cENTER      // CLIENTE 
			IF !EMPTY(MV_PAR07)
				cQuery += "  AND SE1.E1_LOJA >= '" + MV_PAR07+ "' AND SE1.E1_LOJA <= '" + MV_PAR09+ "'  			 "+cENTER      // LOJA 
			ENDIF
			cQuery += "  AND SE1.E1_VEND2    BETWEEN '" + MV_PAR10       + "' AND '" + MV_PAR11       + "'  "+cENTER      // VENDEDOR 2 
			cQuery += "  AND SE1.E1_XGESTOR  BETWEEN '" + MV_PAR12       + "' AND '" + MV_PAR13       + "'  "+cENTER      // GESTOR
			cQuery += "  AND SE1.E1_NUM BETWEEN '"+MV_PAR14+"' AND '"+MV_PAR15+"'     "+cENTER      // GESTOR  AND SE1.E1_PREFIXO='09' 
			cQuery += "  AND SE1.E1_PREFIXO BETWEEN '"+MV_PAR16+"' AND '"+MV_PAR17+"' "+cENTER      // 
			cQuery += "ORDER BY E1_PREFIXO,SE1.E1_NUM, E1_TIPO, E1_CLIENTE, E1_PORTADO,  E1_LOJA, E1_VEND2, E1_XGESTOR, E1_EMISSAO, E1_VENCTO, E1_VENCREA, E1_VALOR "+cENTER

		ENDIF
	#ENDIF             
	
	cRET := cQuery

Return cRET







/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CCABFINR01�Autor  �Valdemir Jos�       � Data �  19/12/12   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function AtualizaTitulo(pNUMTITULO , pPREFIXO, nTMPBAIXA, pnSaldo)
Local _nSaldo  := pnSaldo
Local lRET     := .F.

	  // Adiciona registro se atender a condi��o a baixo.
	  if ((nTMPBaixa < nTitReal) .and. (_nSaldo = 0)) .OR. ((nTMPBaixa > nTitReal) .and. (_nSaldo = 0)) .OR. (((nTMPBaixa) < nTitReal) .and. (_nSaldo > 0))
	    aAdd(aCampo,{ aCampo[Len(aCampo)][iPREFIXO],;      // Prefixo
	                 aCampo[Len(aCampo)][iTITULO],;         // NumTitulo
	                 aCampo[Len(aCampo)][iTIPO],; 	         // Tipo
	                 aCampo[Len(aCampo)][iPORTADOR],;       // Portador
	                 aCampo[Len(aCampo)][iCODCLI],;         // CODCLI
	                 aCampo[Len(aCampo)][iLOCAL],;          // LOCAL
	                 aCampo[Len(aCampo)][iNOMECLIE],;       // NOME
	                 aCampo[Len(aCampo)][iPJPF],;           // JF (JURIDICA / FISICA)
	                 aCampo[Len(aCampo)][iCNPJCPF],;        // CNPJ / CPF
	                 aCampo[Len(aCampo)][iCIDADE],;         // MUNICIPIO
	                 aCampo[Len(aCampo)][iESTADO],;         // ESTADO
	                 aCampo[Len(aCampo)][iRISCOCCAB],;      // RISCO
	                 aCampo[Len(aCampo)][iDT1COMPRA],;      // DT. 1a. COMPRA
	                 aCampo[Len(aCampo)][iVEND2],;        // VENDEDOR
	                 aCampo[Len(aCampo)][iGESTOR],;       // GESTOR
	                 aCampo[Len(aCampo)][iEMISSAO],;      // EMISSAO
	                 aCampo[Len(aCampo)][iVENCTO],;       // VENCTO
	                 aCampo[Len(aCampo)][iVENCTOREAL],;         // VENCTO.REAL
	                 Transform(0,'@E 999,999,999,999.99'),;      // VLR.TITULO      - aCampo[Len(aCampo)][19]
	                 Transform(0,'@E 999,999,999,999.99'),;      // VLR.REAL        //aCampo[Len(aCampo)][20]
	                 aCampo[Len(aCampo)][iMOEDA],; 	   // MOEDA                                   
	                 '',;					               // HISTORICO
	                 aCampo[Len(aCampo)][iDTBAIXA],;      // DT.BAIXA
	                 '',;							       // PARCELA
	                 Transform(nTitReal-nTMPBaixa,'@E 999,999,999,999.99'),;   // VALOR DA BAIXA
	                 'LANCTO.MANUAL',;					     					// MOTIVO BAIXA
	                 Transform(0,'@E 999,999,999,999.99'),;           		    // CORRECAO
	                 Transform(0,'@E 999,999,999,999.99'),;              // JUROS
	                 Transform(0,'@E 999,999,999,999.99'),;           // DESCONTO
	                 Transform(0,'@E 999,999,999,999.99'),;     // SALDO
	                 Transform(0,'@E 999,999,999,999.99'),;     // SALDO REAL
	                 '';
	    })                   

	    // Totalizador
		_nVlrTitulo += VAL(STRTRAN(STRTRAN(aCampo[Len(aCampo)][iVLRTITULO],'.',''),',','.')) 
		_nVlrTReal  += VAL(STRTRAN(STRTRAN(aCampo[Len(aCampo)][iVLRREAL],'.',''),',','.')) 
		_nVLRBAIXA  += VAL(STRTRAN(STRTRAN(aCampo[Len(aCampo)][iVLRBAIXA],'.',''),',','.'))
		_nCORRECAO  += VAL(STRTRAN(STRTRAN(aCampo[Len(aCampo)][iCORRECAO],'.',''),',','.'))
		_nJUROS     += VAL(STRTRAN(STRTRAN(aCampo[Len(aCampo)][iJUROS],'.',''),',','.'))
		_nDESCONTO  += VAL(STRTRAN(STRTRAN(aCampo[Len(aCampo)][iDESCONTO],'.',''),',','.')) 
		_nSALDO     += VAL(STRTRAN(STRTRAN(aCampo[Len(aCampo)][iSALDO],'.',''),',','.'))  
		_nSALDORS   += VAL(STRTRAN(STRTRAN(aCampo[Len(aCampo)][iSALDOR],'.',''),',','.')) 
	    
	    lRET     := .T.
	  endif

Return lRET



      



/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CCABFINR01�Autor  �Valdemir Jose       � Data �  27/12/12   ���
�������������������������������������������������������������������������͹��
���Desc.     �Carrega SE5, referente ao titulo - Baixas e Cancelamentos   ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function CarregaSE5(pPREFIXO, pNUMTITULO, pPARCELA,pTIPO, aCAMPO, pTMP, lEnd, nSaldoAtu, plCheque, nHrIni)
Local aArea 	:= GetArea()
Local cCNPJ_CPF := SA1->A1_CGC
Local cJF       := SA1->A1_PESSOA
Local cPRICOM   := dtoc(SA1->A1_PRICOM)
Local cMun      := SA1->A1_MUN
Local cUF       := SA1->A1_EST
Local cNome     := SA1->A1_NOME                 
Local nMostVlrTit := TMP->VLRTITULO
Local nMostVlrRea := TMP->VLREAL
Local nMostSaldo  := TMP->SALDO
LOCAL cMOTBAIXA   := ''
Local nPos        := 0  
Local cQuery      := ''
Local nCnt        := 0
Local nPerc       := 0
Local nTotBaixa   := 0
Local lCheque     := plCheque            
Local cCampoSql   := ''
                                                                                                             
hInicial := nHrIni
    // Campos utilizado na Tabela SE5
	cCampoSql   += "E5_PREFIXO, E5_NUMERO, E5_PARCELA, E5_TIPO, E5_VALOR, E5_VLCORRE, E5_MOTBX,  "+cENTER
	cCampoSql   += "E5_VLJUROS, E5_VLDESCO, E5_HISTOR, E5_DTDIGIT, E5_DOCUMEN, E5_SEQ,E5_TIPODOC "+cENTER
      
	// Obtem os registros a serem processados
	cQuery += "SELECT "+cCampoSql+" FROM  "+RETSQLNAME('SE51')+' SE5 '+cENTER
	cQuery += "WHERE SE5.D_E_L_E_T_ = ' ' "+cENTER
	cQuery += " AND SE5.E5_PREFIXO='"+pPREFIXO+"' AND SE5.E5_NUMERO = '"+pNUMTITULO+"'  "+cENTER //
	cQuery += " AND SE5.E5_CLIFOR = '"+(pTMP)->CODCLI+"' "+cENTER
	cQuery += " AND SE5.E5_TIPODOC <> 'RA' AND  SE5.E5_TIPODOC <> 'CM' AND  SE5.E5_TIPODOC <> 'JR'"+cENTER
	cQuery += " AND SE5.E5_RECPAG = 'R' "+cENTER
	cQuery += " AND SE5.E5_TIPO = '"+pTIPO+"' "+cENTER
	cQuery += " AND SE5.E5_PARCELA = '"+pPARCELA+"' "+cENTER
	cQuery += "ORDER BY E5_NUMERO, E5_SEQ, E5_PARCELA, E5_DOCUMEN"+cENTER
	
	Memowrite("CCABFINR01-4.SQL",cQuery)
	
	QryExec(cQuery, "TMPE5")
	
    dbSelectArea('TMPE5')
    dbEval( {|x| nCnt++ },,{|| TMPE5->( !EOF() )})    
    oProc:SetRegua2(nCnt)

    dbGotop()   
    
    lPrimeiro := plCheque
                 
	While (!Eof()) 
	   
       nPerc    := ELAPTIME(nHrIni, TIME())

	   oProc:IncRegua2("Tempo percorrido: "+Alltrim(nPerc)+"  Baixas Titulo: " + pNUMTITULO)      
	   
	   if lEnd
	    Exit
	   endif

		nI        :=  Ascan(aMotBx, {|x| Substr(x,1,3) == Upper(TMPE5->E5_MOTBX) })   //Busca a Descri��o do Motivo da Baixa
		cMOTBAIXA := if( nI > 0,Substr(aMotBx[nI],07,10),"" )
	  
	    // Encontra Registros repetidos
	    if !lPrimeiro
		   nPos      := aScan(aCampo,{|X| alltrim(X[iPREFIXO])+ALLTRIM(X[iTITULO])+X[iPARCELA]+X[iTIPO] = FXZEROS+alltrim(TMPE5->E5_PREFIXO)+FXZEROS+alltrim(TMPE5->E5_NUMERO)+TMPE5->E5_PARCELA+TMPE5->E5_TIPO} )
	       lPrimeiro := (nPos > 0)
	    Endif
                                                      
   	   nValor := TMPE5->E5_VALOR                                                                      
  	   nCorre := TMPE5->E5_VLCORRE*(-1)
  	   nJuros := TMPE5->E5_VLJUROS
  	   nDesc  := TMPE5->E5_VLDESCO
  	   cHisto := cMOTBAIXA	   

		IF (TMPE5->E5_TIPODOC = 'ES')      
		   nValor := TMPE5->E5_VALOR*(-1)
	  	   nCorre := TMPE5->E5_VLCORRE    
	  	   nJuros := TMPE5->E5_VLJUROS*(-1)
	  	   nDesc  := TMPE5->E5_VLDESCO*(-1)
	  	   cHisto := TMPE5->E5_HISTOR	   
		ENDIF
                                          
	  	// Adiciona uma Linha
        if (nPos = 0)

	  	  aAdd(aCampo, Array( Len(aTmp)) )
	  	  
	  	  // Alimenta os campos
	  	  aCampo[Len(aCampo)][iPREFIXO]    := FXZEROS+pPREFIXO
	  	  aCampo[Len(aCampo)][iTITULO]     := FXZEROS+pNUMTITULO
		  aCampo[Len(aCampo)][iTIPO]       := FXZEROS+(pTMP)->TIPO
		  aCampo[Len(aCampo)][iPORTADOR]   := FXZEROS+(pTMP)->PORTADOR
		  aCampo[Len(aCampo)][iCODCLI]	   := FXZEROS+(pTMP)->CODCLI             
		  aCampo[Len(aCampo)][iLOCAL]	   := FXZEROS+(pTMP)->LOCAL
		  aCampo[Len(aCampo)][iNOMECLIE]   := cNome
		  aCampo[Len(aCampo)][iPJPF]       := cJF
		  aCampo[Len(aCampo)][iCNPJCPF]    := FXZEROS+cCNPJ_CPF
		  aCampo[Len(aCampo)][iCIDADE]     := cMun
		  aCampo[Len(aCampo)][iESTADO]     := cUF
		  aCampo[Len(aCampo)][iRISCOCCAB]  := FXZEROS+SA1->A1_XCLASSE
		  aCampo[Len(aCampo)][iDT1COMPRA]  := cPRICOM
		  aCampo[Len(aCampo)][iVEND2]      := FXZEROS+(pTMP)->VEND2
		  aCampo[Len(aCampo)][iGESTOR]     := FXZEROS+(pTMP)->GESTOR
		  aCampo[Len(aCampo)][iEMISSAO]    := DTOC(STOD((pTMP)->EMISSAO))
		  aCampo[Len(aCampo)][iVENCTO]     := DTOC(STOD((pTMP)->VENCTO))
		  aCampo[Len(aCampo)][iVENCTOREAL] := DTOC(STOD((pTMP)->VENCTOREAL))     
		  IF !lCheque
		  	aCampo[Len(aCampo)][iVLRTITULO]  := Transform(0,'@E 999,999,999,999.99')
		  	aCampo[Len(aCampo)][iVLRREAL]    := Transform(0,'@E 999,999,999,999.99')
		  	aCampo[Len(aCampo)][iVLRBAIXA]   := Transform(nValor,'@E 999,999,999,999.99')
			nTotBaixa   += (nValor + nCorre +  nDesc + nSldAtuR )      // TMPE5->E5_VLJUROS +  Removido por solicita��o do Reinaldo 10/01/13 as 15:10hs
			                                                            // Saldo adicionado por Valdemir 16/01/13 as 11:57, por solicita��o do Reinaldo
		  ELSE
		  	aCampo[Len(aCampo)][iVLRTITULO]  := Transform(nMostVlrTit,'@E 999,999,999,999.99')
		  	aCampo[Len(aCampo)][iVLRREAL]    := Transform(nMostVlrRea,'@E 999,999,999,999.99')
  		    aCampo[Len(aCampo)][iVLRBAIXA]   := Transform(0,'@E 999,999,999,999.99')   //nValor
  		    lCheque := .F.
		  ENDIF
		  aCampo[Len(aCampo)][iMOEDA]      := FXZEROS+STRZERO((pTMP)->MOEDA,2)
		  aCampo[Len(aCampo)][iHISTORICO]  := alltrim((pTMP)->HISTORICO)
		  aCampo[Len(aCampo)][iDTBAIXA]    := DTOC(STOD(TMPE5->E5_DTDIGIT))
		  aCampo[Len(aCampo)][iPARCELA]    := TMPE5->E5_PARCELA
//		  aCampo[Len(aCampo)][iVLRBAIXA]   := Transform(nValor,'@E 999,999,999,999.99')
		  aCampo[Len(aCampo)][iMOTIVOBAIXA]:= cMOTBAIXA
		  aCampo[Len(aCampo)][iCORRECAO]   := Transform(nCorre,'@E 999,999,999,999.99')
		  aCampo[Len(aCampo)][iJUROS]      := Transform(nJuros,'@E 999,999,999,999.99')
		  aCampo[Len(aCampo)][iDESCONTO]   := Transform(nDesc,'@E 999,999,999,999.99')
		  aCampo[Len(aCampo)][iSALDO]      := Transform(0,'@E 999,999,999,999.99')
		  aCampo[Len(aCampo)][iSALDOR]     := Transform(0,'@E 999,999,999,999.99')
		  aCampo[Len(aCampo)][iDOCUMEN]    := TMPE5->E5_DOCUMEN
        
		    // Totalizador
			_nVlrTitulo += VAL(STRTRAN(STRTRAN(aCampo[Len(aCampo)][iVLRTITULO],'.',''),',','.')) 
			_nVlrTReal  += VAL(STRTRAN(STRTRAN(aCampo[Len(aCampo)][iVLRREAL],'.',''),',','.')) 
			_nVLRBAIXA  += VAL(STRTRAN(STRTRAN(aCampo[Len(aCampo)][iVLRBAIXA],'.',''),',','.'))
			_nCORRECAO  += VAL(STRTRAN(STRTRAN(aCampo[Len(aCampo)][iCORRECAO],'.',''),',','.'))
			_nJUROS     += VAL(STRTRAN(STRTRAN(aCampo[Len(aCampo)][iJUROS],'.',''),',','.'))
			_nDESCONTO  += VAL(STRTRAN(STRTRAN(aCampo[Len(aCampo)][iDESCONTO],'.',''),',','.')) 
			_nSALDO     += VAL(STRTRAN(STRTRAN(aCampo[Len(aCampo)][iSALDO],'.',''),',','.'))  
			_nSALDORS   += VAL(STRTRAN(STRTRAN(aCampo[Len(aCampo)][iSALDOR],'.',''),',','.')) 

		else                       

		    // Totalizador (Deduz para adicionar novo valor)
			_nVlrTitulo -= VAL(STRTRAN(STRTRAN(aCampo[nPos][iVLRTITULO],'.',''),',','.')) 
			_nVlrTReal  -= VAL(STRTRAN(STRTRAN(aCampo[nPos][iVLRREAL],'.',''),',','.')) 
			_nVLRBAIXA  -= VAL(STRTRAN(STRTRAN(aCampo[nPos][iVLRBAIXA],'.',''),',','.'))
			_nCORRECAO  -= VAL(STRTRAN(STRTRAN(aCampo[nPos][iCORRECAO],'.',''),',','.'))
			_nJUROS     -= VAL(STRTRAN(STRTRAN(aCampo[nPos][iJUROS],'.',''),',','.'))
			_nDESCONTO  -= VAL(STRTRAN(STRTRAN(aCampo[nPos][iDESCONTO],'.',''),',','.')) 
			_nSALDO     -= VAL(STRTRAN(STRTRAN(aCampo[nPos][iSALDO],'.',''),',','.'))  
			_nSALDORS   -= VAL(STRTRAN(STRTRAN(aCampo[nPos][iSALDOR],'.',''),',','.')) 
		                                                    
		    // Adicionando novo valor
		    aCampo[nPos][iDTBAIXA]     := DTOC(STOD(TMPE5->E5_DTDIGIT))
		    aCampo[nPos][iPARCELA]     := TMPE5->E5_PARCELA
			aCampo[nPos][iVLRBAIXA]    := Transform(nValor,'@E 999,999,999,999.99')
			aCampo[nPos][iMOTIVOBAIXA] := cMOTBAIXA
			aCampo[nPos][iCORRECAO]    := Transform(nCorre,'@E 999,999,999,999.99')
			aCampo[nPos][iJUROS]       := Transform(nJuros,'@E 999,999,999,999.99')
			aCampo[nPos][iDESCONTO]    := Transform(nDesc,'@E 999,999,999,999.99')
			aCampo[nPos][iDOCUMEN]     := TMPE5->E5_DOCUMEN

		    // ATUALIZANDO TOTALIZADOR
			_nVlrTitulo += VAL(STRTRAN(STRTRAN(aCampo[nPos][iVLRTITULO],'.',''),',','.')) 
			_nVlrTReal  += VAL(STRTRAN(STRTRAN(aCampo[nPos][iVLRREAL],'.',''),',','.')) 
			_nVLRBAIXA  += VAL(STRTRAN(STRTRAN(aCampo[nPos][iVLRBAIXA],'.',''),',','.'))
			_nCORRECAO  += VAL(STRTRAN(STRTRAN(aCampo[nPos][iCORRECAO],'.',''),',','.'))
			_nJUROS     += VAL(STRTRAN(STRTRAN(aCampo[nPos][iJUROS],'.',''),',','.'))
			_nDESCONTO  += VAL(STRTRAN(STRTRAN(aCampo[nPos][iDESCONTO],'.',''),',','.')) 
			_nSALDO     += VAL(STRTRAN(STRTRAN(aCampo[nPos][iSALDO],'.',''),',','.'))  
			_nSALDORS   += VAL(STRTRAN(STRTRAN(aCampo[nPos][iSALDOR],'.',''),',','.')) 

			nPos      := 0
		endif
		
		dbSkip()
	EndDo

	TMPE5->( dbCloseArea() )
	
    // Atualiza Baixas com rela��o ao Titulo
    if !lEnd
   	   AtualizaTitulo(pNUMTITULO , pPREFIXO, nTotBaixa, nSldAtuR)
    Endif

	RestArea( aArea )

Return
//*********************************************************************************************************************************************************************************
//
//																		F I M     E X P O R T A C A O 
//
//*********************************************************************************************************************************************************************************







//*********************************************************************************************************************************************************************************
//
//																		R E L A T O R I O 
//
//*********************************************************************************************************************************************************************************
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CCABFINR01�Autor  �Valdemir Jose       � Data �  12/12/12   ���
�������������������������������������������������������������������������͹��
���Desc.     �Emiss�o do Relatorio Movimento de Titulos                   ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Relatorio                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function CCABFINR01A()
Local cDesc1 			:= "Este programa tem como objetivo imprimir relatorio "
Local cDesc2    		:= "Movimenta��o de Titulos, "
Local cDesc3     		:= "respeitando o par�metro informado."
Local cPict         	:= ""
Local titulo       		:= "RELAT�RIO MOVIMENTA��O DE TITULOS"// 
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


// Configurando fontes para relat�rio
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

//���������������������������������������������������������������������Ŀ
//� Processamento. RPTSTATUS monta janela com a regua de processamento. �
//�����������������������������������������������������������������������

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo )

CursorArrow()

Return



/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RunReport   �Autor  �Valdemir Jos�     � Data �  07/06/12   ���
�������������������������������������������������������������������������͹��
���Desc.     � Processando Registros                                      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
Local cChave2     := ''
Local cPrefixo    := ''
Private cChave
Private cCNPJ_CPF := ''
Private cJF       := ''
Private cPRICOM   := ''
Private cMun      := ''
Private cUF       := ''
Private cNome     := ''

nTVlrBaixa  := 0
nTCorrecao  := 0 
nTJuros     := 0 
nTDesconto  := 0 
nTSaldo     := 0

TMP->( dbGotop() )	
While TMP->( ! EOF() ) 

    cChave := TMP->CODCLI

	dbSelectArea('SA1')
	IF dbSeek(xFilial('SA1')+TMP->CODCLI+TMP->LOCAL)
	      cCNPJ_CPF := SA1->A1_CGC
	      cJF       := SA1->A1_PESSOA
	      cPRICOM   := dtoc(SA1->A1_PRICOM)
	      cMun      := SA1->A1_MUN
	      cUF       := SA1->A1_EST
	      cNome     := SA1->A1_NOME                 
	      dbSeek(xFilial('SA1')+TMP->CODCLI+'01')         // Acrescentado 17/12/2012 - 11:50h, para buscar o risco sempre da loja 01
	ELSE
	      cCNPJ_CPF := 'NOT FOUND'
	      cJF       := 'NOT FOUND'
	      cPRICOM   := ''
	ENDIF
	
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
		
		nI        :=  Ascan(aMotBx, {|x| Substr(x,1,3) == Upper(TMP->MOTBAIXA) })   //Busca a Descri��o do Motivo da Baixa
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

		if (cChave2 <> TMP->NUMTITULO+TMP->PREFIXO+Transform(TMP->VLREAL,"@E 999,999,999.99"))
			                      
			// Impress�o Grafica
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
			  
		    // Impress�o dos Dados
			oPrint:say (nLin , aPosTitulo[01], TMP->PREFIXO							 		  ,oFont08)	
			oPrint:say (nLin , aPosTitulo[02], TMP->NUMTITULO                            		  ,oFont08)	
			oPrint:say (nLin , aPosTitulo[03], TMP->TIPO							     		  ,oFont08)	
			oPrint:say (nLin , aPosTitulo[04], TMP->PORTADOR			                 		  ,oFont08)	
			oPrint:say (nLin , aPosTitulo[05], TMP->VEND2			    				 		  ,oFont08)	
			oPrint:say (nLin , aPosTitulo[06], TMP->GESTOR								 		  ,oFont08)	
			oPrint:say (nLin , aPosTitulo[07], DTOC(STOD(TMP->EMISSAO))				 		  ,oFont08)	
			oPrint:say (nLin , aPosTitulo[08], DTOC(STOD(TMP->VENCTO))					 		  ,oFont08)	                   
			oPrint:say (nLin , aPosTitulo[09], DTOC(STOD(TMP->VENCTOREAL))			 	 		  ,oFont08)	                   
			if (cChave2 <> TMP->NUMTITULO+TMP->PREFIXO+Transform(TMP->VLREAL,"@E 999,999,999.99"))
				oPrint:say (nLin , aPosTitulo[10]+160, Transform(TMP->VLRTITULO,'@E 999,999,999,999.99'), oFont08,,,,1)	                   
				oPrint:say (nLin , aPosTitulo[15]+120, Transform(TMP->VLRBAIXA,'@E 999,999,999,999.99'), oFont08,,,,1)	                   
				oPrint:say (nLin , aPosTitulo[17]+130, Transform(TMP->CORRECAO,'@E 99,999,999.99'), oFont08,,,,1)	                   
				oPrint:say (nLin , aPosTitulo[18]+120, Transform(TMP->JUROS   ,'@E 999,999,999,999.99'), oFont08,,,,1)	                   
				oPrint:say (nLin , aPosTitulo[19]+120, Transform(TMP->DESCONTO,'@E 999,999,999,999.99'), oFont08,,,,1)	                   
				oPrint:say (nLin , aPosTitulo[20]+160, Transform(TMP->SALDO   ,'@E 999,999,999,999.99'), oFont08,,,,1)	                   
			else
				oPrint:say (nLin , aPosTitulo[10]+160, Transform(0,'@E 999,999,999,999.99'), oFont08,,,,1)	                   
				oPrint:say (nLin , aPosTitulo[15]+120, Transform(0,'@E 999,999,999,999.99'), oFont08,,,,1)	                   
				oPrint:say (nLin , aPosTitulo[17]+130, Transform(0,'@E 99,999,999.99'), oFont08,,,,1)	                   
				oPrint:say (nLin , aPosTitulo[18]+120, Transform(0,'@E 999,999,999,999.99'), oFont08,,,,1)	                   
				oPrint:say (nLin , aPosTitulo[19]+120, Transform(0,'@E 999,999,999,999.99'), oFont08,,,,1)	                   
				oPrint:say (nLin , aPosTitulo[20]+160, Transform(0,'@E 999,999,999,999.99'), oFont08,,,,1)	                   
			endif
			oPrint:say (nLin , aPosTitulo[11], STRZERO(TMP->MOEDA,2)					 		  ,oFont08)	
			oPrint:say (nLin , aPosTitulo[12], Substr(alltrim(TMP->HISTORICO),1,10)	 		  ,oFont08)	
			oPrint:say (nLin , aPosTitulo[13], DTOC(STOD(TMP->DTBAIXA))				 		  ,oFont08)	
			oPrint:say (nLin , aPosTitulo[14], DTOC(STOD(TMP->DIGBAIXA))				 		  ,oFont08)	
			oPrint:say (nLin , aPosTitulo[16], cMOTBAIXA			   					 		 ,oFont08)	
			nLin += 40
	        
        ENDIF
        
	    cChave := TMP->CODCLI

		// Total por grupo de clientes
		if (cChave2 <> TMP->NUMTITULO+TMP->PREFIXO+Transform(TMP->VLREAL,"@E 999,999,999.99"))
			nVlrTitulo += TMP->VLRTITULO
			nVlrBaixa  += TMP->VLRBAIXA
			nCorrecao  += TMP->CORRECAO
			nJuros     += TMP->JUROS 
			nDesconto  += TMP->DESCONTO
			nSaldo     += TMP->SALDO
		endif
		nVlrReal   += 0

		// Total Geral dos Titulos
		if (cChave2 <> TMP->NUMTITULO+TMP->PREFIXO+Transform(TMP->VLREAL,"@E 999,999,999.99"))
			nVlrTTitulo += TMP->VLRTITULO
			nTVlrBaixa  += TMP->VLRBAIXA
			nTCorrecao  += TMP->CORRECAO
			nTJuros     += TMP->JUROS 
			nTDesconto  += TMP->DESCONTO
			nTSaldo     += TMP->SALDO                                      
		endif
		nVlrTReal   += 0
		
		cTitulo := TMP->NUMTITULO
		_nValor := TMP->VLRTITULO                                                
		cPrefixo:= TMP->PREFIXO
		cChave2 := TMP->NUMTITULO+TMP->PREFIXO+Transform(TMP->VLREAL,"@E 999,999,999.99")
    
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

//���������������������������������������������������������������������Ŀ
//� Se impressao em disco, chama o gerenciador de impressao...          �
//�����������������������������������������������������������������������
if bInstancia
   oPrint:Preview()        // Visualiza impressao grafica antes de imprimir
Endif

If aReturn[5]==1
	dbCommitAll()
Endif

MS_FLUSH()

Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FER065    �Autor  �Valdemir Jos�       � Data �  07/06/12   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function CabecCCAB(pTITULO,pSubTit,pSubTit1,Cabec1, oPrint_, lFirst, ContFl)
	Local nReturn := 0
	Local cCabFonte 
	
	// Cabe�alho de Titulo Padr�o do Relat�rio
	nReturn += TITULOCABEC(pTITULO,pSubTit, pSubTit1, @oPrint_, @lFirst, @ContFl,'P')
	cCabFonte:=oFont08b   
	nReturn += 40                                 
	//
	SubCabec(oPrint_, nReturn, cCabFonte, cChave)
	nReturn += 100
	
	bInstancia := .T.                               
	
Return nReturn




/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TITULOCABEC   �Autor  �Valdemir Jos�   � Data �  07/06/12   ���
�������������������������������������������������������������������������͹��
���Desc.     � Cabe�alho para TMSPrinter                                  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Dixtal                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
	                             
    //Cabe�alho 1
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


      




/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FER065    �Autor  �Valdemir Jos�       � Data �  09/06/12   ���
�������������������������������������������������������������������������͹��
���Desc.     � SubCabecalho, poder� fazer a chamada de qualquer lugar     ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function SubCabec(oPrint_, nReturn, cCabFonte, cCLIENTE)


	oPrint_:Box(nReturn    ,aPosTitulo[1]-20,nReturn+110,aPosTitulo[20]+170)
	oPrint_:say (nReturn+15, aPosTitulo[1] ,"CLIENTE: "+cCLIENTE+" - "+cNome    ,cCabFonte)
	oPrint_:say (nReturn+15, aPosTitulo[9] ,"CIDADE: "+cMun    ,cCabFonte)
	oPrint_:say (nReturn+15, aPosTitulo[14],"ESTADO: "+cUF    ,cCabFonte)
	nReturn+=50
	oPrint_:say (nReturn+15, aPosTitulo[1] ,"PJ / PF: "+cJF,cCabFonte)
	oPrint_:say (nReturn+15, aPosTitulo[4] ,"CNPJ/CPF: "+cCNPJ_CPF  ,cCabFonte)
	oPrint_:say (nReturn+15, aPosTitulo[9] ,"RISCO CCAB: "+SA1->A1_XCLASSE,cCabFonte)
	oPrint_:say (nReturn+15, aPosTitulo[14],"DT.1� COMPRA: "+cPRICOM  ,cCabFonte)
	nReturn+=60
	//oPrint_:Line(nReturn,aPosTitulo[1]-20,nReturn,aPosTitulo[20]+170)
	// Sub Cabe�alho com os  titulos dos campos
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
	oPrint_:say (nReturn+10,aPosTitulo[7],"EMISS�O"  	  ,cCabFonte)
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
	oPrint_:say (nReturn+10,aPosTitulo[17],"CORRE�"   ,cCabFonte)
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
//*********************************************************************************************************************************************************************************
//
//																		F I M     R E L A T O R I O  
//
//*********************************************************************************************************************************************************************************







//*********************************************************************************************************************************************************************************
//
//																		F U N C O E S   G E N E R I C A S   
//
//*********************************************************************************************************************************************************************************


//������������������������������������������������������������������������������������������������t>�
//�Fun��o que trata o tamanho do fonte                                                             .�
//������������������������������������������������������������������������������������������������t>�*/
Static Function Char2Pix(cTexto,oFont)
Return(GetTextWidht(0,cTexto,oFont)*2)



//������������������������������������������������������������������������������������������������t>�
//�Fun��o que criar� no arquvio de perguntas, respeitando o array que ser� passado como parametro.�
//�Existe dois parametros, um para as perguntas e outro para o help                               �
//������������������������������������������������������������������������������������������������t>�*/
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

Caracter�stica do vetor p/ utiliza��o da fun��o SX1
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

/*  ---------------------------------------- Exemplo de Cria��o de Array para os Parametros ------------------------------------------
aAdd(aP,{"Ano Base           ?"      ,"C",  4,0,"G","",""      , ""   ,""   ,"" ,"", ""})
aAdd(aP,{"M�s De             ?"      ,"C",  2,0,"G","",""      , ""   ,""   ,"" ,"", ""})
aAdd(aP,{"M�s At�            ?"      ,"C",  2,0,"G","",""      , ""   ,""   ,"" ,"", ""})
aAdd(aP,{"Vis�o              ?"      ,"N", 01,0,"C","",""      , "BIO","TEC","" ,"", ""})  //
aAdd(aP,{"C.Custo De         ?"      ,"C",  4,0,"G","","CTT"   , ""   ,""   ,"" ,"", ""})
aAdd(aP,{"C.Custo Ate        ?"      ,"C",  4,0,"G","","CTT"   , ""   ,""   ,"" ,"", ""})
aAdd(aP,{"Conta De           ?"      ,"C", 20,0,"G","","CT1"   , ""   ,""   ,"" ,"", ""})
aAdd(aP,{"Conta Ate          ?"      ,"C", 20,0,"G","","CT1"   , ""   ,""   ,"" ,"", ""})

aAdd(aHelp,{"Digite a data base do Movimento."})
aAdd(aHelp,{"Informe o m�s inicial"})
aAdd(aHelp,{"Informe o m�s final"})
aAdd(aHelp,{"Selecione o item cont�bil, BIO OU TEC"})
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �_QryExec  �Autor  �Valdemir Jose       � Data �  07/06/12   ���
�������������������������������������������������������������������������͹��
���Desc.     � Executa uma Qry que � passada via parametro                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Generico                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function QryExec(_Qry, pAlias)

	dbUseArea(.T., "TOPCONN", TCGenQry(,,_Qry), pAlias, .F., .T.)
	
	dbSelectArea(pAlias)    
	
	dbGotop()                                            

Return                      




/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � GERAARQ     �Autor  �Valdemir Jos�    � Data �  30/06/08   ���
�������������������������������������������������������������������������͹��
���Desc.     � Metodo para Gerar o arquivo HTML,conforme array passado    ���
���          � como parametro                                             ���
�������������������������������������������������������������������������͹��
���Uso       � 01 - HTML                                                  ���
���          � 02 - CSV                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function GERAARQ(paCabec,paCampos,pcNOMEARQ,pcTIPO) 
	Local lContinua	:= .T.
	Local cLin      := "" 
	Local cTmp      := ""
	Local nX        := 0
	Local nY        := 0 
	Local cSTRING   := 0
	Local lRET      := .T.
	Local bAzul     := .F.
	Local nPerc
	Private nHdl    := 0
	Private cEOL    := CHR(13)+CHR(10)

	nHdl	:= fCreate(pcNOMEARQ)

	if nHdl == -1
	    MsgAlert("O arquivo de nome "+pcNOMEARQ+" nao pode ser executado! Verifique os parametros.","Atencao!")
	ElseIf lContinua
		IF pcTIPO = '01'
		    // Montando cabe�alho
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

		       nPerc    := ELAPTIME(hInicial, TIME())
			   oProc:IncRegua2("Tempo percorrido: "+Alltrim(nPerc)+"  Titulo: " + paCAMPOS[nX][2])      

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
		    // Montando cabe�alho      
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


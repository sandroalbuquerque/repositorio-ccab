#INCLUDE "PROTHEUS.CH"
#INCLUDE "ap5mail.ch"
#define cENTER CHR(13)+CHR(10)
#Define PAD_LEFT            0
#Define PAD_RIGHT           1
#Define PAD_CENTER          2


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFUNGERVAL บAutor  ณValdemir Jose       บ Data ณ  14/12/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo Generica                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
                  




 


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
User Function TITULOCABEC(pTITULO,pSubTit ,pSubTit1, oPrint, lFirst, ContFl, pTipo, pNomEmp)
	Local cFont            
	Local nReturn  := 045
	Local nColPix
		
	If !lFirst
		lFirst		:= .T.
		oPrint 		:= TMSPrinter():New(pTITULO)
		if pTipo == 'P' 
			oPrint:SetLandscape()            //Define que a impressao deve ser Paisagem - SetLandscape()
		else
			oPrint:SetPortrait()             //Define que a impressao deve ser RETRATO ou SetPortrait()
		endif
	Endif
	
	oPrint:StartPage() 						// Inicia uma nova pagina
	cFont:=oFont10
	                             
    //Cabe็alho 1
	oPrint:say (nReturn ,040 ,pNomEmp, oFont10b)
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
		oPrint:say(nReturn ,(1000 / 2)+150,Padc(TRIM(pTITULO),80),oFont13b)    //
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
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFUNGERVAL บAutor  ณValdemir Jose       บ Data ณ  14/12/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณTRATAR TAMANHO DA FONTE                                     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Char2Pix(cTexto,oFont)
Return(GetTextWidht(0,cTexto,oFont)*2)




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFUNGERVAL บAutor  ณValdemir Jose                   บ Data ณ  14/12/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo que criarแ no arquvio de perguntas, respeitando o array que serแ บฑฑ
ฑฑบ          ณpassado como parametro.                                                 บฑฑ
ฑฑบ          ณExiste dois parametros, um para as perguntas e outro para o help        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ aP,aHelp                                                               บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function SX1Parametro(aP,aHelp)
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
	
	// Atencao 
	// Nos casos de zeros a esquerda em campos caracteres, para manter os zeros a esquerda ao carregar o array, deve
	// ser passado uma concatenacao de chr(160) a esquerda do campo

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
User Function QryExec(_Qry, pAlias)

	dbUseArea(.T., "TOPCONN", TCGenQry(,,_Qry), pAlias, .F., .T.)
	
	dbSelectArea(pAlias)    
	
	dbGotop()                                            

Return                      




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFUNGERVAL บAutor  ณMicrosiga           บ Data ณ  12/14/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function CriaExcel(paTMP, paCAMPO, pcArqExcel)
    Local oExcelApp
    
	IF (LEN(paCampo) > 0) 
	   if !EXISTDIR("C:\Temp")   
	    	nResult := MAKEDIR("C:\Temp")
	   Endif                                               
	   CursorWait()	
	   IncProc('Carregando planilha.... ')
	   pcArqExcel := "C:\Temp\"+cNomeArq+".html"    //+if(MV_PAR05==1,"html","csv")   
	   
	   If !GERAARQ(paTmp,paCampo,pcArqExcel,'01')
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
		oExcelApp:WorkBooks:Open( pcArqExcel )  
		oExcelApp:SetVisible(.T.)	  
		oExcelApp:Destroy()
	ENDIF

Return






/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณATUTOPQUERY บAutor  ณValdemir Jos้     บ Data ณ  24/11/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Atualiza campos, conforme parametro informado             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
USER FUNCTION UpDateQuery(pcTableName, pcCampo, pcCondicao)  
	Local nPort  := SuperGetMv("MV_TOPPORT",.F.,7890)		 	// PORTA TOP INTERFACE: 7890
	Local cBanco := Alltrim(SuperGetMv("MV_TOPDATA",.F.,"")) 	// BANCO DE DADOS TOP INTERFACE: "MSSQL7/DBINTERFACE"
	Local cSever := Alltrim(SuperGetMv("MV_TOPSERV",.F.,"")) 	// SERVIDOR TOP INTERFACE: "SAMCPD49"
	Local nConect:= 0
	Local cQuery := "UPDATE "+pcTableName                     
		  cQuery += " SET "+pcCampo+" = '"+DTOS(dDataBase)+"'"
		  cQuery += " WHERE "+pcCondicao+" "
	
	IF TcSqlExec(cQuery) <> 0
		UserException( "Tabela: " + cTableName;
		+ cENTER + "SQL Error: " + cENTER + TCSqlError() )
	ENDIF
      

Return                                                                                              




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTelaLocalizar บAutor ณValdemir Jos้    บ Data ณ  28/11/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Apresenta Tela de Localizar                                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
User Function TelaLocalizar(pCaption, aCombos)
	Local oDlg := Nil
	Local oCombo := Nil 
	Local oButton:= nil
	Local cCombo := ""
	Local cPesq := Space(50)
	Local nCbx := 1
	Local aRET := {}  
	Local nOpc := 0
	     
	DEFINE MSDIALOG oDlg TITLE pCaption FROM 65,00 TO 135,435 OF oDlg PIXEL STYLE DS_MODALFRAME STATUS
   		@ 05,05 COMBOBOX oCombo VAR cCombo ITEMS aCombos SIZE 180,50 ON CHANGE (nCbx:=oCombo:nAt) PIXEL OF oDlg
   		@ 20,05 MSGET cPesq PICTURE "@!" SIZE 180,07 PIXEL OF oDlg
   		DEFINE SBUTTON FROM 03,187 TYPE 1 ACTION (nOpc:=1,oDlg:End()) ENABLE OF oDlg
   		DEFINE SBUTTON FROM 18,187 TYPE 2 ACTION oDlg:End() ENABLE OF oDlg
	ACTIVATE MSDIALOG oDlg CENTERED
	
	aAdd(aRET,{nCbx,cPesq,nOPC})

Return aRET



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ_MailEnviar บAutor  ณValdemir Jos้     บ Data ณ  11/02/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Envia e-mail com anexo, conforme parametros informado      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametro ณ _cAnexo    - Arquivo a ser anexado que esteja dentro systemบฑฑ
ฑฑบ          ณ _cTitulo   - Assunto do e-mail                             บฑฑ
ฑฑบ          ณ _cMensagem - Mensagem do corpo do e-mail                   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function _MailEnviar(_cAnexo, _cTitulo, _cMensagem) 
	Local _cConta  :=GETMV("MV_EMCONTA")
	Local _cServer :=GETMV("MV_RELSERV")
	Local _cSenha  :=GETMV("MV_EMSENHA")        
	//Local _cPara   := 'valdemir.jose@totvs.com.br;jvictor@dixtal.com.br'
	Local _cPara   := GETMV("ES_EMLDIRE")        // VALDEMIR JOSE 22/02/2010
	Local _aArMail := GetArea()

	ProcRegua(50) 

	IncProc("Enviando E-Mail...")
	
	If !Empty(_cServer) .And. !Empty(_cConta) .And. !Empty(_cSenha)
		
		CONNECT SMTP SERVER _cServer  ACCOUNT _cConta PASSWORD _cSenha RESULT lOk
		MAILAUTH(Alltrim(_cConta),Alltrim(_cSenha))  
		
		If lOk
			
			If Empty(_cAnexo)
				SEND MAIL FROM _cConta to _cPara SUBJECT _cTitulo BODY _cMensagem RESULT lSendOk
			Else
				SEND MAIL FROM _cConta to _cPara SUBJECT _cTitulo BODY _cMensagem ATTACHMENT _cAnexo RESULT lSendOk
			Endif
			
			If !lSendOk
				GET MAIL ERROR cError
				MsgInfo("Ocorreu um erro no envio do WorkFlow !"+Chr(13)+;
						"Informe o Departamento de TI.",OemToAnsi("Erro de Envio"))  
				lVeriSma:= .F.
			EndIf
			
			DISCONNECT SMTP SERVER
			
		Else
			GET MAIL ERROR cError
			MsgInfo("Informe o Departamento de TI o erro abaixo : "+Chr(13)+cError,OemToAnsi("Erro de Conexao"))
			lVeriSma:= .F.
		EndIf
	EndIf
	
	RestArea(_aArMail)

Return()                                                                       





/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณExisteReg บAutor  ณValdemir Jos้       บ Data ณ  11/02/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Encontra Registro                                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
User Function ExisteReg(pTabela, pOrder, pChave)
	Local lRET  := .T.
	Local aArea := GetArea()
	
	dbSelectArea(pTabela)   
	dbSetOrder(pOrder)
	
	lRET := dbSeek(pChave)	
	
	if !lRET
	   MsgAlert('Registro nใo encontrado...')
	Endif
	
	RestArea( aArea )

Return lRET



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGetStrutura บAutor  ณValdemir Jos้     บ Data ณ  23/02/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo para carregar todos os campos da tabela que ้       บฑฑ
ฑฑบ          ณ passado via parametro                                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametro ณ pTabela - Sigla da Tabela a ser Carregada                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณ aRet - Array Tridimencional                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function GetStrutura(pTabela)
	Local aRet := {}
			
	// Carrega os Campos da tabela
	dbSelectArea("SX3")
	dbSetOrder(1)
	MsSeek(pTabela)
	While ( !Eof() .And. (SX3->X3_ARQUIVO == pTabela) )
                                            
		if  (SX3->X3_CONTEXT <> "V")   // Visual 4 - VISUALIZAR OU ALTERAR        context 5 - VISUAL OU REAL (SX3->X3_VISUAL <> "V") .and.
			   aadd(aRet,{ 	AllTrim(X3Titulo()),;      // 1 - TITULO
								SX3->X3_CAMPO,;        // 2 - NOME CAMPO
								SX3->X3_TIPO})         // 3 - TIPO DO CAMPO
								
		Endif						
	   
	   SX3->(dbSkip())
	   
    EndDo

Return aRET


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTrataBuffer  บAutor  ณValdemir Jos้    บ Data ณ  30/04/08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Rotina que farแ a quebra das informa็๕es-"|"               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function TrataBuffer(cTmpBuffer)
Local cRetorno := ""
Local i        := 0

For i := 1 To Len(cTmpBuffer)
 if SUBSTR(cTmpBuffer,i,1) == "|"
  cRetorno   := SUBSTR(cTmpBuffer,1,i-1)
  cTmpBuffer := SUBSTR(cTmpBuffer,i+1,500)
  Exit
 endif  
 cRetorno  := SUBSTR(cTmpBuffer,1,Len(cTmpBuffer))
Next

Return cRetorno




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRegMasterLog  บAutor  ณValdemir Jos้   บ Data ณ  01/07/2013 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Registra o Log de qualquer que seja a a็ใo no registro     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CCAB                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function RegMasterLog(pTabela, pRotina, pAcao)
	Local aCampos := IF(pAcao='EXC' .or. pAcao='INC',{},U_GetComparacao(pTabela))
	Local nConta  := 0
	Local _cDetalh := "" 
	Local aArea   := GetArea()
	Local cCampoTab := ""

	dbSelectArea(pTabela)
	
	if (Len(aCampos) > 0) .and. ((PadL(pAcao,3) != "EXC") .or. (PadL(pAcao,3) != "INC"))        // S๓ irแ fazer se existir campos alterados

		// Registra o Log informando as altera็๕es
		For nConta := 1 To Len(aCampos)
			// De
			if ValType( (pTabela)->&(ALLTRIM(aCampos[nConta][2])) ) = "N"
				cCampoTab := Alltrim( Str( (pTabela)->&(ALLTRIM(aCampos[nConta][2])) ) )
			Elseif ValType( (pTabela)->&(ALLTRIM(aCampos[nConta][2])) ) = "D"
				cCampoTab := dtoc( (pTabela)->&(ALLTRIM(aCampos[nConta][2])) )
			Else
				cCampoTab := (pTabela)->&(ALLTRIM(aCampos[nConta][2]))
			endif                                                                       

			// Para
			if ValType( M->&(ALLTRIM(aCampos[nConta][2])) ) = "N"
				cCamPara := Alltrim( Str( M->&(ALLTRIM(aCampos[nConta][2])) ) )
			Elseif ValType( (pTabela)->&(ALLTRIM(aCampos[nConta][2])) ) = "D"
				cCamPara := dtoc( M->&(ALLTRIM(aCampos[nConta][2])) )
			Else
				cCamPara := M->&(ALLTRIM(aCampos[nConta][2]))
			endif                                                                       
			
			if     PadL(pAcao,3) == "ALT"
				_cDetalh := 'Alterado'
    			_cDetalh := _cDetalh+" Campo "+aCampos[nConta][1]+" de: "+cCampoTab+" para: "+cCamPara
			Endif     

			grvMasterLog(pRotina, pAcao, _cDetalh, pTabela)

		Next	
		
	Elseif (PadL(pAcao,3) == "EXC") .or. (PadL(pAcao,3) == "INC")
		if     PadL(pAcao,3) == "EXC"                                                                                       
	   		_cDetalh := 'Excluํdo'
   			_cDetalh := _cDetalh+" Registro - "+(pTabela)->(FieldGet(1))+" "+(pTabela)->(FieldGet(2)) //+"  "+(pTabela)->(FieldGet(6))
		Else
			_cDetalh  := IF(INCLUI,'Incluํdo','Alterado')
   			_cDetalh := _cDetalh+" Registro - "+M->&(FieldName(1))+"  "+M->&(FieldName(2))+"  "+M->&(FieldName(6))
		Endif

		grvMasterLog(pRotina, pAcao, _cDetalh, pTabela)

	Endif                                                                       
         
	RestArea( aArea )
	
Return




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณgrvMasterLog บAutor  ณValdemir Jos้    บ Data ณ  01/07/2013 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Grava Dados no Master Log na Tabela PAA                   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CCAB                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function grvMasterLog(pRotina, pAcao, pDetalh, pTabela)
	Local aArea   := GetArea()
	Local _Codigo := ''  
	Local cAlias  := ""
	Local cTab    := ""
	
	if (pTabela = 'SA1')  .or. (pTabela = 'SA2') 
	  IF (ALTERA .OR. INCLUI)
		 _Codigo := iif(pTabela = 'SA1', M->A1_COD, M->A2_COD)
		 _Codigo += '-'+iif(pTabela = 'SA1', M->A1_LOJA, M->A2_LOJA)
	  Else
		 _Codigo := iif(pTabela = 'SA1', SA1->A1_COD, SA2->A2_COD)
		 _Codigo += '-'+iif(pTabela = 'SA1', SA1->A1_LOJA, SA2->A2_LOJA)
	  Endif
	 cAlias := "SZJ"  
	elseif pTabela = 'SB1' 
	 _Codigo := SB1->B1_COD  
	 cAlias := "SZJ"
	elseif pTabela = 'SC7'      // Acrescentado 24/11/10 - Valdemir Jos้
	 _Codigo := SC7->C7_NUM
	 if Empty(SC7->C7_NUM)
		 _Codigo := TMP->C7_NUM
	 Endif
	 cAlias := 'PAE'
	endif 
	          
	dbSelectArea(cAlias)
	                 
	RecLock(cAlias,.T.)
	&(Substr(cAlias,2,3)+"_FILIAL")  := if(pTabela='SB1',SB1->B1_FILIAL,XFILIAL("SZJ"))
	&(Substr(cAlias,2,3)+"_USUARIO") := cUserName                                                                         
	&(Substr(cAlias,2,3)+"_DATA")    := DDATABASE
	&(Substr(cAlias,2,3)+"_HORA")    := TIME()
	&(Substr(cAlias,2,3)+"_ROTINA")  := pRotina
	&(Substr(cAlias,2,3)+"_CODIGO")  := _Codigo
	&(Substr(cAlias,2,3)+"_ACAO")    := pAcao
	&(Substr(cAlias,2,3)+"_DETALH")  := pDetalh
	MsUnlock()	
	
	RestArea( aArea )

Return




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGetComparacao บAutor  ณValdemir Jos้   บ Data ณ  01/07/2013 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Verifica se o campo foi alterado, caso tenha sido retorna  บฑฑ
ฑฑบ          ณ array com as altera็๕es                                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametro ณ pTabela - Sigla da Tabela a ser Carregada                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณ aRet - (Tiiculo do campo, Nome do Campo)                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function GetComparacao(pTabela)
	Local aRet    := {}
	Local aCampos := U_GetStrutura(pTabela)
	Local nCampo  := 0
	Local aArea   := GetArea()

	dbSelectArea(pTabela)
	//RegToMemory(pTabela,.F.,.F.)
	For nCampo := 1 To Len(aCampos)		  // Quantidade de Colunas
		if Right(Alltrim(aCampos[nCampo,2]),6) <> 'FILIAL'						 			 
			// Verifica se o campo nใo estแ vazio
			if (!EMPTY((pTabela)->&(Alltrim(aCampos[nCampo,2]))) ) .AND.;
			   (M->&(Alltrim(aCampos[nCampo,2])) <> (pTabela)->&(Alltrim(aCampos[nCampo,2])) )   // Verifica se os campos de memoria ้ diferente dos campos fisicos
			   aAdd(aRet, {aCampos[nCampo,1],aCampos[nCampo,2]} )                                // Se for diferente, alimenta array 
			Endif                                                    
		Endif
	Next                      
	
	RestArea( aArea )

Return aRet




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMontaCabec บAutor  ณValdemir Jos้      บ Data ณ  19-08-08   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Monta Cabe็alho, baseado no array informado                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Dixtal                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
PARAMETRO
=========
aCabec = Array com os titulos, respeitando o tamanho de cada titulo, conforme o conteudo do campo (Caracteres)
cSepar = ษ o caracter que farแ a separa็ใo entre os campos
*/
User Function Monta_Cabec(aCabec, cSepar)
	Local cRET   := ""
	Local cTmp   := ""
	Local nX     := 0
	Local nCol   := 0 


	// Prepara array com posi็๕es das colunas.
	For nX := 1 To Len(aCabec)
		if nX > 1
			cTmp += ', '
		endif
		cTmp += '0'
	Next
	
	cTmp := '{'+cTmp+'}'
	aCol_ := &(cTmp)
    	
	//                  
	For nX := 1 To Len(aCabec)
	
		if nX == 1
	        aCol_[nX] := 0
	    Else
	      aCol_[nX]   := aCol_[nX-1]+len(aCabec[nX-1])
	    endif
	    cRET     += aCabec[nX]	   
	    /*   Removido por Valdemir Jos้  02/09/2010
        if nX == 1
	        aCol_[nX] := 0
	    Else
	      aCol_[nX]   := aCol_[nX-1]+len(aCabec[nX-1])
	    endif     
    	cRET     += aCabec[nX]+" "
	    
	    if cSepar = " "
	    	if aCabec[nX] != "|"
	    		cRET     += aCabec[nX]
	    	Endif
	    Else	
	    	cRET     += aCabec[nX]+" "
		Endif	    
		*/
	next         
	
Return cRET                       
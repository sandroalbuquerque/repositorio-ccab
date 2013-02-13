#Include "protheus.ch"     
#Include "TopConn.ch"    
#Include "AP5MAIL.ch"
#define cENTER CHR(13)+CHR(10)

#DEFINE DMPAPER_A4	9
#DEFINE ON_NEGRITO  .T.
#DEFINE OFF_NEGRITO .F.
#DEFINE ON_ITALICO .T.
#DEFINE OFF_ITALICO .F.
#DEFINE ON_UNDERLINE .T.
#DEFINE OFF_UNDERLINE .F.

 

/*                                                                        
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � FER052   �Autor  � Valdemir Jos�      � Data �  04/05/2012 ���
�������������������������������������������������������������������������͹��
���Descricao �Imprimir Pedido de Compras Grafico                          ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico SP / CCAB                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/                             

USER FUNCTION Matr110X( cAlias, nReg, nOpcx )
//User Function CCABCOM01(pcPedido)
	Local aPerg			:= {}
	Local cSql          := ""
	Local cAlias	    := ParamIxb[1]
	Local nReg		    := ParamIxb[2]
	Local nOpcx		    := ParamIxb[3]
	
    Private cObsPed     := ''
    Private nTotPag     := 0
	
	PRIVATE lAuto 		:= (nReg!=Nil)           
             
	If lAuto    //!Empty(pcPedido)      //        
		dbSelectArea("SC7")
		dbGoto(nReg)	
	   
       // Efetua o calculo para saber o total de paginas que existir�
	   MsAguarde({|lEnd| IMPRIME(SC7->C7_NUM, SC7->C7_NUM,'','')},"","Aguarde, processando...",.F.)   
       // Emiti o relat�rio
	   MsAguarde({|lEnd| IMPRIME(SC7->C7_NUM, SC7->C7_NUM,'I','')},"","Aguarde, processando...",.F.)  

	Else
     
	 // Chama parametro que ir� pedir o numero do pedido
     AADD(aPerg,{1,"Pedido N� "     	,Space(TamSx3("C7_NUM")[1])	     ,""	,""	,""		,""	,0	,.F.})
     AADD(aPerg,{1,"Filial    "     	,Space(TamSx3("C7_FILIAL")[1])  ,""		,""	,"SM0"	,""	,0	,.F.})
	 
	 if ParamBox(aPerg,"Impressao de Pedido de Compras",,,,,,,,"",.T.,.T.)

	   cSql := " AND C7_NUM ='"+MV_PAR01+"' " // AND C7_NUM <='"+MV_PAR02+"' "  Alterado conforme solicita��o REjiane 30/05/12
	   
       // Efetua o calculo para saber o total de paginas que existir�
	   MsAguarde({|lEnd| IMPRIME(MV_PAR01, MV_PAR01, '',MV_PAR02)},"","Aguarde, processando...",.F.)   
       // Emiti o relat�rio
	   MsAguarde({|lEnd| IMPRIME(MV_PAR01, MV_PAR01,'I',MV_PAR02)},"","Aguarde, processando...",.F.)   
	 
	 endif

	EndIf

Return Nil

//��������������������������������������������������������Ŀ
//� FUNCTION IMPRIME                                       �
//����������������������������������������������������������
Static Function IMPRIME(cPedDe, cPedAte,pTipo, pcFil)

	Local cQuery	:= ""
	Local cCond		:= ""
	Local cTpFrete	:= ""
	Local cCompra	:= ""
	Local nValIPI	:= 0
	Local nValICM	:= 0
	Local nTotal	:= 0
	Local lExist	:= .F.
	Local lPrimeira	:= .T.
	Local nAj_Cod   := -20
	Local nAj_G     := -20                  
	Local nAj       := 20                       
	Local nDif      := 20
	Local nFrete    := 0
	Local nSeguro   := 0
	Local nDespesas := 0  
	Local nOutros   := 0       
	Local nDesconto := 0
	Local cMemo            
	Local cObsPed   := ''
	Local nGrafico  := 0    
	Local nTotNF    := 0

	Private cFornece	:= ""
	Private cLojaFor	:= ""
	Private cPedido		:= ""
	Private dEmissao	:= CtoD("")
	Private cComprador  := ""
	Private cNumSC      := ""
	Private cNumCOT     := ""
	
	Private oFont0	:= TFont():New("Times New Roman",,018,,ON_NEGRITO ,,,,,OFF_UNDERLINE,OFF_ITALICO)
	Private oFontT	:= TFont():New("Times New Roman",,015,,ON_NEGRITO ,,,,,OFF_UNDERLINE,OFF_ITALICO)
	Private oFont1	:= TFont():New("Times New Roman",,016,,ON_NEGRITO ,,,,,OFF_UNDERLINE,OFF_ITALICO)
	Private oFont2	:= TFont():New("Times New Roman",,012,,ON_NEGRITO ,,,,,OFF_UNDERLINE,OFF_ITALICO)
	Private oFont3	:= TFont():New("Times New Roman",,007,,OFF_NEGRITO,,,,,OFF_UNDERLINE,OFF_ITALICO)
	Private oFont4	:= TFont():New("Times New Roman",,011,,ON_NEGRITO ,,,,,OFF_UNDERLINE,OFF_ITALICO)
	Private oFont5	:= TFont():New("Times New Roman",,007,,OFF_NEGRITO,,,,,OFF_UNDERLINE,OFF_ITALICO)
	Private oFont5b	:= TFont():New("Times New Roman",,007,,ON_NEGRITO ,,,,,OFF_UNDERLINE,OFF_ITALICO)
	Private oFont6	:= TFont():New("Times New Roman",,014,,ON_NEGRITO ,,,,,OFF_UNDERLINE,OFF_ITALICO)
	Private oFont6i	:= TFont():New("Times New Roman",,012,,ON_NEGRITO ,,,,,OFF_UNDERLINE, ON_ITALICO)    
	//                                                          

	IF !Empty(pcFil)
	  _cFilial := pcFil
	Else 
	  _cFilial := xFilial('SC7')
	Endif
   
		                             
	// 
	oBrush1			:= TBrush():New( , CLR_BLACK )	
	oBrush2			:= TBrush():New( , CLR_GRAY )	
	
	nLin 			:= 8000
	nEspaco			:= 070
	nDif			:= 10
	nMaxLin			:= 2390     //2590
	nPagina			:= 0
	                
	oPrint := TMSPrinter():New()

	if pTipo = 'I'
		//oPrint:SetLandscape()
		oPrint:SetPortrait()
		oPrint:Setup()
		oPrint:SetPaperSize(9)
		oPrint:StartPage()
    endif
    
    // Monta query para impress�o do relat�rio
	cQuery := MontaQuery(cPedDe, cPedAte, _cFilial)	
	
	If Select("TRB") > 0
		TRB->(dbCloseArea())
	EndIf

	DbUseArea(.T., "TopConn", TCGenQry( NIL, NIL, cQuery), "TRB", .F., .F.)
    TRB->(dbGoTop())

	If !TRB->(Eof())

		lExist 		:= .T.
		
		While !TRB->(Eof())

			cPedido 	:= TRB->PEDIDO
			lPrimeira	:= .T.

			DbSelectarea("SC7")
			SC7->(DbSetorder(1))
			If SC7->( MsSeek(_cFilial + cPedDe) )
                    
				nTotNF    := 0
				nDesconto := 0
				nSeguro   := 0
				nFrete    := 0
				nDEspesas := 0

				cFornece	:= SC7->C7_FORNECE
				cLojaFor	:= SC7->C7_LOJA
				dEmissao	:= SC7->C7_EMISSAO
				cNumSC      := SC7->C7_NUMSC
				cNumCOT     := SC7->C7_NUMCOT   
		
				If nLin > nMaxLin
				   ImpCabec(1,pTipo)
				EndIf
                        
			    // Imprime Titulo do Pedido
                nLin := ImpTitulos(pTipo, oPrint, nLin, nEspaco, nDif, nAj, nAj_G, nAj_Cod)
				cObsPed:= ''                                                                               
				While !Eof() .And. SC7->C7_NUM == cPedido .AND. SC7->C7_FILIAL == _cFilial

					// Efetuando Tratamento de Campo Memo
					//cCodObs := Posicione("SB1",1,xFilial("SB1") + SC7->C7_PRODUTO, "B1_CODOBS") Removido por solicita��o Rejiane informou que tem que ser pego
				    //	                                                                              a observa��o do C7_OBS REUNI�O DE 30/05/2012
				    
					cMemo   := SC7->C7_OBS                            //MSMM(cCodObs)                VALDEMIR 30/05/2012
                    
                    if Len(alltrim(cMemo)) = 0
                     nGrafico := 0 //-70
                    endif
                    
                    // Imprime as Colunas do Pedido
                    if pTipo ='I'
						ImprimeColunas(oPrint, cMemo, nLin, nEspaco+nGrafico, nDif, nAj_G, nAj) 
					endif
					if pTipo = 'I'
						// Faz Impress�o dos Dados do Pedido					
						oPrint:Say(nLin+nDif,085,SC7->C7_ITEM,oFont3)
						oPrint:Say(nLin+nDif,180,SC7->C7_PRODUTO,oFont3)
						oPrint:Say(nLin+nDif,417+nAj_G,Posicione("SB1",1,xFilial("SB1") + SC7->C7_PRODUTO, "SB1->B1_DESC"),oFont3)
						oPrint:Say(nLin+nDif,1163+nAj_G,Transform(SC7->C7_QUANT,"@E 99999.9"),oFont3,,,,1)
						oPrint:Say(nLin+nDif,1195+nAj_G+nAj,SC7->C7_UM,oFont3)
						oPrint:Say(nLin+nDif,1332+nAj_G+nAj+nDif,Transform(SC7->C7_PRECO,"@E 9,999,999.99"),oFont3,,,,1)
						oPrint:Say(nLin+nDif,1404+nAj_G+nAj+nDif,Transform(SC7->C7_DESC,"@E 99")+"%",oFont3,,,,1)
						oPrint:Say(nLin+nDif,1499+nAj_G+nAj+nDif,Transform(SC7->C7_VLDESC,"@E 999,999.999"),oFont3,,,,1)
						oPrint:Say(nLin+nDif,1585+nAj_G+nAj+nDif,Transform(SC7->C7_IPI,"@E 99")+"%",oFont3,,,,1)
						oPrin�t:Say(nLin+nDif,1680+nAj_G+nAj+nDif,Transform(SC7->C7_VALIPI,"@E 999,999.99"),oFont3,,,,1)
						oPrint:Say(nLin+nDif,1866+nAj_G+nAj+nDif,Transform(SC7->C7_PRECO-SC7->C7_VLDESC,"@E 999,999.99"),oFont3,,,,1)
						oPrint:Say(nLin+nDif,2061+nAj_G+nAj+nDif,Transform(SC7->C7_TOTAL,"@E 999,999.99"),oFont3,,,,1)
						oPrint:Say(nLin+nDif,2133+nDif,DtoC(SC7->C7_DATPRF),oFont3)
                    Endif
                      
					cCond		:= SC7->C7_COND
					nValIPI		:= nValIPI + SC7->C7_VALIPI
					nValICM		:= nValICM + SC7->C7_VALICM
					cTpFrete	:= SC7->C7_TPFRETE
					cCompra		:= SC7->C7_USER    
					nTotal		:= nTotal + SC7->C7_TOTAL 
					nTotNF      := nTotNF + SC7->C7_TOTAL 
					nSeguro     += SC7->C7_SEGURO
					nFrete      += SC7->C7_VALFRE 
					nDespesas   += SC7->C7_DESPESA
					nDesconto   += SC7->C7_DESC1+SC7->C7_DESC2+SC7->C7_DESC3
                    nLin 		:= ImprimeObs(oPrint, cMemo, nLin, nEspaco-20, nDif, nAj_G, nAj, pTipo) 
		
					If nLin > nMaxLin
						oPrint:Line(nLin+nGrafico,70,nLin+nGrafico,2320)                         // Tra�o
						ImpRodape(nLin, nEspaco, nAj_G, nAj, nDif, pTipo)
						ImpCabec(1,pTipo)
					    // Imprime Titulo do Pedido
		                nLin := ImpTitulos(pTipo, oPrint, nLin, nEspaco, nDif, nAj, nAj_G, nAj_Cod)
					EndIf
					
					IF !EMPTY(SC7->C7_XOBSPED)
					  cObsPed += " "+SC7->C7_XOBSPED
					ENDIF

					SC7->(DbSkip())
				
			   Enddo                 
               
               
               // Valor Total Liquido                     
               nTotal	  +=  nValIPI + nFrete + nSeguro + nDespesas    // 
               nTotNF     -= nDesconto
                
               
			   //  Faz impress�o at� o final
			   While nLin <= nMaxLin
		         if pTipo ='I'
					ImprimeColunas(oPrint, cMemo, nLin, nEspaco+20, nDif, nAj_G, nAj)   //+nGrafico
				 endif
				 nLin += 90
			   End                         
			   
			   nGrafico := 0	
    	       if Len(alltrim(cMemo)) = 0
                  nGrafico := 0
               endif               
               
               if pTipo='I'
					// Total do Pedido
					oPrint:Line(nLin+nGrafico,70,nLin+nGrafico,2320)                         // Tra�o
					//
					oPrint:FillRect({nLin,70,nLin+nEspaco,376},oBrush1)
					oPrint:FillRect({nLin,378,nLin+nEspaco,576},oBrush1)
					oPrint:FillRect({nLin,578,nLin+nEspaco,776},oBrush1)
					oPrint:FillRect({nLin,778,nLin+nEspaco,976},oBrush1)
					oPrint:FillRect({nLin,978,nLin+nEspaco,1173+nAj_G+nAj},oBrush1)
					//
					oPrint:Say(nLin+20, 170,"FRETE"   ,oFont3,,CLR_WHITE)
					oPrint:Say(nLin+20, 427,"SEGURO"  ,oFont3,,CLR_WHITE)
					oPrint:Say(nLin+20, 620,"DESPESAS",oFont3,,CLR_WHITE)
					oPrint:Say(nLin+20, 850,"IPI"     ,oFont3,,CLR_WHITE)
					oPrint:Say(nLin+20,1020,"OUTROS"  ,oFont3,,CLR_WHITE)
					                                          
					// Quadro do Total do Pedido
					oPrint:FillRect({nLin+20,1709+nAj_G+nAj+nDif,nLin+nEspaco+160,2320},oBrush2)   // 140
					oPrint:Say(nLin+50,1420,"VALOR TOTAL PEDIDO"  ,oFont3)
					oPrint:Say(nLin+40,2180, Transform(nTotal   ,"@E 9,999,999.99"),oFont2,,,,1)	
				endif
				nLin+=nEspaco

                if pTipo='I'
					// Quadro de Dados
					oPrint:Box(nLin, 70,nLin+nEspaco,377)
					oPrint:Box(nLin,377,nLin+nEspaco,577)
					oPrint:Box(nLin,577,nLin+nEspaco,777)
					oPrint:Box(nLin,777,nLin+nEspaco,977)
					oPrint:Box(nLin,977,nLin+nEspaco,1172+nAj_G+nAj)
					// Dados
					oPrint:Say(nLin+20, 200, Transform(nFrete   ,"@E 9,999.99")    ,oFont3)
					oPrint:Say(nLin+20, 447, Transform(nSeguro  ,"@E 9,999.99")    ,oFont3)
					oPrint:Say(nLin+20, 640, Transform(nDespesas,"@E 9,999.99")    ,oFont3)
					oPrint:Say(nLin+20, 860, Transform(nValIPI  ,"@E 9,999.99")    ,oFont3)
					oPrint:Say(nLin+20,1040, Transform(nOutros  ,"@E 9,999.99")    ,oFont3)
				endif
				nLin+=nEspaco

                if pTipo='I'
					// Quadro de Descontos
					oPrint:Box(nLin, 70,nLin+nEspaco,377)
					oPrint:FillRect({nLin,70,nLin+nEspaco,377},oBrush1)
					oPrint:Box(nLin,377,nLin+nEspaco,777)
					oPrint:Say(nLin+20, 100,"DESCONTO"   ,oFont3,,CLR_WHITE)
					oPrint:Say(nLin+20, 640, Transform(nDesconto,"@E 9,999.99")    ,oFont3)
					oPrint:Say(nLin,1420,"VALOR TOTAL LIQUIDO"  ,oFont3)
					oPrint:Say(nLin,2180, Transform(nTotNF   ,"@E 9,999,999.99"),oFont2,,,,1)	
                endif
                //nLin += 50
				nLin += 100
				if pTipo = 'I'                                      
					oPrint:FillRect({nLin, 070,(nLin+nEspaco)-10,2321},oBrush1)
					oPrint:Say(nLin+20,  1100,"OBSERVA��O"  ,oFont5b,,CLR_WHITE)
				endif 
			    // Carrega Observa��es
			    aObsProd := TrataMemo(cObsPed, 115)
				nLin += 70
				//if pTipo = 'I'
				//	oPrint:Box(nLin-20,  070, nLin+150,2320)  
				//	oPrint:Say(nLin   ,  100,  '' , oFont5b)
				//endif     
				xnLin := nLin
			    FOR  nxReg := 1 TO LEN(aObsProd)
					if pTipo = 'I'
						oPrint:Say(nLin,090,aObsProd[nxReg][1],oFont4)
						nLin += 50
		   			endif
				
	    		NEXT
				oPrint:Box(xnLin-20, 070,nLin+nEspaco, 2320)
				
				//If nLin > nMaxLin
				ImpRodape(nLin, nEspaco, nAj_G, nAj, nDif, pTipo)
				//ImpCabec(2, pTipo)
				//ImpObservacoes(nLin, nEspaco, nAj_G, nAj, nDif, pTipo, _cFilial)

				nLin := 8000
				
			EndIf
			
			TRB->(DbSkip())
		Enddo
	Else
		Aviso("Aviso","N�o Existem dados a Serem Impressos, nos parametros Informados...",{"Ok"},2)
	EndIf

	If Select("TRB") > 0
		TRB->(dbCloseArea())
	EndIf

	If lExist         
		if pTipo = 'I'
			oPrint:Preview()
		endif
	EndIf

Return Nil
                        


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ImpCabec  �Autor  �Valdemir Jos�       � Data �  05/05/12   ���
�������������������������������������������������������������������������͹��
���Desc.     � Cabe�alho do Pedido de Compra                              ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � CCAB                                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function ImpCabec(pxTipo, pTipo)
	Local nProw := 200
	//-Local cLogo	:= FisxLogo("1")
	Local cLogo := '\system\Logo01.BMP'
	Local cPrazo    
	Local cObs01 := ''
	Local _cTipo := ''
	
	if pTipo = 'I'
		If nPagina > 0
			oPrint:EndPage()
			oPrint:StartPage()
	    EndIf 
	else
	    nTotPag ++
    Endif
	nPagina ++
            
	nLin := 1080                        //800
	
	cPrazo := Posicione('SE4',1,xFilial('SE4')+SC7->C7_COND,"SE4->E4_DESCRI")

	if pTipo = 'I'
		If cEmpAnt == "02"
			oPrint:SayBitmap(070,070,cLogo,360,150)
		Else
			oPrint:SayBitmap(070,070,cLogo,560,245)         //070,070,cLogo,340,295)
			//oPrint:SayBitmap(070,070,cLogo,220,175)         //070,070,cLogo,340,295)
		EndIf
		oPrint:Say(nProw,  950, "PEDIDO DE COMPRA",oFont0)		// 1350
		oPrint:Say(nProw, 2080, "N� "+cPedido ,oFontT)          //SC7->C7_NUM
	Endif	                                          
	nProw +=  150 //210                       
	  
	if pTipo = 'I'
		// Quadros [Solicita��o, Cota��o, Data
		//oPrint:Box(nProw, 070,nProw+50,550)       // Solicita��o
		//oPrint:Box(nProw,1000,nProw+50,1460)      // Cota��o
		oPrint:Box(nProw,1760,nProw+50,2320)      // Data
		oPrint:Line(nProw, 2110, nProw+50, 2110)  // Divis�o
	endif
	nProw += 10
	if pTipo = 'I'
		//oPrint:Say(nProw,100, "N� SOLICITA��O",oFont5)
		//oPrint:Say(nProw,400, cNumSC   ,oFont5b)
	
		//oPrint:Say(nProw,1040, "N� COTA��O"   ,oFont5)
		//oPrint:Say(nProw,1310, cNumCOT ,oFont5b)
	    
		oPrint:Say(nProw,1800, "DATA"   ,oFont5)
		oPrint:Say(nProw,1930, DTOC(dEMISSAO),oFont5b)
	
		oPrint:Say(nProw,2140, "PAGINA"             , oFont5)
		oPrint:Say(nProw,2240, ALLTRIM(STR(nPagina)+" / "+Alltrim(Str(nTotPag))), oFont5b)
    endif             
    
    // Posicionando Forneedor
	DbSelectarea("SA2")
	SA2->(DbSetorder(1))
	SA2->(DbSeek(xFilial("SA2") + cFornece + cLojaFor))
	
	nProw += 50
	if pTipo = 'I'
		oPrint:Box(nProw, 070,nProw+50,2320)  // Dados Fornecedores
		oPrint:FillRect({nProw,070,nProw+nEspaco,2320},oBrush1)

		oPrint:Say(nProw+20,1020, "D A D O S   D O   F O R N E C E D O R"   ,oFont5b,,CLR_WHITE)
	endif
	nProw += 50
	if pTipo = 'I'
		oPrint:Box(nProw, 070,nProw+(5*50),2320)  
	endif
	nProw += 40                                            
	// Campos
	if pTipo = 'I'
		oPrint:Say(nProw, 100, "CODIGO:"             , oFont5)
		oPrint:Say(nProw, 340, "LOJA:"               , oFont5)
		oPrint:Say(nProw, 600, "RAZ�O SOCIAL:"       , oFont5)
		oPrint:Say(nProw,1840, "CONTATO:"            , oFont5)
		// Dados
		oPrint:Say(nProw, 240, SA2->A2_COD           , oFont5b)
		oPrint:Say(nProw, 440, SA2->A2_LOJA          , oFont5b)
		oPrint:Say(nProw, 850, SA2->A2_NOME          , oFont5b)
		oPrint:Say(nProw,1990, SA2->A2_CONTATO       , oFont5b)
	endif
	nProw += 60    
	// Campos
	if pTipo = 'I'
		oPrint:Say(nProw, 100, "ENDERE�O:"           , oFont5)
		oPrint:Say(nProw,1020, "TELEFONE:"           , oFont5)
		oPrint:Say(nProw,1440, "FAX:"                , oFont5)
		oPrint:Say(nProw,1840, "E-MAIL:"             , oFont5)
		// Dados
		oPrint:Say(nProw, 290, SA2->A2_END                     , oFont5b)
		oPrint:Say(nProw,1210, "("+SA2->A2_DDD+") "+SA2->A2_TEL, oFont5b)               
		oPrint:Say(nProw,1540, "("+SA2->A2_DDD+") "+SA2->A2_FAX, oFont5b)
		oPrint:Say(nProw,1970, LOWER(SA2->A2_EMAIL)            , oFont5b)
	endif
	nProw += 60                         
	// Campos
	if pTipo = 'I'
		oPrint:Say(nProw, 100, "BAIRRO:"             , oFont5)
		oPrint:Say(nProw, 800, "CIDADE:"             , oFont5)
		oPrint:Say(nProw,1210, "UF:"                 , oFont5)
		oPrint:Say(nProw,1440, "CNPJ:"               , oFont5)
		oPrint:Say(nProw,1840, "I.E.:"               , oFont5)
		// Dados
		oPrint:Say(nProw, 240, SA2->A2_BAIRRO        , oFont5b)
		oPrint:Say(nProw, 900, SA2->A2_MUN           , oFont5b)
		oPrint:Say(nProw,1290, SA2->A2_EST           , oFont5b)
		oPrint:Say(nProw,1540, SA2->A2_CGC           , oFont5b)
		oPrint:Say(nProw,1900, SA2->A2_INSCR         , oFont5b)
	endif
	if pxTipo = 1
		nProw += 100
		if pTipo = 'I'
			oPrint:Box(nProw, 070,nProw+50,2320)  // Dados Fornecedores
			oPrint:FillRect({nProw,070,nProw+nEspaco,2320},oBrush1)
			oPrint:Say(nProw+20,1000, "D A D O S   P A R A   F A T U R A M E N T O"   ,oFont5b,,CLR_WHITE)
		endif
		nProw += 50
		if pTipo = 'I'
			oPrint:Box(nProw, 070,nProw+(4*50),2320)  
		endif
		nProw += 40                                            	
		dbSelectArea('SM0')
		// Campos
		if pTipo = 'I'
			oPrint:Say(nProw, 100, "RAZ�O SOCIAL:"             , oFont5)
			oPrint:Say(nProw,1000, "ENDERE�O:"                 , oFont5)
			oPrint:Say(nProw,1800, "BAIRRO:"                   , oFont5)
			// Dados
			oPrint:Say(nProw, 330, SM0->M0_NOMECOM             , oFont5b)
			oPrint:Say(nProw,1200, SM0->M0_ENDCOB              , oFont5b)
			oPrint:Say(nProw,1990, SM0->M0_BAIRCOB             , oFont5b)
		Endif
		nProw += 50
		if pTipo = 'I'
			oPrint:Say(nProw, 100, "MUNIC�PIO:"                , oFont5)
			oPrint:Say(nProw, 750, "UF:"                	   , oFont5)
			oPrint:Say(nProw,1080, "CEP:" 			           , oFont5)
			oPrint:Say(nProw,1670, "CNPJ:"  		           , oFont5)
			oPrint:Say(nProw,2100, "I.E.:"  		           , oFont5)
			// Dados
			oPrint:Say(nProw, 280, SM0->M0_CIDCOB              , oFont5b)
			oPrint:Say(nProw, 850, SM0->M0_ESTCOB              , oFont5b)
			oPrint:Say(nProw,1180, SM0->M0_CEPCOB              , oFont5b)
			oPrint:Say(nProw,1770, SM0->M0_CGC                 , oFont5b)
			oPrint:Say(nProw,2150, SM0->M0_INSC                , oFont5b)
		endif
		nProw += 50
		if pTipo = 'I'
			oPrint:Say(nProw, 100, "TELEFONE:"                , oFont5)
			oPrint:Say(nProw, 750, "FAX:"                	   , oFont5)
			// Dados
			oPrint:Say(nProw, 280, SM0->M0_TEL               , oFont5b)
			oPrint:Say(nProw, 850, SM0->M0_FAX               , oFont5b)
		endif

		nProw += 80
		if pTipo = 'I'                                      
			//oPrint:Box(nProw,  070,nProw+50,1668)  
			oPrint:FillRect({nProw, 070,(nProw+nEspaco)-10,1668},oBrush1)
			//oPrint:Box(nProw, 1670,nProw+50,2320)          
			oPrint:FillRect({nProw,1670,(nProw+nEspaco)-10,2321},oBrush1)
			
			oPrint:Say(nProw+20,  800,"PARCELAS  /  VENCIMENTOS"  ,oFont5b,,CLR_WHITE)
			oPrint:Say(nProw+20, 1880,"PRAZO DE PAGAMENTO",oFont5b,,CLR_WHITE)
		endif	
		nProw += 70
		if pTipo = 'I'
			oPrint:Box(nProw-20,  070, nProw+50,1670)  
			oPrint:Box(nProw-20, 1670, nProw+50,2320)  
			oPrint:Say(nProw,  100, SC7->C7_XVENCTO       , oFont5b)
			oPrint:Say(nProw, 1920, alltrim(cPrazo)        , oFont5b)
		endif
		nProw += 70
		if pTipo = 'I'                                      
			//oPrint:Box(nProw,  070,nProw+50,1668)  
			oPrint:FillRect({nProw, 070,(nProw+nEspaco)-10,2321},oBrush1)
			//oPrint:Box(nProw, 1670,nProw+50,2320)          
			//oPrint:FillRect({nProw,1670,(nProw+nEspaco)-10,2321},oBrush1)
			
			oPrint:Say(nProw+20,  1100,"LOCAL DE ENTREGA"  ,oFont5b,,CLR_WHITE)
		endif	
		nProw += 70
		if pTipo = 'I'
			oPrint:Box(nProw-20,  070, nProw+50,2320)  
			//oPrint:Box(nProw-20, 1670, nProw+50,2320)  
			oPrint:Say(nProw,  100, ALLTRIM(SM0->M0_ENDENT)+" - "+ALLTRIM(SM0->M0_COMPENT)+" - "+ALLTRIM(SM0->M0_BAIRENT)+" - "+ALLTRIM(SM0->M0_CIDENT)+' - '+ALLTRIM(SM0->M0_CEPENT)+" - "+ALLTRIM(SM0->M0_ESTENT)  , oFont5b)
		endif
		nProw += 70
		if pTipo = 'I'                                      
			oPrint:Box(nProw,  070,nProw+50,1567)  
			oPrint:Box(nProw, 1570,nProw+50,2320)    
			oPrint:Box(nProw+20, 1569,nProw+50,1569)    
			      
			oPrint:FillRect({nProw,070 ,(nProw+nEspaco)-10,1567},oBrush1)
			oPrint:FillRect({nProw,1570,(nProw+nEspaco)-10,2321},oBrush1)
			
			oPrint:Say(nProw+20, 850,"OBSERVA��O TAXA"  ,oFont5b,,CLR_WHITE)
			oPrint:Say(nProw+20, 1850,"TIPO LAN�AMENTO",oFont5b,,CLR_WHITE)
		endif	                                

		_CTIPO := ''            		// Acrescentado por Valdemir Jose 30/01/2013   
		IF SC7->C7_XENCC <> 'N'                                                             
		 _CTIPO := IF(SC7->C7_XENCC='E','ENC','CAP')
		ENDIF
		 
		cObs01    := ''
		IF !EMPTY(_cTIPO)				// Acrescentado por Valdemir Jose 30/01/2013
			cObs01 := if(_CTIPO='CAP',_CTIPO+'-Contra Apresenta��o',_CTIPO+'-Encontro de Contas ')+' Data: '+dtoc(SC7->C7_XDTENCC)
		ENDIF
		
		nProw += 70
		if pTipo = 'I'
			oPrint:Box(nProw-20,  070, nProw+50,2320)  
			oPrint:Box(nProw-20, 1569, nProw+50,1569)    
			oPrint:Say(nProw,  100, SC7->C7_XOBS  , oFont5b)
			oPrint:Say(nProw, 1670, cObs01         , oFont5b)
		endif
		
	else
		nLin := nProw+70
	endif
    
Return Nil
                        



//��������������������������������������������������������Ŀ
//� FUNCTION MONTAQUERY (FAZ A SELECAO DOS REGISTROS)      �
//����������������������������������������������������������
Static Function MONTAQUERY(cPedDe, cPedAte, pcFilial)

	Local cQuery := ""

	cQuery := " SELECT	DISTINCT C7_NUM PEDIDO " +CRLF
	cQuery += "	FROM 	"+RetSqlname("SC7")	+ CRLF
	cQuery += " WHERE	D_E_L_E_T_ = '' " 	+ CRLF
	cQuery += " 		AND C7_NUM BETWEEN '"+cPedDe+"' AND '"+cPedAte+"' " + CRLF
	cQuery += " 		AND C7_FILIAL = '"+pcFilial+"' " + CRLF

Return cQuery

     


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ImpRodape �Autor  �Valdemir Jos�       � Data �  09/05/12   ���
�������������������������������������������������������������������������͹��
���Desc.     � Assinatura dos aprovadores                                 ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Ferreira Guedes                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function ImpRodape(nLin, nEspaco, nAj_G, nAj, nDif, pTipo)
    Local aArea   := GetArea()
    Local nxLin   := 0    
    Local lLiber  := .F.
                  
    /*                 
	dbSelectArea('SC8')
	dbSetOrder(1)
	IF dbSeek(xFilial('SC8')+cNUMCOT)
		cComprador  := SC8->C8_XUSUANA      // Criar ponto de entrada aa analise de cota��o e gravar o cUserName em algum campo especifico.
    ENDIF
	*/
	cComprador := UsrFullName(SC7->C7_USER)
	If SC7->C7_CONAPRO != "B"
		lLiber := .T.
	EndIf

    //nLin += 50
    nLin := 2900
    if pTipo = 'I'
		oPrint:FillRect({nLin,   70, nLin+nEspaco, 639},oBrush1)
		oPrint:FillRect({nLin,  642, nLin+nEspaco, 1516+nAj_G+nAj+nDif-2},oBrush1)
		oPrint:FillRect({nLin, 1516+nAj_G+nAj+nDif+2,nLin+nEspaco,2321},oBrush1)	
        //
		oPrint:Say(nLin+20, 180,"COMPRA EFETUADA POR"      ,oFont3,,CLR_WHITE)
		oPrint:Say(nLin+20, 850,"APROVA��O FERREIRA GUEDES",oFont3,,CLR_WHITE)
		oPrint:Say(nLin+20,1800,"ACEITE FORNECEDOR"        ,oFont3,,CLR_WHITE)
	endif
	//
    nLin += nEspaco
    if pTipo = 'I'
		oPrint:Box(nLin, 070,nLin+nEspaco+170, 640)          //20
		oPrint:Box(nLin, 640,nLin+nEspaco+170, 1516+nAj_G+nAj+nDif)    //20
		oPrint:Box(nLin, 1516+nAj_G+nAj+nDif, nLin+nEspaco+170,2320)    //20
	endif
	nLin += 10
    if pTipo = 'I'
			oPrint:Say(nLin, 180,cComprador ,oFont3)            
		/*
	    dbSelectArea('SY1')                      
	    dbSetOrder(3)
	    If dbSeek(xFilial('SY1')+cComprador)
			oPrint:Say(nLin, 180,SY1->Y1_NOME  ,oFont3)            
			nLin += 20
			oPrint:Say(nLin, 180,SY1->Y1_EMAIL ,oFont3)
			nLin += 20
			oPrint:Say(nLin, 180,SY1->Y1_TEL   ,oFont3)
		else        
			nLin += 40
		Endif
		*/
	endif

	nxLin := (nLin-60)

	// Posiciona Aprovadores
	cQuery := QueryAprov(cPedido)	
	
	If Select("TAPROV") > 0
		TAPROV->(dbCloseArea())
	EndIf
    Memowrite('QryAprov', cQuery)
	DbUseArea(.T., "TopConn", TCGenQry( NIL, NIL, cQuery), "TAPROV", .F., .F.)
    TAPROV->(dbGoTop())

	//
	Do While TAPROV->( !EOF() )
	
       if pTipo = 'I'                  
			oPrint:Say(nxLin+20, 840,TAPROV->AK_NOME	   ,oFont3)
			oPrint:Say(nxLin+20,1400,DTOC(STOD(TAPROV->CR_DATALIB)) ,oFont3)
	   endif

	   nxLin += 40
	         
	    TAPROV->( dbSkip() )
	ENDDO

   if pTipo = 'I'                  
     IF !lLiber
     	oPrint:Say(nxLin+60, 840, IF(lLiber,"P E D I D O   L I B E R A D O", "P E D I D O   B L O Q U E A D O !!!"),oFont4)
	    nxLin += 40
     ENDIF
   ENDIF	   
	
	TAPROV->(dbCloseArea())
		
    RestArea( aArea )
    
Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ImpObservacoes �Autor  �Valdemir Jose  � Data �  09/05/12   ���
�������������������������������������������������������������������������͹��
���Desc.     � Imprime as Duas Observa��es Pedido e Tabela de             ���
���          � Condi��es Gerais                                           ���
�������������������������������������������������������������������������͹��
���Uso       � Ferreiga Guedes                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function ImpObservacoes(nLin, nEspaco, nAj_G, nAj, nDif,pTipo,pcFilial)
	Local aCGerais   := {}
	Local nxReg      := 0
	Local bEncontrou := .f.
	LOCAL aObsProd   := {}
	Local nLinInic   := 0
	
	DbSelectarea("SC7")
	SC7->(DbSetorder(1))
	bEncontrou := SC7->(Dbseek(pcFilial + cPedido))

	// Prepara Informa��es de Condi��es Gerais
	aCGerais := MontaCondGeral()                           
	if Len(aCGerais) > 0
		For nxReg := 1 To Len(aCGerais)
			nLin := nLin + 50
			if nxReg = 1                                       
				if pTipo = 'I'
					oPrint:FillRect({nLin,   70, nLin+nEspaco, 2320},oBrush1)
					oPrint:Say(nLin+20, 1020,"C O N D I � � E S  G E R A I S"   ,oFont3,,CLR_WHITE)
				endif
				nLin += 70 
			Endif
			if pTipo = 'I'
				oPrint:Box(nLin, 070,nLin+nEspaco, 070)
				oPrint:Say(nLin, 090,aCGerais[nxReg][1],oFont4)	                          
				oPrint:Box(nLin,2318,nLin+nEspaco,2318)
			endif
			If nLin > nMaxLin
				ImpRodape(nLin, nEspaco, nAj_G, nAj, nDif, pTipo)
				ImpCabec(2,pTipo) 
			EndIf
		Next
		nLin += 70              
		if pTipo = 'I'
			oPrint:Box(nLin, 070,nLin, 2318)
		endif
	Endif 
	
	//Posiciona Novamente no pedido p/ Imprimir Observacoes        
	// MSMM(cCodObs)
	If bEncontrou
      	
	   cMEMO    := ''//MSMM(SC7->C7_XCODOBS)
	   aObsProd := TrataMemo(cMEMO, 115)

		nLin := nLin + 30
		nLinInic   := nLin
		if pTipo = 'I'
			oPrint:FillRect({nLin,   70, nLin+nEspaco, 2319},oBrush1)
			oPrint:Say(nLin+20, 1040,"O B S E R V A � � E S"   ,oFont3,,CLR_WHITE)
			oPrint:Box(nLin, 070,nMaxLin+150, 2319)
		endif
		nLin += 70   

	    FOR  nxReg := 1 TO LEN(aObsProd)
		
			If nLin > nMaxLin
				ImpRodape(nLin, nEspaco, nAj_G, nAj, nDif, pTipo)
				ImpCabec(2, pTipo) 
				nLin := nLin + 30
				if pTipo = 'I'
					oPrint:FillRect({nLin,   70, nLin+nEspaco, 2319},oBrush1)
					oPrint:Say(nLin+20, 1040,"O B S E R V A � � E S"   ,oFont3,,CLR_WHITE)
					oPrint:Box(nLinInic, 070,nMaxLin+150, 2419)
				endif
			   //	nLin += 70   
			EndIf                
			nLin += 70   
			if pTipo = 'I'
				oPrint:Box(nLin, 070,nLin+nEspaco, 070)
				oPrint:Say(nLin,090,aObsProd[nxReg][1],oFont4)
       				oPrint:Box(nLin,2318,nLin+nEspaco,2318)
   			endif
		
		NEXT
		IF Len(aObsProd) > 0
			nLin := nLin + 70
			if pTipo = 'I'
				oPrint:Box(nLinInic, 070,nMaxLin+150, 2318)
			endif
		ENDIF
	EndIf                     
	
	ImpRodape(nLin-10, nEspaco, nAj_G, nAj, nDif, pTipo)
 

Return

        
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FER052    �Autor  �Valdemir Jos�       � Data �  14/05/12   ���
�������������������������������������������������������������������������͹��
���Desc.     � Monta Condi��es Gerais                                     ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Ferreira Guedes                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function MontaCondGeral()
	Local aRET     := {}
	Local aObsProd := {}           
	Local iseq     := 0
	Local nX       := 0
	Local aArea:= GetArea()
/*
	Local cQry := "SELECT * "+cENTER
	 
	if Select('TMPX') > 0
	 TMPX->( dbCloseArea() )
	endif
	cQry += "FROM "+RETSQLNAME("ZZ6")+" ZZ6 "+cENTER
	cQry += " WHERE ZZ6.D_E_L_E_T_=' '		"+cENTER
	cQry += "  AND ZZ6.ZZ6_COD IN "+FormatIn(RemoveCaracter(SC7->C7_XREGRA),",")+" "+cENTER
	cQry += "ORDER BY ZZ6.ZZ6_COD"+cENTER
	// 
	Memowrite("CondicoesGerais.SQL",cQry)
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQry),"TMPX",.T.,.T.)
	
	dbSelectArea("TMPX")
	
	Do While !Eof()           
	    iseq++
		aObsProd := TrataMemo(StrZero(iseq,3)+'. '+TMPX->ZZ6_DESC, 115)
		if Len(aObsProd) > 1
		  For nX := 1 To Len(aObsProd)
			aAdd(aRET,aObsProd[nX])
		  Next
		else
			aAdd(aRET,{StrZero(iseq,3)+'. '+TMPX->ZZ6_DESC})
		endif
		dbSkip()
	EndDo
	              
	TMPX->( dbCloseArea() )
	RestArea( aArea )
*/	
Return aRET

      

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RemoveCaracter   �Autor  �Valdemir Jose� Data �  15/05/12   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function RemoveCaracter(pString)
Local cRET := ''
Local nX

For nX := 1 To Len(pString)
 if Substr(pString,nX,1) <> "'"
 	cRET += Substr(pString,nX,1)   
 Endif
Next

Return Alltrim(cRET)




/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FER052    �Autor  �Valdemir Jos�       � Data �  14/05/12   ���
�������������������������������������������������������������������������͹��
���Desc.     � Atualiza Campo C7_XOBSPED                                  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function GetObsPed(pcPedido, pcXOBSPED)
	Local aArea := GetArea()      

	//��������������������������������������������������������������Ŀ
	//� Grava a descricao do metodo no campo memo do Siga (SYP).     �
	//����������������������������������������������������������������
    dbSelectArea('SC7')
	SC7->( dbSetOrder(1) )
	SC7->( MsSeek(xFilial("SC7") + pcPedido))
	RECLOCK('SC7',.F.)	
	SC7->C7_XOBSPED := pcXOBSPED
	MSUNLOCK()
	
	RestArea( aArea )                       

Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FER052    �Autor  �Valdemir Jos�       � Data �  16/05/12   ���
�������������������������������������������������������������������������͹��
���Desc.     � Imprime Observa��es no corpo do pedido de venda            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Ferreira Guedes                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function ImprimeObs(oPrint, cMemo, nLin, nEspaco, nDif, nAj_G, nAj,pTipo)
Local aObsProd := TrataMemo(cMemo, 50, 'P')
Local nX := 0

	// Impress�o das colunas gr�ficas do corpo do pedido
	if pTipo = 'I'
		ImprimeColunas(oPrint, cMemo, nLin, nEspaco, nDif, nAj_G, nAj) 
	Endif
	nLin += 30
	For nX := 1 To Len(aObsProd)                        
		// Faz impress�o da Observa��o com colunas
		if pTipo = 'I'
		  ImprimeColunas(oPrint, cMemo, nLin, nEspaco-10, nDif, nAj_G, nAj) 
		  oPrint:Say(nLin+nDif,417+nAj_G,aObsProd[nX][1]        ,oFont3)  
		endif
		nLin += 30
	Next           
  
    nLin += 10
	
Return nLin


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FER052    �Autor  �Valdemir Jos�       � Data �  16/05/12   ���
�������������������������������������������������������������������������͹��
���Desc.     � Imprime as colunas do Pedido de Compra                     ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function ImprimeColunas(oPrint, cMemo, nLin, nEspaco, nDif, nAj_G, nAj) 
                                                          				
	// Colunas da Esquerda
	oPrint:Box(nLin,070,nLin+nEspaco,070)    	 				  // Item
	oPrint:Box(nLin,153,nLin+nEspaco,153)  						  // Produto
	oPrint:Line(nLin,397+nAj_G,nLin+nEspaco,397+nAj_G)  		  // Descri��o
  	oPrint:Line(nLin,1075+nAj_G,nLin+nEspaco,1075+nAj_G)  		  // Quantidade
	oPrint:Line(nLin,1172+nAj_G+nAj,nLin+nEspaco,1172+nAj_G+nAj)  // Unidade Medida
	oPrint:Line(nLin,1246+nAj_G+nAj,nLin+nEspaco,1246+nAj_G+nAj)  // Pre�o Unit�rio
	oPrint:Line(nLin,1349+nAj_G+nAj+nDif,nLin+nEspaco,1349+nAj_G+nAj+nDif)  // Desconto
	oPrint:Line(nLin,1423+nAj_G+nAj+nDif,nLin+nEspaco,1423+nAj_G+nAj+nDif)  // Valor Desconto
	oPrint:Line(nLin,1516+nAj_G+nAj+nDif,nLin+nEspaco,1516+nAj_G+nAj+nDif)  // IPI
	oPrint:Line(nLin,1600+nAj_G+nAj+nDif,nLin+nEspaco,1600+nAj_G+nAj+nDif)  // Valor IPI
	oPrint:Line(nLin,1709+nAj_G+nAj+nDif,nLin+nEspaco,1709+nAj_G+nAj+nDif)  // Valor Unit c/ Desconto
	oPrint:Line(nLin,1891+nAj_G+nAj+nDif,nLin+nEspaco,1891+nAj_G+nAj+nDif)  // Valor Total
	oPrint:Line(nLin,2093+nDif,nLin+nEspaco,2093+nDif)  					// Data Entrega
	oPrint:Line(nLin,2320,nLin+nEspaco,2320)            					// Ultima linda da coluna a direita

Return




/*
������������������������������������������������������������������������������������������
������������������������������������������������������������������������������������������ 
��������������������������������������������������������������������������������������ͻ��
���Programa  �FER052    �Autor  �Valdemir Jos�                      � Data �  15/05/12 ���
��������������������������������������������������������������������������������������͹�� 
���Desc.     �  Esta funcao trata a informacao contida em um campo memo, respeitando a ���
���          �  quebra de linha e o numero de caracteres por linha.                    ���
���          �  Retorna um array com as informacoes para impressao.                    ��� 
��������������������������������������������������������������������������������������͹��
���Uso       � Ferreira  Guedes                                                        ���
��������������������������������������������������������������������������������������ͼ�� 
������������������������������������������������������������������������������������������
���������������������������������������������em ���������������������������������������������
*/
Static Function TrataMemo(cMsg, nTotCarac, pTipo)
Local aLinQuebra := {} 
Local aLinMemo   := {}   
Local aRET       := {}

aLinQuebra := VerificaQuebra(cMsg, nTotCarac)

aLinMemo   := VerificaQtdCarac(nTotCarac, aLinQuebra)   

if !Empty(SC7->C7_CC)
    if pTipo = 'P'                            
	   aAdd(aLinMemo,{'C.C.: '+SC7->C7_CC})
	Endif
Endif

aRET := aLinMemo

// Retorna o array contendo as linhas para impressao
Return aRET

           

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FER052    �Autor  �Valdemir Jos�       � Data �  16/05/12   ���
�������������������������������������������������������������������������͹��
��� Desc.     � Esta funcao verifica somente se existe a quebra de pagina,���
��� sendo que a cada quebra e adicionado uma posicao nova no			  ���
��� array																  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Ferreira Guedes                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function VerificaQuebra(cMsg, nTotCarac)
Local aLinQuebra := {}
Local nPosIni := 0
Local nPosFim := 0
Local nPosIniSo := 0
Local nPosFimSo := 0 
Local nPosCarac := 0
Local cMsgCort := ''
Local cMsgSobra := ''
Local nTamMsg := 0

// Muda a quebra de linha para o caracter # na string inteira
cMsg := AllTrim(StrTran(cMsg, Chr(13)+Chr(10), '#' )) 

cMsgSobra := cMsg

While Len(cMsgSobra) > 0
    
    // Pega a quantidade de caracteres da mensagem
    nTamMsg := Len(cMsgSobra)

    // Busca a posicao do caracter #
    nPosCarac := At('#',cMsgSobra) 
    
    // Se encontrar o caracter # adiciona ao array a mensagem cortada conforme o numero de caracteres informado no parametro
    If nPosCarac > 0
    
        nPosIni := 1
        nPosFim := nPosCarac - 1 
        
        // Corta a mensagem de acordo com a posicao inicial e final
        cMsgCort := SubStr(cMsgSobra,nPosIni,nPosFim)
        
        // Adiciona a informacao ao array
        Aadd(aLinQuebra, {cMsgCort}) 
        
        // Faz o calculo da posicao inicial e final para pegar a sobra da mensagem que ainda nao foi cortada
        nPosIniSo := nPosCarac + 1
        nPosFimSo := (nTamMsg - Len(cMsgCort)) - 1
         
        // Pega a sobra da mensagem que ainda nao foi cortada
        cMsgSobra := SubStr(cMsgSobra, nPosIniSo, nPosFimSo)
    
    Else
        
        // Senao encontrar o caracter # adiciona a sobra da mensagem no array 
        Aadd(aLinQuebra, {cMsgSobra})
        
        // Limpa a variavel para sair do loop
        cMsgSobra := ''

    EndIf

EndDo

Return aLinQuebra


/*
������������������������������������������������������������������������������������
������������������������������������������������������������������������������������
��������������������������������������������������������������������������������ͻ��
���Programa  �FER052    �Autor  �Valdemir Jos�              � Data �  16/05/12   ���
��������������������������������������������������������������������������������͹��
���Desc.     � Apos ter sido verificado a quebra de pagina, agora e verificado a ���
���          � quantidade de caracteres por posicao do array, sendo que cada     ���
���          � posicao deve respeitar o numero de caracteres informado pelo      ���
���          � parametro														 ���
���          �                                                            		 ���
��������������������������������������������������������������������������������͹��
���Uso       � Ferreira Guedes                                                   ���
��������������������������������������������������������������������������������ͼ��
������������������������������������������������������������������������������������
������������������������������������������������������������������������������������
*/
Static Function VerificaQtdCarac(nTotCarac, aLinQuebra)

Local aLinMemo := {}
Local nPosIni := 1
Local nPosIniLp := 0
Local nPosFimLp := 0 
Local cMsgCort := ''
Local nNumLoop := 0
Local y := 0
Local x := 0
Local cMsgSobra := ''
Local nTamMsg := 0

For y := 1 To Len(aLinQuebra)

    // Se a quantidade de caracteres for maior que a quantidade passada pelo paramentro entao corta a mensagem 
    If Len(aLinQuebra[y][1]) > nTotCarac
        nNumLoop := Iif((Len(aLinQuebra[y][1]) % nTotCarac) == 0, Len(aLinQuebra[y][1]) / nTotCarac, Int(Len(aLinQuebra[y][1]) / nTotCarac) + 1) // Arredonda para mais sempre 
        nPosIniLp := 1
        nPosFimLp := nTotCarac
        cMsgSobra := aLinQuebra[y][1]
        
        For x := 1 To nNumLoop
            nTamMsg := Len(cMsgSobra) // Pega a quantidade de caracteres que sobraram 
            cMsgCort := SubStr(cMsgSobra, nPosIni, nTotCarac) // Corta a mensagem
            Aadd(aLinMemo, {cMsgCort}) // Adiciona a mensagem cortada ao array
            nPosIniLp := nPosFimLp + 1
            nPosFimLp := nPosIniLp + (nTotCarac - 1) 
            cMsgSobra := SubStr(aLinQuebra[y][1], nPosIniLp, (nTamMsg - Len(cMsgCort))) // Retira da string o conteudo que ja foi adicionado ao array
        Next x
    Else
        Aadd(aLinMemo, {aLinQuebra[y][1]}) // Senao houver a necessidade de cortar a mensagem novamente o conteudo e inserido direto no array 
    EndIf

Next y
    
Return aLinMemo 



                 
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FER052    �Autor  �Valdemir Jose       � Data �  20/06/12   ���
�������������������������������������������������������������������������͹��
���Desc.     � Monta Query de Aprovadores                                 ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function QueryAprov(pcPedido)
	Local cRet := ""
	
	cRET += "SELECT AK_NOME, CR_DATALIB FROM "+RETSQLNAME("SCR")+" SCR, "+RETSQLNAME('SAK')+" SAK "+cENTER
	cRET += "WHERE SCR.D_E_L_E_T_= ' ' AND SAK.D_E_L_E_T_= ' ' "+cENTER
	cRET += " AND SAK.AK_COD = SCR.CR_APROV "+cENTER
	cRET += " AND SCR.CR_NUM = '"+pcPedido+"' "+cENTER
	cRET += " AND SCR.CR_VALLIB > 0    "+cENTER
	cRET += " AND SCR.CR_DATALIB <> ' ' "+cENTER	
	cRET += "GROUP BY AK_NOME, CR_DATALIB"+cENTER	
	       

Return cRet




/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FER052    �Autor  �Valdemir Jos�       � Data �  04/07/12   ���
�������������������������������������������������������������������������͹��
���Desc.     � Imprime Titulo do pedido                                   ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function ImpTitulos(pTipo, oPrint, nLin, nEspaco, nDif, nAj, nAj_G, nAj_Cod)
                
	if pTipo = 'I'
	    nLin += 320
		oPrint:FillRect({nLin,070,nLin+nEspaco,149},oBrush1)
		oPrint:Say(nLin+nDif,080,"N�",oFont3,,CLR_WHITE)

		oPrint:FillRect({nLin,155,nLin+nEspaco,396+nAj_Cod},oBrush1)
		oPrint:Say(nLin+nDif,180,"COD.",oFont3,,CLR_WHITE)
		
		oPrint:FillRect({nLin,400+nAj_G,nLin+nEspaco,1074+nAj_G},oBrush1)
		oPrint:Say(nLin+nDif,417+nAj_G,"DESCRI��O",oFont3,,CLR_WHITE)
		
		oPrint:FillRect({nLin,1076+nAj_G,nLin+nEspaco,1187+nAj_G},oBrush1)
		oPrint:Say(nLin+nDif,1117+nAj_G,"QTD.",oFont3,,CLR_WHITE)
		
		oPrint:FillRect({nLin,1189+nAj_G,nLin+nEspaco,1246+nAj_G+nAj},oBrush1)
		oPrint:Say(nLin+nDif ,1214+nAj_G,"UN",oFont3,,CLR_WHITE)

		oPrint:FillRect({nLin,1248+nAj_G+nAj,nLin+nEspaco,1347+nAj_G+nAj+nDif},oBrush1)
		oPrint:Say(nLin+nDif ,1255+nAj_G+nAj+nDif,"UNIT",oFont3,,CLR_WHITE)

		oPrint:FillRect({nLin,1349+nAj_G+nAj+nDif,nLin+nEspaco,1515+nAj_G+nAj+nDif},oBrush1)
		oPrint:Say(nLin+nDif,1394+nAj_G+nAj+nDif,"DESC",oFont3,,CLR_WHITE)                           

		oPrint:FillRect({nLin,1517+nAj_G+nAj+nDif,nLin+nEspaco,1707+nAj_G+nAj+nDif},oBrush1)
		oPrint:Say(nLin+nDif,1580+nAj_G+nAj+nDif,"IPI",oFont3,,CLR_WHITE)

		oPrint:FillRect({nLin,1709+nAj_G+nAj+nDif,nLin+nEspaco,1888+nAj_G+nAj+nDif},oBrush1)
		oPrint:Say(nLin+nDif,1729+nAj_G+nAj+nDif,"VL UNIT LIQ",oFont3,,CLR_WHITE)

		oPrint:FillRect({nLin,1891+nAj_G+nAj+nDif,nLin+nEspaco,2091+nAj_G+nAj+nDif},oBrush1)
		oPrint:Say(nLin+nDif,1911+nAj_G+nAj+nDif,"VL TOTAL",oFont3,,CLR_WHITE)

		oPrint:FillRect({nLin,2094+nAj_G+nAj+nDif,nLin+nEspaco,2321},oBrush1)
		oPrint:Say(nLin+nDif,2113+nAj_G+nAj+nDif,"ENTREGA",oFont3,,CLR_WHITE)
    endif

	nLin := nLin + 70

Return nLin
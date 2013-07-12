#include "Protheus.ch"
#define cENTER CHR(13)+CHR(10)
#Define PAD_LEFT            0
#Define PAD_RIGHT           1
#Define PAD_CENTER          2
#Define FXZEROS             CHR(160)


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �BacaVal01 �Autor  �Valdemir Jose       � Data �  11/07/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Programa procura falhas na base de poder de terceiro       ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function BacaVal01()
	Local _Query    := ""                                                                        
	Local cNomeArq  := "BACALOG"
	Private aCabec  := {"FILIAL","CLIFOR","LOJA","PRODUTO","LOCAL","DOC","SERIE","QUANT","TES","PODER3","IDENT"}
	Private aCampos := {} 
	Private _cIdent := BuscaIdent()
	

	if MsgYesNo('Deseja Iniciar a verifica��o da Base')
		_Query := MontaQuery()
		Memowrite("BacaVal01.SQL",_Query)

		Processa( {|| U_QryExec(_Query, "TMP") },"Processando","Filtrando os Registros...")
		if TMP->( EOF() )
			MsgInfo('N�o existe registros a serem apresentados, para este filtro...  Por favor, verifique...')
			CursorArrow()
			TMP->( dbCloseArea() )	                                                                        
			Return
		Endif
		ProcessMessages()
		Processa( {|| AnalisReg("TMP") },"Processando","Analisando os Registros...")
		TMP->( dbCloseArea() )
		
	    if !EXISTDIR("C:\Temp")   
	    	nResult := MAKEDIR("C:\Temp")
	    Endif                                               
		
		ProcRegua(Len(aCampos))
		ProcessMessages()
		
		IF LEN(aCampos) > 0   
		cArqExcel := "C:\Temp\"+cNomeArq+".html"    
		u_CriaExcel(aCabec, aCampos, cArqExcel)
		ELSE 
			Alert('N�o encontrou diferen�a nos registros...')
		ENDIF
		CursorArrow()			
	endif

Return



/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �BACAVAL01 �Autor  �Microsiga           � Data �  07/11/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Analisa Registros e Adiciona os Registros ao Log           ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function AnalisReg(pAlias)                   
	Local nQtR    := 0
	Local nQtD    := 0
	Local cIdent  := ""
	Local aTmp    := {}   
	
	(pAlias)->( dbGotop() )	
	While !(pAlias)->( Eof() )
	    cIdent := (pAlias)->B6_IDENT
		nQtR   := 0
		nQtD   := 0
		aTMP   := {}
		While !(pAlias)->( Eof() ) .AND. (cIdent = (pAlias)->B6_IDENT)

			aAdd(aTMP,{ FXZEROS+(pAlias)->B6_FILIAL, (pAlias)->B6_CLIFOR, FXZEROS+(pAlias)->B6_LOJA, (pAlias)->B6_PRODUTO, (pAlias)->B6_LOCAL, (pAlias)->B6_DOC, (pAlias)->B6_SERIE, Transform((pAlias)->B6_QUANT,"@E 999,9999"), (pAlias)->B6_TES, (pAlias)->B6_PODER3, (pAlias)->B6_IDENT} )

			IF (pAlias)->B6_PODER3 = "R"
				nQtR := (pAlias)->B6_QUANT
			ELSE
				nQtD += (pAlias)->B6_QUANT
			ENDIF
			(pAlias)->( dbSkip() )              
		EndDo         
		// Verifica se foi existe registro a ser adicionado
		if (nQtR > 0) .OR. (nQtD > 0)                      
			if (nQtR = nQtD)         //(nQtR <> nQtD) 
			   For nX := 1 To Len(aTmp)
			   	   aAdd(aCampos, {aTmp[nX][1],aTmp[nX][2],aTmp[nX][3],aTmp[nX][4],aTmp[nX][5],aTmp[nX][6],aTmp[nX][7],aTmp[nX][8],aTmp[nX][9],aTmp[nX][10],aTmp[nX][11] })     
			   Next
		    Endif
		Endif
	EndDo

Return








/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �BACAVAL01 �Autor  �Microsiga           � Data �  07/11/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Monta Query para Filtrar os registros                      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function MontaQuery(pFILTRA)
	Local cRET := ""
	         
	cRET += "SELECT * FROM "+RETSQLNAME("SB6")+" SB6 "+cENTER
	cRET += "WHERE SB6.D_E_L_E_T_ = ' '"+cENTER 
	cRET += " AND SB6.B6_PRODUTO='H100.480.SC.008'"+cENTER     
	IF pFILTRA <> "N"
		cRET += " AND SB6.B6_IDENT IN ("+_cIdent+")"+cENTER
	ENDIF
	cRET += "ORDER BY B6_FILIAL, B6_PRODUTO, B6_IDENT, B6_PODER3"+cENTER

Return cRET




/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �BACAVAL01 �Autor  �Valdemir Jose       � Data �  07/12/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Filtra Ident que est� dando a diferen�a informada           ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function BuscaIdent()
	Local cRET := ""   
	Local _cDOC := '3559,7042,7228,7229,7230,7231,7232,7251,7252'
	
		_Query := MontaQuery("N")
		Memowrite("BacaVal02.SQL",_Query)

		Processa( {|| U_QryExec(_Query, "TMP2") },"Processando","Filtrando os Registros...")
		if TMP2->( EOF() )
			MsgInfo('N�o existe registros a serem apresentados, para este filtro...  Por favor, verifique...')
			CursorArrow()
			TMP2->( dbCloseArea() )	                                                                        
			Return
		Endif                 
		TMP2->( dbGotop() )
		While TMP2->(!Eof() )
			_xDOC := U_CortaDir(ALLTRIM(TMP2->B6_DOC),4)
		    if  (_xDOC $ _cDOC)
		    	IF !EMPTY(cRET)
		    	   cRET += ","
		    	ENDIF
		        cRET += "'"+TMP2->B6_IDENT+"'"
		    Endif  
			TMP2->( dbSkip() )
		EndDo 
		
		TMP2->( dbCloseArea() )
	
Return cRET




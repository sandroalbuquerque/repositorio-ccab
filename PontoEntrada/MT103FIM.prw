#include "Protheus.ch"
#Define cENTER      Chr(13) + Chr(10)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT103FIM  ºAutor  ³Valdemir Jose       º Data ³  14/02/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de Entrada para Atualizar o Financeiro, Referente a  º±±
±±º          ³ Data de Vencimento - Apos GRavacao                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CCAB                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MT103FIM()
Local nOpcao    := PARAMIXB[1] 		// Opção Escolhida pelo usuario no aRotina 
Local nConfirma := PARAMIXB[2] 		//
Local _cArea	:= GetArea()
Local _cQry     := ''
Local aVencto   := {}
Local lTrue     := .T.   
Local nI        := 1 
Local nCnt      := 0


	IF (!EMPTY(SD1->D1_PEDIDO)) .AND. (nConfirma = 1) .and. (nOpcao = 3 .or. nOpcao = 4)                                                           
	   lTrue     := (SC7->C7_NUM = SD1->D1_PEDIDO)      // Verifica se as tabelas estão posicionadas no mesmo registro
	   if !lTrue
	      SC7->( dbSetOrder(1) )
	      lTrue := SC7->( dbSeek(xFilial('SC7')+SD1->D1_PEDIDO) )
	   Endif   
	   // Gera uma Lista com vencimentos 
	   if lTrue
	      aVencto   := GeraVencto(SC7->C7_XVENCTO) 
	      if Len(aVencto)=0
	      	Return
	      endif
	   Endif  
	   
	   IF  "TMPSE2") > 0
	      TMPSE2->( dbCloseArea() )
	   ENDIF     
	   
		// Verifica Titulos Gerado
		_cQry += "SELECT * FROM "+RETSQLNAME('SE2')+" SE2 "+cENTER
		_cQry += "WHERE SE2.D_E_L_E_T_ = ' '         "+cENTER
		_cQry += " AND SE2.E2_NUM='"+SF1->F1_DOC+"'	 "+cENTER
		_cQry += " AND SE2.E2_PREFIXO = '"+SF1->F1_PREFIXO+"' "+cENTER
		_cQry += " AND SE2.E2_FORNECE = '"+SF1->F1_FORNECE+"' "+cENTER
		_cQry += " AND SE2.E2_LOJA = '"+SF1->F1_LOJA+"'       "+cENTER
	                                                                        
	    Memowrite('SF1100I.SQL',_cQRY)
		dbUseArea(.T., "TOPCONN", TCGenQry(,,_cQry), "TMPSE2", .F., .T.)
		
		dbSelectArea("TMPSE2")   
		// Verifica Quantos registros tem
		dbEval( {|x| nCnt++ },,{|| TMPSE2->( !EOF() )}) 
		TMPSE2->( dbGotop() ) 
		
		if nCnt > 1
			WHILE !TMPSE2->( EOF() )
			    SE2->( dbSetOrder(1) )
			    if SE2->( dbSeek(xFilial('SE2')+TMPSE2->E2_PREFIXO+TMPSE2->E2_NUM+ALLTRIM(STR(nI))) )
			      if nI <= Len(aVencto) .And. (!Empty(aVencto[nI]))
			    	Reclock('SE2',.F.)  
			    	SE2->E2_VENCTO  := ctod(aVencto[nI])
			    	SE2->E2_VENCREA := SE2->E2_VENCTO
			    	MsUnlock()                                     
			      Endif	
			      nI += 1
			    Endif
				TMPSE2->( dbSkip() )
			ENDDO
		Else 
		    nI := 1     // Adicionado Valdemir José 13/03/13
		    SE2->( dbSetOrder(1) )
		    if SE2->( dbSeek(xFilial('SE2')+TMPSE2->E2_PREFIXO+TMPSE2->E2_NUM) ) .and. (nCnt > 0)
		      if nI <= Len(aVencto) .And. (!Empty(aVencto[1]))
		    	Reclock('SE2',.F.)  
		    	SE2->E2_VENCTO  := ctod(aVencto[1])
		    	SE2->E2_VENCREA := SE2->E2_VENCTO
		    	MsUnlock()                                     
		      Endif	
		    Endif
		Endif
    Endif

	RestArea(_cArea)

Return                 





/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GeraVenctoºAutor  ³Valdemir Jose       º Data ³  14/02/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina ira gerar uma lista de vencimentos com base no      º±±
±±º          ³ campo C7_XVENCTO                                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CCAB                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GeraVencto(pC7_XVENCTO)
Local aRET    := {'','','','','','','','','','','','','','','','','','','',''}   
Local cString := Alltrim(pC7_XVENCTO)
Local cTMP    := ''                                        
Local nPosIni := 0
Local nI      := 1

While Len(cString) > 0                                        
    nPosIni := AT('/',cString)-2
    if nPosIni = 0
       cString := ''
       Exit
    endif
	cTMP    := Substr(cString,nPosIni,8)
	cString := Alltrim(Substr(cString,nPosIni+9,Len(cString)) )
	if !Empty(cTMP)
		aRET[nI] := cTMP
		cTMP     := ''
		ni += 1
	Endif
EndDo

IF Empty(cString) .And. (!Empty(dtoc(SC7->C7_XDTENCC)))      // Valdemir Jose 13/03/13
   aRET[nI] := dtoc(SC7->C7_XDTENCC)
Endif
  
Return aRET
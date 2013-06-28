User Function MT100AG
	Local aArea := GetArea()
	Public nTaxa := 0

	if inclui .and. _lMoeda	 
		dbSelectarea('SC7')
		dbSetOrder(1)
		dbSeek(xFilial('SC7')+_cNum)
		                
	    dbSelectArea('SM2')
	    dbSetOrder(1)
	    if dbSeek(SC7->C7_EMISSAO)	                        
	       nTAXA := SC7->C7_TXMOEDA
	    endif 
	    _lMoeda := .F.
    Endif
	
	RestArea( aArea )
	
Return
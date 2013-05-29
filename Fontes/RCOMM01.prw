#Include 'rwmake.ch' 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RCOMM01   ºAutor  ³Denison Soares      º Data ³  20/08/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Exibe tela na digitacao da condicao de pagamento para preen-º±±
±±º          ³chimento dos vencimentos.	    							  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Pedido de Compra - CCAB			                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function RCOMM01()
              
Local nLin := 005
Local nCol1 := 006
Local nCol2 := 040
Local nLinFim := 50  
Local nColFim := 110
Local cPrazo  
Local aAreaSE4    
Local lRet := .F.
Private oDlg
Private nParc := 1
Private aVenc := array(12)
Private nL      

aAreaSE4 := SE4->(GetArea())   
DbSelectArea("SE4")
DbSetOrder(1)
If DbSeek(xFilial("SE4")+cCondicao)	 
	cDescX := ''
	If SE4->(FieldPos("E4_XDIGVEN")) > 0
		If SE4->E4_XDIGVEN == "S"	
			cDescX := AllTrim(SE4->E4_DESCRI)
			cPrazo := AllTrim(SE4->E4_COND)	
			For nL := 1 To Len(cPrazo)
				If Substr(cPrazo,nL,1) == ","
					nParc++			
				EndIf
			Next nL  			
		Else
			lRet := .T.   
		EndIf
	Else
		lRet := .T.
	Endif 	
EndIf    
RestArea(aAreaSE4)

If lRet
	Return (.T.)
EndIf

aFill(aVenc,ctod("  /  /  "))

For nL := 1 To nParc  	
	nLinFim += 30
Next nL

nLinFim += 70

@ 005, 005 TO nLinFim, 225 DIALOG oDlg TITLE cDescX
        
@ nLin-2, 000 TO nLin+020, nColFim
@ nLin, nCol1 SAY "Informe a(s) data(s) de vencimento(s)"
nLin += 10
@ nLin, nCol1 SAY "da(s) parcela(s) a seguir:"
nLin += 14
                                  
@ nLin-2, 000 TO nLin+010, nColFim
@ nLin, nCol1 SAY "Parcela"
@ nLin, nCol2 SAY "Data de Vencto."

nLin += 13   
nCol1 := 13                          

If nParc >= 1
	@ nLin-2, 000 TO nLin,nColFim // Horizontal
	@ nLin, nCol1 SAY "1 ª"
	@ nLin, nCol2 Get aVenc[1]  Size 40,40
	nLin += 14     	
EndIf
If nParc >= 2
	@ nLin-2, 000 TO nLin,nColFim
	@ nLin, nCol1 SAY "2 ª"
	@ nLin, nCol2 Get aVenc[2]  Size 40,40
	nLin += 14     	
EndIf        
If nParc >= 3
	@ nLin-2, 000 TO nLin,nColFim
	@ nLin, nCol1 SAY "3 ª"
	@ nLin, nCol2 Get aVenc[3] Size 40,40
	nLin += 14     	
EndIf
If nParc >= 4
	@ nLin-2, 000 TO nLin,nColFim
	@ nLin, nCol1 SAY "4 ª"
	@ nLin, nCol2 Get aVenc[4]  Size 40,40
	nLin += 14     	
EndIf
If nParc >= 5
	@ nLin-2, 000 TO nLin,nColFim
	@ nLin, nCol1 SAY "5 ª"
	@ nLin, nCol2 Get aVenc[5]  Size 40,40
	nLin += 14     	
EndIf
If nParc >= 6
	@ nLin-2, 000 TO nLin,nColFim
	@ nLin, nCol1 SAY "6 ª"
	@ nLin, nCol2 Get aVenc[6]  Size 40,40
	nLin += 14     	
EndIf
If nParc >= 7
	@ nLin-2, 000 TO nLin,nColFim
	@ nLin, nCol1 SAY "7 ª"
	@ nLin, nCol2 Get aVenc[7]  Size 40,40
	nLin += 14   
EndIf  	
If nParc >= 8
	@ nLin-2, 000 TO nLin,nColFim
	@ nLin, nCol1 SAY "8 ª"
	@ nLin, nCol2 Get aVenc[8]  Size 40,40
	nLin += 14     	
EndIf
If nParc >= 9
	@ nLin-2, 000 TO nLin,nColFim
	@ nLin, nCol1 SAY "9 ª"
	@ nLin, nCol2 Get aVenc[9]  Size 40,40
	nLin += 14     	
EndIf
If nParc >= 10
	@ nLin-2, 000 TO nLin,nColFim
	@ nLin, nCol1 SAY "10 ª"
	@ nLin, nCol2 Get aVenc[10]  Size 40,40
	nLin += 14
EndIf
If nParc >= 11     	
	@ nLin-2, 000 TO nLin,nColFim
	@ nLin, nCol1 SAY "11 ª"
	@ nLin, nCol2 Get aVenc[11]  Size 40,40
	nLin += 14   
EndIf  	
If nParc >= 12
	@ nLin-2, 000 TO nLin,nColFim
	@ nLin, nCol1 SAY "12 ª"
	@ nLin, nCol2 Get aVenc[12]  Size 40,40
	nLin += 14     	   
EndIf

@ nLin-2, 000 TO nLin,nColFim 

nCol2 += 14    
nLin += 07

@ nLin, nCol1 BMPBUTTON TYPE 01 ACTION fVer() 
@ nLin, nCol2 BMPBUTTON TYPE 02 ACTION fFecha()

ACTIVATE DIALOG oDlg CENTERED

RETURN(.T.)    

Static Function fVer() ////Consiste se foi digitado alguma data fora de sequencia
      
For nL := 1 To nParc
	If Empty(aVenc[nL]) 
		Alert("Informe a Data para a "+AllTrim(Str(nL))+"ª Parcela")
		Return
	ElseIf aVenc[nL] < dA120Emis
		Alert("A data de vencimento da "+AllTrim(Str(nL))+"ª Parcela não pode ser inferior a data de emissão do Pedido.")
		Return		
	EndIf
Next nL

///Consiste de foi digitado alguma data menor que o anterior
if !empty(aVenc[2]) .and. aVenc[2] <= aVenc[1]
	Alert("Data da 2ª Parcela menor ou igual que o Anterior")
	return
elseif !empty(aVenc[3]).and. (aVenc[3] <= aVenc[2] .or. aVenc[3] <= aVenc[1])
	Alert("Data da 3ª Parcela menor ou igual que os Anteriores")
	return
elseif !empty(aVenc[4]).and. (aVenc[4] <= aVenc[3] .or. aVenc[4] <= aVenc[2] .or. aVenc[4] <= aVenc[1])
	Alert("Data da 4ª Parcela menor ou igual que os Anteriores")
	return
elseif !empty(aVenc[5]).and. (aVenc[5] <= aVenc[4] .or. aVenc[5] <= aVenc[3] .or. aVenc[5] <= aVenc[2] .or. aVenc[5] <= aVenc[1])
	Alert("Data da 5ª Parcela menor ou igual que os Anteriores")
	return
elseif !empty(aVenc[6]).and. (aVenc[6] <= aVenc[5] .or. aVenc[6] <= aVenc[4] .or. aVenc[6] <= aVenc[3] .or. aVenc[6] <= aVenc[2] .or. aVenc[6] <= aVenc[1])
	Alert("Data da 6ª Parcela menor ou igual que os Anteriores")
	return
elseif !empty(aVenc[7]).and. (aVenc[7] <= aVenc[6] .or. aVenc[7] <= aVenc[5] .or. aVenc[7] <= aVenc[4] .or. aVenc[7] <= aVenc[3] .or. aVenc[7] <= aVenc[2] .or. aVenc[7] <= aVenc[1])
	Alert("Data da 7ª Parcela menor ou igual que os Anteriores")
	return
elseif !empty(aVenc[8]).and. (aVenc[8] <= aVenc[7] .or. aVenc[8] <= aVenc[6] .or. aVenc[8] <= aVenc[5] .or. aVenc[8] <= aVenc[4] .or. aVenc[8] <= aVenc[3] .or. aVenc[8] <= aVenc[2] .or. aVenc[8] <= aVenc[1])
	Alert("Data da 8ª Parcela menor ou igual que os Anteriores")
	return
elseif !empty(aVenc[9]).and. (aVenc[9] <= aVenc[8] .or. aVenc[9] <= aVenc[7] .or. aVenc[9] <= aVenc[6] .or. aVenc[9] <= aVenc[5] .or. aVenc[9] <= aVenc[4] .or. aVenc[9] <= aVenc[3] .or. aVenc[9] <= aVenc[2] .or. aVenc[9] <= aVenc[1])
	Alert("Data da 9ª Parcela menor ou igual que os Anteriores")
	return
elseif !empty(aVenc[10]).and. (aVenc[10] <= aVenc[9] .or. aVenc[10] <= aVenc[8] .or. aVenc[10] <= aVenc[7] .or. aVenc[10] <= aVenc[6] .or. aVenc[10] <= aVenc[5] .or. aVenc[10] <= aVenc[4] .or. aVenc[10] <= aVenc[3] .or. aVenc[10] <= aVenc[2] .or. aVenc[10] <= aVenc[1])
	Alert("Data da 10ª Parcela menor ou igual que os Anteriores")
	return
elseif !empty(aVenc[11]).and. (aVenc[11] <= aVenc[10] .or. aVenc[11] <= aVenc[9] .or. aVenc[11] <= aVenc[8] .or. aVenc[11] <= aVenc[7] .or. aVenc[11] <= aVenc[6] .or. aVenc[11] <= aVenc[5] .or. aVenc[11] <= aVenc[4] .or. aVenc[11] <= aVenc[3] .or. aVenc[11] <= aVenc[2] .or. aVenc[11] <= aVenc[1])
	Alert("Data da 11ª Parcela menor ou igual que os Anteriores")
	return
elseif !empty(aVenc[12]).and. (aVenc[12] <= aVenc[11] .or. aVenc[12] <= aVenc[10] .or. aVenc[12] <= aVenc[9] .or. aVenc[12] <= aVenc[8] .or. aVenc[12] <= aVenc[7] .or. aVenc[12] <= aVenc[6] .or. aVenc[12] <= aVenc[5] .or. aVenc[12] <= aVenc[4] .or. aVenc[12] <= aVenc[3] .or. aVenc[12] <= aVenc[2] .or. aVenc[12] <= aVenc[1])
	Alert("Data da 12ª Parcela menor ou igual que os Anteriores")
	return
endif

fConfirma()

return()

////////////////////////////////////////////////////////////////////

Static Function fConfirma()   
         
cDescX := ''
For nL := 1 To nParc
	cDescX += ""+AllTrim(Str(nL))+"ª "+DToC(aVenc[nL])+" - "	
Next nL
cDescX := Left(cDescX,Len(cDescX)-2)

MsgBox(cDescX)

oDlg:End()

return()

////////////////////////////////////////////////////////////////////
Static Function fFecha()

oDlg:End()

Return()

////////////////////////////////////////////////////////////////////

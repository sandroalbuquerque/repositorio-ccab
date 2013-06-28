#include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ESFA002   ºAutor  ³Daniel Franciulli   º Data ³  24/04/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina de Importacao de Pre-Pedidos                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function ESFA002(aDadosC,aDadosI,aDadosA)

Local _aAreaIMP 	:= GetArea()
Local _aPedCab  	:= {}
Local _aPedIte  	:= {}
Local _aPedIteA 	:= {}
Local _aPedAdi  	:= {}
Local _aPedAdiA 	:= {}
Local _aPedFil  	:= {}
Local _aPedIteE 	:= {}
Local _aPedAdiE 	:= {}
Local _aRetPeds		:= {}
Local _cFilial  	:= ""
Local _cCliente 	:= ""
Local _cLoja    	:= ""
Local _cCGC     	:= ""
Local _cTransac 	:= ""
Local _cProduto 	:= ""
Local _cFilAtu  	:= ""
Local _cMsg     	:= ""
Local _cMostraE 	:= ""
Local _cX       	:= ""
Local _nNumTra  	:= 0
Local _nX4	    	:= 0
Local _nPosCli  	:= 0
Local _nPosLCli 	:= 0
Local _nPosCGC  	:= 0
Local _nPosFili 	:= 0
Local _nPosFilA 	:= 0
Local _nPosTran 	:= 0
Local _nPosNTra 	:= 0
Local _nPosProd 	:= 0
Local _nPosItItA	:= 0
Local _nPosCond 	:= 0
Local _nPosVend 	:= 0
Local _nPosTES  	:= 0
Local _nPosLoc  	:= 0
Local _nPosCoPI 	:= 0
Local _nPosTTFi 	:= 0
Local _nPosCTTFi	:= 0
Local _nX       	:= 0
Local _nX2      	:= 0
Local _nX3      	:= 0
Private lMsHelpAuto := .F.
Private lMsErroAuto := .F.
Private lAutoErrNoFile	:= .T.

_aPedCab := U_NIMPA01b("SZ2",aDadosC)

For _nX := 1 To Len(aDadosI)
	_aPedIteA:= aDadosI[_nX]
	_aPedIteA:= U_NIMPA01b("SZ3",_aPedIteA)
	
	AaDd(_aPedIte,_aPedIteA)
Next
For _nX := 1 To Len(aDadosA)
	_aPedAdiA:= aDadosA[_nX]
	_aPedAdiA:= U_NIMPA01b("SZ3",_aPedAdiA)
	AaDd(_aPedAdi,_aPedAdiA)
Next

If Len(_aPedCab) > 0 .And. Len(_aPedIte) > 0 // Caso nao seja passado os dados de cabecalho e item
	_nPosFili	:= AsCan(_aPedIte[1],{|x|x[1]="Z3_FILIAL"})
	_nPosCli	:= AsCan(_aPedCab,{|x|x[1]="Z2_CLIENTE"})
	_nPosCGC	:= AsCan(_aPedCab,{|x|x[1]="Z2_CGC"}) // Analisar a criacao do campo
	_nPosLCli	:= AsCan(_aPedCab,{|x|x[1]="Z2_LOJACLI"})
	_nPosTran	:= AsCan(_aPedCab,{|x|x[1]="Z2_T_TRA"})
	_nPosNTra	:= AsCan(_aPedCab,{|x|x[1]="Z2_T_NROTR"})
	_nPosCond	:= AsCan(_aPedCab,{|x|x[1]="Z2_CONDPAG"})
	_nPosVend	:= AsCan(_aPedCab,{|x|x[1]="Z2_VEND1"})
	_nPosCTTFi	:= AsCan(_aPedCab,{|x|x[1]="Z2_TRATFIL"})
	
	_nPosDECO	:= AsCan(_aPedCab,{|x|x[1]="Z2_DECO"})
	_nPosBanc	:= AsCan(_aPedCab,{|x|x[1]="Z2_BCO"})
	_nPosAgen	:= AsCan(_aPedCab,{|x|x[1]="Z2_AGENCIA"})
	_nPosDiga	:= AsCan(_aPedCab,{|x|x[1]="Z2_DIGAGEN"})
	_nPosCont	:= AsCan(_aPedCab,{|x|x[1]="Z2_CONTA"})
	_nPosDigi	:= AsCan(_aPedCab,{|x|x[1]="Z2_DIGITO"})
	
	If _nPosFili > 0 .And. !Empty(XFilial("SZ2"))
		_cFilial := _aPedIte[1,_nPosFili,2]
	Else
		_cFilial := xFilial("SA1")
	Endif
	
	If _nPosTran > 0 .And. _nPosNTra > 0
		_cTransac	:= Padr(_aPedCab[_nPosTran,2], 6)
		_nNumTra 	:= _aPedCab[_nPosNTra,2]
	Endif
	
	If _nPosCli > 0 .And. _nPosLCli > 0 .And. _nPosFili > 0 // Caso nao haja os campos para encontrar os clientes
		_cCliente:= _aPedCab[_nPosCli,2]
		_cLoja   := _aPedCab[_nPosLCli,2]
		If !Empty(_cCliente) .And. !Empty(_cLoja)
			SA1->(DbSetOrder(1))
			If !SA1->(DbSeek(XFilial("SA1")+_cCliente+_cLoja))
				_cMsg:= "Cliente Nao Encontrado............ Pedido Informa:" + _cTransac + Str(_nNumTra)
				U_fGeraLog( "I", "SA1", _cMsg )
			Endif
		Else
			_cMsg:= "Cliente Nao Encontrado............ Pedido Informa:" + _cTransac + Str(_nNumTra)
			U_fGeraLog( "I", "SA1", _cMsg )
		Endif
	ElseIf _nPosCGC > 0
		_cCGC    := _aPedCab[_nPosCGC,2]
		If !Empty(_cCGC)
			SA1->(DbSetOrder(3))
			If !SA1->(DbSeek(XFilial("SA1")+_cCGC))
				_cMsg:= "Cliente Nao Encontrado............ Pedido Informa:" + _cTransac + Str(_nNumTra)
				U_fGeraLog( "I", "SA1", _cMsg )
			Endif
		Else
			_cMsg:= "Cliente Nao Encontrado............ Pedido Informa:" + _cTransac + Str(_nNumTra)
			U_fGeraLog( "I", "SA1", _cMsg )
		Endif
	Else
		_cMsg:= "Cliente Nao Encontrado............ Pedido Informa:" + _cTransac + Str(_nNumtra)
		U_fGeraLog( "I", "SA1", _cMsg )
	Endif
	If _nPosCond > 0
		SE4->(DbSetOrder(1))
		If !SE4->(DbSeek(xFilial("SE4")+_aPedCab[_nPosCond,2]))
			_cMsg:= "Cond. de Pagamento Nao Encontrada.. Pedido Informa:" + _cTransac + Str(_nNumtra)
			U_fGeraLog( "I", "SE4", _cMsg )
		Endif
	Endif
	If _nPosVend > 0
		SA3->(DbSetOrder(1))
		If !SA3->(DbSeek(xFilial("SA3")+_aPedCab[_nPosVend,2]))
			_cMsg:= "Vendedor Nao Encontrado.. Pedido Informa:" + _cTransac + Str(_nNumtra)
			U_fGeraLog( "I", "SA3", _cMsg )
		Endif
	Endif
	
	_nPosProd	:= AsCan(_aPedIte[1],{|x|x[1]="Z3_PRODUTO"})
	_nPosTes	:= AsCan(_aPedIte[1],{|x|x[1]="Z3_TES"})
	_nPosLoc	:= AsCan(_aPedIte[1],{|x|x[1]="Z3_LOCAL"})
	_nPosFili	:= AsCan(_aPedIte[1],{|x|x[1]="Z3_FILIAL"})
	_nPosCoPI	:= AsCan(_aPedIte[1],{|x|x[1]="Z3_CONDPAG"})
	_nPosTTFi	:= AsCan(_aPedIte[1],{|x|x[1]="Z3_TRATFIL"})
	_nPosDECOI	:= AsCan(_aPedIte[1],{|x|x[1]="Z3_DECO"})
	
	For _nX2 := 1 To Len(_aPedIte)
		Conout("..." + Alltrim(Str(_nPosCoPI)) + "." + Alltrim(_aPedIte[_nX2,_nPosCoPI,2]) + ".")
		If !SB1->(DbSeek(xFilial("SB1")+_aPedIte[_nX2,_nPosProd,2]))
			_cMsg:= "Produto Nao Encontrado............ " + Alltrim(_aPedIte[_nX2,_nPosProd,2]) + " Pedido Informa: " + _cTransac + Str(_nNumTra)
			U_fGeraLog( "I", "SB1", _cMsg )
		Endif
		If !SF4->(DbSeek(xFilial("SF4")+_aPedIte[_nX2,_nPosTES,2]))
			_cMsg:= "TES Nao Encontrado................ " + Alltrim(_aPedIte[_nX2,_nPosTES,2]) + " Pedido Informa:" + _cTransac + Str(_nNumTra)
			U_fGeraLog( "I", "SF4", _cMsg )
		Endif
		If !SB2->(DbSeek(_aPedIte[_nX2,_nPosFili,2]+_aPedIte[_nX2,_nPosProd,2]+_aPedIte[_nX2,_nPosLoc,2]))
			_cMsg:= "Local Estoque Nao Encontrado...... " + _aPedIte[_nX2,_nPosFili,2] + _aPedIte[_nX2,_nPosProd,2] + _aPedIte[_nX2,_nPosLoc,2] + " Pedido Informa:" + _cTransac + Str(_nNumTra)
			U_fGeraLog( "I", "SB2", _cMsg )
		Endif
		If _nPosCoPI > 0
			If !SE4->(DbSeek(xFilial("SE4")+_aPedIte[_nX2,_nPosCoPI,2]))
				_cMsg:= "Cond. de Pagamento (Item) " + _aPedIte[_nX2,_nPosCoPI,2] + " Nao Encontrada.. Pedido Informa:" + _cTransac + Str(_nNumtra)
				U_fGeraLog( "I", "SE4", _cMsg )
			Endif
		Endif
	Next
Else
	_cMsg:= "Pedido sem Cabecalho ou Itens..."
	U_fGeraLog( "I", "SZ2", _cMsg )
Endif

If Empty(_cMsg)
	If Len(_aPedAdi) > 0
		_nPosFilA:= AsCan(_aPedAdi[1],{|x|x[1]="Z3_FILIAL"})
	Endif
	_aPedFil := {}
	
	If _nPosProd > 0
		Conout(_nPosFili)
		Conout(_nPosCOPI)
		For _nX := 1 To Len(_aPedIte)
			If AsCan(_aPedFil, _aPedIte[_nX,_nPosFili,2] + _aPedIte[_nX,_nPosCoPI,2]) == 0
				Aadd(_aPedFil,_aPedIte[_nX,_nPosFili,2] + _aPedIte[_nX,_nPosCoPI,2])
			Endif
		Next
		If Empty(_cMsg)
			SB1->(DbSetOrder(1))
			SF4->(DbSetOrder(1))
			SB1->(DbSetOrder(1))
			SE4->(DbSetOrder(1))
			
			For _nX := 1 To Len(_aPedFil)
				_cFilAtu := cFilAnt
				cFilAnt  := Substr(_aPedFil[_nX], 1, 2)
				_cCondOld:= Substr(_aPedFil[_nX], 3, 3)
				_aPedIteE:= {}
				For _nX2 := 1 To Len(_aPedIte)
					If _aPedIte[_nX2,_nPosFili,2] == cFilAnt .And. _aPedIte[_nX2,_nPosCoPI,2] == _cCondOld
						If !SB1->(DbSeek(xFilial("SB1")+_aPedIte[_nX2,_nPosProd,2]))
							_cMsg:= "Produto Nao Encontrado............ " + Alltrim(_aPedIte[_nX2,_nPosProd,2]) + " Pedido Informa: " + _cTransac + Str(_nNumTra)
							U_fGeraLog( "I", "SB1", _cMsg )
						Endif
						If !SF4->(DbSeek(xFilial("SF4")+_aPedIte[_nX2,_nPosTES,2]))
							_cMsg:= "TES Nao Encontrado................ " + Alltrim(_aPedIte[_nX2,_nPosTES,2]) + " Pedido Informa:" + _cTransac + Str(_nNumTra)
							U_fGeraLog( "I", "SF4", _cMsg )
						Endif
						If !SB2->(DbSeek(cFilAnt+_aPedIte[_nX2,_nPosProd,2]+_aPedIte[_nX2,_nPosLoc,2]))
							_cMsg:= "Local Estoque Nao Encontrado...... " + cFilAnt + _aPedIte[_nX2,_nPosProd,2] + _aPedIte[_nX2,_nPosLoc,2] + " Pedido Informa:" + _cTransac + Str(_nNumTra)
							U_fGeraLog( "I", "SB2", _cMsg )
						Endif
						If _nPosCoPI > 0
							If !SE4->(DbSeek(xFilial("SE4")+_aPedIte[_nX2,_nPosCoPI,2]))
								_cMsg:= "Cond. de Pagamento (Item) "+_aPedIte[_nX2,_nPosCoPI,2]+" Nao Encontrada.. Pedido Informa:" + _cTransac + Str(_nNumtra)
								U_fGeraLog( "I", "SE4", _cMsg )
							Endif
						Endif
						If Empty(_cMsg)
							AaDd(_aPedIteE,_aPedIte[_nX2])
						Endif
						_cCondOld	:= _aPedIte[_nX2,_nPosCoPI,2]
					Endif
				Next
				If Empty(_cMsg)
					_aPedAdiE:= {}
					_lPreCab1 := .T.
					_lPreCab2 := .T.
					_lPreCab3 := .T.
					
					For _nX2 := 1 To Len(_aPedAdi)
						If _aPedAdi[_nX2,_nPosFilA,2] = cFilAnt
							AaDd(_aPedAdiE,_aPedAdi[_nX2])
						Endif
					Next
					For _nX3 := 1 To Len(_aPedIteE)
						If _nPosCoPI > 0 .And. _nPosCond > 0 .And. _lPreCab1
							_aPedCab[_nPosCond,2] := _aPedIteE[_nX3,_nPosCoPI,2]
							_lPreCab1 := .F.
						Endif
						If _nPosTTFi > 0 .And. _nPosCTTFi > 0 .And. _lPreCab2
							_aPedCab[_nPosCTTFi,2] := _aPedIteE[_nX3,_nPosTTFi,2]
							_lPreCab2 := .F.
						Endif
						If _nPosDECO > 0 .And. _nPosDECOI > 0 .And. _lPreCab3
							_aPedCab[_nPosDECO,2] := _aPedIteE[_nX3,_nPosDECOI,2]
							If _aPedCab[_nPosDECO,2] <> "S"
								_aPedCab[_nPosBanc,2]	:= ""
								_aPedCab[_nPosAgen,2]	:= ""
								_aPedCab[_nPosDiga,2]	:= ""
								_aPedCab[_nPosCont,2]	:= ""
								_aPedCab[_nPosDigi,2]	:= ""
							Endif
							_lPreCab3 := .F.
						Endif
						AaDd(_aPedIteE[_nX3],{"Z3_ITEM",StrZero(_nX3,2),Nil})
						
						DbSelectArea("SZ2")
						DbSetOrder(5)
						DbSeek(cFilAnt+_cTransac+Str(_nNumtra,10))
						If Found()
							While SZ2->Z2_FILIAL + SZ2->Z2_T_TRA + Str(SZ2->Z2_T_NROTR, 10) == cFilAnt + _cTransac + Str(_nNumtra,10) .And. !Eof()
								If SZ2->Z2_CONDPAG == _aPedIteE[_nX3,_nPosCoPI,2]
									_cMsg:= "Pedido ja importado............ Pedido Informa:" + _cTransac + Str(_nNumTra) + "." + _aPedIteE[_nX3,_nPosCoPI,2]
									U_fGeraLog( "I", "SZ2", _cMsg )
								Endif
								DbSkip()
							End
						EndIf
					Next
					
					
					If Empty(_cMsg)
						Begin Transaction
						DbSelectArea("SZ2")
						DbSetOrder(1)
						
						MSExecAuto({|x,y| MATA410(x,y)},_aPedCab,_aPedIteE)
						If lMsErroAuto
							DisarmTransaction()
							_cMsg:= "Nao foi possivel Importar ..... Pedido Informa:" + _cTransac + Str(_nNumTra)
							U_fGeraLog( "I", "SZ2", _cMsg )
							_cMostraE := U_NIMPA01L()
						Else
							AaDd(_aRetPeds,SZ2->Z2_FILIAL + SZ2->Z2_NUM)
							CONOUT(SZ2->Z2_FILIAL + SZ2->Z2_NUM)
							_cNum := SZ2->Z2_NUM
							If Len(_aPedAdiE) > 0
								_nPosItItA:= AsCan(_aPedAdi[1],{|x|x[1]="Z3_ITEMIT"})
								DbSelectArea("SZ3")
								SZ3->(DbSeek(xFilial("SZ3")+_cNum+"01"))
								While !Eof() .And. SZ3->Z3_FILIAL+SZ3->Z3_NUM = xFilial("SZ3")+_cNum
									For _nX3 := 1 To Len(_aPedAdiE)
										If SZ3->Z3_ITEMIT = _aPedAdiE[_nX3][_nPosItItA][2]
											AaDd(_aPedAdiE[_nX3],{"Z3_NUM",_cNum,Nil})
											AaDd(_aPedAdiE[_nX3],{"Z3_ITEM",SZ3->Z3_ITEM,Nil})
										Endif
									Next
									DbSkip()
								EndDo
								DbSelectArea("SZ3")
								For _nX3 := 1 To Len(_aPedAdiE)
									RecLock("SZ3",.T.)
									For _nX4 := 1 To Len(_aPedAdiE[_nX3])
										SZ3->(FieldPut(FieldPos(_aPedAdiE[_nX3,_nX4,1]),_aPedAdiE[_nX3,_nX4,2]))
									Next
									MsUnLock()
								Next
							ENdif
						Endif
						End Transaction
					Endif
				Endif
				cFilAnt  := _cFilAtu
			Next
		Endif
	Else
		_cMsg:= "Campo do Produto Nao Encontrado............ Pedido Informa:" + _cTransac + Str(_nNumTra)
		U_fGeraLog( "I", "SB1", _cMsg )
	Endif
Endif

Conout(_cMsg)
If Empty(_cMostraE)
	_cMostraE	:= _cMsg
Endif

Return({_cMostraE,_aRetPeds})
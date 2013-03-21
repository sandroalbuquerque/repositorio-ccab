#include "rwmake.ch"        // incluiDo pelo assistente de conversao Do AP5 IDE em 13/12/01
#include "topconn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CCOMR00   º Autor ³ Anderson Zanni     º Data ³ 22/02/08    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Impressao de itens de notas fiscais conforme parametros    º±±
±±º          ³ selecionaDos pelo usuarios (Documentos de Entrada)         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ EspecIfico para o cliente CCAB                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºEduardo Cseh      ³ 29/11/2012 ³ #ECV20121129 - Alteracao para incluir º±±
±±º(Agility)         ³            ³ a coluna filial na geracao em Excel.  º±±
±±º                  ³            ³                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function CCOMR001()        // incluiDo pelo assistente de conversao Do AP5 IDE em 13/12/01

SetPrvt("CSTRING,CDESC1,CDESC2,CDESC3,TAMANHO,ARETURN")
SetPrvt("NOMEPROG,ALINHA,NLASTKEY,CSIT,TITULO,CABEC1")
SetPrvt("CABEC2,CCANCEL,M_PAG,WNREL,LI,_CVEND,_CNVEND,CGERV,totalp,xpediDo")

nOrdem 	 	:= 1
cString  	:= "SD1"
titulo   	:= "Relacao de Compras em "
cDesc1   	:= OemToAnsi("Este relatorio ira imprimir a relacao de itens")
cDesc2   	:= OemToAnsi("referentes a compras efetuadas.")
tamanho  	:= "G"
limite   	:= 220
aReturn  	:= { "ZebraDo", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog 	:= "CCOMR001"
cPerg    	:= "COMR01"
aLinha   	:= { }
nLastKey 	:= 0
cabec1   	:= "NOTA         PRODUTO         DESCRICAO                            QUANTIDADE UM      PR.UNITARIO  IPI      VALOR C/ IPI  ICM  CODIGO RAZAO SOCIAL                        TP TES TP  EMISSAO    DATA DIG.            CUSTO "
cabec2   	:= ""
cCancel  	:= "***** CANCELADo PELO OPERADoR *****"
m_pag    	:= 1  //Variavel que acumula numero da pagina
LI 		 	:= 80
wnrel    	:= "CCOMR001"            //Nome Default Do relatorio em Disco
cCusto 		:= ""
totquant	:= 0
totvalor	:= 0
totcusto	:= 0
gerquant 	:= 0
gervalor 	:= 0
gercusto 	:= 0
nVunit	 	:= 0
nValipi	 	:= 0
nCusmedio	:= 0
cDescMoeda	:= ""

validperg()
pergunte(cPerg,.T.)
cDescMoeda:="MV_MOEDA"+ALLTRIM(STR(MV_PAR09))
SetPrint(cString,wnrel,cperg,titulo+&cDescMoeda,cDesc1,cDesc2,cDesc3,.F.,,,tamanho)

If nLastKey == 27
	Set Filter To
	Return
EndIf

SetDefault(aReturn,cString)

If nLastKey == 27
	Set Filter To
	Return
EndIf

RptStatus({||Imprel()})

Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³Imprel    ³ Autor ³ Anderson Zanni        ³ Data ³ 16.12.97 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Impressao Do corpo Do relatorio                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Imprel()
Private aStrucSD1 	:= SD1->(dbStruct())
Private cFilterUser	:= aReturn[7]
Private aResumo		:= {}
Private cQuery		:= ""

//MontanDo a Query
cQuery := "SELECT D1_FILIAL, D1_PEDIDO, D1_ITEMPC, D1_CUSTO, D1_CUSTO2, D1_TIPO, D1_SERIE,"
cQuery += "D1_DOC,D1_ITEM,D1_COD,B1_DESC,D1_QUANT,B1_UM,D1_IPI,D1_VALIPI, "
cQuery += "D1_PICM,D1_FORNECE,D1_LOJA,D1_TIPO,D1_TES,D1_LOCAL,B1_TIPO,D1_EMISSAO,D1_DTDIGIT, "
//cQuery += "B1_GRUPO,D1_DTDIGIT,B1_LOCPAD, MONTH(D1_DTDIGIT) AS MES, YEAR(D1_DTDIGIT) AS ANO " //#ECV20121129.o
cQuery += "B1_GRUPO,D1_DTDIGIT,B1_LOCPAD, MONTH(D1_DTDIGIT) AS MES, YEAR(D1_DTDIGIT) AS ANO, D1_FILIAL " //#ECV20121129.n
cQuery += "FROM "
cQuery += RetSqlName("SB1")+" SB1, "
If mv_par17==1
	cQuery += RetSqlName("SC7")+" SC7, "
Endif
cQuery += RetSqlName("SD1")+" SD1, "
cQuery += RetSqlName("SF4")+" SF4 "
cQuery += "WHERE "
cQuery += "SB1.D_E_L_E_T_=' ' "
cQuery += "AND SD1.D_E_L_E_T_=' ' "
cQuery += "AND SF4.D_E_L_E_T_=' ' "
If mv_par17==1
	cQuery += "AND SC7.D_E_L_E_T_=' ' "
	cQuery += "AND D1_PEDIDO+D1_ITEMPC=C7_NUM+C7_ITEM "
	cQuery += "AND D1_PEDIDO <> '' "
	cQuery += "AND D1_ITEMPC <> '' "
Endif
cQuery += "AND B1_COD = D1_COD  "
cQuery += "AND F4_CODIGO=D1_TES "
cQuery += "AND D1_TIPO='N' "
cQuery += "AND F4_PODER3 NOT IN ('R','D') "
cQuery += "AND D1_COD BETWEEN '"+Alltrim(mv_par01)+"' AND '"+Alltrim(mv_par02)+"' "
cQuery += "AND D1_DTDIGIT BETWEEN '"+DtoS(mv_par03)+"' AND '"+DtoS(mv_par04)+"' "
cQuery += "AND D1_FORNECE BETWEEN '"+Alltrim(mv_par05)+"' AND '"+Alltrim(mv_par07)+"' "
cQuery += "AND D1_LOJA BETWEEN '"+Alltrim(mv_par06)+"' AND '"+Alltrim(mv_par08)+"' "
cQuery += "AND D1_EMISSAO BETWEEN '"+DtoS(mv_par11)+"' AND '"+DtoS(mv_par12)+"' "
cQuery += "AND B1_TIPO BETWEEN '"+Alltrim(mv_par13)+"' AND '"+Alltrim(mv_par14)+"' "
cQuery += "AND D1_FILIAL BETWEEN '"+mv_par15+"' AND '"+mv_par16+"'"
cQuery += "ORDER BY D1_COD,D1_FORNECE,D1_DTDIGIT"

memowrite("CCOMR001.SQL",cQuery)
cQuery := ChangeQuery(cQuery)

If 	SELECT("TRB1")>0
	dbSelectArea("TRB1")
	dbCloseArea()
EndIf

dbUseArea(.t.,"TOPCONN",TCGENQRY(,,cQuery),"TRB1",.f.,.t.)

If MV_PAR18==1 // Gera planilha?
	
	aDaDos := {}
	
	If 	SELECT("XLS")>0
		dbSelectArea("XLS")
		dbCloseArea()
	EndIf
	
	aAdd(aDaDos,{'MES_ANO'   ,'C',07,0})
	aAdd(aDaDos,{'NOTA'      ,'C',09,0})
	aAdd(aDaDos,{'PRODUTO'   ,'C',15,0})
	aAdd(aDaDos,{'DESCRICAO' ,'C',50,0})
	aAdd(aDaDos,{'QUANT'     ,'N',15,2})
	aAdd(aDaDos,{'UM'        ,'C',02,0})
	aAdd(aDaDos,{'PR_UNIT'   ,'N',15,2})
	aAdd(aDaDos,{'IPI'       ,'N',15,2})
	aAdd(aDaDos,{'VAL_C_IPI' ,'N',15,2})
	aAdd(aDaDos,{'ICMS'      ,'N',15,2})
	aAdd(aDaDos,{'COD_FORN'  ,'C',06,0})
	aAdd(aDaDos,{'FORN_LOJA' ,'C',02,0})
	aAdd(aDaDos,{'FORN_NOME' ,'C',50,0})
	aAdd(aDaDos,{'TIPO_NF'   ,'C',02,0})
	aAdd(aDaDos,{'TES'       ,'C',03,0})
	aAdd(aDaDos,{'TIPO_PROD' ,'C',02,0})
	aAdd(aDaDos,{'EMISSAO'   ,'D',08,0})
	aAdd(aDaDos,{'DATA_DIG'  ,'D',08,0})
	aAdd(aDaDos,{'CUSTO'     ,'N',15,2})
	aAdd(aDaDos,{'FILIAL'    ,'C',02,0}) //#ECV20121129.n
	
	TRB 		:= CriaTrab(aDaDos,.T.)
	_cIndTrb  	:= CriaTrab(Nil,.F.)
	
	dbUseArea(.T.,,TRB,"XLS",.F.,.F.)
	IndRegua("XLS",_cIndTrb,"MES_ANO+PRODUTO+PRODUTO",,,"")
EndIf

If  Select( "TRB1" )==0 .or. (TRB1->(EOF()) .AND. TRB1->(BOF()))
Else
	dbSelectArea("TRB1")
	TRB1->(dbGoTop())
	SetRegua(LastRec())
	While TRB1->(!Eof())
		IncRegua()
		If li > 60
			li := Cabec(titulo+&cDescMoeda,cabec1,cabec2,nomeprog,tamanho,18) //Impressao Do cabecalho
			li++
		EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Considera filtro do usuario                                  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		/*
		If !Empty(aReturn[7])
		If !&(aReturn[7])
		dbSkip()
		Loop
		EndIf
		EndIf
		*/
		
		/*
		If !Empty(cFilterUser) .and. TRB1->(!(&cFilterUser))
		dbSelectArea("TRB1")
		dbSkip()
		Loop
		Endif
		*/
		
		/*
		If !Empty(cFilterUser)
		If !&(aReturn[7])
		dbSkip()
		Loop
		Endif
		Endif
		*/
		
		cQuebraP    := TRB1->D1_COD
		cCondicaoP  := "TRB1->D1_COD"
		totquantP 	:= 0
		totvalorP 	:= 0
		totcustoP 	:= 0
		
		Do While TRB1->(!EOF()) .AND. (cQuebraP == &cCondicaoP) // QUEBRA POR PRODUTO
			
			cQuebraF    := TRB1->D1_COD+TRB1->D1_FORNECE
			cCondicaoF  := "TRB1->D1_COD+TRB1->D1_FORNECE"
			
			cProdm    	:= ""
			totquant 	:= 0
			totvalor	:= 0
			totcusto	:= 0
			
			Do While TRB1->(!EOF()) .AND. (cQuebraF == &cCondicaoF) // QUEBRA POR FORNECEDoR
				cQuebra   	:= ALLTRIM(TRB1->D1_COD)+ALLTRIM(TRB1->D1_FORNECE)+alltrim(strzero(TRB1->MES,2))+alltrim(str(TRB1->ANO))
				cCondicao	:= "ALLTRIM(TRB1->D1_COD)+ALLTRIM(TRB1->D1_FORNECE)+alltrim(strzero(TRB1->MES,2))+alltrim(str(TRB1->ANO))"
				totquant	:= 0
				totvalor	:= 0
				totcusto	:= 0
				Do While TRB1->(!EOF()) .AND. (cQuebra == &cCondicao) // QUEBRA POR DATA
					nVunit		:=0
					nValipi		:=0
					nCusmedio	:=0
					
					_NumPed  :=  TRB1->D1_PEDIDo
					_VlCUSTO :=  TRB1->D1_CUSTO
					If TRB1->D1_PEDIDo <> ''
						_nPrcPc := 0
						_nMoePc := 0
						
						_nPrcPc := Posicione("SC7",1,TRB1->D1_FILIAL+TRB1->D1_PEDIDo+TRB1->D1_ITEMPC, "C7_PRECO")
						_nMoePc := Posicione("SC7",1,TRB1->D1_FILIAL+TRB1->D1_PEDIDo+TRB1->D1_ITEMPC, "C7_MOEDA")
						
						_VALIPI := ((_nPrcPc*TRB1->D1_QUANT)+(TRB1->D1_VALIPI/_nPrcPC))
						
						If Found()
							_NumPed  :=  TRB1->D1_PEDIDo
							If _nMoePc <> MV_PAR09 .and.  MV_PAR10 == 2
								dbSelectArea("TRB1")
								TRB1->(dbSkip())
								Loop
							EndIf
						EndIf
						
						If TRB1->D1_CUSTO > 0
							If MV_PAR09!=1
								
								_cCusto := "TRB1->D1_CUSTO"+ALLTRIM(STR(MV_PAR09) )
								_VlCUSTO :=  &_cCusto /TRB1->D1_QUANT
							Else
								_VlCUSTO :=  TRB1->D1_CUSTO/TRB1->D1_QUANT
							EndIf
						EndIf
						
					EndIf
					
					If li > 60
						li := Cabec(titulo+&cDescMoeda,cabec1,cabec2,nomeprog,tamanho,18) //Impressao Do cabecalho
						li++
					EndIf
					If TRB1->D1_PEDIDo <> ''
						//CONVERTE PARA OUTRAS MOEDAS CASO MV_PAR10=1
						If (MV_PAR09!=_nMoePc)
							//							nVunit		:= xmoeda(_nPrcPC,_nMoePc,MV_PAR09,STOD(TRB1->D1_DTDIGIT))
							nVunit		:= xmoeda(_nPrcPC,_nMoePc,MV_PAR09,STOD(TRB1->D1_EMISSAO),4)
							//							nValipi 	:= xmoeda(_VALIPI,_nMoePc,MV_PAR09,STOD(TRB1->D1_DTDIGIT))
							nValipi 	:= xmoeda(_VALIPI,_nMoePc,MV_PAR09,STOD(TRB1->D1_EMISSAO))
							//MANTEM O PRECO NA MOEDGA ORIGINAL
						Else
							nVunit		:= _nPrcPC
							nValipi		:= _VALIPI
						EndIf
					EndIf
					cProdm	 := ""
					nCusmedio := _VlCUSTO
					@ li , 000 Psay ALLTRIM(TRB1->D1_DOC)
					@ li , 013 Psay ALLTRIM(TRB1->D1_COD)
					@ li , 029 Psay Substr(TRB1->B1_DESC,1,30)
					@ li , 060 Psay TRB1->D1_QUANT 			Picture PesqPict("SD1","D1_QUANT",16)
					@ li , 077 Psay ALLTRIM(TRB1->B1_UM)
					@ li , 080 Psay nVunit 					Picture PesqPict("SD1","D1_CUSTO",16,1)
					@ li , 097 Psay TRB1->D1_IPI    		Picture PesqPict("SD1","D1_IPI",5)
					@ li , 103 Psay nValipi 				Picture PesqPict("SD1","D1_TOTAL",16,1)
					If (cPaisloc=="BRA")
						@ li,120 Psay TRB1->D1_PICM 		Picture PesqPict("SD1","D1_PICM",5)
					EndIf
					
					cNome := If(TRB1->D1_TIPO $ "DB",Posicione("SA1",1,xFilial("SA1")+TRB1->(D1_FORNECE+D1_LOJA),"A1_NOME"), Posicione("SA2",1,xFilial("SA2")+TRB1->(D1_FORNECE+D1_LOJA),"A2_NOME"))
					
					@ li,126 Psay ALLTRIM(TRB1->D1_FORNECE)
					@ li,133 Psay Substr(cNome,1,35)
					
					dbSelectArea("TRB1")
					@ li,169 Psay TRB1->D1_TIPO	 			Picture PesqPict("SD1","D1_TIPO",2)
					@ li,172 Psay TRB1->D1_TES	 			Picture PesqPict("SD1","D1_TES",3)
					@ li,176 Psay TRB1->B1_TIPO	 			Picture PesqPict("SD1","D1_TP",2)
					@ li,180 Psay STOD(TRB1->D1_EMISSAO)
					@ li,191 Psay STOD(TRB1->D1_DTDIGIT)
					@ li,201 Psay nCusmedio      			Picture PesqPict("SD1","D1_CUSTO",16,1)
					totquant += TRB1->D1_QUANT
					totvalor += nValipi
					totcusto += nCusmedio
					cProdm	 := ""
					cProdm	 := alltrim(strzero(TRB1->MES,2))+"/"+alltrim(str(TRB1->ANO))
					li ++
					
					If MV_PAR18==1 // gera planilha?
						RecLock("XLS",.T.)
						XLS->MES_ANO	:= cProdm
						XLS->NOTA       := ALLTRIM(TRB1->D1_DOC)
						XLS->PRODUTO    := ALLTRIM(TRB1->D1_COD)
						XLS->DESCRICAO  := Substr(TRB1->B1_DESC,1,50)
						XLS->QUANT 		:= TRB1->D1_QUANT
						XLS->UM         := ALLTRIM(TRB1->B1_UM)
						XLS->PR_UNIT    := nVunit
						XLS->IPI        := TRB1->D1_IPI
						XLS->VAL_C_IPI  := nValipi
						XLS->ICMS       := TRB1->D1_PICM
						XLS->COD_FORN   := ALLTRIM(TRB1->D1_FORNECE)
						XLS->FORN_LOJA  := ALLTRIM(TRB1->D1_LOJA)
						XLS->FORN_NOME  := Substr(cNome,1,50)
						XLS->TIPO_NF    := TRB1->D1_TIPO
						XLS->TES        := TRB1->D1_TES
						XLS->TIPO_PROD  := TRB1->B1_TIPO
						XLS->EMISSAO    := STOD(TRB1->D1_EMISSAO)
						XLS->DATA_DIG   := STOD(TRB1->D1_DTDIGIT)
						XLS->CUSTO      := nCusmedio
						XLS->FILIAL     := TRB1->D1_FILIAL //#ECV20121129.n
						XLS->(MsUnlock())
					EndIf
					
					// Carrega o array Do resumo geral
					nPosUM := Ascan(aResumo,{|x| x[1] == ALLTRIM(TRB1->B1_UM)})
					
					If nPosUM==0		// NAO ESTA NO ARRAY
						AADD(aResumo,{ALLTRIM(TRB1->B1_UM),TRB1->D1_QUANT,nValipi})
					Else
						aResumo[nPosUM][2] += TRB1->D1_QUANT
						aResumo[nPosUM][3] += nValipi
					EndIf
					
					TRB1->(dbSkip())
				EndDo
				If  totquant  > 0 // TOTAL Do PRODUTO EM 03/2008 ---------------->"
					@ li , 000 Psay "TOTAL Do PRODUTO EM "+cProdm+" ---------------->"
					@ li , 060 Psay totquant 			Picture PesqPict("SD1","D1_QUANT",16)
					@ li , 103 Psay totvalor 			Picture PesqPict("SD1","D1_TOTAL",16,1)
					@ li , 201 Psay totcusto			Picture PesqPict("SD1","D1_CUSTO",16,1)
				EndIf
				gerquant += totquant
				gervalor += totvalor
				gercusto += totcusto
				li := li+2
			EndDo
			If  gerquant  > 0
				@ li , 000 Psay "TOTAL Do FORNECEDoR ------------------------>"
				@ li , 060 Psay gerquant 				Picture PesqPict("SD1","D1_QUANT",16)
				@ li , 103 Psay gervalor 				Picture PesqPict("SD1","D1_TOTAL",16,1)
				@ li , 201 Psay gercusto				Picture PesqPict("SD1","D1_CUSTO",16,1)
			EndIf
			totquantP 	:= gerquant
			totvalorP 	:= gervalor
			totcustoP 	:= gercusto
			gerquant := 0
			gervalor := 0
			gercusto := 0
			li := li+2
		EndDo
		If  totquantP  > 0
			@ li , 000 Psay "TOTAL Do PRODUTO --------------------------->"
			@ li , 060 Psay totquantP 					Picture PesqPict("SD1","D1_QUANT",16)
			@ li , 103 Psay totvalorP 					Picture PesqPict("SD1","D1_TOTAL",16,1)
			@ li , 201 Psay totcustoP					Picture PesqPict("SD1","D1_CUSTO",16,1)
		EndIf
		gerquant := 0
		gervalor := 0
		gercusto := 0
		li := li+2
	EndDo
	li++
	
	If Len(aResumo)>0
		cTitulo := titulo+&cDescMoeda
		cCabr01 := "Resumo Geral"
		cCabr02 := "Unidade de Medida                                          Quantidade            Valor"
		cTam	:= tamanho
		nResQt	:= 0
		nResVl	:= 0
		nTipo	:= 18
		Cabec(cTitulo,cCabr01,cCabr02,wnRel,cTam,nTipo)
		For x:=1 to Len(aResumo)
			@ Li,000 Psay aResumo[x][1]
			@ Li,057 Psay aResumo[x][2] Picture "@E 999,999,999.99"
			@ Li,075 Psay aResumo[x][3] Picture "@E 999,999,999.99"
			Li++
			nResQt += aResumo[x][2]
			nResVl += aResumo[x][3]
		Next x
		@ Li,000 Psay "Geral"
		@ Li,057 Psay nResQt Picture "@E 999,999,999.99"
		@ Li,075 Psay nResVl Picture "@E 999,999,999.99"
	EndIf
	
	If MV_PAR18==1 // gera planilha
		DbSelectArea("XLS")
		
		//_cArquivo := AllTrim(__RELDIR)+"CCOMR001.DBF"
		_cArquivo := AllTrim("\SPOOL\")+"CCOMR001.DBF"
		If File(_cArquivo)
			Ferase(_cArquivo)
		EndIf
		
		Copy To &(_cArquivo)
		
		If !Empty(MV_PAR19)   
		    // ADICIONADO POR VALDEMIR 21/03/13
		    if !EXISTDIR("C:\Temp")   
		    	nResult := MAKEDIR("C:\Temp")
		    Endif                                               			
			If At(':\',MV_PAR19) > 0
				//Deleta
				If File(ALLTRIM(MV_PAR19)+".XLS")
					Ferase(ALLTRIM(MV_PAR19)+".XLS")
				EndIf
				
				//Verifica se deletou
				If !File(ALLTRIM(MV_PAR19)+".XLS")
					__COPYFILE (_cArquivo,ALLTRIM(MV_PAR19)+".XLS")
					Alert("Planilha gerada: "+ALLTRIM(MV_PAR19)+".XLS")
					ShellExecute("open",ALLTRIM(MV_PAR19)+".XLS","","",1)
				Else
					Alert("Planilha não foi gerada porque o arquivo "+ALLTRIM(MV_PAR19)+".XLS estava em uso e não pode ser excluido.")
				EndIf
			Else
				//Deleta
				If File("C:\TEMP\"+ALLTRIM(MV_PAR19)+".XLS")
					Ferase("C:\TEMP\"+ALLTRIM(MV_PAR19)+".XLS")
				EndIf
				
				//Verifica se deletou
				If !File("C:\TEMP\"+ALLTRIM(MV_PAR19)+".XLS")
					__COPYFILE (_cArquivo,"C:\TEMP\"+ALLTRIM(MV_PAR19)+".XLS")
					Alert("Planilha gerada: C:\TEMP\"+ALLTRIM(MV_PAR19)+".XLS")
					ShellExecute("open","C:\TEMP\"+ALLTRIM(MV_PAR19)+".XLS","","",1)
				Else
					Alert("Planilha não foi gerada porque o arquivo C:\"+ALLTRIM(MV_PAR19)+".XLS estava em uso e não pode ser excluido.")
				EndIf
			EndIf
		Else
			//Deleta
			If File("C:\TEMP\CCOMR001.XLS")
				Ferase("C:\TEMP\CCOMR001.XLS")
			EndIf
			
			//Verifica se dele tou
			If !File("C:\CCOMR001.XLS")
				__COPYFILE (_cArquivo,"C:\CCOMR001.XLS")
				Alert("Planilha gerada: C:\CCOMR001.XLS")
				ShellExecute("open","C:\CCOMR001.XLS","","",1)
			Else
				Alert("Planilha não foi gerada porque o arquivo C:\CCOMR001.XLS estava em uso e não pode ser excluido.")
			EndIf
		EndIf
		DBCLOSEAREA("XLS")
	EndIf
EndIf

dbCommitAll()

Set Device to Screen

If aReturn[5] == 1
	Set Printer To
	ourspool(wnrel) //Chamada Do Spool de Impressao
EndIf
MS_FLUSH() //Libera fila de relatorios em spool

If SELECT("TRB1")>0
	dbSelectArea("TRB1")
	dbCloseArea()
End

Return
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³VALIDPERG º Autor ³ AP5 IDE            º Data ³  19/04/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ VerIfica a existencia das perguntas crianDo-as caso seja   º±±
±±º          ³ necessario                                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ValidPerg

Local _sAlias := Alias()
Local aRegs := {}
Local i,j

dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR(cPerg,6)

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
aAdd(aRegs,{cPerg,"01","A partir Do Produto?","¨De Producto       ?","From Product       ?","mv_ch1","C",15,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SB1",""})
aAdd(aRegs,{cPerg,"02","At‚ o Produto      ?","¨A  Producto       ?","To   Product       ?","mv_ch2","C",15,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SB1",""})
aAdd(aRegs,{cPerg,"03","Data Digitacao De  ?","¨De Fecha Tipeo    ?","From Typing Date   ?","mv_ch3","D",08,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"04","Data Digitacao Ate ?","¨A  Fecha Tipeo    ?","To   Typing Date   ?","mv_ch4","D",08,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"05","Do ForneceDor      ?","¨De ProveeDor      ?","From Supplier      ?","mv_ch5","C",06,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","SA2","001"})
aAdd(aRegs,{cPerg,"06","Da Loja            ?","¨¿De Filial        ?","From Unit          ?","mv_ch6","C",02,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"07","Ate o Forneceder   ?","¨A  ProveeDor      ?","To   Supplier      ?","mv_ch7","C",06,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","SA2","001"})
aAdd(aRegs,{cPerg,"08","Ate a Loja         ?","¨¿A Filial         ?","To Unit            ?","mv_ch8","C",02,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"09","Qual a moeda       ?","¨Cual Moneda       ?","Which Currency     ?","mv_ch9","N",01,0,1,"C","","mv_par09","1a moeda","1¦ Moneda","Currency 1","","","2a moeda","2¦ Moneda","Currency 2","","","3a moeda","3¦ Moneda","Currency 3","","","4a moeda","4¦ Moneda","Currency 4","","","5a moeda","5¦ Moneda","Currency 5","","",""})
aAdd(aRegs,{cPerg,"10","Outras Moedas      ?","¨Otras Monedas     ?","Other Currencies   ?","mv_cha","N",01,0,1,"C","","mv_par10","Converter","Convertir","Convert","","","Não Imprimir","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"11","Da Data Emissao    ?","¨De Fecha Emissao  ?","From Emiss  Date   ?","mv_chb","D",08,0,0,"G","","mv_par11","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"12","Ate a Data Emissao ?","¨A  Fecha Emissao  ?","To   Emiss  Date   ?","mv_chc","D",08,0,0,"G","","mv_par12","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"13","De Tipo Produto    ?","¨De Tipo Producto  ?","From Type Product  ?","mv_chd","C",02,0,0,"G","","mv_par13","","","","","","","","","","","","","","","","","","","","","","","","","02",""})
aAdd(aRegs,{cPerg,"14","Ate Tipo de Produto?","¨A Tipo Producto   ?","To Type Product    ?","mv_che","C",02,0,0,"G","","mv_par14","","","","","","","","","","","","","","","","","","","","","","","","","02",""})
aAdd(aRegs,{cPerg,"15","Da Filial          ?","Da Filial          ?","Da Filial          ?","mv_chf","C",02,0,0,"G","","mv_par15","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"16","Ate a Filial       ?","Ate a Filial       ?","Ate a Filial       ?","mv_chg","C",02,0,0,"G","","mv_par16","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"17","Somente c/Pedidos  ?","Somente c/PediDos  ?","Somente c/PediDos  ?","mv_chh","N",01,0,0,"C","","mv_par17","Sim","","","Não","Não","Não","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"18","Gera planilha      ?","Gera planilha      ?","Gera Planilha      ?","mv_ch9","N",01,0,1,"C","","mv_par18","Sim","","","","","Nao","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"19","Nome da Planilha   ?","nome da Planilha   ?","Nome da Planilha   ?","mv_cha","C",30,0,0,"G","","mv_par19","","","","","","","","","","","","","","","","","","","","","","","","","",""})

For i := 1 to Len(aRegs)
	If !dbSeek(Padr(cPerg,Len(SX1->X1_GRUPO))+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			EndIf
		Next
		MsUnlock()
	EndIf
Next

dbSelectArea(_sAlias)

Return
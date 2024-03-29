#INCLUDE "rwmake.ch"
#INCLUDE "TopConn.ch"
#DEFINE ENTER CHR(13) + CHR(10)
//DEFINE FONT oFont NAME "Courier New" SIZE 0,10
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CFATR001  � Autor � Convergence        � Data �  19/10/08   ���
�������������������������������������������������������������������������͹��
���Descricao � Imprime Log de registros de espelho de pedidos de Venda    ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �Especifico para o cliente CCAB                              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function CFATR001

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������
Local cDesc1   := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2   := "de acordo com os parametros informados pelo usuario."
Local cDesc3   := "Log de Registros - Espelho de Pedido de Venda"
Local cPict    := ""
Local titulo   := "Log de Registros - Espelho de Pedido de Venda"
Local nLin     := 80
Local Cabec1   := "                               Filial/PV                                                    Campo     Campo        Conteudo                                Conteudo           "
Local Cabec2   := "Usu�rio         Data     Hora  ou/Pre.PV Pre-PV Cliente                                     Excluido  Alterado     Anterior:                               Atual:             "
//                 XXXXXXXXXXXXXXX 99/99/99 99:99 999999999 999999 999999.99-XXXXXXXXXXXXXXXXXXXXXXXX          SIM       XX_XXXXXXXXX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
//cal Cabec2   := "Usu�rio         Data     Hora  Fil/Ped.  Cliente                             Excluido  Alterado    Anterior:                               Atual:             "
//                 XXXXXXXXXXXXXXX 99/99/99 99:99 999999999 999999.99-XXXXXXXXXXXXXXXXXXXXXXXX  SIM       XX_XXXXXXX  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
Local imprime  := .T.
Local aOrd 		:= {}

Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 220
Private tamanho      := "G"
Private nomeprog     := "CFATR001"
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cPerg       	:= "RFAT01"
Private cbtxt      	:= Space(10)
Private cbcont     	:= 00
Private CONTFL     	:= 01
Private m_pag      	:= 01
Private wnrel      	:= "CFATR001"
Private cString		:= "SZ6"
Private aXRevis		:= {}
Private aXRevis2	:= {}
//���������������������������������������������������������������������Ŀ
//� Valida a existencia de perguntas e alimenta em memoria	            �
//�����������������������������������������������������������������������
ValidPerg(cPerg)
Pergunte(cPerg,.F.)

//���������������������������������������������������������������������Ŀ
//� Monta a interface padrao com o usuario...                           �
//�����������������������������������������������������������������������
wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.F.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)
//���������������������������������������������������������������������Ŀ
//� Processamento. RPTSTATUS monta janela com a regua de processamento. �
//�����������������������������������������������������������������������
RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo) 

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    �RUNREPORT � Autor � AP6 IDE            � Data �  11/07/06   ���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS ���
���          � monta a janela com a regua de processamento.               ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)
//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������
Local cArqTmp 		:= ""
Local aEstr			:= {}
Local cInd1			:= CriaTrab(Nil,.F.)
Local cQuery		:= ""
Local cSelect		:= ""
Local cSeleCount	:= ""
Local cQry			:= ""
Local nTotRegs		:= 0
Local lRecLock		:= .T.
Local cVendAnt		:= ""
Private aProds      := {}


//���������������������������������������������������������������������Ŀ
//�Monta clausulas da query a serem utilizadas no relatorio             �
//�����������������������������������������������������������������������
_cCampoZ5 := ''
_cCampoZ6 := ''
_cCampoC5 := ''
_cCampoC6 := ''
_cCamposZ5:= ''
_cCamposZ6 := ''

DbSelectArea('SZ5')
//For _nI := 1 To Len(FCount())
For _nI := 1 To FCount()
	_cCamposZ5 += FieldName(_nI)+', '
Next

DbSelectArea('SZ6')
//For _nI := 1 To Len(FCount())
For _nI := 1 To FCount()
	IF Alltrim(FieldName(_nI)) <> 'Z6_DATFAT' //.AND. Alltrim(FieldName(_nI)) <> 'Z6_QTDEMP'.AND. Alltrim(FieldName(_nI)) <> 'Z6_OP'.AND. Alltrim(FieldName(_nI)) <> 'Z6_QTDEMP2'
		_cCamposZ6 += FieldName(_nI)+', '
	ENDIF
Next

_cCampoZ6 := Left(_cCampoZ6, Len(_cCampoZ6)-2)

// Seleciona lista de Campos de SZ5 e SZ6
cSelect := "Select Z5_FILIAL, Z5_NUM "+ENTER   //, Z5_USER, Z5_DTLOG
If SZ5->(FieldPos("Z5_EHPREPV")) > 0
	cSelect += "  ,Z5_EHPREPV "
EndIf
cSelect += "From "+RetSqlName("SZ5")+" SZ5"+ENTER
cSelect += "Where SZ5.D_E_L_E_T_ = '' And"+ENTER
cSelect += "	   Z5_DTLOG  >= '"+DtoS(mv_par03)  +"' And Z5_DTLOG   <= '"+DtoS(mv_par04)+"' And"+ENTER
cSelect += "	   Z5_USER   >= '"+     PosUser(mv_par01)   +"' And Z5_USER    <= '"+PosUser(mv_par02) +"' And"+ENTER
cSelect += "	   Z5_NUM    >= '"+     mv_par05   +"' And Z5_NUM     <= '"+     mv_par06 +"' And"+ENTER
cSelect += "	   Z5_FILIAL >= '"+     mv_par12   +"' And Z5_FILIAL  <= '"+     mv_par13 +"'    "+ENTER

If SZ5->(FieldPos("Z5_EHPREPV")) > 0
	If mv_par11 == 1 //Pre-Pedido
		cSelect += "	   AND Z5_EHPREPV =  'S' " + ENTER
	ElseIf mv_par11 == 2 //Pedido
		cSelect += "	   AND Z5_EHPREPV <> 'S' " + ENTER
	ElseIf mv_par11 == 3 //Ambos
		cSelect += "	   AND Z5_EHPREPV >= ' ' " + ENTER
	EndIf
EndIf

cSelect += "GROUP By Z5_FILIAL, Z5_NUM" + ENTER
//cSelect += "GROUP By Z5_FILIAL, Z5_NUM, Z5_USER, Z5_DTLOG" + ENTER
If SZ5->(FieldPos("Z5_EHPREPV")) > 0
	cSelect += "  , Z5_EHPREPV "
EndIf
//cSelect += "ORDER BY SZ5.Z5_DTLOG, Z5_USER" + ENTER

//���������������������������������������������������������������������Ŀ
//�Executa query para selecao dos registros a serem processados no rel. �
//�����������������������������������������������������������������������

cQry := cSelect
If Select("TMPQ") > 0
	dbSelectArea("TMPQ")
	dbCloseArea()
EndIf
MemoWrite("CFatR001.sql",cQry)

TcQuery cQry New Alias "TMPQ"
TCSetField('TMPQ','Z5_DTLOG','D')
TCSetField('TMPQ','Z5_EMISSAO','D')
TCSetField('TMPQ','Z6_ENTREG','D')
TCSetField('TMPQ','Z6_XENTREG','D')
TCSetField('TMPQ','Z5_DATA1','D')
TCSetField('TMPQ','Z5_DATA2','D')
TCSetField('TMPQ','Z5_DATA3','D')
TCSetField('TMPQ','Z5_DATA4','D')

//TCSetField('TMPQ','Z6_DATFAT','D')

//���������������������������������������������������������������������Ŀ
//� SETREGUA -> Indica quantos registros serao processados para a regua �
//�����������������������������������������������������������������������
SetRegua(RecCount())

IF !EMPTY(MV_PAR08)
	AADD(aProds,MV_PAR08)
ENDIF

IF !EMPTY(MV_PAR09)
	AADD(aProds,MV_PAR09)
ENDIF

IF !EMPTY(MV_PAR10)
	AADD(aProds,MV_PAR10)
ENDIF

//������������������������������������������������������������������������������Ŀ
//� Loop no arquivo de trabalho para impressao dos registros                  	|
//��������������������������������������������������������������������������������
DbSelectArea('TMPQ')
DbGoTop()

Do While !TMPQ->(EOF())
	//���������������������������������������������������������������������Ŀ
	//� Verifica o cancelamento pelo usuario...                             �
	//�����������������������������������������������������������������������
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	//���������������������������������������������������������������������Ŀ
	//� Impressao do cabecalho do relatorio. . .                            �
	//�����������������������������������������������������������������������
	If nLin > 55 // Salto de P�gina. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8
	Endif
	
	// Seleciona lista de Campos de SZ5
	cSelect2 := "Select "+_cCamposZ5+" Z5_NUM "+ENTER
	cSelect2 += "From "+RetSqlName("SZ5")+" SZ5"+ENTER
	cSelect2 += "Where SZ5.D_E_L_E_T_ = '' AND "+ENTER
	cSelect2 += "	   Z5_NUM    = '"+TMPQ->Z5_NUM+"' AND "+ENTER
	cSelect2 += "	   Z5_FILIAL = '"+TMPQ->Z5_FILIAL+"' "+ENTER
//	cSelect2 += "	   Z5_USER = '"+TMPQ->Z5_USER+"' "+ENTER
	
	If SZ5->(FieldPos("Z5_EHPREPV")) > 0
		cSelect2 += "  AND Z5_EHPREPV = '"+TMPQ->Z5_EHPREPV+"' "
	EndIf
	
	cSelect2 += "Order By Z5_FILIAL, Z5_NUM,Z5_XREVISA "+ENTER
	
	//���������������������������������������������������������������������Ŀ
	//�Executa query para selecao dos registros a serem processados no rel. �
	//�����������������������������������������������������������������������
	
	cQry2 := cSelect2
	If Select("TMPCPA") > 0
		dbSelectArea("TMPCPA")
		dbCloseArea()
	EndIf
	//	MemoWrite("CFatR001CPA.sql",cQry)
	
	TcQuery cQry2 New Alias "TMPCPA"
	aXRevis := {}
	While TMPCPA->(!Eof())
		aAdd(aXRevis,TMPCPA->Z5_XREVISA)
		TMPCPA->(DbSkip())
	End
	TMPCPA->(DbGoTop())
	
	TCSetField("TMPCPA",'Z5_DTLOG','D')
	TCSetField("TMPCPA",'Z5_EMISSAO','D')
	TCSetField("TMPCPA",'Z5_DATA1','D')
	TCSetField("TMPCPA",'Z5_DATA2','D')
	TCSetField("TMPCPA",'Z5_DATA3','D')
	TCSetField("TMPCPA",'Z5_DATA4','D')
	
	//@nLin,001 pSay "Revisao : "+TMPCPA->Z5_XREVISA
	
	nRegAtu1 := 1
	DO WHILE TMPCPA->(!EOF())
		nRegAtu1 ++
		If nRegAtu1 < Len(aXRevis)
			cPxmRev1 := aXRevis[nRegAtu1]
		Else
			cPxmRev1 := Soma1(aXRevis[Len(aXRevis)])
		EndIf
		
		// Seleciona lista de Campos de SZ6
		cSelect6 := "Select "+_cCamposZ5+"Z5_NUM "+ENTER
		cSelect6 += "From "+RetSqlName("SZ5")+" SZ5"+ENTER
		cSelect6 += "Where SZ5.D_E_L_E_T_ = ''  AND "+ENTER
		cSelect6 += "	   Z5_FILIAL = '"+TMPCPA->Z5_FILIAL+"'  AND "+ENTER
		cSelect6 += "	   Z5_NUM    = '"+TMPCPA->Z5_NUM+"' AND Z5_XREVISA='"+cPxmRev1+"'"+ENTER
		If SZ5->(FieldPos("Z5_EHPREPV")) > 0
			cSelect6 += "  AND Z5_EHPREPV = '"+TMPCPA->Z5_EHPREPV+"' "
		EndIf
		cSelect6 += "Order By Z5_FILIAL, Z5_NUM,Z5_XREVISA "+ENTER
		
		cQry6 := cSelect6
		If Select("TMPCPA2") > 0
			dbSelectArea("TMPCPA2")
			dbCloseArea()
		EndIf
		TcQuery cQry6 New Alias "TMPCPA2"
		
		TCSetField("TMPCPA2",'Z5_DTLOG','D')
		TCSetField("TMPCPA2",'Z5_EMISSAO','D')
		TCSetField("TMPCPA2",'Z5_DATA1','D')
		TCSetField("TMPCPA2",'Z5_DATA2','D')
		TCSetField("TMPCPA2",'Z5_DATA3','D')
		TCSetField("TMPCPA2",'Z5_DATA4','D')
		
		//		TMPCPA2->(DbGoTop())
		
		IF TMPCPA2->(EOF()) .AND. TMPCPA2->(BOF())
			If TMPCPA->Z5_EHPREPV == "S"
				_cCmpCOri := 'SZ2->'
				_cAliasOri := 'SZ2->Z2'
			Else
				_cCmpCOri := 'SC5->'
				_cAliasOri := 'SC5->C5'
			EndIf
		ELSE
			_cCmpCOri := 'TMPCPA2->'
			_cAliasOri := "TMPCPA2->Z5"
		ENDIF
		lImpCapa := .T.
		
		//  	   nLin++
		If TMPCPA->Z5_EHPREPV == "S"
			DbSelectArea('SZ2')
		Else
			DbSelectArea('SC5')
		EndIf
		If DbSeek(TMPCPA->(Z5_FILIAL+Z5_NUM))
			IF MV_PAR11 == 1 .OR. MV_PAR11 == 3
				For _nI := 1 To IIf(TMPCPA->Z5_EHPREPV == "S",SZ2->(FCount()),SC5->(FCount()))
					If nLin > 55 // Salto de P�gina. Neste caso o formulario tem 55 linhas...
						Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
						nLin := 8
					Endif
					
					_cCmpC := _cAliasOri+IIf(TMPCPA->Z5_EHPREPV == "S",RIGHT(SZ2->(FieldName(_nI)),len(SZ2->(FieldName(_nI)))-2),RIGHT(SC5->(FieldName(_nI)),len(SC5->(FieldName(_nI)))-2))
					_cCmpZ := StrTran(_cCmpC, _cAliasOri,'TMPCPA->Z5')
					
					If 'USERLG' $ _cCmpC
						Loop
					EndIf
					IF _cCmpCOri == 'SC5->' .Or. _cCmpCOri == 'SZ2->'
						If TMPCPA->Z5_EHPREPV == "S"
							DbSelectArea('SZ2')
						Else
							DbSelectArea('SC5')
						EndIf
					ELSE
						DbSelectArea('SZ5')
					ENDIF
					
					If  SZ5->(FieldPos(Alltrim(Substr(_cCmpZ,9)))) > 0
						If Type(_cCmpZ) == 'C '
							If AllTrim(&_cCmpC) <> AllTrim(&_cCmpZ)
								IF lImpCapa
									ImpInfCapa(@nLin)
									lImpCapa := .F.
								ENDIF
								
								@nLin,102/*092*/ pSay RetTitle(StrTran(_cCmpC,_cCmpCOri))// FONT oDlg:Font
								@nLin,115/*105*/ pSay Padr(&_cCmpZ,40)
								@nLin,155/*136*/ pSay Padr(&_cCmpC,60)
								nLin++
							ELSEIF TYPE(_cCmpC) == "D"
								If &_cCmpC <> CTOD(&_cCmpZ)
									
									IF lImpCapa
										ImpInfCapa(@nLin)
										lImpCapa := .F.
									ENDIF
									@nLin,102 pSay Alltrim(RetTitle(StrTran(_cCmpC, _cCmpCOri/*'SC5->'*/)))
									@nLin,115 pSay Padr(&_cCmpZ,40)
									@nLin,155 pSay Padr(&_cCmpC,60)
									nLin++
								ENDIF
							EndIf						
						ElseIf Type(_cCmpZ) <> 'U'
								If &_cCmpC <> &_cCmpZ
									IF lImpCapa
										ImpInfCapa(@nLin)
										lImpCapa := .F.
									ENDIF
									@nLin,102 pSay RetTitle(StrTran(_cCmpC,_cCmpCOri))
									@nLin,115 pSay Padr(TRANSF(&_cCmpZ,AVSX3(StrTran(_cCmpC,_cCmpCOri/* 'SC5->'*/),6) ),40)//&_cCmpZ
									@nLin,155 pSay Padr(TRANSF(&_cCmpC,AVSX3(StrTran(_cCmpC, _cCmpCOri/*'SC5->'*/),6) ),60)//&_cCmpC
									nLin++
								EndIf
						EndIf				
					EndIf
				Next
			ENDIF
			
			IF MV_PAR11 == 1
				//		   nLin++
				ImprNewProd(@nLin)
				TMPQ->(dbSkip())
			ENDIF
			
			// Seleciona lista de Campos de SZ6
			cSelect3 := "Select "+_cCamposZ6+"Z6_NUM "+ENTER
			cSelect3 += "From "+RetSqlName("SZ6")+" SZ6"+ENTER
			cSelect3 += "Where SZ6.D_E_L_E_T_ = '' And "+ENTER
			cSelect3 += "	   Z6_FILIAL = '"+TMPQ->Z5_FILIAL+"' and "+ENTER
			cSelect3 += "	   Z6_NUM    = '"+TMPQ->Z5_NUM   +"' and Z6_XREVISA='"+TMPCPA->Z5_XREVISA+"' "+ENTER
			If SZ6->(FieldPos("Z6_EHPREPV")) > 0
				cSelect3 += "  AND Z6_EHPREPV = '"+TMPQ->Z5_EHPREPV+"' "
			EndIf
			
			cSelect3 += "Order By Z6_FILIAL, Z6_NUM,Z6_ITEM,Z6_XREVISA "+ENTER
			
			cQry3 := cSelect3
			If Select("TMPDET") > 0
				dbSelectArea("TMPDET")
				dbCloseArea()
			EndIf
			TcQuery cQry3 New Alias "TMPDET"
			
			aXRevis2 := {}
			While TMPDET->(!Eof())
				aAdd(aXRevis2,TMPDET->Z6_XREVISA)
				TMPDET->(DbSkip())
			End
			TMPDET->(DbGoTop())
			
			TCSetField("TMPDET",'Z6_ENTREG','D')
			TCSetField("TMPDET",'Z6_XENTREG','D')
			
			_aItRevImp:= {}   
			IF Len(aXRevis2) > 0
				_cLastItem := Soma1(aXRevis2[Len(aXRevis2)])
			ELSE
				_cLastItem := '001'
			ENDIF
			
			nRegAtu2 := 1
			DO WHILE TMPDET->(!EOF())
				
				For nRegAtu2:=1 To Len(aXRevis2)
					If aXRevis2[nRegAtu2] > TMPDET->Z6_XREVISA
						cPxmRev2 := aXRevis2[nRegAtu2]
						nRegAtu2 := Len(aXRevis2)
					Else
						cPxmRev2 := Soma1(aXRevis2[nRegAtu2])
					EndIf
				Next nRegAtu2
				
				_cLastItem := cPxmRev2
				
				If nLin > 55 // Salto de P�gina. Neste caso o formulario tem 55 linhas...
					Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
					nLin := 9
				Endif
				IF LEN(aProds) > 0
					IF (nPos:=Ascan(aProds,TMPDET->Z6_PRODUTO)) == 0
						TMPDET->(DBSKIP())
						LOOP
					ENDIF
				ENDIF
				
				// Seleciona lista de Campos de SZ6
				cSelect3 := "Select "+_cCamposZ6+"Z6_NUM "+ENTER
				cSelect3 += "From "+RetSqlName("SZ6")+" SZ6"+ENTER
				cSelect3 += "Where SZ6.D_E_L_E_T_ = '' And "+ENTER
				cSelect3 += "	   Z6_FILIAL = '"+TMPQ->Z5_FILIAL+"' and "+ENTER
				cSelect3 += "	   Z6_NUM    = '"+TMPQ->Z5_NUM+"' AND Z6_ITEM='"+TMPDET->Z6_ITEM+"' AND Z6_XREVISA='"+cPxmRev2+"'"+ENTER
				If SZ6->(FieldPos("Z6_EHPREPV")) > 0
					cSelect3 += "  AND Z6_EHPREPV = '"+TMPQ->Z5_EHPREPV+"' "
				EndIf
				
				IF !EMPTY(MV_PAR08) .OR. !EMPTY(MV_PAR09) .OR. !EMPTY(MV_PAR10)
					cSelect3 += " AND ( "
				ENDIF
				
				IF !EMPTY(MV_PAR08)
					cSelect3 += "  Z6_PRODUTO   = '"+MV_PAR08+"' "+ENTER
				ENDIF
				
				IF !EMPTY(MV_PAR09)
					IF !EMPTY(MV_PAR08)
						cSelect3 += " OR "
					ENDIF
					cSelect3 +=  "   Z6_PRODUTO   = '"+MV_PAR09+"' "+ENTER
				ENDIF
				
				IF !EMPTY(MV_PAR10)
					IF !EMPTY(MV_PAR08) .OR. !EMPTY(MV_PAR09)
						cSelect3 += " OR "
					ENDIF
					cSelect3 +=  "   Z6_PRODUTO   = '"+MV_PAR10+"' "+ENTER
				ENDIF
				
				IF !EMPTY(MV_PAR08) .OR. !EMPTY(MV_PAR09) .OR. !EMPTY(MV_PAR10)
					cSelect3 += " ) "
				ENDIF
				
				cSelect3 += "Order By Z6_FILIAL, Z6_NUM,Z6_ITEM,Z6_XREVISA "+ENTER
				
				cQry3 := cSelect3
				If Select("TMPDET2") > 0
					dbSelectArea("TMPDET2")
					dbCloseArea()
				EndIf
				TcQuery cQry3 New Alias "TMPDET2"
				TCSetField("TMPDET2",'Z6_ENTREG','D')
				TCSetField("TMPDET2",'Z6_XENTREG','D')
				
				AADD(_aItRevImp,{TMPDET2->Z6_ITEM,TMPDET2->Z6_XREVISA})
				
				IF TMPDET2->(EOF()) .AND. TMPDET2->(BOF())
					If TMPQ->Z5_EHPREPV == "S"
						_cCmpCOri := 'SZ3->'
						_cAliasOri := 'SZ3->Z3'
					Else
						_cCmpCOri := 'SC6->'
						_cAliasOri := 'SC6->C6'
					EndIf
				ELSE
					_cCmpCOri := 'TMPDET2->'
					_cAliasOri := "TMPDET2->Z6"
				ENDIF
				
				If TMPQ->Z5_EHPREPV == "S"
					DbSelectArea('SZ3')
					DbSetOrder(1)
					nTamCpo := Len(SZ3->Z3_NUM)
				Else
					DbSelectArea('SC6')
					nTamCpo := Len(SC6->C6_NUM)
				EndIf
				If DbSeek(TMPDET->(Z6_FILIAL+Padr(Z6_NUM,nTamCpo)+Z6_ITEM))
					For _nI := 1 To IIf(TMPQ->Z5_EHPREPV == "S",SZ3->(FCount()),SC6->(FCount()))
						If nLin > 55 // Salto de P�gina. Neste caso o formulario tem 55 linhas...
							Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
							nLin := 9
						Endif
						_cCmpC := _cAliasOri+IIf(TMPQ->Z5_EHPREPV == "S",RIGHT(SZ3->(FieldName(_nI)),len(SZ3->(FieldName(_nI)))-2),RIGHT(SC6->(FieldName(_nI)),len(SC6->(FieldName(_nI)))-2))
						//                _cCmpZ := StrTran(_cCmpC, 'SC6->C6','TMPDET->Z6')
						_cCmpZ := StrTran(_cCmpC, _cAliasOri,'TMPDET->Z6')
						
						If 'USERLG' $ _cCmpC .OR. 'MOPC' $ _cCmpC .OR. 'XDESPER' $ _cCmpC .OR. 'XDTINCL' $ _cCmpC .OR. 'DATFAT' $ _cCmpC .OR. "NUMSFA" $ _cCmpC .OR. "ITEMSFA" $ _cCmpC .OR. "QTDPEN" $ _cCmpC .OR. "XTPPROD" $ _cCmpC .OR. "XTROCAP" $ _cCmpC
							Loop
						EndIf
						
						// - Campos Divergentes.
						If 'TPDEDUZ' $ _cCmpC .OR. 'NFDED' $ _cCmpC .OR. 'MOTDED' $ _cCmpC .OR. 'FORDED' $ _cCmpC;
							.OR. 'LOJDED' $ _cCmpC .OR. 'SERDED' $ _cCmpC .OR. 'VLNFD' $ _cCmpC .OR. 'PCDED' $ _cCmpC;
							.OR. 'VLDED' $ _cCmpC .OR. 'ABATINS' $ _cCmpC .OR. 'CODLAN' $ _cCmpC .OR. 'PEDCOM' $ _cCmpC;
							.OR. 'ITPC' $ _cCmpC .OR. 'FILPED' $ _cCmpC .OR. 'BASVEIC' $ _cCmpC
							Loop
						EndIf
						
						If SZ6->(FieldPos(Alltrim(Substr(_cCmpZ,9)))) > 0
							If ValType(&_cCmpZ) == 'C'
								If AllTrim(&_cCmpC) <> AllTrim(&_cCmpZ)
									IF lImpCapa
										ImpInfCapa(@nLin)
										lImpCapa := .F.
									ENDIF
									@nLin,050 pSay "Item  "+ALLTRIM(&(_cAliasOri+'_ITEM'))+" - "+substring(Posicione("SB1",1,xFilial("SB1")+&(_cAliasOri+'_PRODUTO'),"B1_DESC"),1,25)
									@nLin,102 pSay RetTitle(StrTran(_cCmpC,_cCmpCOri))
									@nLin,115 pSay Padr(&_cCmpZ,40)
									IF TMPQ->Z5_EHPREPV == "S"
										If SZ3->(!EOF())
											@nLin,155 pSay Padr(&_cCmpC,60)
										ELSE
											@nLin,155 pSay "Produto Excluido !"
										ENDIF
									Else
										If SC6->(!EOF())
											@nLin,155 pSay Padr(&_cCmpC,60)
										ELSE
											@nLin,155 pSay "Produto Excluido !"
										ENDIF
									EndIf
									nLin++
								EndIf						
					  		ElseIf ValType(&_cCmpZ) <> 'U'
								If &_cCmpC <> &_cCmpZ
									IF lImpCapa
										ImpInfCapa(@nLin)
										lImpCapa := .F.
									ENDIF
									
									@nLin,050 pSay "Item  "+ALLTRIM(&(_cAliasOri+'_ITEM'))+" - "+substring(Posicione("SB1",1,xFilial("SB1")+&(_cAliasOri+'_PRODUTO'),"B1_DESC"),1,25)
									@nLin,102 pSay RetTitle(StrTran(_cCmpC, _cCmpCOri))
									@nLin,115 pSay Padr(TRANSF(&_cCmpZ,AVSX3(StrTran(_cCmpC, _cCmpCOri),6) ),40)
									IF TMPQ->Z5_EHPREPV == "S"
										IF SZ3->(!EOF())
											@nLin,155 pSay Padr(TRANSF(&_cCmpC,AVSX3(StrTran(_cCmpC, _cCmpCOri),6) ),60)//&_cCmpC
										ELSE
											@nLin,155 pSay "Produto Excluido !"
										ENDIF
									Else
										IF SC6->(!EOF())
											@nLin,155 pSay Padr(TRANSF(&_cCmpC,AVSX3(StrTran(_cCmpC, _cCmpCOri),6) ),60)//&_cCmpC
										ELSE
											@nLin,155 pSay "Produto Excluido !"
										ENDIF
									EndIf
									nLin++
								EndIf
							EndIf
						EndIf					
					Next
				EndIf
				TMPDET->(DBSKIP())
			ENDDO
			
			// Seleciona lista de Campos de SZ6
			cSelect5 := "Select "+_cCamposZ6+"Z6_NUM "+ENTER
			cSelect5 += "From "+RetSqlName("SZ6")+" SZ6"+ENTER
			cSelect5 += "Where SZ6.D_E_L_E_T_ = '' And "+ENTER
			cSelect5 += "	   Z6_FILIAL = '"+TMPQ->Z5_FILIAL+"' and "+ENTER
			cSelect5 += "	   Z6_NUM    = '"+TMPQ->Z5_NUM+"' AND Z6_XREVISA='"+_cLastItem+"'"+ENTER
			If SZ6->(FieldPos("Z6_EHPREPV")) > 0
				cSelect5 += "  AND Z6_EHPREPV = '"+TMPQ->Z5_EHPREPV+"' "
			EndIf
			cSelect5 += "Order By Z6_FILIAL DESC, Z6_NUM,Z6_ITEM,Z6_XREVISA "+ENTER
			
			cQry5 := cSelect5
			If Select("TMPDET5") > 0
				dbSelectArea("TMPDET5")
				dbCloseArea()
			EndIf
			TcQuery cQry5 New Alias "TMPDET5"
			
			DO WHILE TMPDET5->(!EOF())
				IF !EMPTY(MV_PAR08) .OR. !EMPTY(MV_PAR09) .OR. !EMPTY(MV_PAR10)
					IF TMPDET5->Z6_PRODUTO <> MV_PAR08 .AND. TMPDET5->Z6_PRODUTO <> MV_PAR09 .AND. TMPDET5->Z6_PRODUTO <> MV_PAR10
						TMPDET5->(DBSKIP())
						LOOP
					ENDIF
				ENDIF
				
				IF LEN(aProds) > 0
					IF (nPos:=Ascan(aProds,TMPDET5->Z6_PRODUTO)) == 0
						TMPDET5->(DBSKIP())
						LOOP
					ENDIF
				ENDIF
				
				IF nPos := Ascan(_aItRevImp,{|x|x[1]==TMPDET5->Z6_ITEM .AND. x[2]==TMPDET5->Z6_XREVISA }) == 0
					IF lImpCapa
						ImpInfCapa(@nLin)
						lImpCapa := .F.
					ENDIF
					
					@nLin,001 pSay "Inclusao do Produto :"
					nLin++
					@nLin,001 pSay "Item  "+ALLTRIM(TMPDET5->Z6_ITEM)+" Cod.Prod "+ALLTRIM(TMPDET5->Z6_PRODUTO)+" Descricao "+ALLTRIM(substring(Posicione("SB1",1,xFilial("SB1")+TMPDET5->Z6_PRODUTO,"B1_DESC"),1,25))+" Quantidade "+Alltrim(TRANSF(TMPDET5->Z6_QTDVEN,AVSX3( "Z6_QTDVEN",6) ))
					nLin++
				ENDIF
				TMPDET5->(DBSKIP())
			ENDDO
		EndIf
		TMPCPA->(DBSKIP())
	ENDDO
	
	
	nLin++
	
	TMPQ->(dbSkip())
EndDo


SET DEVICE TO SCREEN
//���������������������������������������������������������������������Ŀ
//� Se impressao em disco, chama o gerenciador de impressao...          �
//�����������������������������������������������������������������������
If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif
MS_FLUSH()

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    �VALIDPERG � Autor �                    � Data �  11/07/06   ���
�������������������������������������������������������������������������͹��
���Descri��o � Verifica a existencia das perguntas criando-as caso seja   ���
���          � necessario                                                 ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function ValidPerg(cPerg)
//�������������������������Ŀ
//� Definicoes de variaveis �
//���������������������������
Local aArea   := GetArea()
Local aRegs   := {}
aAdd(aRegs,{cPerg,"01","Usuario de          ?     ","","","mv_ch1","C",15,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"02","Usuario at�         ?     ","","","mv_ch2","C",15,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"03","Data de             ?     ","","","mv_ch3","D",08,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"04","Data at�            ?     ","","","mv_ch4","D",08,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"05","Pre-Ped e Pedido de ?     ","","","mv_ch5","C",06,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"06","Pre-Ped e Pedido at�?     ","","","mv_ch6","C",06,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"07","Opera��o            ?     ","","","mv_ch7","N",01,0,0,"C","","mv_par07","Altera��o","","","","","Exclus�o","","","","","Ambas","","","","","","","","","","","","","",""})
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
aAdd(aRegs,{cPerg,"11","Listar              ?     ","","","mv_chc","N",01,0,0,"C","","mv_par11","Pr�-Pedido","","","","","Pedido","","","","","Ambas","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"12","Da Filial           ?     ","","","mv_chd","C",02,0,0,"G","","mv_par12","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"13","At� Filial          ?     ","","","mv_che","C",02,0,0,"G","","mv_par13","","","","","","","","","","","","","","","","","","","","","","","","",""})


//��������������������������������������������Ŀ
//�Atualizacao do SX1 com os parametros criados�
//����������������������������������������������
DbSelectArea("SX1")
DbSetorder(1)
For nX:=1 to Len(aRegs)
	If !dbSeek(Padr(cPerg,Len(SX1->X1_GRUPO))+aRegs[nX,2])
		RecLock("SX1",.T.)
		For nY:=1 to FCount()
			If nY <= Len(aRegs[nX])
				FieldPut(nY,aRegs[nX,nY])
			EndIf
		Next
		SX1->(MsUnlock())
	EndIf
Next
//�������������������������Ŀ
//�Retorna ambiente original�
//���������������������������
RestArea(aArea)
Return(Nil)
*-------------------------------*
Static Function ImprNewProd(nLin)
*-------------------------------*

IF MV_PAR11 == 1
	Return .T.
ENDIF

If TMPQ->Z5_EHPREPV == "S"
	cSelect4 :=     " SELECT Z3_FILIAL C6_FILIAL, Z3_NUM C6_NUM, Z3_ITEM C6_ITEM, Z3_USERLGI C6_USERLGI, ' ' C6_XDTINCL, Z3_PRODUTO C6_PRODUTO, Z3_QTDVEN C6_QTDVEN "
	cSelect4 +=     "   FROM "+RetSqlName("SZ3")+" SZ3 WHERE SZ3.D_E_L_E_T_ = '' AND Z3_FILIAL='  ' AND Z3_NUM='000016'  AND Z3_NUM='000016' AND Z3_FILIAL+Z3_NUM+Z3_ITEM "
	cSelect4 +=     "    NOT IN(SELECT Z6_FILIAL+Z6_NUM+Z6_ITEM FROM "+RetSqlName("SZ6")+" SZ6 WHERE SZ6.D_E_L_E_T_ = '' AND Z6_FILIAL+Z6_NUM=Z3_FILIAL+Z3_NUM ) "
Else
	cSelect4 :=     " SELECT C6_FILIAL,C6_NUM,C6_ITEM,* FROM "+RetSqlName("SC6")+" SC6 WHERE SC6.D_E_L_E_T_ = '' AND C6_FILIAL='"+TMPQ->Z5_FILIAL+"' AND C6_NUM='"+TMPQ->Z5_NUM+"' AND C6_FILIAL+C6_NUM+C6_ITEM "
	cSelect4 +=     " 	NOT IN(SELECT Z6_FILIAL+Z6_NUM+Z6_ITEM FROM "+RetSqlName("SZ6")+" SZ6 WHERE SZ6.D_E_L_E_T_ = '' AND Z6_FILIAL+Z6_NUM=C6_FILIAL+C6_NUM )"
EndIf

cQry4 := cSelect4
If Select("TMPIT") > 0
	dbSelectArea("TMPIT")
	dbCloseArea()
EndIf
TcQuery cQry4 New Alias "TMPIT"
TCSetField("TMPIT","C6_XDTINCL",'D')

IF TMPIT->(!BOF()) .AND. TMPIT->(!EOF())
	
	@nLin,001 pSay left(EMBARALHA(TMPIT->C6_USERLGI,1),15)
	@nLin,020 pSay TMPIT->C6_XDTINCL
	//@nLin,046 pSay TMPCPA->(Z5_CLIENTE+'.'+Z5_LOJACLI+'-'+Left(Posicione('SA1',1,xFilial('SA1')+Z5_CLIENTE+Z5_LOJACLI,'A1_NOME'),24))
	nLin++
	
	DO WHILE TMPIT->(!EOF())
		IF LEN(aProds) > 0
			IF (nPos:=Ascan(aProds,TMPIT->C6_PRODUTO)) <> 0
				@nLin,001 pSay "Inclusao do Produto :"
				nLin++
				@nLin,001 pSay "Item  "+ALLTRIM(TMPIT->C6_ITEM)+" Cod.Prod "+ALLTRIM(TMPIT->C6_PRODUTO)+" Descricao "+ALLTRIM(substring(Posicione("SB1",1,xFilial("SB1")+TMPIT->C6_PRODUTO,"B1_DESC"),1,25))+" Quantidade "+Alltrim(TRANSF(TMPIT->C6_QTDVEN,AVSX3( "Z6_QTDVEN",6) ))
				nLin++
			ENDIF
		ELSE
			@nLin,001 pSay "Inclusao do Produto :"
			nLin++
			@nLin,001 pSay "Item  "+ALLTRIM(TMPIT->C6_ITEM)+" Cod.Prod "+ALLTRIM(TMPIT->C6_PRODUTO)+" Descricao "+ALLTRIM(substring(Posicione("SB1",1,xFilial("SB1")+TMPIT->C6_PRODUTO,"B1_DESC"),1,25))+" Quantidade "+Alltrim(TRANSF(TMPIT->C6_QTDVEN,AVSX3( "Z6_QTDVEN",6) ))
			nLin++
		ENDIF
		TMPIT->(DBSKIP())
	ENDDO
ENDIF

If Select("TMPIT") > 0
	dbSelectArea("TMPIT")
	dbCloseArea()
EndIf
Return .T.
*-------------------------------*
Static Function ImpInfCapa(nLin)
*-------------------------------*

nLin++
@nLin,001 pSay Substr(TMPCPA->Z5_USER,1,14)
@nLin,016 pSay TMPCPA->Z5_DTLOG
@nLin,025 pSay TMPCPA->Z5_HRLOG
@nLin,031 pSay IIf(Empty(TMPCPA->Z5_FILIAL),"PR",TMPCPA->Z5_FILIAL)+"/"+TMPCPA->Z5_NUM
@nLin,041 pSay IIf(Empty(TMPCPA->Z5_FILIAL),"  ",Posicione('SC5',1,TMPCPA->Z5_FILIAL+TMPCPA->Z5_NUM,'C5_PRENUM'))
@nLin,048 pSay TMPCPA->(Z5_CLIENTE+'.'+Z5_LOJACLI+'-'+Left(Posicione('SA1',1,xFilial('SA1')+Z5_CLIENTE+Z5_LOJACLI,'A1_NOME'),24))
nLin++


Return .T.



/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CFATR001  �Autor  �Valdemir Jose       � Data �  07/05/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Rotina ir� posicionar o usuario, retornando o nome completo���
���          � conforme gravado na tabela SZ5                             ���
�������������������������������������������������������������������������͹��
���Retorno   � Caracteres                                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function PosUser(pcUsuario)
	Local cRET := ""
	
	PswOrder(1)                                 //PswOrder(<nOrdem>) seleciona a ordem de pesquisa: 1;2;3;4    --->>> Verificar tabela de ordens no final do fonte
	if PswSeek(pcUsuario)                       //PswSeek(<cConteudo>,<lUsuario>) pesquisa usuario segundo ordem definida pela PswOrder, retorno .T./.F.
		aRetUser:=PswRet(1)                     //PswRet() retorna informacoes do usuario conforme lista com Vetor com configuracoes dos usuarios.	
		cRET := Substr(aRetUser[1][4],1,15)
	ELSE
		cRET := pcUsuario
	Endif    
	
Return cRET
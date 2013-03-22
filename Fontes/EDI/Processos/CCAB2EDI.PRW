#Include "protheus.ch"
#Include "topconn.ch"

//---------------------------------------------------------------------------
//Ajustes para funcionar corretamente este rotina
//Particularidades CCAB
//---------------------------------------------------------------------------
//Erro LP 530 SEQ 011 estแ com erro
//---------------------------------------------------------------------------

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑบออออออออออุออออออออออุอออออออุอออออออออออออออออออออออุออออออุออออออออออบฑฑ
ฑฑบPrograma  บ CCAB2EDI บAutor  บFelipe Aur้lio de Melo บ Data บ 30/10/09 บฑฑ
ฑฑบออออออออออุออออออออออออออออออฯอออออออออออออออออออออออออออฯอออออออออออออบฑฑ
ฑฑบDesc.     บ                                                            บฑฑ
ฑฑบ          บ                                                            บฑฑ
ฑฑบออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออบฑฑ
ฑฑบUso       บ CCAB2EDI                                                   บฑฑ
ฑฑบออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออบฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User function CCAB2EDI()

Local nHdl
Local lVldPrg := .T.
Local lCntnua := .F.
Private cPerg := "RL2EDI"

fAtuSX1()
fAtuSXB()

//For็a valida็ใo das perguntas
While lVldPrg
	If Pergunte(cPerg,.T.)
		If fVldPerg()
			lVldPrg := .F.
			lCntnua := .T.
		EndIf
	Else
		lVldPrg := .F.
		lCntnua := .F.
	EndIf
End

//Processa se tudo OK
If lCntnua
	//Tira espa็os da rotina
	mv_par01 := AllTrim(mv_par01)
	
	// Tenta abrir o arquivo em modo exclusivo.
	// Se nao conseguir o acesso exclusivo, sair da rotina.
	nHdl := FOpen(mv_par01,16)
	If nHdl < 0
		MsgAlert("Nใo foi possํvel abrir o arquivo no modo exlusivo!")
		Return
	Endif
	
	//Finalizar uso do arquivo
	fClose(nHdl)
	
	//Inicio do processamento do arquivo
	Processa({|| fLerGravar(mv_par01)})
	
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑบออออออออออุออออออออออุอออออออุอออออออออออออออออออออออุออออออุออออออออออบฑฑ
ฑฑบPrograma  บfLerGravarบAutor  บFelipe Aur้lio de Melo บ Data บ 04/10/09 บฑฑ
ฑฑบออออออออออุออออออออออออออออออฯอออออออออออออออออออออออออออฯอออออออออออออบฑฑ
ฑฑบDesc.     บ                                                            บฑฑ
ฑฑบ          บ                                                            บฑฑ
ฑฑบออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออบฑฑ
ฑฑบUso       บ CCAB2EDI                                                   บฑฑ
ฑฑบออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออบฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fLerGravar(cOrig)

Local cIdeReg := ""
Local cTipArq := ""
Local cDiaMes := ""
Local cHraMin := ""
Local cSeqArq := ""
Local cCgcTrs := ""
Local cCodTrs := ""
Local cLojTrs := ""
Local cEstTrs := ""
Local cNomTrs := ""

Local cLinha  := ""
Local aLinha  := {}
Local nCount  := 0

Local lIncFat := .F.
Local aFatPag := {}
Local aFatGrp := {}

Local c352Num := ""
Local d352Emi := StoD("")
Local d352Vct := StoD("")
Local n352Vlr := 0

Local c353Ser := ""
Local c353Doc := ""

Local cCgcFil := ""
Local cBkpFil := ""
Local cTxtLog := ""
Local aLogErro:= {}

Local nLen13  := 0
Local nLen13x := 0

Local lContinua := .T.

//Abre arquivo
FT_FUSE(cOrig)

//Carrega contador
ProcRegua(FT_FLASTREC())

//Posiciona no primeiro registro
FT_FGOTOP()

//Valida se o arquivo ้ o correto
If !FT_FEOF()
	//Vai pra pr๓xima linha
	FT_FSKIP()
	
	If FT_FEOF()
		//Nใo tem proxima linha
		cLinha := ""
	Else
		//Carrega uma linha do arquivo
		cLinha  := FT_FREADLN()
	EndIf
	
	//Primeiro Tratamento - 350
	If Len(AllTrim(cLinha)) >= 16
		//Carrega variaveis do cabe็alho
		cIdeReg := SubStr(cLinha,01,03)
		cTipArq := SubStr(cLinha,04,05)
		cDiaMes := SubStr(cLinha,09,02)+"/"+SubStr(cLinha,11,02)
		cHraMin := SubStr(cLinha,13,02)+":"+SubStr(cLinha,15,02)
		cSeqArq := SubStr(cLinha,17,01)
	EndIf
	
	//Vai pra pr๓xima linha
	FT_FSKIP()
	
	If FT_FEOF()
		//Nใo tem proxima linha
		cLinha := ""
	Else
		//Carrega uma linha do arquivo
		cLinha  := FT_FREADLN()
	EndIf
	
	//Segundo Tratamento - 351
	If Len(AllTrim(cLinha)) >= 17
		//Carrega variaveis do cabe็alho
		cIdeReg += SubStr(cLinha,01,03)
		cCgcTrs := SubStr(cLinha,04,14)
	EndIf
	
	//Localiza o cadatro da transportadora
	SA2->(DbSetOrder(3))
	If SA2->(DbSeek(xFilial("SA2")+cCgcTrs))
		cCodTrs := SA2->A2_COD
		cLojTrs := SA2->A2_LOJA
		cEstTrs := SA2->A2_EST
		cNomTrs := AllTrim(SA2->A2_NOME)
	EndIf
	
	//Vai pra pr๓xima linha
	FT_FSKIP()
EndIf

//Verifica o conte๚do do arquivo
If lContinua .And. (cIdeReg != "350351" .Or. cTipArq != "COBRA")
	lContinua := .F.
	MsgAlert("O Arquivo informado nใo ้ compatํvel!!!"+Space(30) +Chr(13)+Chr(10)+Chr(13)+Chr(10)+;
	"Layout: DocCob"                                    +Chr(13)+Chr(10)+;
	"Versใo: 3.0A"                                      +Chr(13)+Chr(10)+;
	"Data: 03/03/1999 - Ano 2000")
EndIf

//Verifica se o fornecedor do arquivo ้
//diferente do informado no parametro
If lContinua
	If AllTrim(cCodTrs)+AllTrim(cLojTrs) != AllTrim(mv_par02)+AllTrim(mv_par03)
		lContinua := .F.
		MsgAlert("O fornecedor informado no parโmetro ้ diferente do informado no arquivo!!!" +Chr(13)+Chr(10)+Chr(13)+Chr(10)+;
		"Parโmetro: "+AllTrim(mv_par02)+"-"+AllTrim(mv_par03)                        +Chr(13)+Chr(10)+;
		"Arquivo:   "+AllTrim(cCodTrs)+"-"+AllTrim(cLojTrs)                          )
	EndIf
EndIf

//Caso o arquivo seja validado
If lContinua
	If SimNao("Data do Arquivo: "+cDiaMes                            +Chr(13)+Chr(10)+;
		"Hora do Arquivo: "+cHraMin                            +Chr(13)+Chr(10)+;
		"Sequ.do Arquivo: "+cSeqArq                            +Chr(13)+Chr(10)+;
		"Cad. Fornecedor: "+cCodTrs+"/"+cLojTrs+" - "+cNomTrs  +Chr(13)+Chr(10)+Chr(13)+Chr(10)+;
		"Confirma processamento do arquivo?"+Space(30)) != "S"
		lContinua := .F.
	EndIf
EndIf

//Caso nใo continuar, entใo sair da rotina
If !lContinua
	Return
EndIf

lCtrl352 := .F.
lCtrl353 := .F.
lCtrl354 := .F.

//Le arquivo linha a linha
While !FT_FEOF()
	nCount ++
	
	//Processa contador
	IncProc()
	
	//Carrega uma linha do arquivo
	cLinha := FT_FREADLN()
	
	//Identifica registro
	cIdeReg := SubStr(cLinha,01,03)
	
	
	//Documento de cobran็a
	If cIdeReg == "352"
		//Formata linha no layout conforme identifica็ใo
		cLinha := fTrataLin(cLinha,1)
		//Valida acesso
		lCtrl352 := .T.
	EndIf
	
	//Conhecimentos em cobran็a
	If cIdeReg == "353"
		//Formata linha no layout conforme identifica็ใo
		cLinha := fTrataLin(cLinha,2)
		
		//Valida acesso
		lCtrl353 := .T.
	EndIf
	
	//NF em cobran็a no conhecimento
	If cIdeReg == "354"
		//Formata linha no layout conforme identifica็ใo
		cLinha := fTrataLin(cLinha,3)
		
		//Valida acesso
		lCtrl354 := .T.
	EndIf
	
	//Quebra linha num array
	aLinha := StrToKArr(cLinha,";")
	
	//Valida rodap้ com itens?
	
	
	//Caso itens, faz tratamentos e monta array
	If cIdeReg == "352"
		//Carrega informa็๕es
		c352Num := StrZero(Val(aLinha[5]),9)
		d352Emi := StoD(Substr(aLinha[6],5,4)+Substr(aLinha[6],3,2)+Substr(aLinha[6],1,2))
		d352Vct := StoD(Substr(aLinha[7],5,4)+Substr(aLinha[7],3,2)+Substr(aLinha[7],1,2))
		n352Vlr := Val(aLinha[8])
	EndIf
	
	//Caso itens, faz tratamentos e monta array
	If cIdeReg == "353"
		//Carrega informa็๕es
		/*
		If Len(AllTrim(aLinha[3])) == 3
		c353Ser := Padr(AllTrim(aLinha[3]),3)
		Else
		c353Ser := Padr(aLinha[3],1)+"30"
		EndIf
		*/
		c353Ser := Padr(AllTrim(aLinha[3]),3)
		c353Doc := StrZero(Val(aLinha[4]),9)
		//Titulos da fatura
		aAdd(aFatGrp,{})
		aAdd(aFatGrp[Len(aFatGrp)],c353Ser  )	//[1] Prefixo //Tamanho 3 -> Conforme arquivo
		aAdd(aFatGrp[Len(aFatGrp)],c353Doc  )	//[2] Numero  //Tamanho 9 -> Conforme arquivo
		aAdd(aFatGrp[Len(aFatGrp)],"   "    )	//[3] Parcela //Tamanho 3 -> Em branco
		aAdd(aFatGrp[Len(aFatGrp)],"NF "    )	//[4] Tipo    //Tamanho 3 -> NF sempre
		aAdd(aFatGrp[Len(aFatGrp)],.F.      )	//[5] Tํtulo localizado na geracao de fatura (l๓gico). Iniciar com falso.
	EndIf
	
	//Caso itens, faz tratamentos e monta array
	If cIdeReg == "354"
		//Carrega informa็๕es
		cCgcFil := aLinha[7]
	EndIf
	
	//-------------------------------------------------------------------------------------------------------------------------
	//Proxima linha
	FT_FSKIP()
	
	//Identifica registro
	cIdeReg := SubStr(FT_FREADLN(),01,03)
	
	//Verifica se passou por todos os processos
	If cIdeReg $ "352|355"
		If lCtrl352 .And. lCtrl353 .And. lCtrl354
			lIncFat := .T.
		Else
			//Para cada 352 tem que ter pelo menos um 353 e um 354
			//Para cada 343 tem que pelo menos um 354
			aAdd(aLogErro,Replicate("-",75))
			aAdd(aLogErro,"Linha: "+StrZero(2+nCount,4))
			aAdd(aLogErro,"Fornec/Loja: "+cCodTrs+"/"+cLojTrs)
			aAdd(aLogErro,"Mensagem: Inconsistencia do lay-out, cobran็a nใo aglutinada.")
			aAdd(aLogErro,"Mensagem: Aglutina็ใo e gera็ใo de tํtulo nใo realizada")
			aAdd(aLogErro,"")
			//Volta flag de controle para falso
			lIncFat  := .F.
			lCtrl352 := .F.
			lCtrl353 := .F.
			lCtrl354 := .F.
		EndIf
	EndIf
	
	//Controla duplas de 353 e 354
	If !lIncFat .And. lCtrl352
		Do Case
			Case lCtrl353 .And. !lCtrl354 .And. cIdeReg == "354"
				//Normal, pois o pr๓ximo ้ o 354
				
			Case lCtrl353 .And. !lCtrl354 .And. cIdeReg == "353"
				//Errado, pois o proximo tinha que ser 354
				aAdd(aLogErro,Replicate("-",75))
				aAdd(aLogErro,"Linha: "+StrZero(2+nCount,4))
				aAdd(aLogErro,"Fornec/Loja: "+cCodTrs+"/"+cLojTrs)
				aAdd(aLogErro,"Mensagem: Inconsistencia do lay-out, cobran็a nใo aglutinada.")
				aAdd(aLogErro,"Mensagem: Aglutina็ใo e gera็ใo de tํtulo nใo realizada")
				aAdd(aLogErro,"")
				
			Case lCtrl353 .And. lCtrl354 .And. cIdeReg == "354"
				//Normal, pois pode ter varios 354 pra um 353
				
			Case lCtrl353 .And. lCtrl354 .And. cIdeReg == "353"
				//Normal, pois a dupla jแ estแ formada e estแ sendo criada nova dupla
				lCtrl353 := .F.
				lCtrl354 := .F.
				
		EndCase
	EndIf
	
	//Pronto para inclusใo da Fatura
	If lIncFat
		//Ajusta para filial que deve ser localizado o numero do pedido
		cBkpFil := cFilAnt
		cFilAnt := ""
		
		//Localiza Filial
		SM0->(DbGoTop())
		While SM0->(!Eof())
			If SM0->M0_CODIGO == "01" .And. AllTrim(SM0->M0_CGC) == AllTrim(cCgcFil)
				cFilAnt := SM0->M0_CODFIL
			EndIf
			SM0->(DbSkip())
		End
		
		//Posiciona na filial original
		SM0->(DbSeek(cEmpAnt+cFilAnt))
		
		//Declara็ใo da variavel como array vazio
		aFatPag := {}
		
		/*01*/aAdd(aFatPag,mv_par04)				//[01] - Prefixo
		/*02*/aAdd(aFatPag,mv_par05)				//[02] - Tipo
		/*03*/aAdd(aFatPag,c352Num)					//[03] - Numero da Fatura (se o numero estiver em branco obtem pelo FINA290)
		/*04*/aAdd(aFatPag,mv_par07)				//[04] - Natureza
		/*05*/aAdd(aFatPag,StoD("20010101"))		//[05] - Data de
		/*06*/aAdd(aFatPag,dDataBase)				//[06] - Data Ate
		/*07*/aAdd(aFatPag,cCodTrs)					//[07] - Fornecedor
		/*08*/aAdd(aFatPag,cLojTrs)					//[08] - Loja
		/*09*/aAdd(aFatPag,cCodTrs)					//[09] - Fornecedor para geracao
		/*10*/aAdd(aFatPag,cLojTrs)					//[10] - Loja do fornecedor para geracao
		/*11*/aAdd(aFatPag,mv_par06)				//[11] - Condicao de pagto
		/*12*/aAdd(aFatPag,1)						//[12] - Moeda
		
		If Empty(aFatGrp)
			/*13*/aAdd(aFatPag,Nil)					//[13] - ARRAY com os titulos da fatura
		Else
			/*13*/aAdd(aFatPag,{})					//[13] - ARRAY com os titulos da fatura
			For f:=1 To Len(aFatGrp)
				/*13*/nLen13  := Len(aFatPag)
				/*13*/aAdd(aFatPag[nLen13],{})
				/*13*/aFatPag[nLen13][Len(aFatPag[nLen13])] := aFatGrp[f]
			Next f
		EndIf
		//--------------------------------------------------------------------
		/*13*///aAdd(aFatPag[Len(aFatPag)],{})
		/*13*///nLen13  := Len(aFatPag)
		/*13*///nLen13x := Len(aFatPag[nLen13])
		/*13*///aAdd(aFatPag[nLen13][nLen13x] ,"" )	//[1] Prefixo //Tamanho 3 -> Conforme arquivo
		/*13*///aAdd(aFatPag[nLen13][nLen13x] ,"" )	//[2] Numero  //Tamanho 9 -> Conforme arquivo
		/*13*///aAdd(aFatPag[nLen13][nLen13x] ,"" )	//[3] Parcela //Tamanho 3 -> Em branco
		/*13*///aAdd(aFatPag[nLen13][nLen13x] ,"" )	//[4] Tipo    //Tamanho 3 -> NF sempre
		/*13*///aAdd(aFatPag[nLen13][nLen13x] ,.F.)	//[5] Tํtulo localizado na geracao de fatura (l๓gico). Iniciar com falso.
		//--------------------------------------------------------------------
		
		//Valida็ใo do valor da fatura
		nVlrTits := 0
		SE2->(DbSetOrder(1))
		For f:=1 To Len(aFatGrp)
			If SE2->(DbSeek(xFilial("SE2") +aFatGrp[f][1] +aFatGrp[f][2] +aFatGrp[f][3] +aFatGrp[f][4] + cCodTrs + cLojTrs ))
				nVlrTits += SE2->E2_VALOR
			EndIf
		Next f
		
		//Tratamento para dar desconto ou acrescimo caso arredondamento
		Do Case
			Case nVlrTits >  n352Vlr .And. NoRound(nVlrTits,1) == NoRound(n352Vlr,1)
				/*14*/aAdd(aFatPag,0)						//[14] - Valor de decrescimo
				/*15*/aAdd(aFatPag,nVlrTits-n352Vlr)		//[15] - Valor de acrescimo
				
			Case nVlrTits <  n352Vlr .And. NoRound(nVlrTits,1) == NoRound(n352Vlr,1)
				/*14*/aAdd(aFatPag,n352Vlr-nVlrTits)		//[14] - Valor de decrescimo
				/*15*/aAdd(aFatPag,0)						//[15] - Valor de acrescimo
				
			Case nVlrTits == n352Vlr .And. NoRound(nVlrTits,1) == NoRound(n352Vlr,1)
				/*14*/aAdd(aFatPag,0)						//[14] - Valor de decrescimo
				/*15*/aAdd(aFatPag,0)						//[15] - Valor de acrescimo
		EndCase
		
		//Verifica se jแ existe um tํtulo igual no sistema
		lTitExiste := .F.
		SE2->(DbSetOrder(1))
		If SE2->(DbSeek(xFilial("SE2") +mv_par04 +c352Num +Space(3) +mv_par05 + cCodTrs + cLojTrs ))
			lTitExiste := .T.
			// Daniel em 20/01/2010 para tratar o vencimento do titulo de acordo com o arquivo enviado
			If SE2->E2_EMISSAO<=d352Vct
				Reclock("SE2",.F.)
				SE2->E2_VENCTO 	:= d352Vct
				SE2->E2_VENCREA	:= DataValida(d352Vct)
				SE2->E2_FILORIG := cFilant
				SE2->(MsUnlock())
			Endif
		EndIf
		
		//Valida็๕es e execu็ใo da rotina
		Do Case
			Case Empty(cFilAnt)
				aAdd(aLogErro,Replicate("-",75))
				aAdd(aLogErro,"Linha: "+StrZero(2+nCount,4))
				aAdd(aLogErro,"Prefixo/Tipo/Docum.: "+mv_par04+"/"+mv_par05+"/"+c352Num)
				aAdd(aLogErro,"Fornec/Loja: "+cCodTrs+"/"+cLojTrs)
				aAdd(aLogErro,"Mensagem: Inconsistencia de empresas. Nใo foi localizada a filial com CNPJ: "+cCgcFil)
				aAdd(aLogErro,"Mensagem: Aglutina็ใo e gera็ใo de tํtulo nใo realizada")
				aAdd(aLogErro,"")
				
			Case Len(aFatGrp) == 0
				aAdd(aLogErro,Replicate("-",75))
				aAdd(aLogErro,"Linha: "+StrZero(2+nCount,4))
				aAdd(aLogErro,"Filial: "+cFilAnt)
				aAdd(aLogErro,"Prefixo/Tipo/Docum.: "+mv_par04+"/"+mv_par05+"/"+c352Num)
				aAdd(aLogErro,"Fornec/Loja: "+cCodTrs+"/"+cLojTrs)
				aAdd(aLogErro,"Mensagem: Nenhum conhecimento para esta cobran็a foi localizada no arquivo")
				aAdd(aLogErro,"Mensagem: Aglutina็ใo e gera็ใo de tํtulo nใo realizada")
				aAdd(aLogErro,"")
				
			Case Len(aFatPag) == 0
				aAdd(aLogErro,Replicate("-",75))
				aAdd(aLogErro,"Linha: "+StrZero(2+nCount,4))
				aAdd(aLogErro,"Fornec/Loja: "+cCodTrs+"/"+cLojTrs)
				aAdd(aLogErro,"Mensagem: Alguma dificuldade ocorreu ao tentar carregar a linha do arquivo")
				aAdd(aLogErro,"Mensagem: Aglutina็ใo e gera็ใo de tํtulo nใo realizada")
				aAdd(aLogErro,"")
				
			Case NoRound(nVlrTits,1) != NoRound(n352Vlr,1) .And. nVlrTits > 0
				aAdd(aLogErro,Replicate("-",75))
				aAdd(aLogErro,"Linha: "+StrZero(2+nCount,4))
				aAdd(aLogErro,"Filial: "+cFilAnt)
				aAdd(aLogErro,"Prefixo/Tipo/Docum.: "+mv_par04+"/"+mv_par05+"/"+c352Num)
				aAdd(aLogErro,"Fornec/Loja: "+cCodTrs+"/"+cLojTrs)
				aAdd(aLogErro,"Mensagem: Existe diferen็a entre o valor da cobran็a e a somatoria dos conhecimentos.")
				aAdd(aLogErro,"Mensagem: Cobran็a: "+AllTrim(Str(nVlrTits))+" - COnhecimentos: "+AllTrim(Str(n352Vlr))+"")
				aAdd(aLogErro,"Mensagem: Aglutina็ใo e gera็ใo de tํtulo nใo realizada")
				aAdd(aLogErro,"")
				
			Case NoRound(nVlrTits,1) != NoRound(n352Vlr,1) .And. nVlrTits == 0
				aAdd(aLogErro,Replicate("-",75))
				aAdd(aLogErro,"Linha: "+StrZero(2+nCount,4))
				aAdd(aLogErro,"Filial: "+cFilAnt)
				aAdd(aLogErro,"Prefixo/Tipo/Docum.: "+mv_par04+"/"+mv_par05+"/"+c352Num)
				aAdd(aLogErro,"Fornec/Loja: "+cCodTrs+"/"+cLojTrs)
				aAdd(aLogErro,"Mensagem: Nenhum tํtulo de conhecimento foi localizado no ambiente CCAB.")
				aAdd(aLogErro,"Mensagem: Aglutina็ใo e gera็ใo de tํtulo nใo realizada")
				aAdd(aLogErro,"")
				
			Case lTitExiste
				aAdd(aLogErro,Replicate("-",75))
				aAdd(aLogErro,"Linha: "+StrZero(2+nCount,4))
				aAdd(aLogErro,"Filial: "+cFilAnt)
				aAdd(aLogErro,"Prefixo/Tipo/Docum.: "+mv_par04+"/"+mv_par05+"/"+c352Num)
				aAdd(aLogErro,"Fornec/Loja: "+cCodTrs+"/"+cLojTrs)
				aAdd(aLogErro,"Mensagem: Jแ existe um tํtulo com estas informa็๕es.")
				aAdd(aLogErro,"Mensagem: Aglutina็ใo e gera็ใo de tํtulo nใo realizada")
				aAdd(aLogErro,"")
				
			Otherwise
				lRetAut := Nil
				lRetAut := Fina290(3,aFatPag)
				Pergunte(cPerg,.F.)
				aAdd(aLogErro,Replicate("-",75))
				aAdd(aLogErro,"Linha: "+StrZero(2+nCount,4))
				aAdd(aLogErro,"Filial: "+cFilAnt)
				aAdd(aLogErro,"Prefixo/Tipo/Docum.: "+mv_par04+"/"+mv_par05+"/"+c352Num)
				aAdd(aLogErro,"Fornec/Loja: "+cCodTrs+"/"+cLojTrs)
				If lRetAut
					aAdd(aLogErro,"Mensagem: Rotina executada com sucesso.")
				Else
					aAdd(aLogErro,"Mensagem: Erro ao executar rotina automatica.")
				EndIf
				aAdd(aLogErro,"")
		EndCase
		
		//Volta flag de controle para falso
		lIncFat  := .F.
		lCtrl352 := .F.
		lCtrl353 := .F.
		lCtrl354 := .F.
		
		//Restaura variaveis
		cFilAnt := cBkpFil
		cBkpFil := ""
		cCgcFil:= ""
		aFatGrp:= {}
		
		//Posiciona na filial original
		SM0->(DbSeek(cEmpAnt+cFilAnt))
	EndIf
	
End

//Finaliza utiliza็ใo do arquivo
FT_FUSE()

//Renomeia arquivo ap๓s executar
FRenameEx(mv_par01,Upper(SubStr(mv_par01,1,Len(AllTrim(mv_par01))-4))+".PROC")

//Apresentar log com os pedidos criado
cTxtLog := ""
For x:=1 To Len(aLogErro)
	cTxtLog += aLogErro[x]+Chr(13)+Chr(10)
Next x

//Imprime em tela o resultado dos pedidos incluidos
If Len(aLogErro) > 0
	fResumo(cTxtLog)
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ fResumo บ Autor ณFelipe Aur้lio de Melo บ Data ณ 29/10/09 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     บ                                                            บฑฑ
ฑฑบ          บ                                                            บฑฑ
ฑฑบออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออบฑฑ
ฑฑบUso       บ CCAB2EDI                                                   บฑฑ
ฑฑบออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออบฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fResumo(cTexto)

Local oDlg,oMemo
Local cTxtLog := "LOG DOS ERROS NA IMPORTAวรO"
Local cArqLog := Criatrab(,.f.)+".LOG"
Define Font oFont Name "Mono AS" Size 05,12

cTxtLog += CRLF+Replicate("-",75)
cTxtLog += CRLF+"Data: "+DtoC(Date())
cTxtLog += CRLF+"Hora: "+Time()
cTxtLog += CRLF+"Usuแrio: "+cUserName

cTxtLog += CRLF
cTxtLog += CRLF+cTexto

__cFileLog := MemoWrite(cArqLog,cTxtLog)

Define MsDialog oDlg Title cArqLog From 3,0 to 340,417 Pixel
@ 5,5 Get oMemo Var cTxtLog Memo Size 200,145 OF oDlg Pixel
oMemo:bRClicked := {||AllwaysTrue()}
oMemo:oFont:=oFont
Define sButton From 153,175 Type 1 Action oDlg:End() Enable Of oDlg Pixel
Define sButton From 153,145 Type 6 Action ( PrintAErr(__cFileLog,cTxtLog),oDlg:End() ) Enable Of oDlg Pixel
Activate MsDialog oDlg Center

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ PrintAErr บ Autor ณFelipe Aur้lio de Meloบ Data ณ 29/10/09 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Imprime o autoerro.log                                     บฑฑ
ฑฑบ          บ                                                            บฑฑ
ฑฑบออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออบฑฑ
ฑฑบUso       บ CCAB2EDI                                                   บฑฑ
ฑฑบออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออบฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function PrintAErr(cFileErro,cConteudo)

Local nX          := 0
Local nLin        := 0
Default cConteudo := ""
Private aReturn   := {"", 1,"", 1, 2, 1, "",1 }

CursorWait()
SetPrint("","LOGEDI",Nil,"LOG EDI","LOG EDI","","",.F.,"",.F.,"M")
SetDefault(aReturn,"")
nLinha:= MLCount(cConteudo,132)
For nX:= 1 To nLinha
	nLin++
	If nLin > 80
		nLin := 1
		@ 00,00 PSAY AvalImp(132)
	Endif
	@ nLin,000 PSAY Memoline(cConteudo,132,nX)
Next nX
Set device to Screen
MS_FLUSH()

Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑบออออออออออุออออออออออุอออออออุอออออออออออออออออออออออุออออออุออออออออออบฑฑ
ฑฑบPrograma  บ fAtuSX1  บAutor  บFelipe Aur้lio de Melo บ Data บ 02/11/09 บฑฑ
ฑฑบออออออออออุออออออออออออออออออฯอออออออออออออออออออออออออออฯอออออออออออออบฑฑ
ฑฑบDesc.     บ                                                            บฑฑ
ฑฑบ          บ                                                            บฑฑ
ฑฑบออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออบฑฑ
ฑฑบUso       บ CCAB2EDI                                                   บฑฑ
ฑฑบออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออบฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fAtuSX1()

Local aPergs := {}

Aadd(aPergs,{"Arquivo Origem"   , "Arquivo Origem"   , "Arquivo Origem"   , "mv_ch1"  , "C" , 99,00,00 ,"G", "", "mv_par01", ""                , ""                , ""                , "", "", ""                , ""                , ""                , "", "", ""                , ""                , ""                , "", "", ""                , ""                , ""                , "", "", ""                , ""                , ""                , "", "ARQEDI","","S","","",{},{},{}})
Aadd(aPergs,{"Fornecedor"       , "Fornecedor"       , "Fornecedor"       , "mv_ch2"  , "C" , 06,00,00 ,"G", "", "mv_par02", ""                , ""                , ""                , "", "", ""                , ""                , ""                , "", "", ""                , ""                , ""                , "", "", ""                , ""                , ""                , "", "", ""                , ""                , ""                , "", "SA2"   ,"","S","","",{},{},{}})
Aadd(aPergs,{"Loja"             , "Loja"             , "Loja"             , "mv_ch3"  , "C" , 02,00,00 ,"G", "", "mv_par03", ""                , ""                , ""                , "", "", ""                , ""                , ""                , "", "", ""                , ""                , ""                , "", "", ""                , ""                , ""                , "", "", ""                , ""                , ""                , "", ""      ,"","S","","",{},{},{}})
Aadd(aPergs,{"Prefixo"          , "Prefixo"          , "Prefixo"          , "mv_ch4"  , "C" , 03,00,00 ,"G", "", "mv_par04", ""                , ""                , ""                , "", "", ""                , ""                , ""                , "", "", ""                , ""                , ""                , "", "", ""                , ""                , ""                , "", "", ""                , ""                , ""                , "", ""      ,"","S","","",{},{},{}})
Aadd(aPergs,{"Tipo"             , "Tipo"             , "Tipo"             , "mv_ch5"  , "C" , 03,00,00 ,"G", "", "mv_par05", ""                , ""                , ""                , "", "", ""                , ""                , ""                , "", "", ""                , ""                , ""                , "", "", ""                , ""                , ""                , "", "", ""                , ""                , ""                , "", "05 "   ,"","S","","",{},{},{}})
Aadd(aPergs,{"Cond. Pagamento"  , "Cond. Pagamento"  , "Cond. Pagamento"  , "mv_ch6"  , "C" , 03,00,00 ,"G", "", "mv_par06", ""                , ""                , ""                , "", "", ""                , ""                , ""                , "", "", ""                , ""                , ""                , "", "", ""                , ""                , ""                , "", "", ""                , ""                , ""                , "", "SE4"   ,"","S","","",{},{},{}})
Aadd(aPergs,{"Cod. Natureza"    , "Cod. Natureza"    , "Cod. Natureza"    , "mv_ch7"  , "C" , 10,00,00 ,"G", "", "mv_par07", ""                , ""                , ""                , "", "", ""                , ""                , ""                , "", "", ""                , ""                , ""                , "", "", ""                , ""                , ""                , "", "", ""                , ""                , ""                , "", "SED"   ,"","S","","",{},{},{}})
AjustaSx1(cPerg,aPergs)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑบออออออออออุออออออออออุอออออออุอออออออออออออออออออออออุออออออุออออออออออบฑฑ
ฑฑบPrograma  บ fAtuSXB บ Autor บ Felipe Aur้lio de Melo บ Data บ 02/11/09 บฑฑ
ฑฑบออออออออออุออออออออออออออออออฯอออออออออออออออออออออออออออฯอออออออออออออบฑฑ
ฑฑบDesc.     บ                                                            บฑฑ
ฑฑบ          บ                                                            บฑฑ
ฑฑบออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออบฑฑ
ฑฑบUso       บ CCAB2EDI                                                   บฑฑ
ฑฑบออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออบฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fAtuSXB()

Local aSXB   := {}
Local aEstrut:= {}
Local i      := 0
Local j      := 0

aEstrut:= {"XB_ALIAS","XB_TIPO","XB_SEQ","XB_COLUNA","XB_DESCRI","XB_DESCSPA","XB_DESCENG","XB_CONTEM"}

aAdd(aSXB,{"ARQEDI","1","01","RE","Arquivo             ","Archivo             ","File                ","SF1"                  } )
aAdd(aSXB,{"ARQEDI","2","01","01","Arquivo             ","Archivo             ","File                ","PLSLAR500(@mv_par01)" } )
aAdd(aSXB,{"ARQEDI","5","01",""  ,""                    ,""                    ,""                    ,"'xx'"                 } )

dbSelectArea("SXB")
dbSetOrder(1)
For i:= 1 To Len(aSXB)
	If !Empty(aSXB[i][1])
		If !dbSeek(Padr(aSXB[i,1], Len(SXB->XB_ALIAS))+aSXB[i,2]+aSXB[i,3]+aSXB[i,4])
			RecLock("SXB",.T.)
			For j:=1 To Len(aSXB[i])
				If !Empty(FieldName(FieldPos(aEstrut[j])))
					FieldPut(FieldPos(aEstrut[j]),aSXB[i,j])
				EndIf
			Next j
			dbCommit()
			MsUnLock()
		EndIf
	EndIf
Next i

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑบออออออออออุออออออออออุอออออออุอออออออออออออออออออออออุออออออุออออออออออบฑฑ
ฑฑบPrograma  บ fVldPerg บAutor  บFelipe Aur้lio de Melo บ Data บ 02/11/09 บฑฑ
ฑฑบออออออออออุออออออออออออออออออฯอออออออออออออออออออออออออออฯอออออออออออออบฑฑ
ฑฑบDesc.     บ                                                            บฑฑ
ฑฑบ          บ                                                            บฑฑ
ฑฑบออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออบฑฑ
ฑฑบUso       บ CCAB2EDI                                                   บฑฑ
ฑฑบออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออบฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fVldPerg()

Local lRet := .T.

//Tratamento mv_par01
If lRet
	If Empty(mv_par01) .Or. !File(AllTrim(mv_par01))
		lRet := .F.
		ShowHelpDlg("mv_par01", {"O arquivo informado nใo existe","no caminho de pastas selecionado!!!"},5,;
		{"Favor escolher novamente o arquivo","a ser importado."},5)
	EndIf
EndIf

//Tratamento mv_par02
If lRet
	SA2->(DbSetOrder(1))
	If Empty(mv_par02) .Or. SA2->(!DbSeek(xFilial("SA2")+mv_par02))
		lRet := .F.
		ShowHelpDlg("mv_par02", {"O fornecedor informado nใo existe","no cadastro!!!"},5,;
		{"Favor escolher ou digitar novamente","o fornecedor."},5)
	EndIf
EndIf

//Tratamento mv_par03
If lRet
	SA2->(DbSetOrder(1))
	If Empty(mv_par03) .Or. SA2->(!DbSeek(xFilial("SA2")+mv_par02+mv_par03))
		lRet := .F.
		ShowHelpDlg("mv_par03", {"A loja do fornecedor nใo existe","no cadastro!!!"},5,;
		{"Favor digitar novamente a loja","do fornecedor."},5)
	EndIf
EndIf

//Tratamento mv_par04
//Prefixo

//Tratamento mv_par05
SX5->(DbSetOrder(1))
If Empty(mv_par05) .Or. SX5->(!DbSeek(xFilial("SX5")+Padr("05",2)+mv_par05))
	lRet := .F.
	ShowHelpDlg("mv_par05", {"O Tipo nใo existe no cadastro!!!"},5,;
	{"Favor digitar novamente o tipo."},5)
EndIf

//Tratamento mv_par06
If lRet
	SE4->(DbSetOrder(1))
	If Empty(mv_par06) .Or. SE4->(!DbSeek(xFilial("SE4")+mv_par06))
		lRet := .F.
		ShowHelpDlg("mv_par06", {"A cond. pagamento informada","nใo existe no cadastro!!!"},5,;
		{"Favor escolher ou digitar novamente","a cond. pagamento."},5)
	EndIf
EndIf

//Tratamento mv_par07
If lRet
	SED->(DbSetOrder(1))
	If Empty(mv_par07) .Or. SED->(!DbSeek(xFilial("SED")+mv_par07))
		lRet := .F.
		ShowHelpDlg("mv_par07", {"A natureza informada","nใo existe no cadastro!!!"},5,;
		{"Favor escolher ou digitar","novamente a natureza."},5)
	EndIf
EndIf

Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑบออออออออออุออออออออออุอออออออุอออออออออออออออออออออออุออออออุออออออออออบฑฑ
ฑฑบPrograma  บfTrataLinบ Autor บ Felipe Aur้lio de Melo บ Data บ 05/11/09 บฑฑ
ฑฑบออออออออออุออออออออออออออออออฯอออออออออออออออออออออออออออฯอออออออออออออบฑฑ
ฑฑบDesc.     บ                                                            บฑฑ
ฑฑบ          บ                                                            บฑฑ
ฑฑบออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออบฑฑ
ฑฑบUso       บ CCAB1EDI                                                   บฑฑ
ฑฑบออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออบฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fTrataLin(cLinha,nLayOut)

Local cRet      := ""
Local aLayout   := {}

Default nLayOut := 00
Default cLinha  := ""

//Layout: 352
aAdd(aLayout,{})
//                      Tipo, Qtd, C.Dec, Pos
/*001*/aAdd(aLayout[1],{'N' , 003, 000  , 001 })
/*002*/aAdd(aLayout[1],{'C' , 010, 000  , 004 })
/*003*/aAdd(aLayout[1],{'N' , 001, 000  , 014 })
/*004*/aAdd(aLayout[1],{'C' , 003, 000  , 015 })
/*005*/aAdd(aLayout[1],{'N' , 010, 000  , 018 })
/*006*/aAdd(aLayout[1],{'N' , 008, 000  , 028 })
/*007*/aAdd(aLayout[1],{'N' , 008, 000  , 036 })
/*008*/aAdd(aLayout[1],{'N' , 015, 002  , 044 })
/*009*/aAdd(aLayout[1],{'C' , 003, 000  , 059 })
/*010*/aAdd(aLayout[1],{'N' , 015, 002  , 062 })
/*011*/aAdd(aLayout[1],{'N' , 015, 002  , 077 })
/*012*/aAdd(aLayout[1],{'N' , 008, 000  , 092 })
/*013*/aAdd(aLayout[1],{'N' , 015, 002  , 100 })
/*014*/aAdd(aLayout[1],{'C' , 035, 000  , 115 })
/*015*/aAdd(aLayout[1],{'N' , 004, 000  , 150 })
/*016*/aAdd(aLayout[1],{'C' , 001, 000  , 154 })
/*017*/aAdd(aLayout[1],{'N' , 010, 000  , 155 })
/*018*/aAdd(aLayout[1],{'C' , 002, 000  , 165 })
/*019*/aAdd(aLayout[1],{'C' , 001, 000  , 167 })
/*020*/aAdd(aLayout[1],{'C' , 003, 000  , 168 })


//Layout: 353
aAdd(aLayout,{})
//                      Tipo, Qtd, C.Dec, Pos
/*001*/aAdd(aLayout[2],{'N' , 003, 000  , 001 })
/*002*/aAdd(aLayout[2],{'C' , 010, 000  , 004 })
/*003*/aAdd(aLayout[2],{'C' , 005, 000  , 014 })
/*004*/aAdd(aLayout[2],{'C' , 012, 000  , 019 })
/*005*/aAdd(aLayout[2],{'C' , 114, 000  , 031 })


//Layout: 354
aAdd(aLayout,{})
//                      Tipo, Qtd, C.Dec, Pos
/*001*/aAdd(aLayout[3],{'N' , 003, 000  , 001 })
/*002*/aAdd(aLayout[3],{'C' , 003, 000  , 004 })
/*003*/aAdd(aLayout[3],{'N' , 008, 000  , 007 })
/*004*/aAdd(aLayout[3],{'N' , 008, 000  , 015 })
/*005*/aAdd(aLayout[3],{'N' , 007, 002  , 023 })
/*006*/aAdd(aLayout[3],{'N' , 015, 002  , 030 })
/*007*/aAdd(aLayout[3],{'N' , 014, 000  , 045 })
/*007*/aAdd(aLayout[3],{'N' , 112, 000  , 059 })

//Lo็o para montar linha como se fosse csv para depois montar array
If !Empty(cLinha) .And. nLayOut > 0
	cRet := ""
	For x:=1 To Len(aLayout[nLayOut])
		Do Case
			Case aLayout[nLayOut][x][3] > 0
				nPos := aLayout[nLayOut][x][2]-aLayout[nLayOut][x][3]
				cRet += SubStr(cLinha,  aLayout[nLayOut][x][4],   nPos)
				cRet += "."
				cRet += SubStr(cLinha,  aLayout[nLayOut][x][4]+nPos, aLayout[nLayOut][x][3])
				cRet += ";"
				
			Case aLayout[nLayOut][x][1] == 'N'
				cRet += SubStr(cLinha,  aLayout[nLayOut][x][4],  aLayout[nLayOut][x][2])
				cRet += ";"
				
			Case aLayout[nLayOut][x][1] == 'C'
				cRet += SubStr(cLinha,  aLayout[nLayOut][x][4],  aLayout[nLayOut][x][2])
				cRet += ";"
		EndCase
		
	Next x
Else
	cRet := ""
EndIf

Return(cRet)

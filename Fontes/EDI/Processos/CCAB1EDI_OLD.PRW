#Include "protheus.ch"
#Include "topconn.ch"

//---------------------------------------------------------------------------
//Ajustes para funcionar corretamente este rotina
//Particularidades CCAB
//---------------------------------------------------------------------------
//VR:l103Auto
//PE:MT100AGR
//PE:SF1100I
//---------------------------------------------------------------------------

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑบออออออออออุออออออออออุอออออออุอออออออออออออออออออออออุออออออุออออออออออบฑฑ
ฑฑบPrograma  บ CCAB1EDI บAutor  บFelipe Aur้lio de Melo บ Data บ 21/10/09 บฑฑ
ฑฑบออออออออออุออออออออออออออออออฯอออออออออออออออออออออออออออฯอออออออออออออบฑฑ
ฑฑบDesc.     บ                                                            บฑฑ
ฑฑบ          บ                                                            บฑฑ
ฑฑบออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออบฑฑ
ฑฑบUso       บ CCAB1EDI                                                   บฑฑ
ฑฑบออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออบฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User function CCAB1EDI()

Local nHdl
Local lVldPrg 	:= .T.
Local lCntnua 	:= .F.
Private cPerg 	:= "RL1EDI"

fAtuSX1()
fAtuSXB()
fAtuSX6()		// Criado por Daniel em 29/01/2010 para tratar o centro de custo por filial

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
ฑฑบPrograma  บfLerGravarบAutor  บFelipe Aur้lio de Melo บ Data บ 23/10/09 บฑฑ
ฑฑบออออออออออุออออออออออออออออออฯอออออออออออออออออออออออออออฯอออออออออออออบฑฑ
ฑฑบDesc.     บ                                                            บฑฑ
ฑฑบ          บ                                                            บฑฑ
ฑฑบออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออบฑฑ
ฑฑบUso       บ CCAB1EDI                                                   บฑฑ
ฑฑบออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออบฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fLerGravar(cOrig)

Local cIdeReg  := ""
Local cTipArq  := ""
Local cDiaMes  := ""
Local cHraMin  := ""
Local cSeqArq  := ""
Local cCgcTrs  := ""
Local cCodTrs  := ""
Local cLojTrs  := ""
Local cEstTrs  := ""
Local cNomTrs  := ""

Local cLinha   := ""
Local cTxtLog  := ""
Local aLinha   := {}
Local nCount   := 0
Local aSF2NFs  := {}
Local cSF2Ser  := ""
Local cSF2Doc  := ""
Local c322Ser  := ""
Local c322Doc  := ""
Local c322Tes  := ""
Local n322Tot  := 00                                  
Local c322CCus := GetMv("MV_CCEDI")	// Criado por Daniel em 29/01/2010 para tratar o centro de custo por filial
Local cCgcFil  := ""
Local cBkpFil  := ""
Local cMsgErro := ""
Local aLogErro := {} 
Local nIcms     :=   0           // inclusใo da variแvel para passar a porcentagem de IMCS
Local nValicm  :=  0

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
	
	//Primeiro Tratamento - 320
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
	
	//Segundo Tratamento - 321
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
EndIf

//Verifica o conte๚do do arquivo
If lContinua .And. (cIdeReg != "320321" .Or. cTipArq != "CONHE")
	lContinua := .F.
	MsgAlert("O Arquivo informado nใo ้ compatํvel!!!"+Space(30) +Chr(13)+Chr(10)+Chr(13)+Chr(10)+;
	"Layout: ConEmb"                                    +Chr(13)+Chr(10)+;
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

//Le arquivo linha a linha
While !FT_FEOF()
	nCount ++
	
	//Processa contador
	IncProc()
	
	//Carrega uma linha do arquivo
	cLinha := FT_FREADLN()
	
	//Identifica registro
	cIdeReg := SubStr(cLinha,01,03)
	
	
	If cIdeReg == "322"
		//Formata linha no layout conforme identifica็ใo
		cLinha := fTrataLin(cLinha,1)
	EndIf
	
	If cIdeReg == "323"
		//Formata linha no layout conforme identifica็ใo
		cLinha := fTrataLin(cLinha,2)
	EndIf
	
	//Quebra linha num array
	aLinha := StrToKArr(cLinha,";")
	
	//Valida rodap้ com itens?
	
	
	//Caso itens, faz tratamentos e monta array
	If cIdeReg == "322"
		
		//Inicializa variaveis
		aSF2NFs  := {}
		cSF2Ser  := ""
		cSF2Doc  := ""
		c322Ser  := Padr(AllTrim(aLinha[03]),3)
		c322Doc  := StrZero(Val(aLinha[04]),9)
		c322Dt	 := Ctod(substr(aLinha[05],1,2)+"/"+substr(aLinha[05],3,2)+"/"+substr(aLinha[05],7,2))	// Daniel em 20/01/2010 para tratar a emissao da nota com base no arquivo
		n322Tot  := Val(aLinha[08])
		cCgcFil  := aLinha[22]
		cBkpFil  := ""
		cMsgErro := ""
		nIcms     := Val(aLinha[10])            // utilizado o Val para adequa็ใo ao tipo do campo 
		nValicm  := Val(aLinha[11])
			
		//Armazena Notas de saida para depois fazer relacionamento
		For  u:=23 To 102
			//Carrega variaveis
			cSF2Ser := Padr(AllTrim(aLinha[u]),3)
			u ++
			cSF2Doc := StrZero(Val(aLinha[u]),9)
			
			//Adiciona no array somente valores
			If !Empty(cSF2Ser) .And. !Empty(cSF2Doc)
				aAdd(aSF2NFs,{cSF2Ser,cSF2Doc})
			EndIf
		Next u
		
		//Valida Transportadora
		If AllTrim(cCgcTrs) != AllTrim(aLinha[21])
			aAdd(aLogErro,Replicate("-",75))
			aAdd(aLogErro,"Linha: "+StrZero(2+nCount,4))
			aAdd(aLogErro,"Mensagem: Transportadoras diferentes dentro do mesmo arquivo.")
			aAdd(aLogErro,"Status registro: Registro nใo importado!!!")
			aAdd(aLogErro,"")
			
			//Proxima linha
			FT_FSKIP()
			
			//Volta para o inicio
			Loop
		EndIf
		
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
		
		//Ajusta para filial conforme registro do arquivo
		If Empty(cFilAnt)
			aAdd(aLogErro,Replicate("-",75))
			aAdd(aLogErro,"Linha: "+StrZero(2+nCount,4))
			aAdd(aLogErro,"Mensagem: CNPJ nใo encontrado no sistema microsiga como filial.")
			aAdd(aLogErro,"Status registro: Registro nใo importado!!!")
			aAdd(aLogErro,"")
			
			//Restaura variaveis
			cFilAnt := cBkpFil
			cBkpFil := ""
			
			//Posiciona na filial original
			SM0->(DbSeek(cEmpAnt+cFilAnt))
			
			//Proxima linha
			FT_FSKIP()
			
			//Volta para o inicio
			Loop
		Else
			//Posiciona na filial em questใo
			SM0->(DbSeek(cEmpAnt+cFilAnt))
		EndIf
		
		//Verifica se jแ existe um registro com a mesma informa็ใo
		SF1->(DbSetOrder(1))
		If SF1->(DbSeek(xFilial("SF1")+c322Doc+c322Ser+cCodTrs+cLojTrs))
			aAdd(aLogErro,Replicate("-",75))
			aAdd(aLogErro,"Linha: "+StrZero(2+nCount,4))
			aAdd(aLogErro,"Filial: "+xFilial("SD1"))
			aAdd(aLogErro,"Nota/Serie: "+c322Doc+"/"+c322Ser)
			aAdd(aLogErro,"Fornec/Loja: "+cCodTrs+"/"+cLojTrs)
			aAdd(aLogErro,"")
			aAdd(aLogErro,"Mensagem: Jแ existe um registro igual a este inserido no banco de dados.")
			aAdd(aLogErro,"Status registro: Registro nใo importado!!!")
			aAdd(aLogErro,"")
			
			//Proxima linha
			FT_FSKIP()
			
			//Volta para o inicio
			Loop
		EndIf
		
		//Carrega os parametros para evitar erro jแ ocorrido nos testes
		Pergunte(cPerg,.F.)
		
		//Tratamento de TES
	    //	If Upper(AllTrim(cEstTrs)) == Upper(AllTrim(SM0->M0_ESTENT))
	    If Val(aLinha[10]) <> 0                                        //Foi realizada altera็ใo para que, ao inv้s de pegar a empresa, seja avaliado se foi passado valor de ICMS pelo arquivo de importa็ใo
			c322Tes := mv_par08
		Else
			c322Tes := mv_par07
		EndIf
		
		//Montagem do aCabec
		aCabs := {}
		aAdd(aCabs, {'F1_FILIAL ', xFilial("SF1")             	, Nil})
		aAdd(aCabs, {'F1_DOC    ', c322Doc                    	, Nil})
		aAdd(aCabs, {'F1_SERIE  ', c322Ser                    	, Nil})
		aAdd(aCabs, {'F1_TIPO   ', 'N'                        	, Nil})
		aAdd(aCabs, {'F1_FORMUL ', 'N'                        	, Nil})
		aAdd(aCabs, {'F1_ESPECIE', 'CTR'                      	, Nil})
		aAdd(aCabs, {'F1_MOEDA  ', 1                          	, Nil})
		//		aAdd(aCabs, {'F1_EMISSAO', dDataBase	               	, Nil}) alterado pela variavel c322Dt, pois usava a database
		aAdd(aCabs, {'F1_EMISSAO', c322Dt 		               	, Nil})
		aAdd(aCabs, {'F1_FORNECE', cCodTrs                    	, Nil})
		aAdd(aCabs, {'F1_LOJA   ', cLojTrs                    	, Nil})
		aAdd(aCabs, {'F1_EST'    , cEstTrs                    	, Nil})
		aAdd(aCabs, {'F1_COND   ', mv_par09                   	, Nil})
		aAdd(aCabs, {'E2_NATUREZ', mv_par10                   	, Nil})
		
		//Montagem do aItens
		aItens := {}
		aAdd(aItens,{})
		aAdd(aItens[Len(aItens)], {'D1_FILIAL ', xFilial("SD1") , Nil})
		aAdd(aItens[Len(aItens)], {'D1_DOC    ', c322Doc        , Nil})
		aAdd(aItens[Len(aItens)], {'D1_SERIE  ', c322Ser        , Nil})
		aAdd(aItens[Len(aItens)], {'D1_FORNECE', cCodTrs        , Nil})
		aAdd(aItens[Len(aItens)], {'D1_LOJA   ', cLojTrs        , Nil})
		aAdd(aItens[Len(aItens)], {'D1_COD    ', mv_par04       , Nil})
		//aAdd(aItens[Len(aItens)], {'D1_UM     ', 'UN'           , Nil})
		aAdd(aItens[Len(aItens)], {'D1_QUANT  ', 1              , Nil})
		aAdd(aItens[Len(aItens)], {'D1_VUNIT  ', n322Tot        , Nil})
		aAdd(aItens[Len(aItens)], {'D1_TOTAL  ', n322Tot        , Nil}) 
		aAdd(aItens[Len(aItens)], {'D1_TES    ', c322Tes        , Nil}) 
		aAdd(aItens[Len(aItens)], {'D1_VALICM ', nValicm       , Nil})            //deixar ap๓s passar a TES para que o valor nใo seja zerado 
		aAdd(aItens[Len(aItens)], {'D1_PICM '  , nIcms       , Nil})            //deixar ap๓s passar a TES para que o valor nใo seja zerado                                                                                                    
		aAdd(aItens[Len(aItens)], {'D1_CONTA  ', mv_par05       , Nil})
		aAdd(aItens[Len(aItens)], {'D1_ITEMCTA', mv_par06       , Nil})
		aAdd(aItens[Len(aItens)], {'D1_CC     ', c322CCus       , Nil})
		
		//Tratamento variavel para apresentar msg de erro
		lMsErroAuto := .F.
		
		//Executa rotina de inclusใo de documento de entrada
		MSExecAuto({|x,y,z| MATA103(x,y,z)}, aCabs, aItens, 3)
		
		//Tratamento de mensagem de log
		If lMsErroAuto
			//Log informando que algo errado ocorreu
			cMsgErro := Mostraerro("\")
			aAdd(aLogErro,Replicate("-",75))
			aAdd(aLogErro,"Linha: "+StrZero(2+nCount,4))
			aAdd(aLogErro,"Filial: "+xFilial("SD1"))
			aAdd(aLogErro,"Nota/Serie: "+c322Doc+"/"+c322Ser)
			aAdd(aLogErro,"Fornec/Loja: "+cCodTrs+"/"+cLojTrs)
			aAdd(aLogErro,"")
			aAdd(aLogErro,"Mensagem: Mensagem gerada automaticamente pelo sistema microsiga.")
			aAdd(aLogErro,"Status registro: ANALISAR PARA VERIFICAR SE ELE FOI INSERIDO OU NรO!!!")
			aAdd(aLogErro,"")
			aAdd(aLogErro,cMsgErro)
			aAdd(aLogErro,"")
		Else
			//Log informando que foi registrado com sucesso
			aAdd(aLogErro,Replicate("-",75))
			aAdd(aLogErro,"Linha: "+StrZero(2+nCount,4))
			aAdd(aLogErro,"Filial: "+xFilial("SD1"))
			aAdd(aLogErro,"Nota/Serie: "+c322Doc+"/"+c322Ser)
			aAdd(aLogErro,"Fornec/Loja: "+cCodTrs+"/"+cLojTrs)
			aAdd(aLogErro,"Mensagem: Execu็ใo automแtica deste registro realizada com sucesso.")
			
			//Tratamento para amarra็ใo das NFs
			If Len(aSF2NFs) > 0
				SF2->(DbSetOrder(1))
				For u:=1 To Len(aSF2NFs)
					If SF2->(DbSeek(xFilial("SF2") + aSF2NFs[u][2] + aSF2NFs[u][1]))
						If Empty(SF2->F2_XDOC)
							RecLock("SF2",.F.)
							SF2->F2_XDOC	:= c322Doc
							SF2->F2_XSERIE	:= c322Ser
							MsUnlock()
							aAdd(aLogErro,"Amarra็ใo Ok: NF "+aSF2NFs[u][2]+"/"+aSF2NFs[u][1]+" de saํda amarrada com sucesso!!!")
						Else
							aAdd(aLogErro,"Amarra็ใo com Erro: NF "+aSF2NFs[u][2]+"/"+aSF2NFs[u][1]+" de saํda jแ amarrada com NF "+SF2->F2_XDOC+"/"+SF2->F2_XSERIE+" de entrada.")
						EndIf
					Else
						aAdd(aLogErro,"Amarra็ใo com Erro: NF "+aSF2NFs[u][2]+"/"+aSF2NFs[u][1]+" de saํda nใo foi localizada para realizar amarra็ใo")
					EndIf
				Next u
				If Len(aSF2NFs) == 0
					aAdd(aLogErro,"Amarra็ใo com Erro: Nenhuma NF de saida foi encontrada para realizar a amarra็ใo.")
				EndIf
			EndIf
			
			//Continua็ใo do log informando que foi registrado com sucesso
			aAdd(aLogErro,"Status registro: Ok, registro importado com sucesso!!!")
			aAdd(aLogErro,"")
		EndIf
		
		//Volta para filial que deve executar o msexecauto
		cFilAnt := cBkpFil
		cBkpFil := ""
		SM0->(DbSeek(cEmpAnt+cFilAnt))
		
	EndIf
	
	//Proxima linha
	FT_FSKIP()
End

//Finaliza utiliza็ใo do arquivo
FT_FUSE()

//Apresentar log com os pedidos criado
cTxtLog := ""
For x:=1 To Len(aLogErro)
	cTxtLog += aLogErro[x]+Chr(13)+Chr(10)
Next x

//Imprime em tela o resultado dos pedidos incluidos
If Len(aLogErro) > 0
	fResumo(cTxtLog)
EndIf

//Renomeia arquivo ap๓s executar
FRenameEx(AllTrim(cOrig),Upper(SubStr(AllTrim(cOrig),1,Len(AllTrim(cOrig))-4))+".PROC")

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑบออออออออออุออออออออออุอออออออุอออออออออออออออออออออออุออออออุออออออออออบฑฑ
ฑฑบPrograma  บ fVldPerg บAutor  บFelipe Aur้lio de Melo บ Data บ 21/10/09 บฑฑ
ฑฑบออออออออออุออออออออออออออออออฯอออออออออออออออออออออออออออฯอออออออออออออบฑฑ
ฑฑบDesc.     บ                                                            บฑฑ
ฑฑบ          บ                                                            บฑฑ
ฑฑบออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออบฑฑ
ฑฑบUso       บ CCAB1EDI                                                   บฑฑ
ฑฑบออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออบฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fVldPerg()

Local lRet 		:= .T.
Local c322CCus 	:= GetMv("MV_CCEDI")	// Criado por Daniel em 29/01/2010 para tratar o centro de custo por filial

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
If lRet
	SB1->(DbSetOrder(1))
	If Empty(mv_par04) .Or. SB1->(!DbSeek(xFilial("SB1")+mv_par04))
		lRet := .F.
		ShowHelpDlg("mv_par04", {"O c๓digo do produto informado","nใo existe no cadastro!!!"},5,;
		{"Favor escolher ou digitar novamente","o codigo do produto."},5)
	EndIf
EndIf

//Tratamento mv_par05
If lRet
	CT1->(DbSetOrder(1))
	If Empty(mv_par05) .Or. CT1->(!DbSeek(xFilial("CT1")+mv_par05))
		lRet := .F.
		ShowHelpDlg("mv_par05", {"A Conta contแbil informada","nใo existe no cadastro!!!"},5,;
		{"Favor escolher ou digitar novamente","a conta contแbil."},5)
	EndIf
EndIf

//Tratamento mv_par06
If lRet
	CTD->(DbSetOrder(1))
	If Empty(mv_par06) .Or. CTD->(!DbSeek(xFilial("CTD")+mv_par06))
		lRet := .F.
		ShowHelpDlg("mv_par06", {"O item contแbil informado","nใo existe no cadastro!!!"},5,;
		{"Favor escolher ou digitar novamente","o item contแbil."},5)
	EndIf
EndIf

//Tratamento Centro de custo
If lRet
	CTT->(DbSetOrder(1))
	If Empty(c322CCus) .Or. CTT->(!DbSeek(xFilial("CTT")+c322CCus))
		lRet := .F.
		ShowHelpDlg("c322CCus", {"O centro de custo informado","nใo existe no cadastro!!!"},5,;
		{"Favor escolher ou digitar novamente","o centro de custo."},5)
	EndIf
EndIf

//Tratamento mv_par07
If lRet
	SF4->(DbSetOrder(1))
	If Empty(mv_par07) .Or. SF4->(!DbSeek(xFilial("SF4")+mv_par07))
		lRet := .F.
		ShowHelpDlg("mv_par07", {"O TES de oper. estadual informado","nใo existe no cadastro!!!"},5,;
		{"Favor escolher ou digitar novamente","o TES de oper. estadual."},5)
	EndIf
EndIf

//Tratamento mv_par08
If lRet
	SF4->(DbSetOrder(1))
	If Empty(mv_par08) .Or. SF4->(!DbSeek(xFilial("SF4")+mv_par08))
		lRet := .F.
		ShowHelpDlg("mv_par08", {"O TES de oper. interestadual informado","nใo existe no cadastro!!!"},5,;
		{"Favor escolher ou digitar novamente","o TES de oper. interestadual."},5)
	EndIf
EndIf

//Tratamento mv_par09
If lRet
	SE4->(DbSetOrder(1))
	If Empty(mv_par09) .Or. SE4->(!DbSeek(xFilial("SE4")+mv_par09))
		lRet := .F.
		ShowHelpDlg("mv_par09", {"A cond. pagamento informada","nใo existe no cadastro!!!"},5,;
		{"Favor escolher ou digitar novamente","a cond. pagamento."},5)
	EndIf
EndIf

//Tratamento mv_par10
If lRet
	SED->(DbSetOrder(1))
	If Empty(mv_par10) .Or. SED->(!DbSeek(xFilial("SED")+mv_par10))
		lRet := .F.
		ShowHelpDlg("mv_par10", {"A natureza informada","nใo existe no cadastro!!!"},5,;
		{"Favor escolher ou digitar","novamente a natureza."},5)
	EndIf
EndIf

Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑบออออออออออุออออออออออุอออออออุอออออออออออออออออออออออุออออออุออออออออออบฑฑ
ฑฑบPrograma  บ fAtuSX1  บAutor  บFelipe Aur้lio de Melo บ Data บ 21/10/09 บฑฑ
ฑฑบออออออออออุออออออออออออออออออฯอออออออออออออออออออออออออออฯอออออออออออออบฑฑ
ฑฑบDesc.     บ                                                            บฑฑ
ฑฑบ          บ                                                            บฑฑ
ฑฑบออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออบฑฑ
ฑฑบUso       บ CCAB1EDI                                                   บฑฑ
ฑฑบออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออบฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fAtuSX1()

Local aPergs := {}

Aadd(aPergs,{"Arquivo Origem"   , "Arquivo Origem"   , "Arquivo Origem"   , "mv_ch1"  , "C" , 99,00,00 ,"G", "", "mv_par01", ""                , ""                , ""                , "", "", ""                , ""                , ""                , "", "", ""                , ""                , ""                , "", "", ""                , ""                , ""                , "", "", ""                , ""                , ""                , "", "ARQEDI","","S","","",{},{},{}})
Aadd(aPergs,{"Fornecedor"       , "Fornecedor"       , "Fornecedor"       , "mv_ch2"  , "C" , 06,00,00 ,"G", "", "mv_par02", ""                , ""                , ""                , "", "", ""                , ""                , ""                , "", "", ""                , ""                , ""                , "", "", ""                , ""                , ""                , "", "", ""                , ""                , ""                , "", "SA2"   ,"","S","","",{},{},{}})
Aadd(aPergs,{"Loja"             , "Loja"             , "Loja"             , "mv_ch3"  , "C" , 02,00,00 ,"G", "", "mv_par03", ""                , ""                , ""                , "", "", ""                , ""                , ""                , "", "", ""                , ""                , ""                , "", "", ""                , ""                , ""                , "", "", ""                , ""                , ""                , "", ""      ,"","S","","",{},{},{}})
Aadd(aPergs,{"Produto"          , "Produto"          , "Produto"          , "mv_ch4"  , "C" , 15,00,00 ,"G", "", "mv_par04", ""                , ""                , ""                , "", "", ""                , ""                , ""                , "", "", ""                , ""                , ""                , "", "", ""                , ""                , ""                , "", "", ""                , ""                , ""                , "", "SB1"   ,"","S","","",{},{},{}})
Aadd(aPergs,{"Conta Contabil"   , "Conta Contabil"   , "Conta Contabil"   , "mv_ch5"  , "C" , 20,00,00 ,"G", "", "mv_par05", ""                , ""                , ""                , "", "", ""                , ""                , ""                , "", "", ""                , ""                , ""                , "", "", ""                , ""                , ""                , "", "", ""                , ""                , ""                , "", "CT1"   ,"","S","","",{},{},{}})
Aadd(aPergs,{"Item contabil"    , "Item contabil"    , "Item contabil"    , "mv_ch6"  , "C" , 09,00,00 ,"G", "", "mv_par06", ""                , ""                , ""                , "", "", ""                , ""                , ""                , "", "", ""                , ""                , ""                , "", "", ""                , ""                , ""                , "", "", ""                , ""                , ""                , "", "CTD"   ,"","S","","",{},{},{}})
// Aadd(aPergs,{"Centro Custo"     , "Centro Custo"     , "Centro Custo"     , "mv_ch7"  , "C" , 09,00,00 ,"G", "", "mv_par07", ""                , ""                , ""                , "", "", ""                , ""                , ""                , "", "", ""                , ""                , ""                , "", "", ""                , ""                , ""                , "", "", ""                , ""                , ""                , "", "CTT"   ,"","S","","",{},{},{}})
Aadd(aPergs,{"TES Oper.Estadual", "TES Oper.Estadual", "TES Oper.Estadual", "mv_ch8"  , "C" , 03,00,00 ,"G", "", "mv_par07", ""                , ""                , ""                , "", "", ""                , ""                , ""                , "", "", ""                , ""                , ""                , "", "", ""                , ""                , ""                , "", "", ""                , ""                , ""                , "", "SF4"   ,"","S","","",{},{},{}})
Aadd(aPergs,{"TES Interestadual", "TES Interestadual", "TES Interestadual", "mv_ch9"  , "C" , 03,00,00 ,"G", "", "mv_par08", ""                , ""                , ""                , "", "", ""                , ""                , ""                , "", "", ""                , ""                , ""                , "", "", ""                , ""                , ""                , "", "", ""                , ""                , ""                , "", "SF4"   ,"","S","","",{},{},{}})
Aadd(aPergs,{"Cond. Pagamento"  , "Cond. Pagamento"  , "Cond. Pagamento"  , "mv_cha"  , "C" , 03,00,00 ,"G", "", "mv_par09", ""                , ""                , ""                , "", "", ""                , ""                , ""                , "", "", ""                , ""                , ""                , "", "", ""                , ""                , ""                , "", "", ""                , ""                , ""                , "", "SE4"   ,"","S","","",{},{},{}})
Aadd(aPergs,{"Cod. Natureza"    , "Cod. Natureza"    , "Cod. Natureza"    , "mv_chb"  , "C" , 10,00,00 ,"G", "", "mv_par10", ""                , ""                , ""                , "", "", ""                , ""                , ""                , "", "", ""                , ""                , ""                , "", "", ""                , ""                , ""                , "", "", ""                , ""                , ""                , "", "SED"   ,"","S","","",{},{},{}})

AjustaSx1(cPerg,aPergs)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑบออออออออออุออออออออออุอออออออุอออออออออออออออออออออออุออออออุออออออออออบฑฑ
ฑฑบPrograma  บ fAtuSXB บ Autor บ Felipe Aur้lio de Melo บ Data บ 21/10/09 บฑฑ
ฑฑบออออออออออุออออออออออออออออออฯอออออออออออออออออออออออออออฯอออออออออออออบฑฑ
ฑฑบDesc.     บ                                                            บฑฑ
ฑฑบ          บ                                                            บฑฑ
ฑฑบออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออบฑฑ
ฑฑบUso       บ CCAB1EDI                                                   บฑฑ
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
ฑฑบPrograma  บfTrataLinบ Autor บ Felipe Aur้lio de Melo บ Data บ 26/10/09 บฑฑ
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

aAdd(aLayout,{})
//                      Tipo, Qtd, C.Dec, Pos
/*001*/aAdd(aLayout[1],{'N' , 003, 000  , 001 })
/*002*/aAdd(aLayout[1],{'C' , 010, 000  , 004 })
/*003*/aAdd(aLayout[1],{'C' , 005, 000  , 014 })
/*004*/aAdd(aLayout[1],{'C' , 012, 000  , 019 })
/*005*/aAdd(aLayout[1],{'N' , 008, 000  , 031 })
/*006*/aAdd(aLayout[1],{'C' , 001, 000  , 039 })
/*007*/aAdd(aLayout[1],{'N' , 007, 002  , 040 })
/*008*/aAdd(aLayout[1],{'N' , 015, 002  , 047 })
/*009*/aAdd(aLayout[1],{'N' , 015, 002  , 062 })
/*010*/aAdd(aLayout[1],{'N' , 004, 002  , 077 })
/*011*/aAdd(aLayout[1],{'N' , 015, 002  , 081 })
/*012*/aAdd(aLayout[1],{'N' , 015, 002  , 096 })
/*013*/aAdd(aLayout[1],{'N' , 015, 002  , 111 })
/*014*/aAdd(aLayout[1],{'N' , 015, 002  , 126 })
/*015*/aAdd(aLayout[1],{'N' , 015, 002  , 141 })
/*016*/aAdd(aLayout[1],{'N' , 015, 002  , 156 })
/*017*/aAdd(aLayout[1],{'N' , 015, 002  , 171 })
/*018*/aAdd(aLayout[1],{'N' , 015, 002  , 186 })
/*019*/aAdd(aLayout[1],{'N' , 001, 000  , 201 })
/*020*/aAdd(aLayout[1],{'N' , 003, 000  , 202 })
/*021*/aAdd(aLayout[1],{'N' , 014, 000  , 205 })
/*022*/aAdd(aLayout[1],{'N' , 014, 000  , 219 })
/*023*/aAdd(aLayout[1],{'C' , 003, 000  , 233 }) //Serie 01
/*024*/aAdd(aLayout[1],{'N' , 008, 000  , 236 }) //Nota  01
/*025*/aAdd(aLayout[1],{'C' , 003, 000  , 244 }) //Serie 02
/*026*/aAdd(aLayout[1],{'N' , 008, 000  , 247 }) //Nota  02
/*027*/aAdd(aLayout[1],{'C' , 003, 000  , 255 }) //Serie 03
/*028*/aAdd(aLayout[1],{'N' , 008, 000  , 258 }) //Nota  03
/*029*/aAdd(aLayout[1],{'C' , 003, 000  , 266 }) //Serie 04
/*030*/aAdd(aLayout[1],{'N' , 008, 000  , 269 }) //Nota  04
/*031*/aAdd(aLayout[1],{'C' , 003, 000  , 277 }) //Serie 05
/*032*/aAdd(aLayout[1],{'N' , 008, 000  , 280 }) //Nota  05
/*033*/aAdd(aLayout[1],{'C' , 003, 000  , 288 }) //Serie 06
/*034*/aAdd(aLayout[1],{'N' , 008, 000  , 291 }) //Nota  06
/*035*/aAdd(aLayout[1],{'C' , 003, 000  , 299 }) //Serie 07
/*036*/aAdd(aLayout[1],{'N' , 008, 000  , 302 }) //Nota  07
/*037*/aAdd(aLayout[1],{'C' , 003, 000  , 310 }) //Serie 08
/*038*/aAdd(aLayout[1],{'N' , 008, 000  , 313 }) //Nota  08
/*039*/aAdd(aLayout[1],{'C' , 003, 000  , 321 }) //Serie 09
/*040*/aAdd(aLayout[1],{'N' , 008, 000  , 324 }) //Nota  09
/*041*/aAdd(aLayout[1],{'C' , 003, 000  , 332 }) //Serie 10
/*042*/aAdd(aLayout[1],{'N' , 008, 000  , 335 }) //Nota  10
/*043*/aAdd(aLayout[1],{'C' , 003, 000  , 343 }) //Serie 11
/*044*/aAdd(aLayout[1],{'N' , 008, 000  , 346 }) //Nota  11
/*045*/aAdd(aLayout[1],{'C' , 003, 000  , 354 }) //Serie 12
/*046*/aAdd(aLayout[1],{'N' , 008, 000  , 357 }) //Nota  12
/*047*/aAdd(aLayout[1],{'C' , 003, 000  , 365 }) //Serie 13
/*048*/aAdd(aLayout[1],{'N' , 008, 000  , 368 }) //Nota  13
/*049*/aAdd(aLayout[1],{'C' , 003, 000  , 376 }) //Serie 14
/*050*/aAdd(aLayout[1],{'N' , 008, 000  , 379 }) //Nota  14
/*051*/aAdd(aLayout[1],{'C' , 003, 000  , 387 }) //Serie 15
/*052*/aAdd(aLayout[1],{'N' , 008, 000  , 390 }) //Nota  15
/*053*/aAdd(aLayout[1],{'C' , 003, 000  , 398 }) //Serie 16
/*054*/aAdd(aLayout[1],{'N' , 008, 000  , 401 }) //Nota  16
/*055*/aAdd(aLayout[1],{'C' , 003, 000  , 409 }) //Serie 17
/*056*/aAdd(aLayout[1],{'N' , 008, 000  , 412 }) //Nota  17
/*057*/aAdd(aLayout[1],{'C' , 003, 000  , 420 }) //Serie 18
/*058*/aAdd(aLayout[1],{'N' , 008, 000  , 423 }) //Nota  18
/*059*/aAdd(aLayout[1],{'C' , 003, 000  , 431 }) //Serie 19
/*060*/aAdd(aLayout[1],{'N' , 008, 000  , 434 }) //Nota  19
/*061*/aAdd(aLayout[1],{'C' , 003, 000  , 442 }) //Serie 20
/*062*/aAdd(aLayout[1],{'N' , 008, 000  , 445 }) //Nota  20
/*063*/aAdd(aLayout[1],{'C' , 003, 000  , 453 }) //Serie 21
/*064*/aAdd(aLayout[1],{'N' , 008, 000  , 456 }) //Nota  21
/*065*/aAdd(aLayout[1],{'C' , 003, 000  , 464 }) //Serie 22
/*066*/aAdd(aLayout[1],{'N' , 008, 000  , 467 }) //Nota  22
/*067*/aAdd(aLayout[1],{'C' , 003, 000  , 475 }) //Serie 23
/*068*/aAdd(aLayout[1],{'N' , 008, 000  , 478 }) //Nota  23
/*069*/aAdd(aLayout[1],{'C' , 003, 000  , 486 }) //Serie 24
/*070*/aAdd(aLayout[1],{'N' , 008, 000  , 489 }) //Nota  24
/*071*/aAdd(aLayout[1],{'C' , 003, 000  , 497 }) //Serie 25
/*072*/aAdd(aLayout[1],{'N' , 008, 000  , 511 }) //Nota  25
/*073*/aAdd(aLayout[1],{'C' , 003, 000  , 508 }) //Serie 26
/*074*/aAdd(aLayout[1],{'N' , 008, 000  , 511 }) //Nota  26
/*075*/aAdd(aLayout[1],{'C' , 003, 000  , 519 }) //Serie 27
/*076*/aAdd(aLayout[1],{'N' , 008, 000  , 522 }) //Nota  27
/*077*/aAdd(aLayout[1],{'C' , 003, 000  , 530 }) //Serie 28
/*078*/aAdd(aLayout[1],{'N' , 008, 000  , 533 }) //Nota  28
/*079*/aAdd(aLayout[1],{'C' , 003, 000  , 541 }) //Serie 29
/*080*/aAdd(aLayout[1],{'N' , 008, 000  , 544 }) //Nota  29
/*081*/aAdd(aLayout[1],{'C' , 003, 000  , 552 }) //Serie 30
/*082*/aAdd(aLayout[1],{'N' , 008, 000  , 555 }) //Nota  30
/*083*/aAdd(aLayout[1],{'C' , 003, 000  , 563 }) //Serie 31
/*084*/aAdd(aLayout[1],{'N' , 008, 000  , 566 }) //Nota  31
/*085*/aAdd(aLayout[1],{'C' , 003, 000  , 574 }) //Serie 32
/*086*/aAdd(aLayout[1],{'N' , 008, 000  , 577 }) //Nota  32
/*087*/aAdd(aLayout[1],{'C' , 003, 000  , 585 }) //Serie 33
/*088*/aAdd(aLayout[1],{'N' , 008, 000  , 588 }) //Nota  33
/*089*/aAdd(aLayout[1],{'C' , 003, 000  , 596 }) //Serie 34
/*090*/aAdd(aLayout[1],{'N' , 008, 000  , 599 }) //Nota  34
/*091*/aAdd(aLayout[1],{'C' , 003, 000  , 607 }) //Serie 35
/*092*/aAdd(aLayout[1],{'N' , 008, 000  , 610 }) //Nota  35
/*093*/aAdd(aLayout[1],{'C' , 003, 000  , 618 }) //Serie 36
/*094*/aAdd(aLayout[1],{'N' , 008, 000  , 621 }) //Nota  36
/*095*/aAdd(aLayout[1],{'C' , 003, 000  , 629 }) //Serie 37
/*096*/aAdd(aLayout[1],{'N' , 008, 000  , 632 }) //Nota  37
/*097*/aAdd(aLayout[1],{'C' , 003, 000  , 640 }) //Serie 38
/*098*/aAdd(aLayout[1],{'N' , 008, 000  , 643 }) //Nota  38
/*099*/aAdd(aLayout[1],{'C' , 003, 000  , 651 }) //Serie 39
/*100*/aAdd(aLayout[1],{'N' , 008, 000  , 654 }) //Nota  39
/*101*/aAdd(aLayout[1],{'C' , 003, 000  , 662 }) //Serie 40
/*102*/aAdd(aLayout[1],{'N' , 008, 000  , 665 }) //Nota  40
/*103*/aAdd(aLayout[1],{'C' , 001, 000  , 673 })
/*104*/aAdd(aLayout[1],{'C' , 001, 000  , 674 })
/*105*/aAdd(aLayout[1],{'C' , 004, 000  , 675 })
/*106*/aAdd(aLayout[1],{'C' , 002, 000  , 678 })

aAdd(aLayout,{})
//                      Tipo, Qtd, C.Dec, Pos
/*001*/aAdd(aLayout[2],{'N' , 003, 000  , 001 })
/*002*/aAdd(aLayout[2],{'N' , 004, 000  , 004 })
/*003*/aAdd(aLayout[2],{'N' , 015, 002  , 008 })
/*004*/aAdd(aLayout[2],{'C' , 658, 000  , 023 })


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


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ fResumo บ Autor ณFelipe Aur้lio de Melo บ Data ณ 29/10/09 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     บ                                                            บฑฑ
ฑฑบ          บ                                                            บฑฑ
ฑฑบออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออบฑฑ
ฑฑบUso       บ CCAB1EDI                                                   บฑฑ
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
ฑฑบUso       บ CCAB1EDI                                                   บฑฑ
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
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCCAB1EDI  บAutor  ณMicrosiga           บ Data ณ  01/29/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fAtuSX6()

Local _aFilial 	:= {}
Local _cPerg	:= "MV_CCEDI"

aAdd(_aFilial,{"01","22080"})	// Matriz
aAdd(_aFilial,{"02","22010"})	// Rondonopolis
aAdd(_aFilial,{"03",""})		// Campo Grande
aAdd(_aFilial,{"04","22030"})	// Cuiaba
aAdd(_aFilial,{"05","22020"})	// Dourados
aAdd(_aFilial,{"06","22070"})	// Porto Alegre
aAdd(_aFilial,{"07","22060"})	// LEM
aAdd(_aFilial,{"08","22040"})	// Ibipora
aAdd(_aFilial,{"09",""})		// Rondonopolis 2

For _x:=1 to Len(_aFilial)
	If !SX6->(dbSeek(_aFilial[_x][1]+_cPerg))
		RecLock("SX6",.T.)
		SX6->X6_FIL		:= _aFilial[_x][1]
		SX6->X6_VAR		:= _cPerg
		SX6->X6_TIPO	:= "C"
		SX6->X6_DESCRIC	:= "Centro de Custo utilizado para a inclusao da nota"
		SX6->X6_DESC1	:= "de CTR importada pelo EDI. Especifico CCAB"
		SX6->X6_CONTEUD	:= _aFilial[_x][2]
		SX6->X6_CONTSPA	:= _aFilial[_x][2]
		SX6->X6_CONTENG	:= _aFilial[_x][2]
		SX6->X6_PROPRI	:= "U"
	   	SX6->X6_PYME    := "S"
		SX6->(MsUnlock())
	Endif
Next

Return()
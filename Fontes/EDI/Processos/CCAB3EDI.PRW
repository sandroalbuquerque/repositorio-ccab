#Include "protheus.ch"
#Include "topconn.ch"

//---------------------------------------------------------------------------
//Ajustes para funcionar corretamente este rotina
//Particularidades CCAB
//---------------------------------------------------------------------------
//Cria Campo: F2_EDICOCR -> Tipo = Caracter -> Tamanho = 02 -> Cod.Ocorrencia
//Cria Campo: F2_EDIDOCR -> Tipo = Caracter -> Tamanho = 70 -> Dsc.Ocorrencia
//---------------------------------------------------------------------------

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ºÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍº±±
±±ºPrograma  º CCAB3EDI ºAutor  ºFelipe Aurélio de Melo º Data º 10/11/09 º±±
±±ºÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍº±±
±±ºDesc.     º                                                            º±±
±±º          º                                                            º±±
±±ºÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍº±±
±±ºUso       º CCAB3EDI                                                   º±±
±±ºÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User function CCAB3EDI()

Private cPerg     := "RL3EDI"
Private cStrCad   := "SF2"
Private cTitCad   := "Controle de Ocorrências"
Private cCadastro := cTitCad+" ["+cStrCad+"]"
Private aRotina   := MenuDef()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria estrutura da rotina                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
fAtuSX1()
fAtuSX5()
fAtuSXB()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Chama rotina browse com os menus                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea(cStrCad)
DbSetOrder(1)
mBrowse(6,1,22,75,cStrCad)

Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³MenuDef   ³ Autor ³ Felipe Aurelio de Melo³ Data ³16/11/09  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Utilizacao de menu Funcional                               ³±±     
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Array com opcoes da rotina.                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Parametros do array a Rotina:                               ³±±
±±³          ³1. Nome a aparecer no cabecalho                             ³±±
±±³          ³2. Nome da Rotina associada                                 ³±±
±±³          ³3. Reservado                                                ³±±
±±³          ³4. Tipo de Transa‡„o a ser efetuada:                        ³±±
±±³          ³		1 - Pesquisa e Posiciona em um Banco de Dados           ³±±
±±³          ³    2 - Simplesmente Mostra os Campos                       ³±±
±±³          ³    3 - Inclui registros no Bancos de Dados                 ³±±
±±³          ³    4 - Altera o registro corrente                          ³±±
±±³          ³    5 - Remove o registro corrente do Banco de Dados        ³±±
±±³          ³5. Nivel de acesso                                          ³±±
±±³          ³6. Habilita Menu Funcional                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function MenuDef()

Local aRotina := {;
                   { OemToAnsi("Pesquisar" ),"AxPesqui"     , 0 , 1},;  //
                   { OemToAnsi("Visualizar"),"U_CadEdi3Ccab", 0 , 2},;  //
                   { OemToAnsi("Importar"  ),"U_CadEdi3Ccab", 0 , 3} }  //
Return(aRotina)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³CadEdi3Ccab³ Autor ³Felipe Aurelio de Melo³ Data ³ 16.11.09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Exibe na tela enchoice e a getdados                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CadEdi3Ccab(cAlias,nReg,nOpc)                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CadEdi3Ccab                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Alias do Arquivo                                   ³±±
±±³          ³ ExpN1 = Numero do Registro                                 ³±±
±±³          ³ ExpN2 = Numero da opcao selecionada                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function CadEdi3Ccab(cAlias,nReg,nOpc)

Local nHdl
Local lVldPrg     := .T.
Local lCntnua     := .F.

If nOpc == 2
	Mc090Visual("SF2",SF2->(RecNo()),1)
	Return
EndIf

//Força validação das perguntas
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
	//Tira espaços da rotina
	mv_par01 := AllTrim(mv_par01)

	// Tenta abrir o arquivo em modo exclusivo.
	// Se nao conseguir o acesso exclusivo, sair da rotina.
	nHdl := FOpen(mv_par01,16)
	If nHdl < 0
		MsgAlert("Não foi possível abrir o arquivo no modo exlusivo!")
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
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ºÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍº±±
±±ºPrograma  ºfLerGravarºAutor  ºFelipe Aurélio de Melo º Data º 10/11/09 º±±
±±ºÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍº±±
±±ºDesc.     º                                                            º±±
±±º          º                                                            º±±
±±ºÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍº±±
±±ºUso       º CCAB3EDI                                                   º±±
±±ºÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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

Local c342Ser := ""
Local c342Doc := ""
Local c342Ocr := ""

Local cCgcFil := ""
Local cBkpFil := ""
Local cTxtLog := ""
Local aLogErro:= {}

Local lContinua := .T.

//Abre arquivo
FT_FUSE(cOrig)

//Carrega contador
ProcRegua(FT_FLASTREC())

//Posiciona no primeiro registro
FT_FGOTOP()

//Valida se o arquivo é o correto
If !FT_FEOF()
	//Vai pra próxima linha
	FT_FSKIP()

	If FT_FEOF()
		//Não tem proxima linha
		cLinha := ""
	Else
		//Carrega uma linha do arquivo
		cLinha  := FT_FREADLN()
	EndIf

	//Primeiro Tratamento - 340
	If Len(AllTrim(cLinha)) >= 16
		//Carrega variaveis do cabeçalho
		cIdeReg := SubStr(cLinha,01,03)
		cTipArq := SubStr(cLinha,04,05)
		cDiaMes := SubStr(cLinha,09,02)+"/"+SubStr(cLinha,11,02)
		cHraMin := SubStr(cLinha,13,02)+":"+SubStr(cLinha,15,02)
		cSeqArq := SubStr(cLinha,17,01)
	EndIf

	//Vai pra próxima linha
	FT_FSKIP()

	If FT_FEOF()
		//Não tem proxima linha
		cLinha := ""
	Else
		//Carrega uma linha do arquivo
		cLinha  := FT_FREADLN()
	EndIf

	//Segundo Tratamento - 341
	If Len(AllTrim(cLinha)) >= 17
		//Carrega variaveis do cabeçalho
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

	//Vai pra próxima linha
	FT_FSKIP()
EndIf

//Verifica o conteúdo do arquivo
If lContinua .And. (cIdeReg != "340341" .Or. cTipArq != "OCORR")
	lContinua := .F.
	MsgAlert("O Arquivo informado não é compatível!!!"+Space(30) +Chr(13)+Chr(10)+Chr(13)+Chr(10)+;
			 "Layout: OcoRen"                                    +Chr(13)+Chr(10)+;
			 "Versão: 3.0A"                                      +Chr(13)+Chr(10)+;
			 "Data: 04/02/1999 - Ano 2000")
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

//Caso não continuar, então sair da rotina
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


	//Ocorrencia na Entrega
	If cIdeReg == "342"
	    //Formata linha no layout conforme identificação
		cLinha := fTrataLin(cLinha,1)
	EndIf

	//Quebra linha num array
	aLinha := StrToKArr(cLinha,";")


	//Caso itens, faz tratamentos e monta array
	If cIdeReg == "342"
		//Carrega informações
		c342Ser := Padr(AllTrim(aLinha[3]),3)
		c342Doc := StrZero(Val(aLinha[4]),9)
		c342Ocr := aLinha[5]
		cCgcFil := aLinha[2]
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

	//Posiciona na filial original
	SM0->(DbSeek(cEmpAnt+cFilAnt))


	//Atualiza SF2 - NF de Saída
	If !Empty(cFilAnt)
		//Criar Campo SF2 para atualizar caso encontre
		If SF2->(DbSeek(xFilial("SF2")+c342Doc+c342Ser+cCodTrs+cLojTrs))
			RecLock("SF2",.F.)
			SF2->F2_EDICOCR := c342Ocr
			SF2->F2_EDIDOCR := Upper(Padr(POSICIONE("SX5",1,SPACE(2)+"WJ"+c342Ocr,"X5_DESCRI"),70))
			MsUnLock()
			aAdd(aLogErro,Replicate("-",75))
			aAdd(aLogErro,"Linha: "+StrZero(2+nCount,4))
			aAdd(aLogErro,"Filial: "+cFilAnt)
			aAdd(aLogErro,"Serie/Doc: "+c342Ser+"/"+c342Doc)
			aAdd(aLogErro,"Ocorrência: "+c342Ocr)
			aAdd(aLogErro,"Mensagem: Ocorrência atualizada com sucesso.")
			aAdd(aLogErro,"")
		Else
			aAdd(aLogErro,Replicate("-",75))
			aAdd(aLogErro,"Linha: "+StrZero(2+nCount,4))
			aAdd(aLogErro,"Filial: "+cFilAnt)
			aAdd(aLogErro,"Serie/Doc: "+c342Ser+"/"+c342Doc)
			aAdd(aLogErro,"Ocorrência: "+c342Ocr)
			aAdd(aLogErro,"Mensagem: NF não localizada, por isso não foi possível atualização da ocorrência.")
			aAdd(aLogErro,"")
		EndIf
	Else
		aAdd(aLogErro,Replicate("-",75))
		aAdd(aLogErro,"Linha: "+StrZero(2+nCount,4))
		aAdd(aLogErro,"CNPJ: "+cCgcFil)
		aAdd(aLogErro,"Serie/Doc: "+c342Ser+"/"+c342Doc)
		aAdd(aLogErro,"Ocorrência: "+c342Ocr)
		aAdd(aLogErro,"Mensagem: Filial não localizada, logo NF também não foi localizada para atualização.")
		aAdd(aLogErro,"")	
	EndIf

	//Restaura variaveis
	cFilAnt := cBkpFil
	cBkpFil := ""
	cCgcFil := ""

	//Posiciona na filial original
	SM0->(DbSeek(cEmpAnt+cFilAnt))
		
	//Proxima linha
	FT_FSKIP()
End

//Finaliza utilização do arquivo
FT_FUSE()

//Renomeia arquivo após executar
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
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ fResumo º Autor ³Felipe Aurélio de Melo º Data ³ 29/10/09 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     º                                                            º±±
±±º          º                                                            º±±
±±ºÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍº±±
±±ºUso       º CCAB3EDI                                                   º±±
±±ºÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function fResumo(cTexto)

Local oDlg,oMemo
Local cTxtLog := "LOG DOS ERROS NA IMPORTAÇÃO"
Local cArqLog := Criatrab(,.f.)+".LOG"
Define Font oFont Name "Mono AS" Size 05,12

cTxtLog += CRLF+Replicate("-",75)
cTxtLog += CRLF+"Data: "+DtoC(Date())
cTxtLog += CRLF+"Hora: "+Time()
cTxtLog += CRLF+"Usuário: "+cUserName

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
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ PrintAErr º Autor ³Felipe Aurélio de Meloº Data ³ 29/10/09 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Imprime o autoerro.log                                     º±±
±±º          º                                                            º±±
±±ºÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍº±±
±±ºUso       º CCAB3EDI                                                   º±±
±±ºÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ºÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍº±±
±±ºPrograma  º fAtuSX1  ºAutor  ºFelipe Aurélio de Melo º Data º 10/11/09 º±±
±±ºÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍº±±
±±ºDesc.     º                                                            º±±
±±º          º                                                            º±±
±±ºÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍº±±
±±ºUso       º CCAB3EDI                                                   º±±
±±ºÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fAtuSX1()

Local aPergs := {}

Aadd(aPergs,{"Arquivo Origem"   , "Arquivo Origem"   , "Arquivo Origem"   , "mv_ch1"  , "C" , 99,00,00 ,"G", "", "mv_par01", ""                , ""                , ""                , "", "", ""                , ""                , ""                , "", "", ""                , ""                , ""                , "", "", ""                , ""                , ""                , "", "", ""                , ""                , ""                , "", "ARQEDI","","S","","",{},{},{}})
AjustaSx1(cPerg,aPergs)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ºÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍº±±
±±ºPrograma  º fAtuSX5 º Autor º Felipe Aurélio de Melo º Data º 10/11/09 º±±
±±ºÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍº±±
±±ºDesc.     º                                                            º±±
±±º          º                                                            º±±
±±ºÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍº±±
±±ºUso       º CCAB3EDI                                                   º±±
±±ºÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fAtuSX5()

Local aSX5   := {}
Local aEstrut:= {}
Local cTabSx5:= "WJ"
Local cFilSx5:= "WJ"
Local i      := 0
Local j      := 0
aEstrut:= {"X5_FILIAL","X5_TABELA","X5_CHAVE","X5_DESCRI","X5_DESCSPA","X5_DESCENG"}

aAdd(aSX5,{cFilSx5    ,cTabSx5    ,"01"      ,"Entrega Realizada Normalmente"                                       ,"",""} )
aAdd(aSX5,{cFilSx5    ,cTabSx5    ,"02"      ,"Entrega Fora da Data Programada"                                     ,"",""} )
aAdd(aSX5,{cFilSx5    ,cTabSx5    ,"03"      ,"Recusa por Falta de Pedido de Compra"                                ,"",""} )
aAdd(aSX5,{cFilSx5    ,cTabSx5    ,"04"      ,"Recusa por Pedido de Compra Cancelado"                               ,"",""} )
aAdd(aSX5,{cFilSx5    ,cTabSx5    ,"05"      ,"Falta de Espaço Físico no Depósito do Cliente Destino"               ,"",""} )
aAdd(aSX5,{cFilSx5    ,cTabSx5    ,"06"      ,"Endereço do Cliente Destino não Localizado"                          ,"",""} )
aAdd(aSX5,{cFilSx5    ,cTabSx5    ,"07"      ,"Devolução não Autorizada pelo Cliente"                               ,"",""} )
aAdd(aSX5,{cFilSx5    ,cTabSx5    ,"08"      ,"Preço Mercadoria em Desacordo com o Pedido Compra"                   ,"",""} )
aAdd(aSX5,{cFilSx5    ,cTabSx5    ,"09"      ,"Mercadoria em Desacordo com o Pedido Compra"                         ,"",""} )
aAdd(aSX5,{cFilSx5    ,cTabSx5    ,"10"      ,"Cliente Destino somente Recebe Mercadoria com Frete Pago"            ,"",""} )
aAdd(aSX5,{cFilSx5    ,cTabSx5    ,"11"      ,"Recusa por Deficiência Embalagem Mercadoria"                         ,"",""} )
aAdd(aSX5,{cFilSx5    ,cTabSx5    ,"12"      ,"Redespacho não Indicado"                                             ,"",""} )
aAdd(aSX5,{cFilSx5    ,cTabSx5    ,"13"      ,"Transportadora não Atende a Cidade do Cliente Destino"               ,"",""} )
aAdd(aSX5,{cFilSx5    ,cTabSx5    ,"14"      ,"Mercadoria Sinistrada"                                               ,"",""} )
aAdd(aSX5,{cFilSx5    ,cTabSx5    ,"15"      ,"Embalagem Sinistrada"                                                ,"",""} )
aAdd(aSX5,{cFilSx5    ,cTabSx5    ,"16"      ,"Pedido de Compras em Duplicidade"                                    ,"",""} )
aAdd(aSX5,{cFilSx5    ,cTabSx5    ,"17"      ,"Mercadoria fora da Embalagem de Atacadista"                          ,"",""} )
aAdd(aSX5,{cFilSx5    ,cTabSx5    ,"18"      ,"Mercadorias Trocadas"                                                ,"",""} )
aAdd(aSX5,{cFilSx5    ,cTabSx5    ,"19"      ,"Reentrega Solicitada pelo Cliente"                                   ,"",""} )
aAdd(aSX5,{cFilSx5    ,cTabSx5    ,"20"      ,"Entrega Prejudicada por Horário/Falta de Tempo Hábil"                ,"",""} )
aAdd(aSX5,{cFilSx5    ,cTabSx5    ,"21"      ,"Estabelecimento Fechado"                                             ,"",""} )
aAdd(aSX5,{cFilSx5    ,cTabSx5    ,"22"      ,"Reentrega sem Cobrança do Cliente"                                   ,"",""} )
aAdd(aSX5,{cFilSx5    ,cTabSx5    ,"23"      ,"Extravio de Mercadoria em Trânsito"                                  ,"",""} )
aAdd(aSX5,{cFilSx5    ,cTabSx5    ,"24"      ,"Mercadoria Reentregue ao Cliente Destino"                            ,"",""} )
aAdd(aSX5,{cFilSx5    ,cTabSx5    ,"25"      ,"Mercadoria Devolvida ao cliente Origem de Origem"                    ,"",""} )
aAdd(aSX5,{cFilSx5    ,cTabSx5    ,"26"      ,"Nota Fiscal Retida pela Fiscalização"                                ,"",""} )
aAdd(aSX5,{cFilSx5    ,cTabSx5    ,"27"      ,"Roubo de Carga"                                                      ,"",""} )
aAdd(aSX5,{cFilSx5    ,cTabSx5    ,"28"      ,"Mercadoria Retida até Segunda Ordem"                                 ,"",""} )
aAdd(aSX5,{cFilSx5    ,cTabSx5    ,"29"      ,"Cliente Retira Mercadoria na Transportadora"                         ,"",""} )
aAdd(aSX5,{cFilSx5    ,cTabSx5    ,"30"      ,"Problema com a Documentação (Nota Fiscal / CTRC)"                    ,"",""} )
aAdd(aSX5,{cFilSx5    ,cTabSx5    ,"31"      ,"Entrega com Indenização Efetuada"                                    ,"",""} )
aAdd(aSX5,{cFilSx5    ,cTabSx5    ,"32"      ,"Falta com Solicitação de Reposição"                                  ,"",""} )
aAdd(aSX5,{cFilSx5    ,cTabSx5    ,"33"      ,"Falta com Busca/Reconferência"                                       ,"",""} )
aAdd(aSX5,{cFilSx5    ,cTabSx5    ,"34"      ,"Cliente Fechado para Balanço"                                        ,"",""} )
aAdd(aSX5,{cFilSx5    ,cTabSx5    ,"35"      ,"Quantidade de Produto em Desacordo (Nota Fiscal e/ou Pedido)"        ,"",""} )
aAdd(aSX5,{cFilSx5    ,cTabSx5    ,"41"      ,"Pedido de Compra Incompleto"                                         ,"",""} )
aAdd(aSX5,{cFilSx5    ,cTabSx5    ,"42"      ,"Nota Fiscal com Produtos de Setores Diferentes"                      ,"",""} )
aAdd(aSX5,{cFilSx5    ,cTabSx5    ,"43"      ,"Feriado Local/Nacional"                                              ,"",""} )
aAdd(aSX5,{cFilSx5    ,cTabSx5    ,"44"      ,"Excesso de Veículos"                                                 ,"",""} )
aAdd(aSX5,{cFilSx5    ,cTabSx5    ,"45"      ,"Cliente Destino Encerrou Atividades"                                 ,"",""} )
aAdd(aSX5,{cFilSx5    ,cTabSx5    ,"46"      ,"Responsável de Recebimento Ausente"                                  ,"",""} )
aAdd(aSX5,{cFilSx5    ,cTabSx5    ,"47"      ,"Cliente Destino em Greve"                                            ,"",""} )
aAdd(aSX5,{cFilSx5    ,cTabSx5    ,"50"      ,"Greve nacional (greve geral)"                                        ,"",""} )
aAdd(aSX5,{cFilSx5    ,cTabSx5    ,"65"      ,"Entrar em Contato com o Comprador"                                   ,"",""} )
aAdd(aSX5,{cFilSx5    ,cTabSx5    ,"66"      ,"Troca não Disponível"                                                ,"",""} )
aAdd(aSX5,{cFilSx5    ,cTabSx5    ,"67"      ,"Fins Estatísticos"                                                   ,"",""} )
aAdd(aSX5,{cFilSx5    ,cTabSx5    ,"68"      ,"Data de Entrega Diferente do Pedido"                                 ,"",""} )
aAdd(aSX5,{cFilSx5    ,cTabSx5    ,"69"      ,"Substituição Tributária"                                             ,"",""} )
aAdd(aSX5,{cFilSx5    ,cTabSx5    ,"70"      ,"Sistema Fora do Ar"                                                  ,"",""} )
aAdd(aSX5,{cFilSx5    ,cTabSx5    ,"71"      ,"Cliente Destino não Recebe Pedido Parcial"                           ,"",""} )
aAdd(aSX5,{cFilSx5    ,cTabSx5    ,"72"      ,"Cliente Destino só Recebe Pedido Parcial"                            ,"",""} )
aAdd(aSX5,{cFilSx5    ,cTabSx5    ,"73"      ,"Redespacho somente com Frete Pago"                                   ,"",""} )
aAdd(aSX5,{cFilSx5    ,cTabSx5    ,"74"      ,"Funcionário não autorizado a Receber Mercadorias"                    ,"",""} )
aAdd(aSX5,{cFilSx5    ,cTabSx5    ,"75"      ,"Mercadoria Embarcada para Rota Indevida"                             ,"",""} )
aAdd(aSX5,{cFilSx5    ,cTabSx5    ,"76"      ,"Estrada/Entrada de Acesso Interditada"                               ,"",""} )
aAdd(aSX5,{cFilSx5    ,cTabSx5    ,"77"      ,"Cliente Destino Mudou de Endereço"                                   ,"",""} )
aAdd(aSX5,{cFilSx5    ,cTabSx5    ,"78"      ,"Avaria Total"                                                        ,"",""} )
aAdd(aSX5,{cFilSx5    ,cTabSx5    ,"79"      ,"Avaria Parcial"                                                      ,"",""} )
aAdd(aSX5,{cFilSx5    ,cTabSx5    ,"80"      ,"Extravio Total"                                                      ,"",""} )
aAdd(aSX5,{cFilSx5    ,cTabSx5    ,"81"      ,"Extravio Parcial"                                                    ,"",""} )
aAdd(aSX5,{cFilSx5    ,cTabSx5    ,"82"      ,"Sobra de Mercadoria sem Nota Fiscal"                                 ,"",""} )
aAdd(aSX5,{cFilSx5    ,cTabSx5    ,"83"      ,"Mercadoria em poder da SUFRAMA para Internação"                      ,"",""} )
aAdd(aSX5,{cFilSx5    ,cTabSx5    ,"84"      ,"Mercadoria Retirada para Conferência"                                ,"",""} )
aAdd(aSX5,{cFilSx5    ,cTabSx5    ,"85"      ,"Apreensão Fiscal da Mercadoria"                                      ,"",""} )
aAdd(aSX5,{cFilSx5    ,cTabSx5    ,"86"      ,"Excesso de Carga/Peso"                                               ,"",""} )
aAdd(aSX5,{cFilSx5    ,cTabSx5    ,"91"      ,"Entrega Programada"                                                  ,"",""} )
aAdd(aSX5,{cFilSx5    ,cTabSx5    ,"92"      ,"Problemas Fiscais"                                                   ,"",""} )
aAdd(aSX5,{cFilSx5    ,cTabSx5    ,"99"      ,"Outros tipos de ocorrências não especificados acima"                 ,"",""} )

dbSelectArea("SX5")
dbSetOrder(1)
For i:= 1 To Len(aSX5)
	If !Empty(aSX5[i][1])
		If !dbSeek(aSX5[i,1]+aSX5[i,2]+aSX5[i,3])
			RecLock("SX5",.T.)
			For j:=1 To Len(aSX5[i])
				If !Empty(FieldName(FieldPos(aEstrut[j])))
					FieldPut(FieldPos(aEstrut[j]),aSX5[i,j])
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
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ºÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍº±±
±±ºPrograma  º fAtuSXB º Autor º Felipe Aurélio de Melo º Data º 10/11/09 º±±
±±ºÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍº±±
±±ºDesc.     º                                                            º±±
±±º          º                                                            º±±
±±ºÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍº±±
±±ºUso       º CCAB3EDI                                                   º±±
±±ºÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ºÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍº±±
±±ºPrograma  º fVldPerg ºAutor  ºFelipe Aurélio de Melo º Data º 10/11/09 º±±
±±ºÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍº±±
±±ºDesc.     º                                                            º±±
±±º          º                                                            º±±
±±ºÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍº±±
±±ºUso       º CCAB3EDI                                                   º±±
±±ºÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fVldPerg()

Local lRet := .T.

//Tratamento mv_par01
If lRet
	If Empty(mv_par01) .Or. !File(AllTrim(mv_par01))
		lRet := .F.
		ShowHelpDlg("mv_par01", {"O arquivo informado não existe","no caminho de pastas selecionado!!!"},5,;
								{"Favor escolher novamente o arquivo","a ser importado."},5)
	EndIf
EndIf

Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ºÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍº±±
±±ºPrograma  ºfTrataLinº Autor º Felipe Aurélio de Melo º Data º 05/11/09 º±±
±±ºÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍº±±
±±ºDesc.     º                                                            º±±
±±º          º                                                            º±±
±±ºÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍº±±
±±ºUso       º CCAB1EDI                                                   º±±
±±ºÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function fTrataLin(cLinha,nLayOut)

Local cRet      := ""
Local aLayout   := {}

Default nLayOut := 00
Default cLinha  := ""

//Layout: 342
aAdd(aLayout,{})
//                      Tipo, Qtd, C.Dec, Pos
/*001*/aAdd(aLayout[1],{'N' , 003, 000  , 001 })
/*002*/aAdd(aLayout[1],{'N' , 014, 000  , 004 })
/*003*/aAdd(aLayout[1],{'C' , 003, 000  , 018 })
/*004*/aAdd(aLayout[1],{'N' , 008, 000  , 021 })
/*005*/aAdd(aLayout[1],{'N' , 002, 000  , 029 })
/*006*/aAdd(aLayout[1],{'N' , 008, 000  , 031 })
/*007*/aAdd(aLayout[1],{'N' , 004, 000  , 039 })
/*008*/aAdd(aLayout[1],{'N' , 002, 000  , 043 })
/*009*/aAdd(aLayout[1],{'C' , 070, 000  , 045 })
/*010*/aAdd(aLayout[1],{'C' , 006, 000  , 115 })

//Loço para montar linha como se fosse csv para depois montar array
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
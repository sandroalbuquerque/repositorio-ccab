#include "rwmake.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ RFATR03  ºAutor  ³ Paulo Elias        º Data ³  26/02/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Espelho de Nota Fiscal de Entrada / Saída / Importação     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Específico CCAB                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RFATR03()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private nValDescIt  := 0
SetPrvt("CBTXT,CBCONT,NORDEM,ALFA,Z,M,J")
SetPrvt("CPREPED,CPEDSFA")
SetPrvt("CNFORI,TAMANHO,LIMITE,TITULO,CDESC1,CDESC2,CDESC3")
SetPrvt("ANATOPER,CNATUREZA,ARETURN,NOMEPROG,CPERG,NLASTKEY,LCONTINUA")
SetPrvt("NLIN,NLINANT,WNREL,NTAMNF,CSTRING,CPEDANT,NLININI")
SetPrvt("XNUM_NF,XPREFIXO,XSERIE,XEMISSAO,XTOT_FAT,XLOJA,XFRETE,XDI,XTRA")
SetPrvt("XSEGURO,XBASE_ICMS,XBASE_IPI,XVALOR_ICMS,XICMS_RET,XVALOR_IPI,XPARCELA")
SetPrvt("XVALOR_MERC,XNUM_DUPLIC,XCOND_PAG,XPBRUTO,XPLIQUI,XTIPO")
SetPrvt("XESPECIE,XVOLUME,CPEDATU,CITEMATU,XPED_VEND,XITEM_PED")
SetPrvt("XNUM_NFDV,XPREF_DV,XICMS,XCOD_PRO,XLOTE,XVALID,LTES,XQTD_PRO,XPRE_UNI, XHAWB")
SetPrvt("XPRE_TAB,XIPI,XVAL_IPI,XDESC,XVAL_DESC,XVAL_MERC")
SetPrvt("XTES,XCF,XICMSOL,XICM_PROD,XPESO_PRO,XPESO_BRU,XPESO_UNIT")
SetPrvt("XDESCRICAO,XCEME,XUNID_PRO,XCOD_TRIB,XMEN_TRIB,XCOD_FIS,XCLAS_FIS")
SetPrvt("XMEN_POS,XISS,XTIPO_PRO,XLUCRO,XCLFISCAL,XPESO_LIQ,XPESO_BRU1")
SetPrvt("I,NPELEM,_CLASFIS,NPTESTE,XPESO_LIQUID,XPED,XINVOICE")
SetPrvt("XPESO_BRUTO,XP_LIQ_PED,xP_BRUTO,XCLIENTE,XTIPO_CLI,XCOD_MENS,xFil_mens,xMensagem,xMensagem1")
SetPrvt("XTPFRETE,XCONDPAG,XCOD_VEND,XDESC_NF,XDESC_PAG,XPED_CLI")
SetPrvt("XDESC_PRO,J,XCOD_CLI,XLJ_CLI,XNOME_CLI,XEND_CLI,XBAIRRO")
SetPrvt("XCEP_CLI,XCOB_CLI,XREC_CLI,XMUN_CLI,XEST_CLI,XCGC_CLI")
SetPrvt("XINSC_CLI,XTRAN_CLI,XTEL_CLI,XFAX_CLI,XSUFRAMA,XCALCSUF")
SetPrvt("ZFRANCA,XVENDEDOR,XBSICMRET,XNOME_TRANSP,XEND_TRANSP,XMUN_TRANSP")
SetPrvt("XEST_TRANSP,XVIA_TRANSP,XCGC_TRANSP,XTEL_TRANSP,XPARC_DUP,XVENC_DUP, xDESC_DUP")
SetPrvt("XVALOR_DUP,XDUPLICATAS,XNATUREZA,XFORNECE,XNFORI,XPEDIDO")
SetPrvt("XPESOPROD,XFAX,NOPC,CCOR,NTAMDET,XB_ICMS_SOL")
SetPrvt("XV_ICMS_SOL,NCONT,NCOL,NTAMOBS,NAJUSTE,BB")
SetPrvt("XPROD_ONU,XPROD_RISC,XDESCSUFR,XDESCZFR,XSIT, _xdif")
SetPrvt("_nDESCR2,xLOCDESC,xCliEntreg,xLjEntreg,_lnota,XEMBARQUE,XTPEMBARQ,_xLocal")
SetPrvt("_nTOTDES,XDESFIN,xParc_PV,_TESAUX")

#IFNDEF WINDOWS
	// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 19/11/99 ==> 	#DEFINE PSAY SAY
#ENDIF

/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Programa  ¦  Espelho ¦ Autor ¦   Paulo Elias         ¦ Data ¦ 28/09/07 ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Nota Fiscal de Entrada/Saida                               ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ Especifico para CCAB-Agro                                  ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/
//+--------------------------------------------------------------+
//¦ Define Variaveis Ambientais                                  ¦
//+--------------------------------------------------------------+
//+--------------------------------------------------------------+
//¦ Variaveis utilizadas para parametros                         ¦
//¦ mv_par01             // Da Nota Fiscal                       ¦
//¦ mv_par02             // Ate a Nota Fiscal                    ¦
//¦ mv_par03             // Da Serie                             ¦
//¦ mv_par04             // Nota Fiscal de Entrada/Saida         ¦
//+--------------------------------------------------------------+
aNatOper 	:= {}
CbTxt		:= ""
CbCont		:= ""
nOrdem 		:= 0
Alfa 		:= 0
Z			:= 0
M			:= 0
tamanho		:= "G"
limite		:= 220
titulo 		:= PADR("Espelho NF - Espelho - Vr 2.0",74)
cDesc1 		:= PADR("Este programa ira emitir o Espelho de Entrada/Saida",74)
cDesc2 		:= PADR("da Nfiscal",74)
cDesc3 		:= ""
cNatureza	:= ""
cNFOri      := ""
cPrePed     := ""
cPedSFA     := ""
aReturn 	:= { "Especial", 1,"Administracao", 1, 2, 1,"",1 }
nomeprog	:="Espelho"
cPerg		:="ESPELH"
nLastKey	:= 0
lContinua 	:= .T.
xLOCDESC	:= ""
wnrel   	:= "EspelhoNF"
lTes 		:= .F.
_xLocal 	:= ""
_xdif 		:= 0
nLin		:= 0
nTamNf		:= 72     // Apenas Informativo                                     
xPED_VEND := {}                         	// Numero do Pedido de Venda

//+-------------------------------------------------------------------------+
//¦ Verifica as perguntas selecionadas, busca o padrao do espelho           ¦
//+-------------------------------------------------------------------------+

Pergunte(cPerg,.F.)               // Pergunta no SX1

cString:="SF2"

//+--------------------------------------------------------------+
//¦ Envia controle para a funcao SETPRINT                        ¦
//+--------------------------------------------------------------+

wnrel:=SetPrint(cString,wnrel,cPerg,Titulo,cDesc1,cDesc2,cDesc3,.T.)

If nLastKey == 27
	Return
Endif

//+--------------------------------------------------------------+
//¦ Verifica Posicao do Formulario na Impressora                 ¦
//+--------------------------------------------------------------+
SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

VerImp()

//+--------------------------------------------------------------+
//¦                                                              ¦
//¦ Inicio do Processamento da Nota Fiscal                       ¦
//¦                                                              ¦
//+--------------------------------------------------------------+
#IFDEF WINDOWS
	RptStatus({|| RptDetail()})// Substituido pelo assistente de conversao do AP5 IDE em 19/11/99 ==> 	RptStatus({|| Execute(RptDetail)})
	Return
	// Substituido pelo assistente de conversao do AP5 IDE em 19/11/99 ==> 	Function RptDetail
	Static Function RptDetail()
#ENDIF

Local I:=1
Local J:=1

If mv_par04 == 2
	dbSelectArea("SF2")                // * Cabecalho da Nota Fiscal Saida
	dbSetOrder(1)
	dbSeek(xFilial()+mv_par01+mv_par03,.t.)
	
	dbSelectArea("SD2")                // * Itens de Venda da Nota Fiscal
	dbSetOrder(3)
	dbSeek(xFilial()+mv_par01+mv_par03)
	cPedant := SD2->D2_PEDIDO
Else
	dbSelectArea("SF1")                // * Cabecalho da Nota Fiscal Entrada
	DbSetOrder(1)
	dbSeek(xFilial()+mv_par01+AllTrim(mv_par03),.t.)
	
	dbSelectArea("SD1")                // * Itens da Nota Fiscal de Entrada
	dbSetOrder(3)
Endif
dbSelectArea("SF4")                   // * Tipos de Entrada e Saida
DbSetOrder(1)

//+-----------------------------------------------------------+
//¦ Inicializa  regua de impressao                            ¦
//+-----------------------------------------------------------+
SetRegua(Val(mv_par02)-Val(mv_par01))
If mv_par04 == 2
	dbSelectArea("SF2")
	While !eof() .and. SF2->F2_DOC <= mv_par02 .and. lContinua
		
		If AllTrim(SF2->F2_SERIE) != AllTrim(mv_par03) .OR. SF2->F2_filial <> xFilial("SF2")   // Se a Serie do Arquivo for Diferente
			DbSkip()                    // do Parametro Informado !!!
			Loop
		Endif
		
		IF lAbortPrint
			@ 00,01 PSAY "** CANCELADO PELO OPERADOR **"
			lContinua := .F.
			Exit
		Endif
		
		nLinIni:=nLin                         // Linha Inicial da Impressao
		
		aNatOper    := {}                     // Zera TES dos Itens
		cNFOri      :=""                      // Zera NF Origem
		cPrePed     :=""
		cPedSFA     :=""
		xNUM_NF     :=SF2->F2_DOC             // Numero
		xSERIE      :=SF2->F2_SERIE           // Serie
		xEMISSAO    :=SF2->F2_EMISSAO         // Data de Emissao
		xTOT_FAT    :=SF2->F2_VALBRUT          // Valor Total da Fatura
		xPREFIXO    :=SF2->F2_PREFIXO		  // Prefixo do Titulo no Financeiro
		
		if xTOT_FAT == 0
			xTOT_FAT := SF2->F2_VALMERC+SF2->F2_VALIPI+SF2->F2_SEGURO+SF2->F2_FRETE
		endif
		
		xLOJA       :=SF2->F2_LOJA            // Loja do Cliente
		xFRETE      :=SF2->F2_FRETE           // Frete
		xSEGURO     :=SF2->F2_SEGURO          // Seguro
		xBASE_ICMS  :=SF2->F2_BASEICM         // Base   do ICMS
		xBASE_IPI   :=SF2->F2_BASEIPI         // Base   do IPI
		xVALOR_ICMS :=SF2->F2_VALICM          // Valor  do ICMS
		xICMS_RET   :=SF2->F2_ICMSRET         // Valor  do ICMS Retido
		xVALOR_IPI  :=SF2->F2_VALIPI          // Valor  do IPI
		xVALOR_MERC :=SF2->F2_VALMERC         // Valor  da Mercadoria
		xNUM_DUPLIC :=SF2->F2_DUPL            // Numero da Duplicata
		xCOND_PAG   :=SF2->F2_COND            // Condicao de Pagamento
		xPBRUTO     :=SF2->F2_PBRUTO          // Peso Bruto
		xPLIQUI     :=SF2->F2_PLIQUI          // Peso Liquido
		xTIPO       :=SF2->F2_TIPO            // Tipo do Cliente
		xESPECIE    :=SF2->F2_ESPECI1         // Especie 1 no Pedido
		
		xTRAN_CLI := ""
		
		If !Empty(SF2->F2_TRANSP)
			xTRAN_CLI := SF2->F2_TRANSP
		Endif
		
		dbSelectArea("SD2")                   // * Itens de Venda da N.F.
		dbSetOrder(3)
		dbSeek(xFilial()+xNUM_NF+xSERIE)
		
		cPedAtu   := SD2->D2_PEDIDO
		cItemAtu  := SD2->D2_ITEMPV
		xFil_Mens := ' '
		ltes	  := .f.						  	// Nao imprime a validade do Lote
		xPED_VEND := {}                         	// Numero do Pedido de Venda
		xITEM_PED := {}                         	// Numero do Item do Pedido de Venda
		xNUM_NFDV := {}                         	// nUMERO QUANDO HOUVER DEVOLUCAO
		xPREF_DV  := {}                         	// Serie  quando houver devolucao
		xICMS     := {}                         	// Porcentagem do ICMS
		xCOD_PRO  := {}                         	// Codigo  do Produto
		xLOTE     := {}                         	// Codigo  do lote do produto
		xVALID    := {}                         	// Data de Validade do Lote
		xQTD_PRO  := {}                         	// Peso/Quantidade do Produto
		xPRE_UNI  := {}                         	// Preco Unitario de Venda
		xPRE_TAB  := {}                         	// Preco Unitario de Tabela
		xIPI      := {}                         	// Porcentagem do IPI
		xVAL_IPI  := {}                         	// Valor do IPI
		xDESC     := {}                         	// Desconto por Item
		xVAL_DESC := {}                         	// Valor do Desconto
		xVAL_MERC := {}                         	// Valor da Mercadoria
		xTES      := {}                         	// TES
		xCF       := {}                         	// Classificacao quanto natureza da Operacao
		xICMSOL   := {}                         	// Base do ICMS Solidario
		xICM_PROD := {}                         	// ICMS do Produto
		xDESCZFR  := {}                         	// dESCONTO sUFRSA
		xNATUREZA := {}   	                     	// NATUREZA DA OPERACAO
		xSIT 	  := {}                         	// SEGUNDO DIGITO SITUACAO TRIB
		xDESFIN   := {}
		_nTOTDES  := 0
		_xdif     := 0
		
		While !Eof() .and. SD2->D2_DOC==xNUM_NF .and. SD2->D2_SERIE==xSERIE
			
			If AllTrim(SD2->D2_SERIE) != AllTrim(mv_par03)         // Se a Serie do Arquivo for Diferente
				DbSkip()                       						// do Parametro Informado !!!
				Loop
			Endif
			
			Aadd(xPED_VEND 	,SD2->D2_PEDIDO)
			Aadd(xITEM_PED 	,SD2->D2_ITEMPV)
			Aadd(xNUM_NFDV 	,IIF(Empty(SD2->D2_NFORI),"",SD2->D2_NFORI))
			Aadd(xPREF_DV  	,SD2->D2_SERIORI)
			Aadd(xICMS     	,IIf(Empty(SD2->D2_PICM),0,SD2->D2_PICM))
			Aadd(xCOD_PRO  	,SD2->D2_COD)
			//======================================================================
			// Novo Ajuste para pegar o numero do Lote do Fornecedor quando Houver	
			// Favaro 30/03/2012						
			cLoteForx := ""
			cLoteForx := Posicione("SB8",1,xFilial("SB8")+Padr(SD2->D2_COD,15)+Padr(SD2->D2_LOCAL,2)+PADR(DTOS(SD2->D2_DTVALID),8)+PADR(SD2->D2_LOTECTL,10)+PADR(SD2->D2_NUMLOTE,6),"B8_LOTEFOR")
			//Aadd(xLOTE     	,SD2->D2_LOTECTL) 
			Aadd(xLOTE     	,IIF(Alltrim(cLoteForx) <> "",cLoteForx,SD2->D2_LOTECTL))
			Aadd(XVALID    	,SD2->D2_DTVALID)
			Aadd(xQTD_PRO  	,SD2->D2_QUANT)     // Guarda as quant. da NF
			Aadd(xPRE_UNI  	,Iif(SD2->D2_PRUNIT > 0,SD2->D2_PRCVEN,SD2->D2_PRCVEN))
			Aadd(xDESCZFR  	,SD2->D2_DESCZFR)
			Aadd(xPRE_TAB  	,SD2->D2_PRUNIT)
			Aadd(xIPI      	,IIF(Empty(SD2->D2_IPI),0,SD2->D2_IPI))
			Aadd(xVAL_IPI  	,SD2->D2_VALIPI)
			Aadd(xDESC     	,SD2->D2_DESC)
			Aadd(xVAL_MERC 	,SD2->D2_TOTAL)
			Aadd(xTES 		,SD2->D2_TES)
			Aadd(xICM_PROD 	,If(Empty(SD2->D2_PICM),0,SD2->D2_PICM))
			Aadd(xDESFIN 	,SD2->D2_XDESFIN)
			
			_TESAUX := SD2->D2_TES
			_nTOTDES:= _nTOTDES + SD2->D2_XDESFIN
			
			_xdif   := _xdif + Iif(SD2->D2_PRUNIT > 0,0,0)
			_xLocal := SD2->D2_LOCAL
			
			//	Incluido por Samir para imprimir o desconto comercial
			nValDescIt += IIF(POSICIONE("SF4",1,XFILIAL("SF4")+SD2->D2_TES,"F4_AGREG")=="N" .and. SD2->D2_TIPO == "N",SD2->D2_TOTAL,0)
			
			DbSelectArea("SF4")                   // * Tipos de Entrada e Saida *
			DbSeek(xFilial("SF4")+SD2->D2_TES)
			Aadd(xNATUREZA 	,SF4->F4_TEXTO)
			Aadd(xSIT 		,SF4->F4_SITTRIB)
			Aadd(xCF  		,SD2->D2_CF)
			cNatureza := fGroupTES(@aNatOper,SD2->D2_TES,IIf(!SD2->D2_TIPO$"IP",SD2->D2_TOTAL,0))
			
			//Grava as NF Origem
			If !Empty(SD2->(D2_NFORI+D2_SERIORI))
				If !(StrTran(SD2->(D2_NFORI+"-"+D2_SERIORI)," ","") $ cNFOri)
					cNFOri += IIf(Empty(cNFOri),"","/")+StrTran(SD2->(D2_NFORI+"-"+D2_SERIORI)," ","")
				EndIf
			EndIf
			
			// Daniel 10/09/2010 - Tratamento de mensagens para produtos especificos (caso de fertilizantes)
			_cGrupo	   := Posicione("SB1",1,xFilial("SB1")+SD2->D2_COD	,"B1_GRUPO")
			_cMensGrpD := Posicione("SBM",1,xFilial("SBM")+_cGrupo		,"BM_XMENSD")
			_cMensGrpF := Posicione("SBM",1,xFilial("SBM")+_cGrupo		,"BM_XMENSF")
			
			If !Empty(_cMensGrpD+_cMensGrpF) // Caso uma das duas esteja preenchida
				// Verifica se o tipo de entrada eh para dentro ou fora do estado (D=Dentro;F=Fora;A=Ambos)
				_cTpOper := SF4->F4_XESTADO
				
				If _cTpOper=="F" // fora do estado
					_cMensF := AllTrim(FORMULA(_cMensGrpF))
					If !Empty(_cMensF) .And. !AllTrim(_cMensF) $ xFil_Mens
						If !Empty(xFil_Mens)
							xFil_Mens += " / "
						EndIf
						xFil_Mens += AllTrim(_cMensF)
					EndIf
				Else
					_cMensD := AllTrim(FORMULA(_cMensGrpD))
					If !Empty(_cMensD) .And. !AllTrim(_cMensD) $ xFil_Mens
						If !Empty(xFil_Mens)
							xFil_Mens += " / "
						EndIf
						xFil_Mens += AllTrim(_cMensD)
					EndIf
				Endif
			Else
				_cMensTes:= ""
				If SF4->F4_XESTADO$"D"
					If (!AllTrim(Formula("F01")) $ _cMensTes) .and. (!Empty(Formula("F01")))   // Empty - Acrescentado por Valdemir José 07/02/13
						_cMensTes	+= Formula("F01")
					Endif
				Elseif SF4->F4_XESTADO$"F"
					If (!AllTrim(Formula("F02")) $ _cMensTes)  .and. (!Empty(Formula("F02")))   // Empty - Acrescentado por Valdemir José 07/02/13
						_cMensTes	+= Formula("F02")
					Endif
				Else
					If (!AllTrim(SF4->(Formula(F4_FORMULA))) $ _cMensTes).and. (!Empty(SF4->F4_FORMULA))   // Empty - Acrescentado por Valdemir José 07/02/13
						_cMensTes	+= Formula(SF4->F4_FORMULA)
					Endif
				Endif
				
				If !Empty(_cMensTes) .And. !AllTrim(_cMensTes) $ xFil_Mens
					If !Empty(xFil_Mens)
						xFil_Mens += " / "
					EndIf
					xFil_Mens += AllTrim(_cMensTes)
				EndIf
				
				_cMensTes := Formula(SF4->F4_XFORMU2)
				If !Empty(_cMensTes) .And. !AllTrim(_cMensTes) $ xFil_Mens
					If !Empty(xFil_Mens)
						xFil_Mens += " / "
					EndIf
					xFil_Mens += AllTrim(_cMensTes)
				EndIf
				
			Endif
			
			DbSelectArea("SD2")
			Dbskip()
		EndDo
		
		DbSelectArea("SB5")                     // * Desc. Cientifica do produto
		DbSetOrder(1)
		// Mensagens por Produto
		xCEME :={}                         // Descricao do Produto
		I:=1
		For I:=1 to Len(xCOD_PRO)
			If  SB5->(dbSeek(xFilial("SB5")+xCOD_PRO[I])) 	// .and. XTIPO=="D"
				Aadd(xCEME , {SB5->B5_XDESCR1+SB5->B5_XDESCR2+SB5->B5_XDESCR3+SB5->B5_XDESCR4+SB5->B5_XDESCR5+SB5->B5_XDESCR6+SB5->B5_XDESCR7, SB5->B5_COD})
			Else
				Aadd(xCEME , {"@#$", ""})
			EndIf
		Next
		
		dbSelectArea("SB1")                     // * Desc. Generica do Produto
		dbSetOrder(1)
		
		xPESO_PRO	:={}                        // Peso Liquido
		xPESO_BRU	:={}                        // Peso Bruto
		xPESO_UNIT	:={}                        // Peso Unitario do Produto
		xDESCRICAO	:={}                        // Descricao do Produto
		xUNID_PRO	:={}                        // Unidade do Produto
		xCOD_TRIB	:={}                        // Codigo de Tributacao
		xMEN_TRIB	:={}                        // Mensagens de Tributacao
		xCOD_FIS	:={}                        // Cogigo Fiscal
		xCLAS_FIS	:={}                        // Classificacao Fiscal
		xMEN_POS	:={}                        // Mensagem da Posicao IPI
		xISS		:={}                        // Aliquota de ISS
		xTIPO_PRO	:={}                        // Tipo do Produto
		xLUCRO		:={}                        // Margem de Lucro p/ ICMS Solidario
		xCLFISCAL	:={}                        // Variavel p/utilizacai Classificacao fiscal
		xPROD_RISC	:={}                        // Codigo do Risco para Seguro
		xPROD_ONU	:={}                        // Codigo ONU
		xPESO_LIQ	:= 0                        // Variavel p/utilizacao Calculo Peso Liquido
		xPESO_BRU1	:= 0                        // Variavel p/utilizacao Calculo Peso Bruto
		xVOLUME		:= 0                        // Volume da Nota Fiscal
		I:=1
		
		For I:=1 to Len(xCOD_PRO)
			dbSeek(xFilial()+xCOD_PRO[I])
			
			xVOLUME     := xVOLUME + (xQTD_PRO[I] / SB1->B1_QE)
			AADD(xPESO_UNIT , SB1->B1_PESO)
			AADD(xUNID_PRO ,SB1->B1_UM)
			AADD(xDESCRICAO ,SB1->B1_DESC)
			AADD(xCOD_TRIB ,SUBS(SB1->B1_ORIGEM,1,1))
			AADD(xPROD_RISC , '')
			AADD(xPROD_ONU , '')
			AADD(xCLAS_FIS ,SB1->B1_POSIPI)
			
			If Ascan(xMEN_TRIB, SB1->B1_ORIGEM)==0
				AADD(xMEN_TRIB ,SB1->B1_ORIGEM)
			Endif
			
			If SB1->B1_ALIQISS > 0
				AADD(xISS ,SB1->B1_ALIQISS)
			Endif
			
			AADD(xTIPO_PRO ,SB1->B1_TIPO)
			AADD(xLUCRO    ,SB1->B1_PICMRET)
			
			// Calculo do Peso Liquido e Bruto da Nota Fiscal
			xPESO_LIQUID:=0                                 // Peso Liquido da Nota Fiscal
			For j:=1 to Len(xPESO_PRO)
				xPESO_LIQUID:=xPESO_LIQUID+xPESO_PRO[j]
			Next
			
			xPESO_BRUTO :=0                                 // Peso Bruto   da Nota Fiscal
			For j:=1 to Len(xPESO_BRU)
				xPESO_BRUTO:=xPESO_BRUTO+xPESO_BRU[j]
			Next
		Next
		
		nLen := Len(xCF)+1
		DO WHILE nLen  < 5
			AADD(xCF ,"   ")
			AADD(xNATUREZA,"                    ")
			nLen:= nLen + 1
		Enddo
		
		dbSelectArea("SC5")                            // * Pedidos de Venda
		dbSetOrder(1)
		
		xPED        := {}
		xP_BRUTO := 0
		xP_LIQ_PED  := 0
		
		For I:=1 to Len(xPED_VEND)
			dbSeek(xFilial()+xPED_VEND[I])
			
			If ASCAN(xPED,xPED_VEND[I])==0
				dbSeek(xFilial()+xPED_VEND[I])
				cPrePed     :=SC5->C5_PRENUM
				cPedSFA     :=Posicione("SZ2",1,xFilial("SZ2")+cPrePed,"Z2_NUMSFA")
				xPEDIDO     :=SC5->C5_NUM                // Numero do Pedido
				xCLIENTE    :=SC5->C5_CLIENTE            // Codigo do Cliente
				xTIPO_CLI   :=SC5->C5_TIPOCLI            // Tipo de Cliente
				xCOD_MENS   :=SC5->C5_MENPAD             // Codigo da Mensagem Padrao
				xMENSAGEM1  :=SC5->C5_MENNOTA            // Mensagem para a Nota Fiscal
				xMENSAGEM2  :=SC5->C5_MENNOT1            // Mensagem para a Nota Fiscal Especifica
			Endif
			xCOD_MENS 	:=SC5->C5_MENPAD             // Codigo da Mensagem Padrao
			xTPFRETE    :=SC5->C5_TPFRETE            	// Tipo de Entrega
			xCONDPAG    :=SC5->C5_CONDPAG            	// Condicao de Pagamento
			xCliEntreg	:=SC5->C5_CLIENT             	// Cliente de entrega
			xLjEntreg   :=SC5->C5_LOJAENT            	// Loja de entrega
			xP_LIQ_PED  :=xP_LIQ_PED + SC5->C5_PESOL 	// Peso Liquido
			xP_BRUTO :=SC5->C5_PBRUTO                	// Peso Bruto CASO SEJA INFORMADO O PESO BRUTO DO PEDIDO NAO CONSIDERAR CALCULO DO SISTEMA
			xCOD_VEND:= {SC5->C5_VEND1,;             	// Codigo do Vendedor 1
			SC5->C5_VEND2,;             				// Codigo do Vendedor 2
			SC5->C5_VEND3,;             				// Codigo do Vendedor 3
			SC5->C5_VEND4,;             				// Codigo do Vendedor 4
			SC5->C5_VEND5}              				// Codigo do Vendedor 5
			xDESC_NF := {SC5->C5_DESC1,;             	// Desconto Global 1
			SC5->C5_DESC2,;             				// Desconto Global 2
			SC5->C5_DESC3,;             				// Desconto Global 3
			SC5->C5_DESC4}              				// Desconto Global 4
			xParc_PV := {SC5->C5_PARC1,;
			SC5->C5_PARC2,;
			SC5->C5_PARC3,;
			SC5->C5_PARC4}
			AADD(xPED,xPED_VEND[I])
			
			If xP_LIQ_PED >0
				xPESO_LIQ := xP_LIQ_PED
			Endif
			If xP_BRUTO >0
				xPESO_BRUTO := xP_BRUTO
			Endif
		Next
		
		//+---------------------------------------------+
		//¦ Pesquisa da Condicao de Pagto               ¦
		//+---------------------------------------------+
		dbSelectArea("SE4")                    // Condicao de Pagamento
		dbSetOrder(1)
		dbSeek(xFilial("SE4")+xCONDPAG)
		xDESC_PAG := SE4->E4_DESCRI
		dbSelectArea("SC6")                    // * Itens de Pedido de Venda
		dbSetOrder(1)
		xPED_CLI :={}                          // Numero de Pedido
		xDESC_PRO:={}                          // Descricao aux do produto
		J:=Len(xPED_VEND)
		
		For I:=1 to J
			dbSeek(xFilial()+xPED_VEND[I]+xITEM_PED[I])
			AADD(xPED_CLI ,SC6->C6_PEDCLI)
			AADD(xDESC_PRO,SC6->C6_DESCRI)
			AADD(xVAL_DESC,SC6->C6_VALDESC)
		Next
		
		If xTIPO=='N' .OR. xTIPO=='C' .OR. xTIPO=='P' .OR. xTIPO=='I' .OR. xTIPO=='S' .OR. xTIPO=='T' .OR. xTIPO=='O'
			dbSelectArea("SA1")                // * Cadastro de Clientes
			dbSetOrder(1)
			dbSeek(xFilial()+xCLIENTE+xLOJA)
			xCOD_CLI :=SA1->A1_COD             	// Codigo do Cliente
			xLJ_CLI  :=SA1->A1_LOJA            	// Loja do Cliente
			xNOME_CLI:=SA1->A1_NOME            	// Nome
			xEND_CLI :=ALLTRIM(SA1->A1_END)+" "+ALLTRIM(SA1->A1_XCOMPLE)	// Endereco
			xBAIRRO  :=SA1->A1_BAIRRO          	// Bairro
			xCEP_CLI :=SA1->A1_CEP             	// CEP
			xCOB_CLI :=SA1->A1_ENDCOB          	// Endereco de Cobranca
			xREC_CLI :=SA1->A1_ENDENT          	// Endereco de Entrega
			xMUN_CLI :=SA1->A1_MUN             	// Municipio
			xEST_CLI :=SA1->A1_EST             	// Estado
			xCGC_CLI :=SA1->A1_CGC             	// CGC
			IF !EMPTY(SA1->A1_INSCR)
				xINSC_CLI:=SA1->A1_INSCR     	// Inscricao estadual
			ELSE
				IF LEN(RTRIM(xCGC_CLI))==14
					xINSC_CLI :="ISENTO"
				ELSE
					xINSC_CLI:=SA1->A1_INSCR  	//SA1->A1_XRGCLI
				ENDIF
			ENDIF
			xTEL_CLI :=SA1->A1_TEL             	// Telefone
			xFAX_CLI :=SA1->A1_FAX             	// Fax
			xSUFRAMA :=SA1->A1_SUFRAMA      	// Codigo Suframa
			xCALCSUF :=SA1->A1_CALCSUF        	// Calcula Suframa
			xLOCDESC :=If(SA1->A1_TIPO$'FL',SA1->A1_XDESCAR,'')
			
			// Alteracao p/ Calculo de Suframa
			If !empty(xSUFRAMA) .and. xCALCSUF =="S"
				If XTIPO == 'D' .OR. XTIPO == 'B'
					zFranca := .F.
				Else
					zFranca := .T.
				Endif
			Else
				zfranca:= .F.
			Endif
			
		Else
			zFranca:=.F.
			dbSelectArea("SA2")                // * Cadastro de Fornecedores
			dbSetOrder(1)
			dbSeek(xFilial()+xCLIENTE+xLOJA)
			xCOD_CLI :=SA2->A2_COD             // Codigo do Fornecedor
			xLJ_CLI  :=SA2->A2_LOJA            // Loja do Fornecedor
			xNOME_CLI:=SA2->A2_NOME            // Nome Fornecedor
			xEND_CLI :=SA2->A2_END             // Endereco
			xBAIRRO  :=SA2->A2_BAIRRO          // Bairro
			xCEP_CLI :=SA2->A2_CEP             // CEP
			xCOB_CLI :=""                      // Endereco de Cobranca
			xREC_CLI :=""                      // Endereco de Entrega
			xMUN_CLI :=SA2->A2_MUN             // Municipio
			xEST_CLI :=SA2->A2_EST             // Estado
			xCGC_CLI :=SA2->A2_CGC             // CGC
			xINSC_CLI:=SA2->A2_INSCR           // Inscricao estadual
			If EMPTY(xTRAN_CLI)               	// Se C.G.C. Transportador nao for Vazio
				xTRAN_CLI:=SA2->A2_TRANSP          // Transportadora
			ENDIF
			xTEL_CLI :=SA2->A2_TEL             // Telefone
			xFAX_CLI :=SA2->A2_FAX             // Fax
		Endif
		dbSelectArea("SA3")                   // * Cadastro de Vendedores
		dbSetOrder(1)
		xVENDEDOR:={}                         // Codigo do vendedor
		I:=1
		J:=Len(xCOD_VEND)
		For I:=1 to J
			dbSeek(xFilial()+xCOD_VEND[I])
			Aadd(xVENDEDOR,SA3->A3_COD)
		Next
		
		If xICMS_RET >0                          // Apenas se ICMS Retido > 0
			dbSelectArea("SF3")                   // * Cadastro de Livros Fiscais
			dbSetOrder(4)
			dbSeek(xFilial()+SA1->A1_COD+SA1->A1_LOJA+SF2->F2_DOC+SF2->F2_SERIE)
			If Found()
				xBSICMRET:=F3_VALOBSE
			Else
				xBSICMRET:=0
			Endif
		Else
			xBSICMRET:=0
		Endif
		
		dbSelectArea("SA4")                   // * Transportadoras
		dbSetOrder(1)
		dbSeek(xFilial()+xTRAN_CLI)
		xNOME_TRANSP :=SA4->A4_NOME           // Nome Transportadora
		xEND_TRANSP  :=SA4->A4_END            // Endereco
		xMUN_TRANSP  :=SA4->A4_MUN            // Municipio
		xEST_TRANSP  :=SA4->A4_EST            // Estado
		xVIA_TRANSP  :=SA4->A4_VIA            // Via de Transporte
		xCGC_TRANSP  :=SA4->A4_CGC            // CGC
		xTEL_TRANSP  :=SA4->A4_TEL            // Fone
		
		dbSelectArea("SE1")                   // * Contas a Receber
		dbSetOrder(1)
		xPARC_DUP  :={}                       // Parcela
		xVENC_DUP  :={}                       // Vencimento
		xVALOR_DUP :={}                       // Valor
		xDESC_DUP  :={}
		xDUPLICATAS:=IIF(dbSeek(xFilial("SE1")+xPREFIXO+xNUM_DUPLIC,.T.),.T.,.F.) // Flag p/Impressao de Duplicatas
		
		While !eof() .and. SE1->E1_NUM==xNUM_DUPLIC .and. xDUPLICATAS==.T.
			If !("NF" $ SE1->E1_TIPO)
				dbSkip()
				Loop
			Endif
			AADD(xPARC_DUP ,SE1->E1_PARCELA)
			AADD(xVENC_DUP ,SE1->E1_VENCTO)
			AADD(xVALOR_DUP,SE1->E1_VLCRUZ)
			AADD(xDESC_DUP ,SE1->E1_DESCFIN)
			dbSkip()
		EndDo
		
		Imprime()
		
		//+--------------------------------------------------------------+
		//¦ Termino da Impressao da Nota Fiscal                          ¦
		//+--------------------------------------------------------------+
		IncRegua()                    // Termometro de Impressao
		
		nLin:=0
		dbSelectArea("SF2")
		dbSkip()                      // passa para a proxima Nota Fiscal
	EndDo
	
	// Nota Fiscal de Entrada
Else
	
	DbSelectArea("SF1")              // * Cabecalho da Nota Fiscal Entrada
	DbSetOrder(1)
	//DbSeek(xFilial("SF1")+mv_par01+mv_par03, .F.)
	While !eof() .and. SF1->F1_DOC <= mv_par02 .and. lContinua //.and. SF1->F1_SERIE == mv_par03
		
		// Se a Serie do Arquivo for Diferente do Parametro Informado ou nao for formulario proprio!!!
		If AllTrim(SF1->F1_SERIE) != AllTrim(mv_par03) .OR. SF1->F1_FILIAL <> xFilial("SF1")
			DbSkip()
			Loop
		Endif
		
		//+-----------------------------------------------------------+
		//¦ Inicializa  regua de impressao                            ¦
		//+-----------------------------------------------------------+
		SetRegua(Val(mv_par02)-Val(mv_par01))
		
		IF lAbortPrint
			@ 00,01 PSAY "** CANCELADO PELO OPERADOR **"
			lContinua := .F.
			Exit
		Endif
		
		nLinIni:=nLin                         // Linha Inicial da Impressao
		
		//+--------------------------------------------------------------+
		//¦ Inicio de Levantamento dos Dados da Nota Fiscal              ¦
		//+--------------------------------------------------------------+
		
		aNatOper    := {}                     // Zera TES dos Itens
		cNFOri      :=""                      // Zera NF Origem
		cPrePed     :=""
		cPedSFA     :=""
		xNUM_NF     :=SF1->F1_DOC             // Numero
		xSERIE      :=SF1->F1_SERIE           // Serie
		xFORNECE    :=SF1->F1_FORNECE         // Cliente/Fornecedor
		xEMISSAO    :=SF1->F1_EMISSAO         // Data de Emissao
		xTOT_FAT    :=SF1->F1_VALBRUT         // Valor Bruto da Compra
		xLOJA       :=SF1->F1_LOJA            // Loja do Cliente
		xFRETE      :=SF1->F1_FRETE           // Frete
		xSEGURO     :=SF1->F1_DESPESA         // Despesa
		xBASE_ICMS  :=SF1->F1_BASEICM         // Base   do ICMS
		xBASE_IPI   :=SF1->F1_BASEIPI         // Base   do IPI
		xBSICMRET   :=SF1->F1_BRICMS          // Base do ICMS Retido
		xVALOR_ICMS :=SF1->F1_VALICM          // Valor  do ICMS
		xICMS_RET   :=SF1->F1_ICMSRET         // Valor  do ICMS Retido
		xVALOR_IPI  :=SF1->F1_VALIPI          // Valor  do IPI
		xVALOR_MERC :=SF1->F1_VALMERC         // Valor  da Mercadoria
		xNUM_DUPLIC :=SF1->F1_DUPL            // Numero da Duplicata
		xCOND_PAG   :=SF1->F1_COND            // Condicao de Pagamento
		xTIPO       :=SF1->F1_TIPO            // Tipo do Cliente
		
		xHawb		:= AllTrim(SF1->F1_HAWB)
		_lAcumBrut  := xTOT_FAT == 0 		  // Indica se o valor da nota devera ser acumulado pelo SD1
		_lAcumMerc  := xVALOR_MERC == 0 	  // Indica se o valor da mercadoria devera ser acumulado pelo SD1
		xTRAN_CLI	:= SF1->F1_XTRANSP
		
		dbSelectArea("SA4")                   // * Transportadoras
		dbSetOrder(1)
		dbSeek(xFilial()+xTRAN_CLI)
		xNOME_TRANSP :=SA4->A4_NOME           // Nome Transportadora
		xEND_TRANSP  :=SA4->A4_END            // Endereco
		xMUN_TRANSP  :=SA4->A4_MUN            // Municipio
		xEST_TRANSP  :=SA4->A4_EST            // Estado
		xVIA_TRANSP  :=SA4->A4_VIA            // Via de Transporte
		xCGC_TRANSP  :=SA4->A4_CGC            // CGC
		xTEL_TRANSP  :=SA4->A4_TEL            // Fone
		
		DbSelectArea("SD1")                   // * Itens da N.F. de Compra
		DbSetOrder(1)
		DbSeek(xFilial()+xNUM_NF+xSERIE+xFORNECE+xLOJA)
		
		xNFORI      := SD1->D1_NFORI          // NF Original
		xPREF_DV    := SD1->D1_SERIORI        // Serie Original
		cPedAtu   	:= SD1->D1_PEDIDO
		cItemAtu  	:= SD1->D1_ITEMPC
		
		xPEDIDO   	:={}                         // Numero do Pedido de Compra
		xITEM_PED 	:={}                         // Numero do Item do Pedido de Compra
		xNUM_NFDV 	:={}                         // Numero quando houver devolucao
		xPREF_DV  	:={}                         // Serie  quando houver devolucao
		xICMS     	:={}                         // Porcentagem do ICMS
		xCOD_PRO  	:={}                         // Codigo  do Produto
		xQTD_PRO  	:={}                         // Peso/Quantidade do Produto
		xPRE_UNI  	:={}                         // Preco Unitario de Compra
		xIPI      	:={}                         // Porcentagem do IPI
		xPESOPROD 	:={}                         // Peso do Produto
		xPESO_LIQ 	:= 0
		xPESO_BRU1	:= 0                         // Variavel p/utilizacao Calculo Peso Bruto
		xVAL_IPI  	:={}                         // Valor do IPI
		xDESC     	:={}                         // Desconto por Item
		xVAL_DESC 	:={}                         // Valor do Desconto
		xVAL_MERC 	:={}                         // Valor da Mercadoria
		xVOLUME   	:= 0                         // Volume da Nota Fiscal
		xTES      	:={}                         // TES
		xCF       	:={}                         // Classificacao quanto natureza da Operacao
		xNATUREZA 	:={}                         // NATUREZA DA OPERACAO
		xSIT      	:={}                         // SEGUNDO DIGITO SITUACAO TRIB
		xICMSOL   	:={}                         // Base do ICMS Solidario
		xICM_PROD 	:={}                         // ICMS do Produto
		xDESCRICAO	:={}                         // Descricao do Produto
		xLOTE     	:={}                         // Numero do Lote
		xVALID	  	:={}                         // Validade do Lote
		
		While !eof() .and. SD1->D1_DOC==xNUM_NF
			If AllTrim(SD1->D1_SERIE) != AllTrim(mv_par03)        // Se a Serie do Arquivo for Diferente
				DbSkip()                      // do Parametro Informado !!!
				Loop                          // Quando for nota fiscal de importacao
			Endif                             // nao estranhe imprime somente 1 item
			If _lAcumBrut
				xTOT_FAT += SD1->D1_TOTAL+SD1->D1_VALIPI+SD1->D1_VALDESC
			Endif
			
			If _lAcumMerc
				xVALOR_MERC += SD1->D1_TOTAL+SD1->D1_VALDESC
			Endif
			
			AADD(xPEDIDO ,SD1->D1_PEDIDO)           // Ordem de Compra
			AADD(xITEM_PED ,SD1->D1_ITEMPC)         // Item da O.C.
			AADD(xNUM_NFDV ,IIF(Empty(SD1->D1_NFORI),"",SD1->D1_NFORI))
			AADD(xPREF_DV  ,SD1->D1_SERIORI)        // Serie Original
			AADD(xICMS     ,IIf(Empty(SD1->D1_PICM),0,SD1->D1_PICM))
			AADD(xCOD_PRO  ,SD1->D1_COD)            // Produto
			
			AADD(xLOTE     ,SD1->D1_LOTECTL)		// Dados do lote
			AADD(XVALID    ,SD1->D1_DTVALID)		// Validade do lote
			
			AADD(xQTD_PRO  ,SD1->D1_QUANT)          // Guarda as quant. da NF
			AADD(xPRE_UNI  ,SD1->D1_VUNIT)          // Valor Unitario
			AADD(xIPI      ,SD1->D1_IPI)            // % IPI
			AADD(xVAL_IPI  ,SD1->D1_VALIPI)         // Valor do IPI
			AADD(xPESOPROD ,SD1->D1_PESO)           // Peso do Produto
			AADD(xDESC     ,SD1->D1_DESC)           // % Desconto
			AADD(xVAL_MERC ,SD1->D1_TOTAL)          // Valor Total
			AADD(xTES      ,SD1->D1_TES)            // Tipo de Entrada/Saida
			AADD(xCF       ,SD1->D1_CF)             // Codigo Fiscal
			AADD(xICM_PROD ,IIf(Empty(SD1->D1_PICM),0,SD1->D1_PICM))
			
			DbSelectArea("SF4")
			DbSeek(xFilial()+SD1->D1_TES)
			AADD(xNATUREZA ,SF4->F4_TEXTO)
			Aadd(xSIT      ,SF4->F4_SITTRIB)
			Aadd(xCF       ,SD1->D1_CF)
			
			xCOD_MENS := SF4->F4_FORMULA
			cNatureza := fGroupTES(@aNatOper,SD1->D1_TES,IIf(!SD1->D1_TIPO$"IP",SD1->D1_TOTAL,0))
			
			DbSelectArea("SD1")
			Dbskip()
		End
		
		nLen := Len(xCF)+1
		Do While nLen  < 5
			AADD(xCF ,"   ")
			AADD(xNATUREZA,"                    ")
			nLen:= nLen + 1
		Enddo
		
		DbSelectArea("SB1")                     // * Desc. Generica do Produto
		DbSetOrder(1)
		xPROD_RISC	:={}                        // Codigo do Risco para Seguro
		xPROD_ONU 	:={}                        // Codigo ONU
		xPESO_PRO	:={}                        // Peso Liquido
		xPESO_BRU	:={}                        // Peso Liquido
		xPESO_UNIT 	:={}                        // Peso Unitario do Produto
		xUNID_PRO	:={}                        // Unidade do Produto
		xDESC_PRO	:={}                        // Descricao do Produto
		xMEN_POS 	:={}                        // Mensagem da Posicao IPI
		xCOD_TRIB	:={}                        // Codigo de Tributacao
		xMEN_TRIB	:={}                        // Mensagens de Tributacao
		xCOD_FIS 	:={}                        // Cogigo Fiscal
		xCLAS_FIS	:={}                        // Classificacao Fiscal
		xISS     	:={}                        // Aliquota de ISS
		xTIPO_PRO	:={}                        // Tipo do Produto
		xLUCRO   	:={}                        // Margem de Lucro p/ ICMS Solidario
		xCLFISCAL   :={}
		xSUFRAMA :=""
		xCALCSUF :=""
		
		xCEME :={}                         // Descricao do Produto
		I:=1
		
		For I:=1 to Len(xCOD_PRO)
			
			If SB5->(  dbSeek(xFilial("SB5")+xCOD_PRO[I])  ) // .and. XTIPO=="D"
				AADD(xCEME, {TRIM(SB5->B5_XDESCR1)+" "+TRIM(SB5->B5_XDESCR2)+" "+TRIM(SB5->B5_XDESCR3)+" "+TRIM(SB5->B5_XDESCR4)+" "+TRIM(SB5->B5_XDESCR5)+" "+TRIM(SB5->B5_XDESCR6)+" "+TRIM(SB5->B5_XDESCR7), SB5->B5_COD} )
			Else
				AADD(xCEME, {"@#$", ""})
			EndIf
			
		Next
		
		I:=1
		For I:=1 to Len(xCOD_PRO)
			
			dbSeek(xFilial()+xCOD_PRO[I])
			dbSelectArea("SB1")
			
			// Volume da Nota Fiscal
			xVOLUME     := 0
			
			AADD(xDESCRICAO ,SB1->B1_DESC)  // por nota.
			AADD(xPESO_UNIT , SB1->B1_PESO)
			AADD(xUNID_PRO ,SB1->B1_UM)
			AADD(xCOD_TRIB ,SUBS(SB1->B1_ORIGEM,1,1))
			AADD(xPROD_RISC , '')
			AADD(xPROD_ONU ,  '')
			AADD(xCLAS_FIS ,SB1->B1_POSIPI)
			
			
			If Ascan(xMEN_TRIB, SB1->B1_ORIGEM)==0
				AADD(xMEN_TRIB ,SB1->B1_ORIGEM)
			Endif
			
			If SB1->B1_ALIQISS > 0
				AADD(xISS,SB1->B1_ALIQISS)
			Endif
			AADD(xTIPO_PRO ,SB1->B1_TIPO)
			AADD(xLUCRO    ,SB1->B1_PICMRET)
		Next
		
		//+---------------------------------------------+
		//¦ Pesquisa da Condicao de Pagto               ¦
		//+---------------------------------------------+
		
		DbSelectArea("SE4")                    // Condicao de Pagamento
		DbSetOrder(1)
		DbSeek(xFilial("SE4")+xCOND_PAG)
		xDESC_PAG := SE4->E4_DESCRI
		
		If xTIPO == "D"
			
			dbSelectArea("SA1")                	// * Cadastro de Clientes
			dbSetOrder(1)
			dbSeek(xFilial()+xFORNECE+xLOJA)
			xCOD_CLI :=SA1->A1_COD             	// Codigo do Cliente
			xLJ_CLI :=SA1->A1_LOJA            	// Loja do Cliente
			xNOME_CLI:=SA1->A1_NOME            	// Nome
			xEND_CLI :=If(Empty(SA1->A1_ENDENT),ALLTRIM(SA1->A1_END)+" "+ALLTRIM(SA1->A1_XCOMPLE),SA1->A1_ENDENT)             // Endereco
			xBAIRRO  :=SA1->A1_BAIRRO          	// Bairro
			xCEP_CLI :=SA1->A1_CEP             	// CEP
			xCOB_CLI :=SA1->A1_ENDCOB          	// Endereco de Cobranca
			xREC_CLI :=SA1->A1_ENDENT          	// Endereco de Entrega
			xMUN_CLI :=SA1->A1_MUN             	// Municipio
			xEST_CLI :=SA1->A1_EST             	// Estado
			xCGC_CLI :=SA1->A1_CGC             	// CGC
			IF !EMPTY(SA1->A1_INSCR)
				xINSC_CLI:=SA1->A1_INSCR        // Inscricao estadual
			ELSE
				IF LEN(RTRIM(xCGC_CLI))==14
					xINSC_CLI :="ISENTO"
				ELSE
					xINSC_CLI:=SA1->A1_RGCLI
				ENDIF
			ENDIF
			If EMPTY(xTRAN_CLI)               // Se C.G.C. Transportador nao for Vazio
				xTRAN_CLI:=SA1->A1_TRANSP          // Transportadora
			ENDIF
			xTEL_CLI :=SA1->A1_TEL             // Telefone
			xFAX_CLI :=SA1->A1_FAX             // Fax
			xTipo :=SA1->A1_TIPO               // Tipo
		Else
			
			dbSelectArea("SA2")                // * Cadastro de Fornecedores
			dbSetOrder(1)
			dbSeek(xFilial()+xFORNECE+xLOJA)
			xCOD_CLI :=SA2->A2_COD                // Codigo do Cliente
			xLJ_CLI :=SA2->A2_LOJA                // Loja do Cliente
			xNOME_CLI:=SA2->A2_NOME               // Nome
			xEND_CLI :=SA2->A2_END                // Endereco
			xBAIRRO  :=SA2->A2_BAIRRO             // Bairro
			xCEP_CLI :=SA2->A2_CEP                // CEP
			xCOB_CLI :=""                         // Endereco de Cobranca
			xREC_CLI :=""                         // Endereco de Entrega
			xMUN_CLI :=SA2->A2_MUN                // Municipio
			xEST_CLI :=SA2->A2_EST                // Estado
			xCGC_CLI :=SA2->A2_CGC                // CGC
			xINSC_CLI:=SA2->A2_INSCR              // Inscricao estadual
			If EMPTY(xTRAN_CLI)               // Se C.G.C. Transportador nao for Vazio
				xTRAN_CLI:=SA2->A2_TRANSP          // Transportadora
			ENDIF
			xTEL_CLI :=SA2->A2_TEL                // Telefone
			xFAX     :=SA2->A2_FAX                // Fax
			
		EndIf
		dbSelectArea("SA4")                   // * Transportadoras
		dbSetOrder(1)
		dbSeek(xFilial()+xTRAN_CLI)
		xNOME_TRANSP :=SA4->A4_NOME           // Nome Transportadora
		xEND_TRANSP  :=SA4->A4_END            // Endereco
		xMUN_TRANSP  :=SA4->A4_MUN            // Municipio
		xEST_TRANSP  :=SA4->A4_EST            // Estado
		xVIA_TRANSP  :=SA4->A4_VIA            // Via de Transporte
		xCGC_TRANSP  :=SA4->A4_CGC            // CGC
		xTEL_TRANSP  :=SA4->A4_TEL            // Fone
		dbSelectArea("SE1")          // * Contas a Receber
		dbSetOrder(1)
		xPARC_DUP  :={}              // Parcela
		xVENC_DUP  :={}              // Vencimento
		xVALOR_DUP :={}              // Valor
		xDESC_DUP  :={}
		
		Imprime()
		//+--------------------------------------------------------------+
		//¦ Termino da Impressao da Nota Fiscal                          ¦
		//+--------------------------------------------------------------+
		
		IncRegua()                    // Termometro de Impressao
		
		nLin:=0
		dbSelectArea("SF1")
		dbSkip()                     // e passa para a proxima Nota Fiscal
		
	EndDo
Endif
//+--------------------------------------------------------------+
//¦                                                              ¦
//¦                      FIM DA IMPRESSAO                        ¦
//¦                                                              ¦
//+--------------------------------------------------------------+

//+--------------------------------------------------------------+
//¦ Fechamento do Programa da Nota Fiscal                        ¦
//+--------------------------------------------------------------+

dbSelectArea("SF2")
Retindex("SF2")
dbSelectArea("SF1")
Retindex("SF1")
dbSelectArea("SD2")
Retindex("SD2")
dbSelectArea("SD1")
Retindex("SD1")
Set Device To Screen

If aReturn[5] == 1
	Set Printer TO
	dbcommitAll()
	ourspool(wnrel)
Endif
Eject
MS_FLUSH()

Return()

/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦ VERIMP   ¦ Autor ¦   Marcos Simidu       ¦ Data ¦ 20/12/95 ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Verifica posicionamento de papel na Impressora             ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ Espelho NF                                                 ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/

Static Function VerImp()

nLin:= 0                // Contador de Linhas
nLinIni:=0
_lNota := .f.

If aReturn[5]==2
	
	nOpc       := 1
	#IFNDEF WINDOWS
		cCor       := "B/BG"
	#ENDIF
	While .T.
		
		SetPrc(0,0)
		dbCommitAll()
		
		@ nLin ,000 PSAY " "
		@ nLin ,004 PSAY "*"
		@ nLin ,022 PSAY "."
		#IFNDEF WINDOWS
			Set Device to Screen
			DrawAdvWindow(" Formulario ",10,25,14,56)
			SetColor(cCor)
			@ 12,27 Say "Formulario esta posicionado?"
			nOpc:=Menuh({"Sim","Nao","Cancela Impressao"},14,26,"b/w,w+/n,r/w","SNC","",1)
			Set Device to Print
		#ELSE
			IF MsgYesNo("Fomulario esta posicionado ? ")
				if alltrim(cusername) == "Administrador"
					_lNota := MsgYesNo("Nota em Fomulario próprio ? ")
				Endif
				nOpc := 1
			ElseIF MsgYesNo("Tenta Novamente ? ")
				nOpc := 2
			Else
				nOpc := 3
			Endif
		#ENDIF
		
		Do Case
			Case nOpc==1
				lContinua:=.T.
				Exit
			Case nOpc==2
				Loop
			Case nOpc==3
				lContinua:=.F.
				Return
		EndCase
	End
Endif

Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³QUEBRALINHº Autor ³ AP5 IDE            º Data ³  20/01/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Quebra uma string em um array com as linhas do tamanho     º±±
±±º          ³ especificado                                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
static function QuebraLinha(_cTexto,_nTamanho)

local _aRet := {}
local _nContaFor := 0
local _nLines := mlcount(_cTexto,_nTamanho)

for _nContaFor := 1 to _nLines
	if !empty(alltrim(memoline(_cTexto,_nTamanho,_nContaFor)))
		aadd(_aRet,memoline(_cTexto,_nTamanho,_nContaFor))
	endif
next _nContaFor

return(_aRet)

/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçào    ¦ IMPRIME  ¦ Autor ¦   Marcos Simidu       ¦ Data ¦ 20/12/95 ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Imprime a Nota Fiscal de Entrada e de Saida                ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ Generico RDMAKE                                            ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/

Static Function Imprime()
Local I:=1
Local J:=1
local _cEndEnt 	:= ""
local _aEndEnt 	:= {}
local _nCont 	:= 0

_cAdic 	:= {}
nLin 	:= 00

If mv_par04 == 2 .and. 	!(xTipo$"DB")
	SA1->(dbsetorder(1)) // A1_FILIAL + A1_COD + A1_LOJA
	
	If SA1->(dbseek(xFilial("SA1")+xCliente+xLoja))
		If Empty(xCliEntreg) .and. Empty(xLjEntreg)
			
			aadd(_cAdic, Space(60))
			
			_cEndEnt := "LOCAL DE ENTREGA: "
			_cEndEnt += alltrim(SA1->A1_NOME) 		+ " - "
			_cEndEnt += alltrim(SA1->A1_ENDENT)		+ " - "
			_cEndEnt += alltrim(SA1->A1_XCOMPLI)	+ " - "
			_cEndEnt += alltrim(SA1->A1_XREF1)  	+ " - "
			_cEndEnt += alltrim(SA1->A1_XREF2)  	+ " - "
			_cEndEnt += alltrim(SA1->A1_BAIRROE) 	+ " - "
			_cEndEnt += alltrim(SA1->A1_MUNE) 		+ "-"
			_cEndEnt += alltrim(SA1->A1_EST) 		+ " "
			_cEndEnt += "FONE: " + alltrim(SA1->A1_TEL)
			_aEndEnt := QuebraLinha(_cEndEnt , 50)
			
			for _nCont := 1 to len(_aEndEnt)
				aadd( _cAdic , _aEndEnt[_nCont] )
			next _nCont
			
		ElseIf !empty(xCliEntreg) .and. !empty(xLjEntreg)
			_aAreaSA1 := GetArea("SA1")
			If SA1->(dbseek(xFilial("SA1")+xCliEntreg+xLjEntreg))
				
				aadd(_cAdic, Space(60))
				
				_cEndEnt := "LOCAL DE ENTREGA: "
				_cEndEnt += alltrim(SA1->A1_NOME) 		+ " - "
				_cEndEnt += alltrim(SA1->A1_ENDENT)		+ " - "
				_cEndEnt += alltrim(SA1->A1_XCOMPLI)	+ " - "
				_cEndEnt += alltrim(SA1->A1_XREF1)  	+ " - "
				_cEndEnt += alltrim(SA1->A1_XREF2)  	+ " - "
				_cEndEnt += alltrim(SA1->A1_BAIRROE) 	+ " - "
				_cEndEnt += alltrim(SA1->A1_MUNE) 		+ "-"
				_cEndEnt += alltrim(SA1->A1_EST) 		+ " "
				_cEndEnt += "FONE: " + alltrim(SA1->A1_TEL)
				_aEndEnt := QuebraLinha(_cEndEnt , 50)
				
				for _nCont := 1 to len(_aEndEnt)
					aadd( _cAdic , _aEndEnt[_nCont] )
				next _nCont
			Endif
			RestArea(_aAreaSA1)
		Endif
		
		If !Empty(SA1->A1_XDESCAR)
			aAreaSZ1:=GetArea()
			dbSelectArea("SZ1")
			dbsetorder(1)
			dbseek(xfilial()+SA1->A1_XDESCAR)
			_cEndDesc := "LOCAL DE DESCARTE: "
			_cEndDesc += Iif(Empty(SZ1->Z1_NOME)	,"", Alltrim(SZ1->Z1_NOME) 		+ " - ")
			_cEndDesc += Iif(Empty(SZ1->Z1_END)	,"", Alltrim(SZ1->Z1_END)		+ " - ")
			_cEndDesc += Iif(Empty(SZ1->Z1_BAIRRO)	,"", Alltrim(SZ1->Z1_BAIRRO) 	+ " - ")
			_cEndDesc += Iif(Empty(SZ1->Z1_MUN)	,"", Alltrim(SZ1->Z1_MUN) 		+ " - ")
			_cEndDesc += Iif(Empty(SZ1->Z1_EST)	,"", Alltrim(SZ1->Z1_EST) 		+ " - ")
			_cEndDesc += Iif(Empty(SZ1->Z1_CEP)	,"", "CEP : " + TRANSFORM(SZ1->Z1_CEP,"@R 99999-999")  + " - ")
			_cEndDesc += Iif(Empty(SZ1->Z1_TEL)	,"", "FONE: " + TRANSFORM(SZ1->Z1_TEL,"@R 9999-9999")  + " - ")
			_cEndDesc += Iif(Empty(SZ1->Z1_OBS)	,"", "OBS: "  + Alltrim(SZ1->Z1_OBS))
			_aEndDesc := QuebraLinha(_cEndDesc , 50)
			
			for _nCont := 1 to len(_aEndDesc)
				aadd( _cAdic , _aEndDesc[_nCont] )
			next _nCont
		Endif
	Endif
Endif

//----------------------------------------------------- Complementa Dados Adicionais
For i := len(_cAdic) + 1 to 22
	aadd(_cAdic, Space(60))
Next i

@ nLin 	, 000 PSAY Chr(15)+Chr(27)+Chr(48)
//----------------------------------------------- LINHA 01
@ nLin  , 000 PSAY " "
//----------------------------------------------- LINHA 02
@ nLin  , 202 PSAY xNUM_NF
//----------------------------------------------- LINHA 03
If mv_par04 == 2
	@ nLin+1, 177 PSAY "X"		// 148
Else
	@ nLin+1, 187 PSAY "X"		// 162
Endif

@ nLin+1, 204 PSAY xEMISSAO
@ nLin+2, 196 PSAY "Filial: " + Upper(Alltrim(SM0->M0_FILIAL))
//----------------------------------------------- LINHA 03 a 06
@ nLin+3, 000 PSAY _cAdic[01]
@ nLin+5, 000 PSAY _cAdic[02]
@ nLin+6, 000 PSAY _cAdic[03]
//----------------------------------------------- LINHA 07
@ nLin+7, 000 PSAY _cAdic[04]
//----------------------------------------------- LINHA 08
@ nLin+8, 000 PSAY _cAdic[05]
//----------------------------------------------- LINHA 09
@ nLin+9, 000 PSAY _cAdic[06]
//----------------------------------------------- LINHA 10
@ nLin+10, 000 PSAY _cAdic[07]
//----------------------------------------------- LINHA 11
@ nLin+11, 000 PSAY Space(60)
@ nLin+11, 142 PSAY iif(!EMPTY(xNATUREZA[1]),Transform(xCF[1],"@R 9.999"),"")
//----------------------------------------------- LINHA 12
@ nLin+12, 000 PSAY _cAdic[09]
//----------------------------------------------- LINHA 13
@ nLin+13, 000 PSAY _cAdic[10]
@ nLin+14, 084 PSAY iif(!EMPTY(cNatureza),Alltrim(cNatureza),"")
//----------------------------------------------- LINHA 14
@ nLin+16, 000 PSAY _cAdic[11]

// Daniel Franciulli - Inserido em 09/07/08 para tratar a mensagem de local de saida dos produtos no campo de dados adicionais (trata somente o primeiro item)
If Len(xCOD_PRO) >0
	MSx5nota :=""
	_cLocSai := Posicione("SX5",1,xFilial("SX5")+"AL"+_xLocal,"X5_DESCRI")
	tamtxt := Len(_cLocSai)
	Axabar   := AT("/",_cLocSai)
	IF  Axabar > 0
		MSx5nota := SUBS(X5Descri(),Axabar+1,tamtxt)
	ELSE
		MSx5nota := ""
	ENDIF 
	If 	Alltrim(MSx5nota) <> ""
	//alert(Formula(Alltrim(MSx5nota)))
		@ nLin+17, 000 Psay SubStr(Formula(Alltrim(MSx5nota)),1,66)
		@ nLin+18, 000 Psay SubStr(Formula(Alltrim(MSx5nota)),67, 150)
	EndIf
Endif

nLin:= 18 		// Antes 21
@ nLin+ 0, 084 PSAY xNOME_CLI + "  "// + xCOD_CLI + "-" + xLJ_CLI
If !EMPTY(xCGC_CLI)
	IF Posicione("SA1", 1, xFilial("SA1") + xCOD_CLI + xLJ_CLI, "A1_PESSOA" ) == 'J'
		@ nLin+ 0, 204 PSAY xCGC_CLI Picture"@R 99.999.999/9999-99"
	ELSE
		@ nLin+ 0, 204 PSAY xCGC_CLI Picture"@R 999.999.999-99"
	Endif
Endif

@ nLin+ 1, 000 PSAY _cAdic[16]
@ nLin+ 2, 084 PSAY xEND_CLI
@ nLin+ 2, 204 PSAY xBAIRRO

@ nLin+ 3, 000 PSAY _cAdic[19]
@ nLin+ 4, 204 PSAY xCEP_CLI Picture "@R 99999-999"		// 25

@ nLin+ 7, 000 PSAY _cAdic[21]				// 27
@ nLin+ 7, 084 PSAY xMUN_CLI
@ nLin+ 7, 160 PSAY xTEL_CLI
@ nLin+ 7, 194 PSAY xEST_CLI
@ nLin+ 7, 204 PSAY xINSC_CLI
nLin:= 27	// Antes 32
If mv_par04 == 2
	@ nLin+ 1, 003 PSAY xCOD_VEND[2]		// 28
	//	@ 33, 015 PSAY xCOD_VEND[1]
	@ nLin+ 1, 045 PSAY XPEDIDO
EndIf

For i:= 1 to Len(xPARC_DUP)
	If i < 4
		@ nLin+i , 086 PSAY xNUM_DUPLIC+" "+xPARC_DUP[i]
		@ nLin+i , 106 PSAY xVENC_DUP[i]
		@ nLin+i , 125 PSAY xVALOR_DUP[i] Picture("@E 99,999,999.99")
		If xDESC_DUP[i] > 0
			cTxtDescont:= "DESCONTO DE PONTUALIDADE SE PAGO ATE "+Dtoc(xVENC_DUP[i])+" :"
			@ nLin+i , 144 PSAY cTxtDescont
			If xParc_PV[i] > 0
				_nTOTDESC := _nTOTDES*(xParc_PV[i]/100)
			Else
				_nTOTDESC := _nTOTDES/Len(xPARC_DUP)
			EndIf
			@ nLin+i , 194 PSAY _nTOTDESC Picture("@E 99,999,999.99") //xParc_PV[i]
		EndIf
	EndIf
Next i

xB_ICMS_SOL	:= 0          // Base  do ICMS Solidario
xV_ICMS_SOL	:= 0          // Valor do ICMS Solidario
xDESCSUFR	:= 0
_nVolume	:= 0
_nPesBruto  := 0
_nPesLiqui  := 0
_cDesc		:= ""
cMsg := ""
nLin := 30//28//32 //30		// 40
If mv_par04 == 2
	
	For i := 1 to Len(xCOD_PRO)
		xDESCSUFR := XDESCSUFR+xDESCZFR[I]
		@ nLin, 000  Psay xCOD_PRO[I]
		@ nLin, 018  Psay xDESC_PRO[I]
		@ nLin, 086  Psay If(ltes, Alltrim(xLOTE[I]),xLOTE[I])			// If(ltes, Alltrim(xLOTE[I]),xLOTE[I])
		@ nLin, 110  Psay Transform(xCLAS_FIS[I],"@r 99.99.99.99")
		@ nLin, 132  Psay xCOD_TRIB[I]
		@ nLin, 133  Psay xSIT[I]
		@ nLin, 140  Psay xUNID_PRO[I]
		@ nLin, 152  Psay xQTD_PRO[I]               							Picture "@E 9999,999.999"
		@ nLin, 170  Psay xPRE_UNI[I]+(xDESCZFR[I]/xQTD_PRO[I])	    		Picture "@E 99,999,999.9999"
		@ nLin, 200  Psay xQTD_PRO[I]*(xPRE_UNI[I]+(xDESCZFR[I]/xQTD_PRO[I]))	Picture "@E 99,999,999.99"
		@ nLin, 224  Psay xICM_PROD[I]											Picture "99"
		@ nLin, 234  Psay xIPI[I]												Picture "99"
		@ nLin, 244  Psay xVAL_IPI[I]											Picture "@E 9,999,999.99"
		
		Dbselectarea("SC5")
		SC5->(Dbsetorder(1))
		SC5->(Dbseek(Xfilial("SC5")+xPED_VEND[I]))
		If !Empty(SC5->C5_MENPAD2)
			cMsg := SC5->C5_MENPAD2
		Endif
		
		If xCEME[I][1] <> "@#$"
			If Len(xCOD_PRO) == 1
				nLin := nLin + 1
				@ nlin, 018  Psay xCEME[I][1]		// 10
			Else
				_cCod := IIf( Len(xCOD_PRO) == I, xCOD_PRO[I], xCOD_PRO[I + 1] )
				
				If xCEME[I][2] <> _cCod .Or. Len(xCOD_PRO) == I
					nLin := nLin + 1
					@ nlin, 018  PSAY xCEME[I][1]
				EndIf
			EndIf
			
		EndIf
		
		_nVolume   += ( (xQTD_PRO[I] / Posicione("SB1",1,xFilial("SB1")+xCOD_PRO[I],"B1_QE")) / Posicione("SB5",1,xFilial("SB5")+xCOD_PRO[I],"B5_QE1"))
		_nPesLiqui += xQTD_PRO[I] * Posicione("SB1",1,xFilial("SB1")+xCOD_PRO[I],"B1_PESO")
		_nPesBruto += xQTD_PRO[I] * Posicione("SB1",1,xFilial("SB1")+xCOD_PRO[I],"B1_PESBRU")
		
		nLin :=nLin+1
		
	Next i
	
	nLin :=nLin+1
	
	//	Incluido por Samir para imprimir o desconto comercial
	If nValDescIt > 0
		@ nLin, 000  PSAY "Desconto comercial concedido:"
		@ nLin, 040  PSAY nValDescIt	 Picture "@E 99,999,999.99"
		nLin :=nLin+1
		
	EndIf
	
	
	nValDescIt := 0
	
	If xDESCSUFR # 0
		@ nLin,125 PSAY "Desconto para Zona Franca"
		@ nLin,162 PSAY xDESCSUFR  Picture"@E 99,999,999.99"
		nLin :=nLin+1
	Endif
	
Else				// Entrada
	For i := 1 to Len(xCOD_PRO)
		For j :=  1 to len (xDESCRICAO[I])
			If j = 1
				// Nf Entrada
				@ nLin, 000  PSAY xCOD_PRO[I]
				@ nLin, 018  PSAY xDESCRICAO[I]
				If !empty(alltrim(xLOTE[I]))
					@ nLin, 086  PSAY alltrim(xLOTE[I])
				Endif
				@ nLin, 110  PSAY Transform(xCLAS_FIS[I],"@r 99.99.99.99")
				@ nLin, 132  PSAY xCOD_TRIB[I]
				@ nLin, 133  PSAY xSIT[I]
				@ nLin, 140  PSAY xUNID_PRO[I]
				@ nLin, 152  PSAY xQTD_PRO[I]    Picture "@E 9999,999.999"
				@ nLin, 170  PSAY xPRE_UNI[I]    Picture "@E 99,999,999.99"
				@ nLin, 200  PSAY xVAL_MERC[I]   Picture "@E 99,999,999.99"
				@ nLin, 224  PSAY xICM_PROD[I]   Picture "99"
				@ nLin, 234  PSAY xIPI[I]        Picture "99"
				@ nLin, 244  PSAY xVAL_IPI[I]    Picture "@E 9,999,999.99"
			Endif               
			If Len(xPED_VEND) > 0
				Dbselectarea("SC5")
				SC5->(Dbsetorder(1))
				SC5->(Dbseek(Xfilial("SC5")+xPED_VEND[I]))
				If !Empty(SC5->C5_MENPAD2)
					cMsg := SC5->C5_MENPAD2
				Endif
			EndIF			
		Next j
		nLin := nLin + 1
		
		If xCEME[I][1] <> "@#$"
			If Len(xCOD_PRO) == 1
				@ nlin, 014  PSAY xCEME[I][1]
				nLin := nLin + 1
			Else
				_cCod := IIf( Len(xCOD_PRO) == I, xCOD_PRO[I], xCOD_PRO[I + 1] )
				
				If xCEME[I][2] <> _cCod .Or. Len(xCOD_PRO) == I
					@ nlin, 014  PSAY xCEME[I][1]
					nLin := nLin + 1
				EndIf
				
			EndIf
		EndIf
		_nPes := ( xQTD_PRO[I] / Posicione("SB1",1,xFilial("SB1")+xCOD_PRO[I],"B1_QE") * Posicione("SB1",1,xFilial("SB1")+xCOD_PRO[I],"B1_PESBRU"))
		_nPesLiqui += xQTD_PRO[I] * Posicione("SB1",1,xFilial("SB1")+xCOD_PRO[I],"B1_PESO")
		_nPesBruto += IIf( _nPes > 0, _nPes, _nPesLiqui)
	Next i
	
Endif
//----------------------------------------------- LINHA 54/55/56

If mv_par04 == 2 .and. Len(xISS) == 0
	@ nLin +0, 018 Psay Upper(Alltrim(xMENSAGEM1))
	@ nLin +1, 018 Psay Upper(Alltrim(xMENSAGEM2))
Endif

/*
If cFilAnt == "01" .And. _TESAUX $ GetMv("MV_XTESSP")
@ nLin +1, 018 Psay GetMv("MV_XDESSP")
EndIf
*/
If cFilAnt == "01" .And. !EMPTY(cMsg)
	@ nLin +1, 018 Psay Alltrim(Formula(cMsg))
EndIf     

If cFilAnt == "06" .And. !EMPTY(cMsg)
	@ nLin +1, 018 Psay Alltrim(Formula(cMsg))
EndIf


//----------------------------------------------- LINHA 58
cNumNfPreSfa := ""
If !Empty(cNFOri)
	cNumNfPreSfa += " / "+Upper("NF Origem: "+Alltrim(cNFOri))
EndIf

If !Empty(cPrePed)
	cNumNfPreSfa += " / "+Upper("Pré-Pedido: "+Alltrim(cPrePed))
EndIf

If !Empty(cPedSFA)
	cNumNfPreSfa += " / "+Upper("Pedido SFA: "+Alltrim(cPedSFA))
EndIf

If !Empty(cNumNfPreSfa)
	cNumNfPreSfa += " / "
	@ nLin +2, 018 Psay cNumNfPreSfa
EndIf

If !Empty(xFil_Mens)
	@ nLin +4, 018 PSAY xFil_Mens //FORMULA(xFil_Mens)
Endif          


If !Empty(xCOD_MENS)
	@ nLin +5, 018 PSAY FORMULA(xCOD_MENS)
Endif

//=========================================================================================================
// Favaro - Mensagem customizada do campo "A1_XFORM01" Nova Solicitação Faturamento ( Valdeci ) 05/12/2011                               
//=========================================================================================================
If mv_par04 == 2 .and. 	!(xTipo$"DB") .AND. SF2->F2_XTPPED == '3'
	XFORM01 := Posicione("SA1",1,xFilial("SA1")+SF2->F2_CLIENT+SF2->F2_LOJENT,"A1_XFORM01")
	cMensNova   :=  Alltrim(U_PegaForM4(SF2->F2_CLIENT,SF2->F2_LOJENT,xFilial("SF2"))) 
	xVolta := Posicione("SA1",1,xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA,"A1_CGC")
	If Alltrim(cMensNova) <> ""
		@ nLin +6, 018 PSAY cMensNova
	EndIf                                
EndIf

//----------------------------------------------- LINHA 61
If Len(xISS) > 0
	@ nLin + 7, 148  PSAY xTOT_FAT  Picture	"@E@Z 999,999,999.99"   // Valor do Servico
Endif

//----------------------------------------------- LINHA 61 a 64
@ nLin +8, 008  PSAY xBASE_ICMS  Picture	"@E@Z 999,999,999.99"  // Base do ICMS
@ nLin +8, 038  PSAY xVALOR_ICMS Picture	"@E@Z 999,999,999.99"  // Valor do ICMS
@ nLin +8, 067  PSAY xBSICMRET   Picture	"@E@Z 999,999,999.99"  // Base ICMS Ret.
@ nLin +8, 096  PSAY xICMS_RET   Picture	"@E@Z 999,999,999.99"  // Valor  ICMS Ret.	61	 7
@ nLin +8, 148  PSAY xVALOR_MERC Picture	"@E@Z 999,999,999.99"  // Valor Tot. Prod.	68  14

//----------------------------------------------- LINHA 69 a 74
@ nLin +9, 008  PSAY xFRETE      Picture	"@E@Z 999,999,999.99"  // Valor do Frete		69 	15
@ nLin +9, 038  PSAY xSEGURO     Picture	"@E@Z 999,999,999.99"  // Valor Seguro
@ nLin +9, 096  PSAY xVALOR_IPI  Picture	"@E@Z 999,999,999.99"  // Valor do IPI
@ nLin +9, 148  PSAY xTOT_FAT    Picture	"@E@Z 999,999,999.99"  // Valor Total NF  		69 	15

nLin := 61//:= 05//61
@ nLin    , 000  PSAY xNOME_TRANSP                 // Nome da Transport.	74
If xTPFRETE=='C'                                   // Frete por conta do
	@ nLin    , 113 PSAY "1"                       // Emitente (1)
Else                                              //     ou
	@ nLin    , 113 PSAY "2"                       // Destinatario (2)
Endif
If !Empty(xCGC_TRANSP)                             // Se C.G.C. Transportador nao for Vazio
	@ nLin    , 150 PSAY xCGC_TRANSP Picture	"@R 99.999.999/9999-99"		// 74
Endif
//----------------------------------------------- LINHA 76 a 88
@ nLin +1, 000 PSAY xEND_TRANSP                   // Endereco Transp.
@ nLin +1, 100 PSAY xMUN_TRANSP                   // Municipio
@ nLin +1, 138 PSAY xEST_TRANSP                   // U.F.
//----------------------------------------------- LINHA 77 a 88
@ nLin +3, 012 PSAY _nVOLUME  Picture	"@E@Z 999,999.99"
@ nLin +3, 030 PSAY xESPECIE  Picture	"Volumes"              // Especie
@ nLin +3, 052 PSAY " "                                       // Res para Marca
@ nLin +3, 075 PSAY " "                                       // Res para Numero
@ nLin +3, 129 PSAY _nPesBruto  Picture	"@E@Z 999,999.99"      // Res para Peso Bruto
@ nLin +3, 157 PSAY _nPesLiqui  Picture	"@E@Z 999,999.99"      // Res para Peso Liquido
@ nLin +4, 238 PSAY xNUM_NF                                    // Numero da Nota Fiscal

Return .t.

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±
±±³Fun‡…o	 ³fGroupTES ³ Autor ³ Felipe Aurélio de Melo ³ Data ³ 27.02.09 ³±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±
±±³Descri‡…o ³                                                             ³±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±
±±³Retorno	 ³ cRet = Texto [Descr.Naturezas]                              ³±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±
±±³Parametros³ aNatOper = Todas as naturezas e seus valores agrupados      ³±
±±³Parametros³ cD2TES   = Código da TES do item                            ³±
±±³Parametros³ nD2TOTAL = Valor total do item                              ³±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function fGroupTES(aNatOper,cD2TES,nD2Total)

Local x:=1
Local cRet     := ""
Local lAchou   := .F.
Local aSF4Area := SF4->(GetArea())

//Tratamento para agrupar TES
SF4->(dbSetOrder(1))
If SF4->(DbSeek(xFilial("SF4")+cD2TES))
	For x:=1 To Len(aNatOper)
		If Upper(AllTrim(aNatOper[x][1])) == Upper(AllTrim(cD2TES))
			aNatOper[x][1] := Upper(AllTrim(cD2TES))
			aNatOper[x][2] := Upper(AllTrim(SF4->F4_TEXTO))
			aNatOper[x][3] += nD2Total
			lAchou := .T.
		EndIf
	Next x
	If !lAchou
		aAdd(aNatOper,{Upper(AllTrim(cD2TES)),Upper(AllTrim(SF4->F4_TEXTO)),nD2Total})
	EndIf
EndIf

//Ordena TES pelo valor do maior para o menor
aNatOper := aSort(aNatOper,,,{|x,y| x[3] > y[3]})

//Seleciona as cinco primeiras TES
For x:=1 To Len(aNatOper)
	//Trata para não mostrar mais que três descrições
	If x > 3
		x := Len(aNatOper)
	Else
		//Trata para não duplicar descrições
		If !(aNatOper[x][2] $ cRet)
			cRet += IIf(Empty(cRet),"","/")+aNatOper[x][2]
		EndIf
	EndIf
Next x

RestArea(aSF4Area)

Return(cRet)
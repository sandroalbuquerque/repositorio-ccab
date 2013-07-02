#include "protheus.ch"         
#include "apcfg40r01.ch"
#DEFINE cENTER CHR(10)+CHR(13)
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �APCFG40R01�Autor  �Valdemir Jos�       � Data �  24/03/10   ���
�������������������������������������������������������������������������͹��
���Desc.     � Relat�rio de Log                                           ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Dixtal                                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
User Function ccabrcli() 
Local cDesc1       := Substr(STR00001,  1,51)    //51
Local cDesc2       := Substr(STR00001, 52,51)    //51
Local cDesc3       := Substr(STR00001,104,51)    //51
Local cPict        := ""
Local titulo       := ""
Local nLin         := 80
Local Cabec1       := ""
Local Cabec2       := ""
Local Cabec_2      := ""
Local imprime      := .T.
Local aOrd         := {}
LOCAL cConta       := ""
Local _Query       := ""
Local aP           := {}
Local aHelp        := {}

public aCabec           := {"|",STR00002,"|",STR00003+"     ","|","   "+STR00004+"   ","|","  "+STR00005+"  ","|",STR00006+"              ","|",STR00007+"               ","|",STR00008+"          ","|",STR00009,"|",STR00010,"|"}


nPos                    := 0
Private aCampos         := {}
Private aQuery          := {0,0,0,0,0,0,0,0,0,0}
Private lEnd            := .F.
Private lAbortPrint     := .F.
Private CbTxt           := ""
Private limite          := 220    //220
Private tamanho         := "G"   //G
Private nomeprog        := "CCABRCLI"
Private nTipo           := 18
Private aReturn         := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey        := 0
Private cPerg           := "APCFR1"
Private cbcont          := 00
Private CONTFL          := 01                                                                                                 
Private m_pag           := 01
Private wnrel           := "ACF"
Private cString         := "TMP"
Private aCol_           := {}

// Montando cabe�alho
Cabec1                  := U_Monta_Cabec(aCabec, "|")

aAdd(aP,{STR00011+"              ?"      ,"D",  8,0,"G", ""          ,""      , ""   ,""   ,"" ,"", ""})
aAdd(aP,{STR00012+"              ?"      ,"D",  8,0,"G", ""          ,""      , ""   ,""   ,"" ,"", ""})
aAdd(aP,{"Usuario                ?"      ,"C", 15,0,"G", ""          ,"US3"   , ""   ,""   ,"" ,"", ""})
aAdd(aP,{"C�digo Cliente         ?"      ,"C",  6,0,"G", ""          ,"SA1"   , ""   ,""   ,"" ,"", ""}) 
aAdd(aP,{"Loja Cliente           ?"      ,"C",  2,0,"G", ""          ,""      , ""   ,""   ,"" ,"", ""})
//
aAdd(aHelp,{STR00013})
aAdd(aHelp,{STR00014})
aAdd(aHelp,{"Informe o usu�rio a ser filtrado "})
aAdd(aHelp,{"Informe o c�digo do cliente"})
aAdd(aHelp,{"Informe a loja do cliente"})

if !U_SX1Parametro(aP,aHelp)
  Return
Endif

titulo := "RELAT�RIO LOG DE CLIENTES"
//
CursorArrow()
CursorWait()

_Query := MontaQuery()

U_QryExec(_Query, "TMP")
//Processa( { U_QryExec(_Query, "TMP") },"Aguarde... Selecionando os registros")

if Eof() .and. Bof()
	MsgInfo(STR00016)
	TMP->( dbCloseArea() )
	CursorArrow()
	return
Endif

wnrel := SetPrint(cString, wnrel ,cPerg,@TITULO,cDesc1,cDesc2,cDesc3,.F.,,.F.,TAMANHO,.F.,.F.)

If nLastKey == 27
	TMP->( dbCloseArea() )
	CursorArrow()
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	TMP->( dbCloseArea() )
	CursorArrow()
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//���������������������������������������������������������������������Ŀ
//� Processamento. RPTSTATUS monta janela com a regua de processamento. �
//�����������������������������������������������������������������������

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo )

CursorArrow()

TMP->( dbCloseArea() )


Return



/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RunReport �Autor  �Valdemir Jos�       � Data �  27/10/09   ���
�������������������������������������������������������������������������͹��
���Desc.     � Processo do Relat�rio Acompanhamento de Implementa��o      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Dixtal                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)
Local nCol    := 0                                                                                     
Local nPerc   := 0         
Local cabec_2 := ''

//���������������������������������������������������������������������Ŀ
//� SETREGUA -> Indica quantos registros serao processados para a regua �
//�����������������������������������������������������������������������

dbSelectArea("TMP")

SetRegua(RecCount())

dbGoTop()

nTotala := 0
nTotal  := 0
nPerc   := 0 

While !Eof() 

	//���������������������������������������������������������������������Ŀ
	//� Verifica o cancelamento pelo usuario...                             �
	//�����������������������������������������������������������������������
	
	If lAbortPrint
		@nLin,00 PSAY STR00017
		Exit
	Endif
	
	//���������������������������������������������������������������������Ŀ
	//� Impressao do cabecalho do relatorio. . .                            �
	//�����������������������������������������������������������������������

	
	If nLin > 55 // Salto de P�gina. Neste caso o formulario tem 55 linhas...
		Cabec(Titulo,Cabec1,Cabec_2,NomeProg,Tamanho,nTipo)
		nLin := 9
	Endif
                      
	nCol := 0
	@nLin,nCol  PSAY "|"
	nCol += 1
	@nLin,nCol  PSAY Substr( Alltrim(TMP->FILIAL)+space(LEN(aCabec[2])),1,LEN(aCabec[2]) )
	nCol += LEN(aCabec[2])
	@nLin,nCol  PSAY "|"
	nCol += 1
	@nLin,nCol   PSAY Substr(Alltrim(TMP->USUARIO)+Space(Len(aCabec[4])),1,Len(aCabec[4]))
	nCol += Len(aCabec[4])
	@nLin,nCol PSAY "|"
	nCol += 1
	@nLin,nCol PSAY Substr(Alltrim(Transform(stod(TMP->DT_ALT),STR00018))+Space(Len(aCabec[6])),1,Len(aCabec[6]) )
	nCol += Len(aCabec[6])
	@nLin,nCol PSAY "|"
	nCol += 1
	@nLin,nCol PSAY Substr(Alltrim(TMP->HORA)+Space(Len(aCabec[8])),1,Len(aCabec[8]))
	nCol += Len(aCabec[8])
	@nLin,nCol PSAY "|"
	nCol += 1
	@nLin,nCol PSAY Substr(Alltrim(TMP->MODULOS)+Space(Len(aCabec[10])),1,Len(aCabec[10]))
	nCol += Len(aCabec[10])
	@nLin,nCol PSAY "|"
	nCol += 1
	@nLin,nCol PSAY Substr(Alltrim(TMP->ROTINA)+Space(Len(aCabec[12])),1,Len(aCabec[12]))
	nCol += Len(aCabec[12])
	@nLin,nCol PSAY "|"
	nCol += 1
	@nLin,nCol PSAY Substr(Alltrim(TMP->CODIGO)+Space(Len(aCabec[14])),1,Len(aCabec[14]))
	nCol += Len(aCabec[14])
	@nLin,nCol PSAY "|"
	nCol += 1
	@nLin,nCol PSAY Substr(Alltrim(TMP->ACAO)+Space(Len(aCabec[16])),1,Len(aCabec[16]))
	nCol += Len(aCabec[16])
	@nLin,nCol PSAY "|"
	nCol += 1
	@nLin,nCol PSAY Substr(Alltrim(TMP->HISTORICO)+Space(255),1,255)
	nCol += 255
	@nLin,nCol PSAY "|"  
	//
	nLin += 1
	//
	if Len(Alltrim(Substr( Alltrim(TMP->HISTORICO) ,256,255))) > 0

		nCol := 0
		@nLin,nCol  PSAY "|"
		nCol += 1
		nCol += LEN(aCabec[2])
		@nLin,nCol  PSAY "|"
		nCol += 1
		nCol += Len(aCabec[4])
		@nLin,nCol PSAY "|"
		nCol += 1
		nCol += Len(aCabec[6])
		@nLin,nCol PSAY "|"
		nCol += 1
		nCol += Len(aCabec[8])
		@nLin,nCol PSAY "|"
		nCol += 1
		nCol += Len(aCabec[10])
		@nLin,nCol PSAY "|"
		nCol += 1
		nCol += Len(aCabec[12])
		@nLin,nCol PSAY "|"
		nCol += 1       
		nCol += Len(aCabec[14])
		@nLin,nCol PSAY "|"
		nCol += 1       
		nCol += Len(aCabec[16])
		@nLin,nCol PSAY "|"
		nCol += 1       
		@nLin,nCol PSAY Substr( Alltrim(TMP->HISTORICO) ,256,255)
		nCol += 255
		@nLin,nCol PSAY "|"                                           
		nLin += 1
	Endif
	

    dbSkip() // Avanca o ponteiro do registro no arquivo
	
EndDo   


//���������������������������������������������������������������������Ŀ
//� Finaliza a execucao do relatorio...                                 �
//�����������������������������������������������������������������������

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






/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MontaQuery�Autor  �Valdemir Jos�       � Data �  24/03/10   ���
�������������������������������������������������������������������������͹��
���Desc.     � Prepara Query para relat�rio                               ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
Static Function MontaQuery()
Local cRET := ""

cRET := "SELECT SZJ.ZJ_FILIAL AS FILIAL, SZJ.ZJ_USUARIO AS USUARIO, SZJ.ZJ_DATA AS DT_ALT, SZJ.ZJ_HORA AS HORA, "+cENTER
cRET += "CASE WHEN SZJ.ZJ_ROTINA = 'MATA010' THEN 'CADASTRO DE PRODUTO'"+cENTER
cRET += "    WHEN (SZJ.ZJ_ROTINA = 'MATA020') THEN 'CADASTRO DE FORNECEDOR'"+cENTER
cRET += "    WHEN SZJ.ZJ_ROTINA = 'MATA030' THEN 'CADASTRO DE CLIENTE'"+cENTER
cRET += "    ELSE 'OUTROS' "+cENTER
cRET += "    END AS ROTINA,"+cENTER
cRET += "    SZJ.ZJ_ACAO AS ACAO, SZJ.ZJ_ROTINA AS MODULOS,  SZJ.ZJ_CODIGO AS CODIGO,   "+cENTER
cRET += "    SZJ.ZJ_DETALH AS HISTORICO"+cENTER
cRET += "FROM "+RETSQLNAME("SZJ")+" SZJ "+cENTER
cRET += "WHERE SZJ.D_E_L_E_T_ = ' '     "+cENTER
cRET += "    AND SZJ.ZJ_DATA BETWEEN '"+DTOS(MV_PAR01)+ "' AND '"+DTOS(MV_PAR02)+"'"+cENTER
if !Empty(MV_PAR03)
	cRET += "    AND SZJ.ZJ_USUARIO='"+MV_PAR03+"' "+cENTER
endif                                                      
if !Empty(MV_PAR04)                                
   IF !EMPTY(MV_PAR05)
	  cRET += "    AND SZJ.ZJ_CODIGO='"+MV_PAR04+"-"+MV_PAR05+"' "+cENTER
   ELSE
	  cRET += "    AND SUBSTRING(SZJ.ZJ_CODIGO,1,6)='"+MV_PAR04+"' "+cENTER
   ENDIF
endif                                                      


Return cRET   
#Include "Protheus.ch"
#Include "Topconn.ch"

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT120TEL  �Autor  �Denison Soares      � Data �  22/11/12   ���
�������������������������������������������������������������������������͹��
���Desc.     �P.E Disponibiliza o objeto e as coordenadas da Dialog.	  ���
���          �															  ���
�������������������������������������������������������������������������͹��
���Uso       �Pedido de Compra		                                      ���
�������������������������������������������������������������������������Ĵ��
��� PROGRAMADOR      �  DATA      � MOTIVO DA ALTERACAO                   ���
�������������������������������������������������������������������������Ĵ��
���Eduardo Cseh      � 26/11/2012 � #ECV20121126 - Alteracao para validar ���
���(Agility)         �            � se a observacao pode ser alterada.    ���
���                  �            � 									  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/

User Function MT120TEL()

Local aArea		:= GetArea()
Local oDlg		:= PARAMIXB[1]
Local aPosGet	:= PARAMIXB[2]   
Local nOpcx		:= PARAMIXB[4]    
Local nRecPC	:= PARAMIXB[5]   
Local lEdit 	:= IIF(nOpcx == 3 /*Inclusao*/ .Or. nOpcx == 4/*Alteracao*/ .Or. nOpcx == 6/*Copia*/,.T.,.F.) //#ECV20121126.o 
Public _cObs
              
SC7->(DbGoTo(nRecPC))

//#ECV20121126.bn 
//Funcao que verifica se o pedido foi atendido 
If lEdit .And. nOpcX <> 3 
	lEdit := fVerAtend(SC7->C7_NUM) 
EndIf
//#ECV20121126.en

_cObs := IIF(nOpcx == 3,CriaVar("C7_XOBS",.F.),SC7->C7_XOBS)

@ 056,	aPosGet[1,1] SAY Alltrim(RetTitle("C7_XOBS"))OF oDlg PIXEL SIZE 050,006
@ 055,	aPosGet[1,2] MSGET _cObs WHEN   lEdit;
 		PICTURE PesqPict('SC7','C7_XOBS') OF oDlg PIXEL SIZE 230,006

RestArea(aArea)

Return()



/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �fVerAtend � Autor �Eduardo Cseh Vasques   � Data � 26/11/12 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Rotina que verifica se um pedido de compras foi total ou   ���
���          �parcialmente atendido.                                      ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   �fVerAtend(Num. Pedido)                                      ���
�������������������������������������������������������������������������Ĵ��
��� Uso      �MT120TEL   												  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function fVerAtend(_cPedido)

Local _lRet		:= .T.
Local _cQuery	:= ""
Local _nCount	:= 0

//Query que verifica se existem itens atendidos para o pedido em questao
_cQuery := "SELECT C7_NUM"
_cQuery += " FROM "+RetSqlName("SC7")+" SC7" 
_cQuery += " WHERE SC7.D_E_L_E_T_ = ''"
_cQuery += "	AND C7_FILIAL = '"+xFilial("SC7")+"'"
_cQuery += "	AND C7_NUM = '"+_cPedido+"'"
_cQuery += "	AND (C7_QUJE > 0 "
_cQuery += "	OR C7_RESIDUO <> '' "
_cQuery += "	OR C7_ENCER <> '') "

If Select ("TMP") > 0
	TMP->(DbCloseArea())
EndIf     

TCQUERY _cQuery NEW ALIAS "TMP"

TMP->(DbGoTop())

Count To _nCount

If _nCount > 0 //Caso retorne algum registro
	_lRet	:= .F.
EndIf

Return _lRet

#include "rwmake.ch"      

/*/
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������Ŀ��
���Funcao      � M030EXC  � Autor � Paulo Elias           � Data � 09/10/08 ���
���������������������������������������������������������������������������Ĵ��
���Descricao   � Ponto Entrada para deletar automaticamente uma classe de   ���
���            � valor ap�s a dele�ao do Cliente.                           ���
���������������������������������������������������������������������������Ĵ��
��� Uso        � MP8                                                        ���
���������������������������������������������������������������������������Ĵ��
���            � Especifico CCAB                                            ���
����������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
/*/

User Function M030EXC()

//������������������������������������������������������������������Ŀ
//� Declaracao de variaveis                                          �
//��������������������������������������������������������������������

Local _aArea    := GetArea()
Local _aAreaSA1 := SA1->(GetArea())
Local _aAreaCTH := CTH->(GetArea())
Local _cXCLVL   := "C"+SA1->A1_COD+SA1->A1_LOJA
Local _lRet     := .T.

DbSelectArea("CTH")
DbSetOrder(1)
If DbSeek(xFilial("CTH")+_cXCLVL)
	RecLock("CTH",.F.)
 	DbDelete()
   	MsUnLock()
Else
   	Alert("Classe Valor C"+SA1->A1_COD+SA1->A1_LOJA+" n�o encontrado para dele��o!")
   	_lRet := .T.
EndIf

// Valdemir Jos� 01/07/2013 - Adicionado Registro de Log
U_RegMasterLog("SA1", FunName(), "EXC")  


RestArea(_aAreaSA1)
RestArea(_aAreaCTH)
RestArea(_aArea)

Return(_lRet)
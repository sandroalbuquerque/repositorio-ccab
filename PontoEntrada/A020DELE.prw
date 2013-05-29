#include "rwmake.ch"      

/*/
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������Ŀ��
���Funcao      � A020DELE � Autor � Paulo Elias           � Data � 07/10/08 ���
���������������������������������������������������������������������������Ĵ��
���Descricao   � Ponto Entrada para deletar automaticamente uma classe de   ���
���            � valor ap�s a dele�ao do fornecedor.                        ���
���������������������������������������������������������������������������Ĵ��
��� Uso        � MP8                                                        ���
���������������������������������������������������������������������������Ĵ��
���            � Especifico CCAB                                            ���
����������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
/*/

User Function A020DELE()

//������������������������������������������������������������������Ŀ
//� Declaracao de variaveis                                          �
//��������������������������������������������������������������������

Local _aArea    := GetArea()
Local _aAreaSA2 := SA2->(GetArea())
Local _aAreaCTH := CTH->(GetArea())
Local _cXCLVL   := "F"+SA2->A2_COD+SA2->A2_LOJA
Local _lRet     := .T.

DbSelectArea("CTH")
DbSetOrder(1)
If MsSeek(xFilial("CTH")+_cXCLVL)
   RecLock("CTH",.F.)
   DbDelete()
   MsUnLock()
Else
   Alert("Classe Valor F"+SA2->A2_COD+SA2->A2_LOJA+" n�o encontrado para dele��o!")
   _lRet := .T.
EndIf

RestArea(_aAreaSA2)
RestArea(_aAreaCTH)
RestArea(_aArea)

Return(_lRet)
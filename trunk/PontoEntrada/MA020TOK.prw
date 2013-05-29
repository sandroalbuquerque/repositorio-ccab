#include "rwmake.ch"      

/*/
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������Ŀ��
���Funcao      � MA020TOK � Autor � Paulo Elias           � Data � 30/09/08 ���
���������������������������������������������������������������������������Ĵ��
���Descricao   � Ponto Entrada disparado na confirmacao do cadastro de for- ���
���            � necedores na inclusao para gravar a classe de valor no SA2 ���
���            � A2_XCLVL e na tabela CTH CTH_CLVL.                         ���
���������������������������������������������������������������������������Ĵ��
��� Uso        � MP8                                                        ���
���������������������������������������������������������������������������Ĵ��
���Programador � Alteracao feita pelo Motivo ( Descricao abaixo)            ���
���������������������������������������������������������������������������Ĵ��
���            � Especifico CCAB                                            ���
����������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
/*/

User Function MA020TOK()

//������������������������������������������������������������������Ŀ
//� Declaracao de variaveis                                          �
//��������������������������������������������������������������������
Local _aArea    := GetArea()
Local _aAreaSA2 := SA2->(GetArea())
Local _aAreaCTH := CTH->(GetArea())
Local _cXCLVL   := "F"+M->A2_COD+M->A2_LOJA
Local _lRet     := .T.

M->A2_XCLVL     := _cXCLVL
          
If Inclui 

	If M->A2_EST <> "EX" .AND. Empty(M->A2_CGC)    // Trocado de local, por Valdemir 11/03/2013
		Alert("Quando Fornecedor for Nacional, � obrigat�rio o preenchimento do CNPJ ou CPF.")
		_lRet := .F.
	Endif
    
	if _lRet
		DbSelectArea("CTH")
		DbSetOrder(1)
		If !DbSeek(xFilial("CTH")+_cXCLVL)
			RecLock("CTH",.T.)
			CTH_FILIAL  := xFilial("CTH")
			CTH_CLVL    := _cXCLVL
			CTH_CLASSE  := "2"
	        CTH_NORMAL  := "1"
			CTH_DESC01  := ALLTRIM(M->A2_NOME)
			CTH_BLOQ    := "2"
			CTH_DTEXIS  := CTOD("01/01/1980")
			CTH_CLVLLP  := _cXCLVL
			MsUnlock()
		Else
			Alert("Classe Valor F"+M->A2_COD+M->A2_LOJA+" ja Cadastrado!")
			_lRet := .F.
		EndIf
	Endif
Endif   
/*                 Removido por Valdemir Jose 11/03/2013
If M->A2_EST <> "EX" .AND. Empty(M->A2_CGC)
	Alert("Quando Fornecedor for Nacional, � obrigat�rio o preenchimento do CNPJ ou CPF.")
	_lRet := .F.
Endif
*/
RestArea(_aAreaSA2)
RestArea(_aAreaCTH)
RestArea(_aArea)

Return(_lRet)
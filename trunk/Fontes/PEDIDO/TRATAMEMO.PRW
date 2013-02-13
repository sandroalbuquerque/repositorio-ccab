#include 'protheus.ch'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±± 
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TRATAMEMO ºAutor  ³Ciro Pedreira       º Data ³  24/08/06                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±± 
±±ºDesc.     ³  Esta funcao trata a informacao contida em um campo memo, respeitando a º±±
±±º          ³  quebra de linha e o numero de caracteres por linha.                    º±±
±±º          ³  Retorna um array com as informacoes para impressao.                    º±± 
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Rotinas Protheus 8                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±± 
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

/*************************************************** 
Variaveis usadas:

cMsg - Mensagem a ser tratada
nTotCarac - Total de caracteres por linha

****************************************************/

User Function TrataMemo(cMsg, nTotCarac)

Local aLinQuebra := {} 
Local aLinMemo := {}

aLinQuebra := VerificaQuebra(cMsg, nTotCarac)

aLinMemo := VerificaQtdCarac(nTotCarac, aLinQuebra)

// Retorna o array contendo as linhas para impressao
Return aLinMemo

/****************************************************

Funcao VerificaQuebra()

Esta funcao verifica somente se existe a quebra de pagina,
sendo que a cada quebra e adicionado uma posicao nova no
array

****************************************************/

Static Function VerificaQuebra(cMsg, nTotCarac)
                                                                                                                              
Local aLinQuebra := {}
Local nPosIni := 0
Local nPosFim := 0
Local nPosIniSo := 0
Local nPosFimSo := 0 
Local nPosCarac := 0
Local cMsgCort := ''
Local cMsgSobra := ''
Local nTamMsg := 0

// Muda a quebra de linha para o caracter # na string inteira
cMsg := AllTrim(StrTran(cMsg, Chr(13)+Chr(10), '#' )) 

cMsgSobra := cMsg

While Len(cMsgSobra) > 0
    
    // Pega a quantidade de caracteres da mensagem
    nTamMsg := Len(cMsgSobra)

    // Busca a posicao do caracter #
    nPosCarac := At('#',cMsgSobra) 
    
    // Se encontrar o caracter # adiciona ao array a mensagem cortada conforme o numero de caracteres informado no parametro
    If nPosCarac > 0
    
        nPosIni := 1
        nPosFim := nPosCarac - 1 
        
        // Corta a mensagem de acordo com a posicao inicial e final
        cMsgCort := SubStr(cMsgSobra,nPosIni,nPosFim)
        
        // Adiciona a informacao ao array
        Aadd(aLinQuebra, {cMsgCort}) 
        
        // Faz o calculo da posicao inicial e final para pegar a sobra da mensagem que ainda nao foi cortada
        nPosIniSo := nPosCarac + 1
        nPosFimSo := (nTamMsg - Len(cMsgCort)) - 1
         
        // Pega a sobra da mensagem que ainda nao foi cortada
        cMsgSobra := SubStr(cMsgSobra, nPosIniSo, nPosFimSo)
    
    Else
        
        // Senao encontrar o caracter # adiciona a sobra da mensagem no array 
        Aadd(aLinQuebra, {cMsgSobra})
        
        // Limpa a variavel para sair do loop
        cMsgSobra := ''

    EndIf

EndDo

Return aLinQuebra



/********************************************************* 

Funcao VerificaQtdCarac()

Apos ter sido verificado a quebra de pagina, agora e verificado a 
quantidade de caracteres por posicao do array, sendo que cada
posicao deve respeitar o numero de caracteres informado pelo 
parametro

*********************************************************/
Static Function VerificaQtdCarac(nTotCarac, aLinQuebra)

Local aLinMemo := {}
Local nPosIni := 1
Local nPosIniLp := 0
Local nPosFimLp := 0 
Local cMsgCort := ''
Local nNumLoop := 0
Local y := 0
Local x := 0
Local cMsgSobra := ''
Local nTamMsg := 0
Local cMsgCort := ''

For y := 1 To Len(aLinQuebra)

    // Se a quantidade de caracteres for maior que a quantidade passada pelo paramentro entao corta a mensagem 
    If Len(aLinQuebra[y][1]) > nTotCarac
        nNumLoop := Iif((Len(aLinQuebra[y][1]) % nTotCarac) == 0, Len(aLinQuebra[y][1]) / nTotCarac, Int(Len(aLinQuebra[y][1]) / nTotCarac) + 1) // Arredonda para mais sempre 
        nPosIniLp := 1
        nPosFimLp := nTotCarac
        cMsgSobra := aLinQuebra[y][1]
        
        For x := 1 To nNumLoop
            nTamMsg := Len(cMsgSobra) // Pega a quantidade de caracteres que sobraram 
            cMsgCort := SubStr(cMsgSobra, nPosIni, nTotCarac) // Corta a mensagem
            Aadd(aLinMemo, {cMsgCort}) // Adiciona a mensagem cortada ao array
            nPosIniLp := nPosFimLp + 1
            nPosFimLp := nPosIniLp + (nTotCarac - 1) 
            cMsgSobra := SubStr(aLinQuebra[y][1], nPosIniLp, (nTamMsg - Len(cMsgCort))) // Retira da string o conteudo que ja foi adicionado ao array
        Next x
    Else
        Aadd(aLinMemo, {aLinQuebra[y][1]}) // Senao houver a necessidade de cortar a mensagem novamente o conteudo e inserido direto no array 
    EndIf

Next y
    
Return aLinMemo 

/*  Programa para contar as ocorrencias das
    palavras de um texto    */


/*  Variaveis globais  */

globais:
	carac nomes[50][10], palavra[10];
	int ntab, nocorr[50];

funcoes:

/*  Funcao para procurar uma palavra na tabela de palavras  */

int Procura () {
locais:
	int i, inf, sup, med, posic, compara;
	logico achou, fimteste;
comandos:
	achou := false;
	inf := 1;
	sup := ntab;
	enquanto (!achou && sup >= inf) {
		med := (inf + sup) / 2;
		compara := 0;
		fimteste := false;
		para (i := 0; !fimteste && compara = 0; i := i + 1) {
			se (palavra[i] < nomes[med][i]) 
				compara := ~1;
			senao se (palavra[i] > nomes[med][i]) 
				compara := 1;
			se (palavra[i] = '\0' || nomes[med][i] = '\0') 
				fimteste := true;
		}
		se (compara = 0) 
			achou := true;
		senao se (compara < 0) 
			sup := med - 1;
		senao inf := med + 1;
	}
	se (achou) 
		posic := med;
	senao posic := ~inf;
	retornar posic;
}

/*  Funcao para inserir uma palavra na tabela de palavras  */

vazio Inserir (int posic) {
locais:
	int i, j;
	logico fim;
comandos:
	ntab := ntab + 1;
	para (i := ntab; i >= posic + 1; i := i - 1) {
		fim := false;
		para (j := 0; !fim; j := j + 1) {
			nomes[i][j] := nomes[i - 1][j];
			se (nomes[i][j] = '\0') 
				fim := true;
		}
		nocorr[i] := nocorr[i - 1];
	}
	fim := false;
	para (j := 0; !fim; j := j + 1) {
		nomes[posic][j] := palavra[j];
		se (palavra[j] = '\0') 
			fim := true;
	}
	nocorr[posic] := 1;
}

/*  Funcao para escrever a tabela de palavras  */

vazio ExibirTabela () {
locais:
	int i, j;
	logico fim;
comandos:
	escrever ("  ", "Palavra     ", "   Num. de ocorr.");
	para (i := 1; i <= 50; i := i + 1) escrever ("-");
	para (i := 1; i <= ntab; i := i + 1) {
		escrever ("\n  ");
		fim := false;
		para (j := 0; !fim; j := j + 1) {
			se (nomes[i][j] = '\0') 
				fim := true;
			senao escrever (nomes[i][j]);
		}
		escrever (" | ", nocorr[i]);
	}
}

/*  Funcao principal  */

principal {
locais:
	carac c;
	int posic, i;
	logico fim;
comandos:
	ntab := 0;
	escrever ("Nova palavra? (s/n): ");
	ler (c);
	enquanto (c = 's' || c = 'S') {
		escrever ("\nDigite a palavra: ");
		fim := false;
		para (i := 0; !fim; i := i + 1) {
			ler (palavra[i]);
			se (palavra[i] = '\n') {
				fim := true;
				palavra[i] := '\0';
			}
		}
		posic := Procura ();
		se (posic > 0) 
			nocorr[posic] := nocorr[posic] + 1;
		senao chamar Inserir(~posic);
		escrever ("\n\nNova palavra? (s/n): ");
		ler (c);
	}
	chamar ExibirTabela();
}

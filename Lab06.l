%{
void comentario (void);
void comentarioLinha (void);
char tratachar (char *);
void tratacadeia (char *);
%}

delim		[ \t\n\r]
ws			{delim}+
digito	    [0-9]
letra		[A-Za-z]
ctint 		{digito}+
id			{letra}({letra}|{digito})*
ctreal      {digito}+\.{digito}*([Ee][+-]?{digito}+)?
carac1		\\.|[^\\']
carac2		\\.|[^\\\"]
ctcarac 	'{carac1}'
cadeia		\"{carac2}*\"

%%

{ws}						{ ;}
"//"						{comentarioLinha();}
"/*"						{comentario ();}

se|SE 						{return SE;}
senao|SENAO 				{return SENAO;}
enquanto|ENQUANTO 			{return ENQUANTO;}
para|PARA 					{return PARA;}
retornar|RETORNAR 			{return RETORNAR;}
repetir|REPETIR 			{return REPETIR;}
true|TRUE|verdade|VERDADE	{return VERDADE;}
false|FALSE|falso|FALSO  	{return FALSO;}

globais|GLOBAIS     		{return GLOBAIS;}
locais|LOCAIS     			{return LOCAIS;}
comandos|COMANDOS   		{return COMANDOS;}
funcoes|FUNCOES	    		{return FUNCOES;}
principal|PRINCIPAL			{return PRINCIPAL;}

ler|LER         			{return LER;}
abrir|ABRIR       			{return ABRIR;}
escrever|ESCREVER   		{return ESCREVER;}
chamar|CHAMAR      			{return CHAMAR;}

int|INT         			{return INTEIRO;}
real|REAL        			{return REAL;}
carac|CARAC       			{return CARAC;}
logico|LOGICO      			{return LOGICO;}
vazio|VAZIO       			{return VAZIO;}

{id}		{strcpy (yylval.cadeia, yytext);    return ID;		}
{ctcarac}	{yylval.carac = tratachar (yytext);	return CTCARAC;	}
{cadeia}	{strcpy (yylval.cadeia, yytext);
				tratacadeia (yylval.cadeia);    return CADEIA;	}
{ctint}		{yylval.valint  = atoi(yytext);     return CTINT;	}
{ctreal}    {yylval.valreal = atof(yytext);     return CTREAL;	}

"<"		    {yylval.atr = LT;   return OPREL;}
"<="		{yylval.atr = LE;   return OPREL;}
">"		    {yylval.atr = GT;   return OPREL;}
">="		{yylval.atr = GE;   return OPREL;}
"!="		{yylval.atr = NE;   return OPREL;}
"="		    {yylval.atr = EQ;	return OPREL;}

"+"         {yylval.atr = MAIS; return OPADD;}
"-"         {yylval.atr = MENOS;return OPADD;}
"*"         {yylval.atr = MULT; return OPMULTIP;}
"/"         {yylval.atr = DIV;  return OPMULTIP;}
"%"         {yylval.atr = RESTO;return OPMULTIP;}
"&&"        {return AND;}
"||"        {return OR;}
"!"         {return NOT;}
"~"         {return NEG;}

";"         {return PVIRG;}
"."         {return PONTO;}
":"         {return DPONTS;}
","         {return VIRG;}
"("         {return ABPAR;}
")"         {return FPAR;}
"["         {return ABCOL;}
"]"         {return FCOL;}
"{"         {return ABCHAVE;}
"}"         {return FCHAVE;}
":="        {return ATRIB;}

.			{yylval.carac = yytext[0]; return INVAL;}
%%
/*
	comentario: le comentarios do tipo multilinha
*/
void comentario () {
	char c;  int estado;
	estado = 1;
	tabular(2); printf("/*");
	while (estado != 3) {
		switch (estado) {
			case 1:
				c = input ();
				printf("%c",c);
				if (c == EOF) estado = 3;
				else if (c == '*') estado = 2;
				break;
            case 2:
                c = input ();
                printf("%c",c);
				if (c == EOF || c == '/') estado = 3;
				else if (c != '*') estado = 1;
                break;
		}
	}
	tabular(1);
}

/*
	comentarioLinha: le comentarios do tipo linha
*/
void comentarioLinha() {
	char c;
	tabular(2); printf ("//");
	c = input ();
	while (c != EOF && c != '\n') {
		printf("%c", c);
		c = input ();
	}
}


/*
	tratachar: retorna o codigo ASCII de uma constante do tipo char,
   eliminando os apostrofos e as barras invertidas
 */

char tratachar (char *s) {
	if (s[1] != '\\') return s[1];
	else switch (s[2]) {
		case 'a': 	return 7;		case '\\': 	return 92;
		case 'b': 	return 8;		case 'r': 	return 13;
		case '\"': 	return 34;		case 'f': 	return 12;
		case 't': 	return 9;		case 'n': 	return 10;
		case '0': 	return 0;		case '\'': 	return 39;
		case 'v': 	return 11;
		default:		return s[2];
	}
}

/*
	tratacadeia: elimina as aspas e as barras invertidas
	de uma constante do tipo char, substituindo-as pelo respectivo
	codigo ASCII
 */

 void tratacadeia (char *s) {
	int i, n, d;
	n = strlen (s);
	for (i = 0, d = 1; i <= n-2-d; i++)   {
		if (s[i+d] != '\\') s[i] = s[i+d];
		else {
			switch (s[i+d+1]) {
				case 'a': 	s[i] = 7;	break;
				case '\\': 	s[i] = 92;	break;
				case 'b': 	s[i] = 8;	break;
				case 'r': 	s[i] = 13;	break;
				case '\"': 	s[i] = 34;	break;
				case 'f': 	s[i] = 12;	break;
				case 't': 	s[i] = 9; 	break;
				case 'n': 	s[i] = 10;	break;
				case '\0': 	s[i] = 0;	break;
				case '\'': 	s[i] = 39;	break;
				case 'v': 	s[i] = 11;	break;
				default:		s[i] = s[i+d+1];
			}
			d++;
		}
	}
	s[i] = s[n];
}

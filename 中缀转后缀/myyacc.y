%{
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include<ctype.h>
#define YYSTYPE char*
char num[50];
char id[50];
int yylex();
void yyerror();
%}
%token NUMBER
%token ID
%token ADD SUB MUL DIV LBR RBR
%left LBR
%left ADD SUB
%left MUL DIV
%right UMINUS
%right RBR

%%

lines : lines expr ';' {printf("%s\n",$2);}
| lines ';'
|
;

expr : expr ADD expr {$$=(char*)malloc(50*sizeof(char)); strcpy($$,$1);strcat($$,$3);strcat($$,"+");strcat($$," ");}
| expr SUB expr {$$=(char*)malloc(50*sizeof(char)); strcpy($$,$1);strcat($$,$3);strcat($$,"-");strcat($$," ");}
| expr MUL expr {$$=(char*)malloc(50*sizeof(char)); strcpy($$,$1);strcat($$,$3);strcat($$,"*");strcat($$," ");}
| expr DIV expr {$$=(char*)malloc(50*sizeof(char)); strcpy($$,$1);strcat($$,$3);strcat($$,"/");strcat($$," ");}
| LBR expr RBR {$$=(char*)malloc(50*sizeof(char));strcpy($$,$2);}
| SUB expr %prec UMINUS {$$=(char*)malloc(50*sizeof(char)); strcpy($$,"-");strcat($$,$2);strcat($$," ");}             
| NUMBER  {$$ = (char*)malloc(50*sizeof(char)); strcpy($$,$1);strcat($$," ");}
| ID  {$$=(char*)malloc(50*sizeof(char));strcpy($$,$1);strcat($$," ");}


%%

int yylex()
{
    int t;
    while(1){
        t=getchar();    
        if(t==' '||t=='\t'||t=='\n');
        else if((t>='0'&& t<='9')){
            int i=0;
            while((t>='0'&& t<='9')){
                num[i]=t;
                t=getchar();
                i++;
            }
            num[i]='\0';
            yylval = num;
            ungetc(t,stdin);
            return NUMBER;
        }
        else if((t>='a'&&t<='z')||(t>='A'&&t<='Z')||(t=='_')){
            int i=0;
            while((t>='a'&&t<='z')||(t>='A'&&t<='Z')||(t=='_')||(t>='0'&& t<='9')){
                id[i]=t;
                i++;
                t=getchar();
            }
            id[i]='\0';
            yylval=id;
            ungetc(t,stdin);
            return ID;
        }
        else 
        {
            switch(t)
            {
            case '+':
                return ADD;
            case '-':
                return SUB;
            case '*':
                return MUL;
            case '/':
                return DIV;
            case'(':
                return LBR;
            case')':
                return RBR;
            default: 
                return t;
            }
        }
    }
}
void yyerror()
{
    fprintf(stderr,"error\n");
    exit(1);
}
int main(void)
{
    return yyparse();
}

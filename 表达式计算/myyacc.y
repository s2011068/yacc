%{
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include<ctype.h>
#include<math.h>
//#define YYSTYPE char*
#define YYSTYPE float
int num[50];
float sum=0;
int yylex();
void yyerror();
%}
%token NUMBER
%token ADD SUB MUL DIV LBR RBR
%left LBR
%left ADD SUB
%left MUL DIV
%right UMINUS
%right RBR

%%

lines : lines expr ';' {printf("%g\n",$2);}
| lines ';'
|
;

expr : expr ADD expr {$$=$1+$3;}
| expr SUB expr {$$=$1-$3;}
| expr MUL expr {$$=$1*$3;}
| expr DIV expr {$$=$1/$3;}
| LBR expr RBR {$$=$2;}
| SUB expr %prec UMINUS {$$=-$2;}             
| NUMBER   {$$=$1;}


%%

int yylex()
{
    int t;
    while(1){
        t=getchar();    
        if(t==' '||t=='\t'||t=='\n');
        else if((t>='0'&& t<='9')){
            sum=0;
            int i=0;
            while((t>='0'&& t<='9')){
                num[i]=t;
                t=getchar();
                i++;
            }
            num[i]='\0';
            for(int j=0;j<i;j++)
            {
                sum += (num[i-j-1]-48) * pow(10,j);
            }
            yylval=sum;
            ungetc(t,stdin);
            return NUMBER;
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

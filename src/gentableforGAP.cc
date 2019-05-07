/****************************************
*  Computer Algebra System SINGULAR     *
****************************************/
/* $Id: gentable.cc 14015 2011-03-18 09:57:48Z seelisch $ */

/*
* ABSTRACT: generate iparith.inc etc.
*/

#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <stdio.h>
#include <time.h>
#include <unistd.h>

#include <kernel/mod2.h>
#include <Singular/tok.h>
#include <Singular/grammar.h>

// to produce convert_table.texi for doc:
//#define CONVERT_TABLE 1

// bits 0,1 for PLURAL
#define NO_NC            0
#define ALLOW_PLURAL     1
#define COMM_PLURAL      2
// bit 6: non-commutative letterplace
#define ALLOW_LP         64
#define NC_MASK          (3+64)
#define ALLOW_NC         ALLOW_LP|ALLOW_PLURAL

// bit 2 for RING-CF
#define ALLOW_RING       4
#define NO_RING          0

// bit 3 for zerodivisors
#define NO_ZERODIVISOR   8
#define ALLOW_ZERODIVISOR  0
#define ZERODIVISOR_MASK 8

#define ALLOW_ZZ (ALLOW_RING|NO_ZERODIVISOR)

// bit 4 for warning, if used at toplevel
#define WARN_RING        16
// bit 5: do no try automatic conversions
#define NO_CONVERSION    32

/*=============== types =====================*/
struct _scmdnames
{
  const char *name;
  short alias;
  short tokval;
  short toktype;
};
typedef struct _scmdnames cmdnames;


struct sValCmd2
{
  int p;
  short cmd;
  short res;
  short arg1;
  short arg2;
  short valid_for;
};
struct sValCmd1
{
  int p;
  short cmd;
  short res;
  short arg;
  short valid_for;
};
struct sValCmd3
{
  int p;
  short cmd;
  short res;
  short arg1;
  short arg2;
  short arg3;
  short valid_for;
};
struct sValCmdM
{
  int p;
  short cmd;
  short res;
  short number_of_args; /* -1: any, -2: any >0, .. */
  short valid_for;
};
struct sValAssign_sys
{
  int p;
  short res;
  short arg;
};

struct sValAssign
{
  int p;
  short res;
  short arg;
};

struct sConvertTypes
{
  int i_typ;
  int o_typ;
  int p;
  int pl;
};


#define jjWRONG   1
#define jjWRONG2  1
#define jjWRONG3  1
#define XS(A) A


#define D(A)     2
#define NULL_VAL 0
#define IPARITH
#define GENTABLE
#define IPCONV
#define IPASSIGN

#include <Singular/table.h>

const char * Tok2Cmdname(int tok)
{
  int i = 0;
  if (tok < 0)
  {
    return cmds[0].name;
  }
  if (tok==COMMAND) return "command";
  if (tok==ANY_TYPE) return "any_type";
  if (tok==NONE) return "nothing";
  //if (tok==IFBREAK) return "if_break";
  //if (tok==VECTOR_FROM_POLYS) return "vector_from_polys";
  //if (tok==ORDER_VECTOR) return "ordering";
  //if (tok==REF_VAR) return "ref";
  //if (tok==OBJECT) return "object";
  //if (tok==PRINT_EXPR) return "print_expr";
  if (tok==IDHDL) return "identifier";
  // we do not blackbox objects during table generation:
  //if (tok>MAX_TOK) return getBlackboxName(tok);
  while (cmds[i].tokval!=0)
  {
    if ((cmds[i].tokval == tok)&&(cmds[i].alias==0))
    {
      return cmds[i].name;
    }
    i++;
  }
  return cmds[0].name;
}
/*---------------------------------------------------------------------*/
/*generic*/
const char * iiTwoOps(int t)
{
  if (t<127)
  {
    static char ch[2];
    switch (t)
    {
      case '&':
        return "and";
      case '|':
        return "or";
      default:
        ch[0]=t;
        ch[1]='\0';
        return ch;
    }
  }
  switch (t)
  {
    case COLONCOLON:  return "::";
    case DOTDOT:      return "..";
    //case PLUSEQUAL:   return "+=";
    //case MINUSEQUAL:  return "-=";
    case MINUSMINUS:  return "--";
    case PLUSPLUS:    return "++";
    case EQUAL_EQUAL: return "==";
    case LE:          return "<=";
    case GE:          return ">=";
    case NOTEQUAL:    return "<>";
    default:          return Tok2Cmdname(t);
  }
}
//
// automatic conversions:
//
/*2
* try to convert 'inputType' in 'outputType'
* return 0 on failure, an index (<>0) on success
*/
int iiTestConvert (int inputType, int outputType)
{
  if ((inputType==outputType)
  || (outputType==DEF_CMD)
  || (outputType==IDHDL)
  || (outputType==ANY_TYPE))
  {
    return -1;
  }

  // search the list
  int i=0;
  while (dConvertTypes[i].i_typ!=0)
  {
    if((dConvertTypes[i].i_typ==inputType)
    &&(dConvertTypes[i].o_typ==outputType))
    {
      //Print("test convert %d to %d (%s -> %s):%d\n",inputType,outputType,
      //Tok2Cmdname(inputType), Tok2Cmdname(outputType),i+1);
      return i+1;
    }
    i++;
  }
  //Print("test convert %d to %d (%s -> %s):0\n",inputType,outputType,
  // Tok2Cmdname(inputType), Tok2Cmdname(outputType));
  return 0;
}
void ttGen1()
{
  int i;
  printf(
  "#########################################\n"
  "#  Computer Algebra System SINGULAR     #\n"
  "#########################################\n"
  "# Mappings for the high level GAP interface\n"
  "# This file is automatically generated by gentableforGAP.\n"
  "# Please do not edit it.\n\n");

  printf("BindGlobal(\"SI_OPERATIONS\", [\n[\n");
  int op;
  i=0;
  while ((op=dArith1[i].cmd)!=0)
  {
    if (dArith1[i].p!=jjWRONG) {
        const char *s = iiTwoOps(op);
        printf("  [\"%s\",[\"%s\"],\"%s\",%d],\n",
              s,
              Tok2Cmdname(dArith1[i].arg),
              Tok2Cmdname(dArith1[i].res),
              i);
    }
    i++;
  }
  printf("],\n#################################################\n[\n");
  i=0;
  while ((op=dArith2[i].cmd)!=0)
  {
    if (dArith2[i].p!=jjWRONG2) {
        const char *s = iiTwoOps(op);
        printf("  [\"%s\",[\"%s\",\"%s\"],\"%s\",%d],\n",
              s,
              Tok2Cmdname(dArith2[i].arg1),
              Tok2Cmdname(dArith2[i].arg2),
              Tok2Cmdname(dArith2[i].res),
              i);
    }
    i++;
  }
  printf("],\n#################################################\n[\n");
  i=0;
  while ((op=dArith3[i].cmd)!=0)
  {
    const char *s = iiTwoOps(op);
    if (dArith3[i].p!=jjWRONG3) {
        printf("  [\"%s\",[\"%s\",\"%s\",\"%s\"],\"%s\",%d],\n",
              s,
              Tok2Cmdname(dArith3[i].arg1),
              Tok2Cmdname(dArith3[i].arg2),
              Tok2Cmdname(dArith3[i].arg3),
              Tok2Cmdname(dArith3[i].res),
              i);
    }
    i++;
  }
  printf("],\n#################################################\n[\n");
  i=0;
  while ((op=dArithM[i].cmd)!=0)
  {
    const char *s = iiTwoOps(op);
    printf("  [\"%s\",%d,\"%s\",%d],\n", 
            s, dArithM[i].number_of_args,Tok2Cmdname(dArithM[i].res),i);
    i++;
  }
  printf("]\n]);\n");
  /* Seems no longer to be needed */
  printf("BindGlobal(\"SI_TOKENLIST\", [\n");
  char ops[]="=><+-*/[.^,%(;";
  for(i=0;ops[i]!='\0';i++)
    printf("  %d,\"%c\",\n", (int)ops[i], ops[i]);
  for (i=257;i<=MAX_TOK;i++)
  {
    const char *s=iiTwoOps(i);
    if (s[0]!='$')
    {
      printf("  %d,\"%s\",\n", i, s);
    }
  }
  printf("]);\n");
}
/*-------------------------------------------------------------------*/

int main()
{
  ttGen1();
  return 0;
}

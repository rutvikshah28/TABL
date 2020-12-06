/*
    CS 410 - TABL grammar file
        Name: Rutvik Shah. 200396357
        Name: Sushitha, 200xxx

 */


//Code files for our compiler -- ie. input files should be of extensions .tblc
//.tbl files are output files or basically files with our generated tables in them -- albeit only made through export functionality.
//Defining the grammar for TABL language
grammar TABL;

/*Parser Rules*/

//This is where our program should start parsing
program : start stExpr (expr)* end ;
//This is our starting routine which checks for 'TABL.start' inclusion, if not then error in the parsing 
start : 'TABL.start' semicolon ;
//This checks for End of the program, if not then error in parsing
end : 'TABL.end' semicolon ;
//We must always have make or import expressions after start so we can work on a known 'table' or a new table.. if not error in parsing.

stExpr : makeExpr | importExpr ;
//Make table expr
makeExpr : 'make' tblname semicolon;
//Import table expr
importExpr : 'import' tblname'.tbl' 'as' tblname semicolon;

//This is a regular expression which can be one of the following types.
expr :  insertExpr | printExpr | deleteExpr | sortExpr | filterExpr | movementExpr | editExpr | exportExpr ;
//Insert type of expression -- it can be insersion into row or column 
insertExpr : 'insert' 
            (('column' 'for' tblname 'type' datatype 'name' value (('default'  value ) | 'auto' ))
            |
            ('row' 'for' tblname ))
            semicolon
            ;
//Print type expression, this prints the current row out to outStream(ideally) if we cant do that, we should print it out to log.txt in directory of working.
printExpr :
            'print' (('row' | 'column') 'for')? tblname  semicolon ;
//Delete type expr
deleteExpr : 'delete' 
            ((('row' | 'column') 'for' tblname)
            |
            (tblname))
            semicolon
            ;
//Sort type expr - we will sort the table array by a certain value
sortExpr   :
            'sort' tblname 'by' value  semicolon;
//FilterExpr -- we can filter out content according to a row or column - value pairs to filterOut.tbl file
filterExpr : 'filter' 'data' 'for' ('row' | 'column' value) 'to' tblname'.tbl' semicolon;
//This is a movement expr which will have our increment/decrement and +/- operators
movementExpr : tblname'.'('row' | 'column')(plusHandle | minusHandle | incrementHandle | decrementHandle) ;
//This is our editExpr -- we can edit a value in the current row 
editExpr : 'edit' 'row' 'for' tblname (value  value)+ semicolon ;
//Export expr -- we will export the table with output 'tblname.tbl'
exportExpr : 'export' 'table' 'as' tblname semicolon;


incrementHandle : '++'  semicolon;
decrementHandle : '--'  semicolon;
plusHandle : ('+') integer  semicolon;
minusHandle : ('-') integer  semicolon;

integer: INTEGER;
semicolon : ';' ;


/*Lexer Rules*/
tblname : TBLNAME ;
TBLNAME : [a-zA-Z]+[0-9]*;
WS : [ \t\r\n]+ -> skip ;
COMMENT
    : '/*' .*? '*/' -> skip
;
COMMENTLINE
    : '//' ~[\r\n]* -> skip
;
value : VALUE;

VALUE :  (('"' | '“')?(STRING | '-')( '"' | '”' )?) | INTEGER | FLOAT ;

STRING :  [a-zA-Z0-9]+;
 INTEGER : [0-9]+ ;
 FLOAT : (INTEGER)'.'(INTEGER);
 CHAR : [a-zA-Z];
 


datatype : 'INT' | 'STRING' | 'CHAR' | 'FLOAT' ;

array : '[' value (',' value)* ']' ;


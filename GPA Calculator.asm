TITLE "GPA Calculator"

.MODEL small
.STACK 256
.DATA              

; Declaring some string and variables in order to use further...

newline DB 0DH,0AH,"$"
welcome DB "---------- Welcome to the GPA Calculator ----------$"
thanks DB 0DH,0AH,0DH,0AH,"Thanks for using our program. See you again... $" 
ask DB 0DH,0AH,0DH,0AH,"Now What you want to do?",
DB 0DH,0AH,"1- GPA "
DB 0DH,0AH,"2- Exit ",0DH,0AH," $"

subject DB 0DH,0AH,0DH,0AH,"How many subjects do you have in your semester? $"
invalid_ DB 0DH,0AH,"Sorry your input is invalid!! Please enter a valid input... $"

grade DB 0DH,0AH,0DH,0AH,"Enter the grade of subject $"
invalidG DB 0DH,0AH,"Sorry your entered invalid grade!! Please enter a valid grade...$" 

creditHour DB 0DH,0AH,"Now enter the credit hours of that subject: $"     
invalid DB 0DH,0AH,"Sorry your input is invalid!! Please enter a valid input from 1 to 9...",0DH,0AH,"$"

show DB 0AH,0DH,"Your GPA is :  $"
nSub DB ?
i DB ?

var DB ?,?     
total DB 0,0
tch DB 0
result DB ?,?
     
.CODE
main PROC
    MOV AX, @DATA
    MOV DS, AX
    
    LEA DX, welcome      ;load and print "welcome" message or string
    call displayString   ;call the "displayString" procedure or function
    
    GPA:                 ;make GPA label
    MOV i,0              ;move 0 in array i
    
    ;asking for number of subjects
    LEA DX, subject      ;load and print subject message or string
    CALL displayString   ;call the "displayString" procedure
    
    TakeS:               ;make TakeS label
    CALL input           ;call the "input" procedure
    
    ; Saving number of subjects in cl for comparasion of loop
    MOV CL, AL           ;
    SUB CL, 30H          ;
    CMP CL, 0            ;compare value 0 with CL (0 is an invalid value)
    JE not_valid         ;jump to label "not_valid" because jump perform when value = zero
    CMP CL, 9            ;compare value (value greater than 9 is also invalid)
    JG not_valid         ;jump to label "not_valid" because jump is greater than given value  9
    
    Next:                ;make Next label
    INC i                ;increamenting the loop value       
    
    
    ; Asking for grade
    LEA DX, grade        ;load and print "grade" message or string
    CALL displayString   ;call the "displayString" procedure or function
    
    MOV DL, i            ;
    ADD DL, 30h          ;
    CALL displayChr      ;call the "displayChr" procedure or function
    LEA DX, newline      ;load and print "newline" message or string
    CALL displayString   ;call the "displayString" procedure or function
    CALL input           ;call the "input" procedure or function
    
    ; moving grade into bl and computing its gpa value
    MOV BL ,AL           ;move grade (stored in al) into bl
    CALL compute         ;call the "compute" procedure or function 
    
    ; Taking number of credit hours of subject
    LEA DX, creditHour   ;load and print "creditHour" message or string
    CALL displayString   ;call the "displayString" procedure or function
    
    takeC:               ;make takeC label
    CALL input           ;call the "input" procedure or function
    SUB AL, 30H          ;
    CMP AL, 0            ;compare value 0 with AL
    JE notvalid          ;jump to label "notvalid" because jump perform when value = zero
    ADD tch, AL          ;
    MOV BL, AL           ;move al into bl
    
    
    ; Multiply subjects grade with credit hours
    CALL multiply        ;call the "multiply" procedure or function      
    
    ; add subject gpa to total
    CALL sum             ;call the "sum" procedure or function
    
    CMP CL ,i            ;repaet loop until i become cl     
    
    JNE Next             ;jump to label "Next" because jump perform when value not= zero
    
    ; Divide total GPA by tch to compute the result
    CALL ComputeResult   ;call the "ComputeResult" procedure or function
    
    ; Displaying the result
    LEA DX, show         ;load and print "show" message or string
    CALL displayString   ;call the "displayString" procedure or function
    MOV DL, result       ;move result into DL
    ADD DL, 30h          ;add 30h and store in dl
    CALL displayChr      ;call the "displayChr" procedure or function
    MOV dl, '.'          ;move . sign into dl
    Call displayChr      ;call the "displayChr" procedure or function
    MOV BX, 0            ;move 0 into BX
    MOV DL, result+1      ;move result+1 into dl
    CALL displayChr      ;call the "displayChr" procedure or function
    JMP askForAgain      ;go to label "askForAgain"
    
    ; For invalid credit hours value...
    notValid:            ;make "notValid" label
    LEA DX, invalid      ;load and print "invalid" message or string
    CALL displayString   ;call the "displayString" procedure or function
    JMP takeC            ;go to label "takeC"   
    
    ; For invalid number of Subjects...
    not_Valid:           ;make "not_valid" label
    LEA DX, invalid      ;load and print "invalid" message or string
    CALL displayString   ;call the "displayString" procedure or function
    JMP takeS            ;go to label "takeS"
    
    ; Asking user if he wants to continue or not          
    askForAgain:         ;make "askForAgain" label
    LEA DX, ask          ;load and print "ask" message or string
    CALL displayString   ;call the "displayString" procedure or function
    LEA DX, newline      ;call the "newline" procedure or function
    CALL displayString   ;call the "displayString" procedure or function
    
    ; Getting user choice in al
    Choice:              ;make "Choice" label
    CALL input           ;call the "input" procedure or function
    CMP AL, 31h          ;
    JE GPA               ;jump to label "GPA" because jump perform when value = zero
    CMP AL, 32h          ;
    JE ExitP             ;jump to label "ExitP" because jump perform when value = zero
    LEA DX, invalid_     ;
    Call displayString   ;call the "displayString" procedure or function
    JMP Choice           ;go to label "Choice"
    
    ExitP:               ;make "Choice" label
    LEA DX, thanks       ;load and print "thanks" message or string
    CALL displayString   ;call the "displayString" procedure or function
    
    MOV AH, 4Ch          ;to exit the dos
    INT 21H              ;invoke function 4Ch

main ENDP                ;to end the main procedure or code segment
ret

; Function to display character value
displayChr PROC          ;start the "displayChr" procedure or function
    MOV AH, 02H          ;function to display a character
    INT 21H              ;invoke function 2
    ret                  ;to return the procedure or function
    displayChr ENDP      ;to end the "displayChr" procedure or fucntion
 
; Displaying string 
displayString PROC       ;start the "displayString" procedure or function
    MOV AH, 09H          ;function to display a string
    INT 21H              ;invoke function 9
    ret                  ;to return tthe procedure or fucntion 
    displayString ENDP   ;to end the "displayString" procedure or function

;Taking input in al
input PROC               ;start the "input" procedure or function
    MOV AH, 01H          ;function to take input
    INT 21H              ;invoke function 1
    ret                  ;to return the procedure or fucntion 
    input ENDP           ;to end the "input" procedure or function

; Computing gpa corresponding to a grade 
compute PROC             ;start the "compute" procedure or function
    up:                  ;make "up" label
    CMP BL, 'A'          ;compare BL with character 'A'
    JE A                 ;jump to label "A",jump perform because bl = A
    CMP BL, 'B'          ;compare BL with character 'B'
    JE B                 ;jump to label "B",jump perform because bl = B
    CMP BL, 'C'          ;compare BL with character 'C'
    JE C                 ;jump to label "C",jump perform because bl = C
    CMP BL, 'D'          ;compare BL with character 'D'
    JE D                 ;jump to label "D",jump perform because bl = D
    CMP BL, 'F'          ;compare BL with character 'F'
    JE F                 ;jump to label "F",jump perform because bl = F
    CALL invalidGrade    ;call the "invalidGrade" procedure or function
    
    A:                   ;make "A" label
    CALL input           ;call the "input" procedure or function
    CMP AL, '+'          ;compare AL with '+' sign
    JE AA                ;jump to label "AA",jump perform because al = +
    CMP AL, 0DH          ;compare AL with 0DH
    JE AA                ;jump to label "AA",jump perform because al = 0DH
    CMP AL, '-'          ;compare AL with '+' sign
    JE A_                ;jump to label "A_",jump perform because al = -
    Call invalidGrade    ;call the "input" procedure or function
    
    ;on A and A+ gpa will be 4.0
    AA:                  ;make "AA" label
    MOV var, 4           ;move 4 in var
    MOV var+1, 0         ;move 0 in var next index
    JMP Exit             ;go to label "Exit"
    
    ;on A- gpa will be 3.7
    A_:                  ;make "A_" label
    MOV var, 3           ;move 3 in var
    MOV var+1, 7         ;move 7 in var next index
    JMP Exit             ;go to label "Exit"
    
    B:                   ;make "B" label
    CALL input           ;call the "input" procedure or function
    CMP AL, '+'          ;compare AL with '+' sign
    JE BPositive         ;jump to label "BPositive",jump perform because al = +
    CMP AL, '-'          ;compare AL with '-' sign
    JE BNegative         ;jump to label "BNegative",jump perform because al = -
    CMP AL, 0DH          ;compare AL with ODH
    JE BB                ;jump to label "BB",jump perform because al = 0DH
    Call invalidGrade    ;call the "input" procedure or function
    
    ;on B grade GPA will be 3.0  
    BB:                  ;make "BB" label
    MOV var, 3           ;move 3 in var
    MOV var+1, 0         ;move 0 in var next index
    JMP Exit             ;go to label "Exit"                
    
    ;on B+ grade GPA will be 3.3            
    BPositive:           ;make "BPositive" label
    MOV var, 3           ;move 3 in var
    MOV var+1, 3         ;move 3 in var next index
    JMP Exit             ;go to label "Exit"    
    
    ;on B- grade GPA will be 2.7
    BNegative:           ;make "BNegative" label
    MOV var, 2           ;move 2 in var
    MOV var+1, 7         ;move 7 in var next index
    JMP Exit             ;go to label "Exit"
    
    C:                   ;make "C" label
    CALL input           ;call the "input" procedure or function
    CMP AL, '+'          ;compare AL with '+' sign
    JE CPositive         ;jump to label "CPositive",jump perform because al = +
    CMP AL, '-'          ;compare AL with '-' sign
    JE CNegative         ;jump to label "CNegative",jump perform because al = -
    CMP AL, 0DH          ;compare AL with ODH
    JE CC                ;jump to label "CC",jump perform because al = 0DH
    Call invalidGrade    ;call the "input" procedure or function
    
    ;on C grade GPA will be 2.0  
    CC:                  ;make "CC" label
    MOV var, 2           ;move 2 in var
    MOV var+1, 0         ;move 0 in var next index
    JMP Exit             ;go to label "Exit"
    
    ;on C+ grade GPA will be 2.3          
    CPositive:           ;make "CPositive" label
    MOV var, 2           ;move 2 in var
    MOV var+1, 3         ;move 3 in var next index
    JMP Exit             ;go to label "Exit"
    
    ;on C- grade GPA will be 1.7
    CNegative:           ;make "CNegative" label
    MOV var, 1           ;move 1 in var
    MOV var+1, 7         ;move 7 in var next index
    JMP Exit             ;go to label "Exit"
      
    D:                   ;make "D" label
    CALL input           ;call the "input" procedure or function
    CMP AL, '+'          ;compare AL with '+' sign
    JE DPositive         ;jump to label "BPositive",jump perform because al = +
    CMP AL, '-'          ;compare AL with '-' sign
    JE DNegative         ;jump to label "BNegative",jump perform because al = -
    CMP AL, 0DH          ;compare AL with ODH
    JE DD                ;jump to label "CC",jump perform because al = 0DH
    Call invalidGrade    ;call the "input" procedure or function
    
    ;on D grade GPA will be 1.0  
    DD:                  ;make "DD" label
    MOV var, 1           ;move 1 in var
    MOV var+1, 0         ;move 0 in var next index
    JMP Exit             ;go to label "Exit"
    
    ;on D+ grade GPA will be 1.3          
    DPositive:           ;make "DPositive" label
    MOV var, 1           ;move 2 in var
    MOV var+1, 3         ;move 3 in var next index
    JMP Exit             ;go to label "Exit"
    
    ;on D- grade GPA will be 0.7
    DNegative:           ;make "DNegative" label
    MOV var, 0           ;move 1 in var
    MOV var+1, 7         ;move 7 in var next index
    JMP Exit             ;go to label "Exit"

           
    ;on F grade GPA will be 0.0
    F:                   ;make "F" label
    MOV var, 0           ;move 0 in var
    MOV var+1, 0         ;move 0 in var next index
    JMP Exit             ;go to label "Exit"
    
    invalidGrade:        ;make "invalidGrade" label
    LEA DX, invalidG     ;load and print "invalidG" message or string
    call displayString   ;call the "displayString" procedure or function
    LEA DX, newline       ;load and print "newline" message or string
    CALL displayString   ;call the "displayString" procedure or function
    CALL input           ;call the "input" procedure or function
    MOV AL, BL           ;move bL content in al
    JMP up               ;go to label "up"
    Exit:                ;make "Exit" label
    ret                  ;to return tthe procedure or fucntion
    compute ENDP         ;to end the "compute" procedure or fucntion

; Multiplying subject's gpa with credit hours
multiply PROC            ;start the "multiply" procedure or function
     MOV AX, 0H          ;move 0h in ax
     MOV AL, var+1       ;move var+1 index value in al
     MUL BL              ;multiply bl with al
     MOV var+1, AL       ;move AL content in var+1 index
     MOV AX, 0H          ;move 0h in ax
     MOV AL, var         ;move var index value in al
     MUL BL              ;multiply bl with al
     MOV var, AL         ;move al content in var index
     MOV BL, var+1       ;move var+1 index value in bl
     MOV AX, 0H          ;move 0h in ax
     MOV AL, var+1       ;move var+1 index value in al
     MOV BL, 10          ;move 10 in bl
     DIV BL              ;divided bl by al
     CMP AL, 0           ;compare 0 with al
     JE Exit_            ;jump to label "Exit_", jump perform when value of AL = zero
     ADD var, AL         ;addition al with var
     MOV var+1, AH       ;move ah content var+1 index
     Exit_:              ;make "Exit_" label
     ret                 ;to return the command very next line in main proc
     multiply ENDP       ;to end the "multiply" procedure or fucntion

; Adding gpa of all subjects to total...
sum PROC                 ;start the "sum" procedure or function
    MOV BL, var          ;move var index value in bl
    ADD total, BL        ;add bl with var
    MOV BL, var+1        ;move var+1 index value in bl
    ADD total+1, BL      ;add total+1 with bl
    MOV BL, total        ;move total value in bl
    MOV AX, 0h           ;move 0 in ax
    MOV AL, total+1      ;move total+1 index value in al
    MOV BL, 10           ;move 10 in bl
    DIV BL               ;divide bl by al
    CMP AL, 0            ;compare AL with 0 
    JE Exitt             ;jump to label "Exitt", jump perform when value of AL = zero
    ADD total, AL        ;addition between total and al
    MOV total+1, AH      ;move total+1 index value in al
    Exitt:               ;make "Exitt" label
    ret                  ;to return the command very next line in main proc
    sum ENDP             ;to end the "sum" procedure or fucntion

; Divide total gpa with total number of credit hours to compute final gpa...
ComputeResult PROC       ;start the "ComputeResult" procedure or function
     MOV AX, 0h          ;move oh in ax
     MOV AL, total       ;move total index value in AL
     MOV BL, tch         ;move tch in BL
     DIV BL              ;divide bl by al
     MOV result, AL      ;move al content in result
     MOV AL, AH          ;move ah content in al
     CMP AL, 0           ;compare 0 with al
     JE Skip             ;jump to label "Skip", jump perform when value of AL = zero
     MOV AH, 0h          ;move 0h in ah
     MOV CL, 10          ;move 10 in cl
     MUL CL              ;mul cl with al
     ADD AL, total+1     ;add al with total+1
     DIV BL              ;divide bl by al
     Skip:               ;make "Skip" label
     MOV result+1, AL    ;move al in result+1 index
     ret                 ;to return the command very next line in main proc
     ComputeResult ENDP  ;to end the "ComputeResult" procedure or fucntion

; Displaying a three character number....            
display PROC             ;start the "display" procedure or function
    MOV AX, 00h          ;move 00h in ax
    MOV AL, BL           ;move bl content in al
    MOV BL, 100          ;move 100 in bl
    DIV BL               ;divide bl by al
    MOV CL, AL           ;move al content in cl
    MOV AL, AH           ;move ah conetent in al
    MOV AH, 0h           ;move 0h in ah
    MOV BL, 10           ;move 10 in bl
    DIV BL               ;divide bl by al
    MOV BL, AH           ;move ah content in bl
    MOV CH, AL           ;move al content in ch
    MOV DL, CL           ;move cl content in dl
    ADD DL, 30h          ;add 30h in dl
    MOV AH, 02h          ;move 02h in ah
    CMP DL, 30h          ;compare dl with 30h
    JE M                 ;jump to label "Exitt", jump perform when value of DL = 30H
    int 21h              ;invoke function 2
    M:                   ;make "M" label
    MOV DL, CH           ;move ch in dl
    ADD DL, 30H          ;addition between dl and 30h
    MOV DL, BL           ;move bl in dl
    ADD DL, 30H          ;addition between dl and 30h
    int 21h              ;invoke function 
    ret                  ;to return the command very next line in main proc
    display ENDP         ;to end the "display" procedure or fucntion

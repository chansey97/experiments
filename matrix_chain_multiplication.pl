%% Implementing Dynamic Programming Recurrences in Constraint Handling Rules with Rule Priorities by Ahmed Magdy, Frank Raiser, and Thom Fr¨uhwirth

:- use_module(library(chr)).

:- chr_constraint
  cell(+,+,+),
  p(+,+),
  currentSize(+), % size of the sub problems as recurrence stepper, i-j
  maxSize(+),
  split(+,+,+,+,+),
  printOrder(+,+)
  .

%% It seems that CHRrp is not required, the refined operational semantics is sufficient,
%% because in this example rules' textual order can be used as rules' priority.

optimization @ cell(I,J,C1), split(I,K1,K11,J,C1) \ cell(I,J,C2), split(I,K2,K21,J,C2) <=>
  C2 >= C1 | true.

recurrence @ cell(I,K,C1), cell(K1,J,C2), p(I0,P1), p(K,P2), p(J,P3), currentSize(D) ==>
  K1=:=K+1, D=:=J-I, I0=:=I-1 |
  R is C1+C2+P1*P2*P3, cell(I,J,R),
  split(I,K,K1,J,R).

expand @ maxSize(X) \ currentSize(Y) <=>
  Y<X |
  NextY is Y+1 , currentSize(NextY).

result @ split(X,X,Y,Y,_) \ printOrder(X,Y) <=> write("("), write(X), write("*"), write(Y), write(")").
result @ split(X,X,K1,Y,_) \ printOrder(X,Y) <=> write("("), write(X), write("*"), printOrder(K1,Y), write(")").
result @ split(X,K,Y,Y,_) \ printOrder(X,Y) <=> write("("),  printOrder(X,K), write("*"), write(Y), write(")").
result @ split(X,K,K1,Y,_) \ printOrder(X,Y) <=> write("("), printOrder(X,K), write("*"), printOrder(K1,Y), write(")").

%% ?- cell(1,1,0), cell(2,2,0), cell(3,3,0), cell(4,4,0), cell(5,5,0),
%% p(0,20), p(1,10), p(2,15), p(3,20), p(4,10), p(5,10),
%% maxSize(4), currentSize(0), printOrder(1,5).
%@ (1*((2*(3*4))*5))
%@ cell(1,5,7500),
%@ cell(1,4,6500),
%@ cell(2,5,5500),
%@ cell(1,3,7000),
%@ cell(2,4,4500),
%@ cell(3,5,4500),
%@ cell(1,2,3000),
%@ cell(2,3,3000),
%@ cell(3,4,3000),
%@ cell(4,5,2000),
%@ cell(5,5,0),
%@ cell(4,4,0),
%@ cell(3,3,0),
%@ cell(2,2,0),
%@ cell(1,1,0),
%@ p(5,10),
%@ p(4,10),
%@ p(3,20),
%@ p(2,15),
%@ p(1,10),
%@ p(0,20),
%@ currentSize(4),
%@ maxSize(4),
%@ split(1,1,2,5,7500),
%@ split(1,1,2,4,6500),
%@ split(2,4,5,5,5500),
%@ split(1,1,2,3,7000),
%@ split(2,2,3,4,4500),
%@ split(3,4,5,5,4500),
%@ split(1,1,2,2,3000),
%@ split(2,2,3,3,3000),
%@ split(3,3,4,4,3000),
%@ split(4,4,5,5,2000).


%% ?- cell(1,1,0), cell(2,2,0), cell(3,3,0), cell(4,4,0), cell(5,5,0), cell(6,6,0),
%%    p(0,30), p(1,35), p(2,15), p(3,5), p(4,10), p(5,20), p(6,25),
%%    maxSize(5), currentSize(0), printOrder(1,6).
%@ ((1*(2*3))*((4*5)*6))
%@ cell(1,6,15125),
%@ cell(2,6,10500),
%@ cell(1,5,11875),
%@ cell(3,6,5375),
%@ cell(2,5,7125),
%@ cell(1,4,9375),
%@ cell(1,3,7875),
%@ cell(3,5,2500),
%@ cell(4,6,3500),
%@ cell(2,4,4375),
%@ cell(1,2,15750),
%@ cell(2,3,2625),
%@ cell(3,4,750),
%@ cell(4,5,1000),
%@ cell(5,6,5000),
%@ cell(6,6,0),
%@ cell(5,5,0),
%@ cell(4,4,0),
%@ cell(3,3,0),
%@ cell(2,2,0),
%@ cell(1,1,0),
%@ p(6,25),
%@ p(5,20),
%@ p(4,10),
%@ p(3,5),
%@ p(2,15),
%@ p(1,35),
%@ p(0,30),
%@ currentSize(5),
%@ maxSize(5),
%@ split(1,3,4,6,15125),
%@ split(2,3,4,6,10500),
%@ split(1,3,4,5,11875),
%@ split(3,3,4,6,5375),
%@ split(2,3,4,5,7125),
%@ split(1,3,4,4,9375),
%@ split(1,1,2,3,7875),
%@ split(3,3,4,5,2500),
%@ split(4,5,6,6,3500),
%@ split(2,3,4,4,4375),
%@ split(1,1,2,2,15750),
%@ split(2,2,3,3,2625),
%@ split(3,3,4,4,750),
%@ split(4,4,5,5,1000),
%@ split(5,5,6,6,5000).


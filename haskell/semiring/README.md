# Playing with Semiring

Some remarks.

## Two definitions of (closed) semiring

The 1st definition of (closed) semiring does not force the element 0 to be absorbing with respect to multiplication (a · 0 = 0 · a = 0). [Rafael Penaloza's Algebraic Structures for Transitive Closure](https://citeseerx.ist.psu.edu/viewdoc/summary?doi=10.1.1.71.7650), [Lehmann's Algebraic Structures for Transitive Closure](https://wrap.warwick.ac.uk/46308/7/WRAP_Lehmann_cs-rr-010.pdf) use this definition.

With this definition, if $S$ is a partial closed semiring then $S\cup\{u\}$ can be made a closed semiring by adding these definitions: $u+a = a  + u = u$, $a \cdot u = u \cdot a=u$, $u* = u$ and $a* = u$ if $a*$ was not previously defined. 

For example, to solve linear equations, using the closed semiring $\{R \cup \{u\}, +,·,*,0,1\}$ for 
$$
a^{\star} = \begin{cases} 
\frac{1}{1-a} & \text{if } a \notin \{1,u\} \\
u & \text{if } a \in \{1,u\}
\end{cases}
$$
and $u + a = a + u = u$, $a \cdot u = u \cdot a=u$. It obviously does not satisfy a · 0 = 0 · a = 0. 

See [Lehmann's Algebraic Structures for Transitive Closure](https://wrap.warwick.ac.uk/46308/7/WRAP_Lehmann_cs-rr-010.pdf) p.65 and  [Rafael Penaloza's Algebraic Structures for Transitive Closure](https://citeseerx.ist.psu.edu/viewdoc/summary?doi=10.1.1.71.7650) p.8.

The 2nd definition of (*-) semiring forces the element 0 to be absorbing with respect to multiplication (i.e. a · 0 = 0 · a = 0). [Wikipedia](https://en.wikipedia.org/wiki/Semiring), [A Very General Method of Computing Shortest Paths](http://r6.ca/blog/20110808T035622Z.html), [Fun with semirings](https://web.archive.org/web/20160305153614id_/http://www.cl.cam.ac.uk/~sd601/papers/semirings.pdf), [Transitive closure and related semiring properties via eliminants](https://core.ac.uk/download/pdf/81124964.pdf) use this definition.

With this definition, to solve linear equations, they define the closed semiring $\{R \cup \{∞\}, +,·,*,0,1\}$ for
$$
a^{\star} = \begin{cases} 
\frac{1}{1-a} & \text{if } a \notin \{1, \infty\} \\
\infty & \text{if } a \in \{1, \infty\}
\end{cases}
$$
and $u + a = a + u = u$, $a \cdot ∞ = ∞ \cdot a=∞ \ {{\mathrm{if}\ a\neq 0}}$, $0 \cdot a = a \cdot 0=0$.

Remark. I'm uncertain the implications of these two definitions on practical problems, but the authors of [Transitive closure and related semiring properties via eliminants](https://core.ac.uk/download/pdf/81124964.pdf) says that

> Our formulation of semirings is very similar to, but slightly less general than that of Lehmann [10],
> because we include the axiom a.0=0.a=0, which he does not. We feel that this axiom can be added without
> any sacrifice in the applicability of semirings to practical problems. On the other hand, any theoretical loss
> is more than adequately compensated by the resulting simplicity and beauty of the eliminant approach.

## Matrix Inverse

Many articles on closed semiring claimed that asteration can be used to invert a matrix. This is only partially true. For instances,

$S = \begin{bmatrix}
2 & 1 \\
4 & 2 \\
\end{bmatrix}$ is singular,  $(I-A)*$ gives you $A = \begin{bmatrix}
∞ & ∞ \\
∞ & ∞ \\
\end{bmatrix}$.

$A = \begin{bmatrix}
0 & 15 & 3 \\
28 & 7 & 2 \\
5 & 1 & 0
\end{bmatrix}$ is invertible, but $(I-A)*$ gives you $\begin{bmatrix}
∞ & ∞ & ∞ \\
∞ & ∞ & ∞ \\
∞ & ∞ & ∞
\end{bmatrix}$ as well.

The problem is that computing asteration of a matrix won't automatically permute the pivots. To perform this correctly, you have to calculate a permutation matrix $P$ beforehand:

$P = \begin{bmatrix}
0 & 1 & 0 \\
0 & 0 & 1 \\
1 & 0 & 0
\end{bmatrix}$, $P \cdot A = \begin{bmatrix}
28 & 7 & 2 \\
5 & 1 & 1 \\
0 & 15 & 3
\end{bmatrix}$, $A^{-1} = (I-PA)* \cdot P  =  \begin{bmatrix}
-0.0155039 & 0.0232558 & 0.0697674 \\
0.0775194 & -0.116279 & 0.651163 \\
-0.0542636 & 0.581395 & -3.25581
\end{bmatrix}$

This subtle issue was not mentioned in [A Very General Method of Computing Shortest Paths](http://r6.ca/blog/20110808T035622Z.html) and [Fun with semirings](https://web.archive.org/web/20160305153614id_/http://www.cl.cam.ac.uk/~sd601/papers/semirings.pdf).

See [Lehmann's Algebraic Structures for Transitive Closure](https://wrap.warwick.ac.uk/46308/7/WRAP_Lehmann_cs-rr-010.pdf) p.65 


















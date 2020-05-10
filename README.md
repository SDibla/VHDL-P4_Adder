# Pentium 4 adder

P4 adder is based on two substructures a carry generator and a sum generator. 

![Alt text](/img/P4.JPG?raw=true "P4")

## Sum Generator block

Using the RCA adder I build a higher level block which implements a parametric carry select block and carry select-like sum generator architecture as shown in the image below. 

![Alt text](/img/CS_like.JPG?raw=true "CS_like")

## Carry Select block

Carry Select block is based on the sparse tree lookahead adder.

• The PG network generates the propagate and generate terms defined as: 
```
pi = ai ⊕ bi  
gi = ai · bi
```
• The general propagate (white box) and general generate (shadowed box) superblocks generates outputs as:
```
G_i:j = G_i:k + P_i:k · G_k−1:j 
P_i:j = P_i:k · P_k−1:j
```
The PG blocks (white box) generates both G_i:j and P_i:j , while the the G block (shadowed box) generates only G_i:j.

![Alt text](/img/PG.JPG?raw=true "PG")

Structural description is used for the tree structure, and a behavioral one for the elementary blocks.

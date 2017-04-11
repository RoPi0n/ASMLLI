; ASMLLI
; Autor: Shiriaev Pavel

data byte rand_a 45
data byte rand_c 21
data byte rand_m 67
data double rand_lastnumber    2

label Random
 double &x ?
 mov &x rand_lastnumber
 mul &x rand_a
 add &x rand_c
 mod &x rand_m
 push &x
 mov &rand_lastnumber &x
 rem &x
return

label Randomize
 invoke    now
 pop       random_lastnumber
return
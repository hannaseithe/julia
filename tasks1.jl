#Aufgabe 3 Regression

a = [1 -5
1 -1
1 0
1 1
1 5]

b = [1,4,5,6,9]

function directSolve(a,b)
    return b\a 
end

display(directSolve(a,b))
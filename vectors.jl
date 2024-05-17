using LinearAlgebraX, LinearAlgebra, Polynomials, Roots


v1 = [1, 2, 3]
v2 = [ 1; 2; 3]         #v1 und v2 beides Vektoren, es wird hier nicht zwischen Spalten und Zeilenvektoren unterschieden
v3 = [3, 4, 5]
v4 = [3 4 5]            #kein Vektor => 1X3 Matrix
v5 = [3; 4; 5;;]        #kein Vektor => 3X1 Matrix
m1 = [1 2 3
3 4 5
6 7 8]

function displayVariables()
display(v1)
display(v2)
display(v3)
display(v4)      
display(v5)     
display(m1)  
end

#Vektoren
#Skalarmultiplikation
function showScalarmultiplication()
display(3*v1)           #Skalarmultiplikation
end

#Skalarprodukt
function displayScalarProduct()
display(dot(v1,v2))     #Skalarprodukt
display(v1 ⋅ v2)        #Skalarprodukt /cdot
display(v1 ⋅ v4)        #Skalarprodukt Vektor ⋅ 1x3 M
display(v1 ⋅ v5)        #Skalarprodukt Vektor ⋅ 3x1 M
display(v1'v2)          #Skalarprodukt
display(v1' * v2)       # => Skalar
end

#Matrizenmultiplikation
function displayMatrixMultiplication()
display(v1 * v2')       # => 3x3 Matrix (aus zwei Vektoren)
#ABER:
display(v1' * v2)       # => Skalar!!! (aus zwei Vektoren)
display(v4 * v4')       # 1x1 Matrix    (aus zwei Matrizen!)
display(m1 * m1')
end

function displayAddition()
    println(summary(m1+m1), m1 + m1)
end

function displayOtherOperations()
display(cross(v1,v3))   #Kreuzprodukt
display(normalize(v1))  #Vektornormalisierung
end

function abstandsGeradePunkt(p,n,q) #Hessesche Normalform
    n0 = normalize(n)
    d = n0 ⋅ p
    return n0 ⋅ q - d
end 

function displayAbstandGeradePunkt()
display(abstandsGeradePunkt([1,1],[3,4],[5,5]))
display(abstandsGeradePunkt(v1,v3,v3))
end

function displaySolution()
    display(v1\m1) #solution for m1 * X = v1
end

displaySolution()
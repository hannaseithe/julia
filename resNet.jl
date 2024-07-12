using ForwardDiff
using Random
using PlotlyJS
using LinearAlgebra
include("gradient.jl")


"""
gamma in (0,0.5)
eta in (gamma,1)

fx = f(x)
gfx = grad f(x)
return sigma satisfying
f(x+sigma*s) < fx +gamma gfxs
grad f(x+sigma*s)^Ts >=  eta gfxs
i.e. Powell-Wolfe stepsize

"""


function Sigmoid(y)
    return 1 / (1+exp(-y))
    #return 0.5 * (y + sqrt(y^2 + 4))

end

################## the Klassifier, i.e. the function whose parameters will be fixed

#evaluate the network given by parameters P at the point p \in \RR^2
function Klassifier(p,P)
    #we assume that W^k \in \RR^{2 x 2} and b_k \in \RR^2 \forall k

    K = Int64(length(P)/6)
    if 6*K != length(P)
        AssertionError("length(P) must be multiple of 6")
    end

    
    y = p
    for i in 1:K
        y = [y[1] + Sigmoid(P[i:i+1]'*y + P[i+2]),
        y[2] + Sigmoid(P[i+3:i+4]'*y + P[i+5])]
    end

    return y

end


#this function fixes the known points p in function Klassifier
function Klassifier_Fix_Points(p)

    function theKlassifier(P)
        return Klassifier(p,P)
    end

    return theKlassifier

end

function Klassifier_Fix_Parameters(P)
    function theKlassifier(p)
        return Klassifier(p,P)
    end

    return theKlassifier
end


################### The Loss function, i.e. the function to minimize w.r.t. P (given data p,lp)

function Loss(P,p,lp)
    result = 0
    n = size(p,2)
    for i in 1:n
        result = result + norm(Klassifier(p[:,i],P) - lp[:,i])^2
    end
    return 1/(2*n)*result
end



function Loss_fix_p_lp(p,lp)

    function theLoss(P;evalGrad=false)
#TODO fill
      
    end

    return theLoss
end



#     r = [1.0, 0.0]
#     b = [0.0, 1.0]
# if y<fx(x) return r else b 
# p \in \RR^{2\times N}
# fx function: f : \RR \to \RR
function labelPoints(p,fx)

    N = size(p,2) # number of points
    res = zeros(2,N)
    for n=1:N
        res[(p[2,n] > fx(p[1,n]))+1,n] = 1
    end

    return res
end


#used for plotting
# 1 -> rot, 0 -> blau
function classify(p,Klassifier)
    F = Klassifier(p)
    return 1.0*(F[1] > F[2])
end


####################################################################
############## Now the code starts


# a function to generate the exact labels
fex_labels = x->3*x.*x


#TODO fill generation of data ( p,l(p) ) and fill training -> final result: P
function g(x)
    return 3*x*(1-x)
end
N = 10
p = rand(2,N)
r = [1,0]
b = [0,1]
lp = Matrix(undef,2,N)
for i in 1:N
    lp[1:2,i]= (p[2,i] < g(p[1,i])) ? r : b
end

display(lp)

function theLoss(P;evalGrad=false)
    function Loss_(P)
        return Loss(P,p,lp)
    end
    if evalGrad
        return Loss_(P), ForwardDiff.gradient(Loss_, P)
    else
        return Loss_(P)
    end
end

P,xfinal = GradientDecent(theLoss, ones(18), 1e-4, 1000;stepMethod="PowellWolfe")




########################################################################
theKlassifier = Klassifier_Fix_Parameters(P);


#plotting with NP points per direction
NP = 50
x = y = LinRange(0,1,NP)
x = repeat(x,NP)
y = repeat(y',NP)[:]


#plot result of Klassifier on NP x NP Points
c = [classify([x[j];y[j]],theKlassifier) for j in eachindex(y)]
class = PlotlyJS.scatter(;x=x,y=y,
    mode="markers",
    marker=Dict(:mode=>"markers",
                :size=>10,
                :colorscale=>[[0,"rgb(0,0,255)"],[1,"rgb(255,0,0"]],
                :cmin => 0.0,
                :cmax => 1.0,
                :color => c,
                ),
    name="classified")
  

# plot the sepration line for the exakt labels
u = LinRange(0,1,100)
sepa = PlotlyJS.scatter(;x=u,y=min.(1.0,fex_labels(u)),
          mode="lines", line_color=:red,
         fill="tonexty",
         name="exactClassifier")




# plot the data that was used for training
data = PlotlyJS.scatter(;x=p[1,:],y=p[2,:],
    mode="markers",
    marker=Dict(:mode=>"markers",
                :size=>15,
                :color => "rgb(0,0,0)",
                ),
    name="usedData")         


  legend = PlotlyJS.Layout()
  


  PlotlyJS.plot([sepa,class,data],legend) 

  #Klassifier([1;1],ones(18))
  #display(Loss(ones(18),[1,1],[1,0]))
  
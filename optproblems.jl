function Rosenbrock(x;evalGrad=false)
    if evalGrad
        return 100(x[2]-x[1]^2)^2+(1-x[1])^2, [-400*x[1]*x[2]+400*x[1]^3+2*x[1]-2,200*x[2]-200*x[1]^2]
    else
        return 100(x[2]-x[1]^2)^2+(1-x[1])^2
    end
end
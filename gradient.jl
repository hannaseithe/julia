include("stepsize.jl")
function GradientDecent(f,x0,tol,maxit;
    stepMethod="Armijo",
    Armijo_beta=0.5,
    Armijo_gamma=1e-4,
    collectIterates=false,
    collectStepsizes=false)
    xk = x0
    kfinal = 0
    itM = x0
    for k in 0:maxit
        #println(xk)
        fx,gfx = f(xk;evalGrad=true)
        if sqrt(gfx'*gfx) <= tol
            break
        end
        sk = -gfx
        if stepMethod == "Armijo"
            sigma = Armijo(f,xk,sk,fx,gfx)
        elseif  stepMethod == "PowellWolfe"
            sigma = PowellWolfe2(f,xk,sk,gfx)
        end
        xk = xk + sigma * sk
        kfinal = k
        if collectIterates
            itM = hcat(itM,xk)
        end
    end
    if collectIterates
        return xk,kfinal,itM
    end
    return xk, kfinal
end
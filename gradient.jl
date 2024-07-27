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
    sigma=0
    gfx=0
    for k in 0:maxit
        #println(xk)
        fx,gfx = f(xk;evalGrad=true)
        ngfx= norm(gfx)
        nfx=norm(fx)
        #println(ngfx)
        #println(nfx)
        if ngfx <= tol
            println("gradient almost zero")

            break
        end
        sk = -gfx
        if stepMethod == "Armijo"
            sigma = Armijo(f,xk,sk,fx,gfx)
        elseif  stepMethod == "PowellWolfe"
            sigma = PowellWolfe(f,xk,sk,fx,gfx)
        elseif stepMethod == "dummy"
            sigma = max(0.1,sigma*0.999)
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
    println("Gradient", norm(gfx))

    return xk, kfinal
end
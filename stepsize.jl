function Armijo(f,x,s,fx,gfx;gamma=0.001,beta=0.5)
    for i in 1:200
        if f(x+beta^i*s) <= fx + gamma*beta^i*s'*gfx
            return beta^i
        end
    end
    return beta^200
end

function ArmijoRev(f,x,s,fx,gfx;gamma=0.001,beta=2)
    for i in 1:200
        if f(x+beta^i*s) >= fx + gamma*beta^i*s'*gfx
            return beta^i
        end
    end
    return beta^i
end

function PowellWolfe(f, x, s, fx, gfx; 
    gamma=0.0001, eta= 0.75)
    
    sigma = 1
    if f(x+sigma*s) - fx <= gamma*sigma*s'*gfx
        # Schritt 3
    
        fx_, gfx_ = f(x+sigma*s;evalGrad=true)
        if gfx_' * s >= eta * gfx' * s
        
            return sigma
        end
        #Schritt 4
        
        sigmaPlus = ArmijoRev(f,x,s,fx,gfx;beta=2)
        sigmaMinus = sigmaPlus / 2
    else
        #Schritt 2
        sigmaMinus = Armijo(f,x,s,fx,gfx)
        sigmaPlus = 2 * sigmaMinus 
    end

    #Schritt 5


    for i in 1:10 
        sigma = sigmaMinus 
        fx_, gfx_ = f(x+sigma*s; evalGrad=true)
        if gfx_' * s >= eta * gfx' * s
            return sigma
        end
        sigma = (sigmaMinus + sigmaPlus) / 2
        if f(x+sigma*s) - fx <= gamma*sigma*s'*gfx
            sigmaMinus = sigma
        else
            sigmaPlus = sigma
        end
    end
    #display(sigma)
    return sigma

end

function PowellWolfe2(f, x, s, gf; gamma = 1e-4, eta = 0.75)
    sigma = 1
    if f(x+sigma*s) - f(x) < sigma * gamma * gf'*s
        sigmaPlus = sigma
        while f(x+sigmaPlus*s) - f(x) > sigmaPlus * gamma * gf'*s
            sigmaPlus = 2*sigmaPlus
        end
        sigmaMinus = sigmaPlus/2
    else
        sigmaMinus = sigma
        while f(x+sigmaMinus*s) - f(x) > sigmaMinus * gamma * gf'*s
            sigmaMinus = sigmaMinus/2
        end
        sigmaPlus = 2*sigma
    end

#    println([sigmaMinus,sigmaPlus])

    fx, gradf = f(x+sigmaMinus*s; evalGrad = true)
    while gradf'*s < eta * gf'*s
        fx, gradf = f(x+sigmaMinus*s; evalGrad = true)
        sigma = (sigmaMinus + sigmaPlus)/2
            if f(x+sigma*s) - f(x) < sigma * gamma * gf'*s
                sigmaMinus = sigma
            else
                sigmaPlus = sigma
            end
    end
    sigma = sigmaMinus
    return sigma
end 
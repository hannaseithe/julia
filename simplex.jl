struct simTab
    tab
    nb
    b
    gce
    rs
end

function simTabCon(tab)
        b = size(tab,1) - 1
        nb = size(tab,2) - 2 - b
        simTab(tab,nb,b,b+1,nb+b+1)
end

Base.copy(t::simTab) = simTab(copy(t.tab),t.nb,t.b,t.gce,t.rs)


function selectPivotElement(t) 
    gce = t.tab[t.gce,1]
    indexCol = 1
    for i in 2:t.nb
        if gce > t.tab[t.gce,i]
            indexCol = i
            gce = t.tab[t.gce,i]
        end
    end    
    indexRow = 1
    quot = t.tab[1,t.rs]/t.tab[1,indexCol]
    for i in 2:t.b
        
        if quot > t.tab[i,t.rs]/t.tab[i,indexCol]
            indexRow = i
            quot = t.tab[i,t.rs]/t.tab[i,indexCol]
        end    
        println(quot)
    end    
    return [indexRow, indexCol]
end

function gceUnderZero(t)
    result = false
    for i in 1:t.rs-1
        if t.tab[t.gce,i] < 0
            result = true
        end
    end
    return result
end

function simplex(t)

    #piv = [3,2]
    
    index = 0
   
    while (gceUnderZero(t)) & (index < 3)
        nt = copy(t)
        piv = selectPivotElement(t)
        println(piv)
        index = index + 1
        for i in 1:t.rs
            println(i)
            println(piv...)
            println(t.tab[piv[1],i]/t.tab[piv...])
            nt.tab[piv[1],i] = t.tab[piv[1],i]/t.tab[piv...]
        end
        for i in 1:t.gce
            nt.tab[i, piv[2]] = -t.tab[i, piv[2]]/t.tab[piv...]
        end
        nt.tab[piv...] = 1/t.tab[piv...]
        for i in 1:t.gce
            for j in 1:t.rs
                if (i != piv[1])
                    nt.tab[i,j] = t.tab[i,j] - t.tab[piv[1],j] * t.tab[i,piv[2]] / t.tab[piv...]
                end
            end
        end
        t = nt
    end
    
    println(t.tab)
end

tab1 = [5 8 1 0 0 700 0
1 1 0 1 0 100 0
0 1 0 0 1 60 0
-1 -2 0 0 0 0 0]
tab2 = [20. 10. 1. 0. 0. 8000. 0
4. 5. 0. 1. 0. 2000. 0
6. 15. 0. 0. 1. 4500. 0
-16. -32. 0. 0. 0. 0. 0]

stab2 = simTabCon(tab2)
simplex(stab2)
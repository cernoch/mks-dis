function size = CountOwnKeys(p,d,q)
    size = nchoosek(p,q) * power(d-1,p-q);
end

function C = localize(X,T,TI,R,Cinit)
    n=size(X,2);
    C=Cinit;
    for i=1:n
        if X(i)==0
            C(i)=0;
        end
    end
    
    % main (implemented from Algorithm of localization book)
    for i=1:n-1 %we are 1based instead of 0based, so -2 becomes -1
        if X(i)==0; continue; end
        if i>find(C==C(i), 1); continue; end
        for j=i+1:n
            if X(j)==0; continue; end
            if j>find(C==C(j), 1); continue; end
            W=zeros(n,n);
            [flag,W] = check_merge(X,T,TI,i,j,W,R,C,i);
            if flag
                for k=find(X)
                    KW = W(k,:);
                    if any(KW)
                        for l=find(KW)
                            if C(k)<=C(l)
                                C(C==C(l))=C(k); %sets all states in cell C(l) to cell C(k)
                            else
                                C(C==C(k))=C(l); %sets all states in cell C(k) to cell C(l)
                            end
                        end
                    end
                end
            end
        end
    end
end

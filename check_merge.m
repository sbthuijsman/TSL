function [flag,W] = check_merge(X,T,TI,i,j,W,R,C,index)
% global calls;
% calls=calls+1;

XP = C==C(i);
for iprime=find(C==C(i))
    for x=find(W(iprime,:))
        XP = XP | C==C(x);
    end
end
XQ = C==C(j);
for jprime=find(C==C(j))
    for x=find(W(jprime,:))
        XQ = XQ | C==C(x);
    end
end

for xp=find(XP)
    for xq=find(XQ)
        
        if W(xp,xq)==1; continue; end
        if R(xp,xq)==0; flag=false; return; end

        W(xp,xq)=1;
        W(xq,xp)=1;

        for edgi = TI{xp} %transitions from xp
            for edgj = TI{xq} %transitions from xq
                if T(2,edgi)==T(2,edgj) % same sigma
                    itar = T(3,edgi);
                    jtar = T(3,edgj);
                    if C(itar) == C(jtar) || W(itar,jtar)==1; continue; end
                    if find(C==C(itar), 1) < index || find(C==C(jtar), 1) < index; flag = false; return; end
                    [flag,W] = check_merge(X,T,TI,itar,jtar,W,R,C,index);
                    if ~flag; return; end
                end
            end
        end
    end
end
flag = true;
return;
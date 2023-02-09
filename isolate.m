function [C,n_initialguess] = isolate(X,T,TI,R,Xprime,Tprime,TIprime,Rprime,C)
if size(X,2)~=size(Xprime,2)
    error('initialize X to same size!');
end
n=size(X,2);

%initialize C
for i=1:n
    if X(i)==0 && Xprime(i)==1
        C(i)=max(C)+1;
    end
    if Xprime(i)==0 && C(i)~=0
        C(i)=0;
    end
end

n_initialguess=sum(unique(C)~=0);

Xintersect=X & Xprime;

while true
    flaglessloop=true; %if we loop over all states i without flagging anything, we know we are finished
    for i=find(Xintersect)
        flag=false;
        for j=find(Xintersect & C==C(i))
            if i==j; continue; end
            if Rprime(i,j)==0
                flag=true;
                flaglessloop=false;
                C(i)=max(C)+1;
                break
            end
            if flag; break; end
            for edgi = TIprime{i}
                for edgj = TIprime{j} %transitions from j
                    if Tprime(2,edgi)==Tprime(2,edgj) % same sigma
                        if C(Tprime(3,edgi)) ~= C(Tprime(3,edgj)) % compare cell of target state
                            flag=true;
                            flaglessloop=false;
                            C(i)=max(C)+1; %isolates state i
                            break;
                        end
                    end
                end
                if flag; break; end
            end
            if flag; break; end
        end
    end
    if flaglessloop
        break
    end
end

end
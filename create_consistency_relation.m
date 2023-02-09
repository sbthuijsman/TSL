function R = create_consistency_relation(X,T,D,local_c_events)
T = quick_prune_trans(T,ones(size(X)),local_c_events,zeros(size(X))); %only check transitions for locally controllable events
R = ones(size(X,2),size(X,2));
for i=1:size(D,2)
    for t=find(T(2,:)==D(2,i)) %transitions that enable disabled sigma
        R(T(1,t),D(1,i))=0;
        R(D(1,i),T(1,t))=0;
    end
end
for i = 1:size(X,2)
    if X(i)==0
        R(i,:)=zeros(1,size(X,2)); 
        R(:,i)=zeros(size(X,2),1); 
    end
end

end
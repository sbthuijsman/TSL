clear all; close all; clc

%% select model
foldermodelname = 'CMT';
basemodelname = 'CMT_n4_k1_base';
variantmodelname = 'CMT_n4_k1_var1';
load(['MLsys/' foldermodelname '/' basemodelname '_to_' variantmodelname '.mat']);

%% select number of tests
nrdm=10;
nloops=1;

%% sizes
nX=sum(X~=0);
nXprime=sum(Xprime~=0);

%% creating random indexing for fair experiments
for rdm = 1:nrdm
    rng(1000+rdm) %sets seed
    indexing = randperm(size(X,2));
    
    Xrnd=zeros(size(X));
    X0rnd=zeros(size(X));
    Xmrnd=zeros(size(X));
    Xprimernd=zeros(size(X));
    X0primernd=zeros(size(X));
    Xmprimernd=zeros(size(X));
    Drnd=D;
    Dprimernd=Dprime;
    for i=1:size(X,2)
        Xrnd(indexing(i))=X(i);
        X0rnd(indexing(i))=X0(i);
        Xmrnd(indexing(i))=Xm(i);
        Xprimernd(indexing(i))=Xprime(i);
        X0primernd(indexing(i))=X0prime(i);
        Xmprimernd(indexing(i))=Xmprime(i);
    end
    for j=1:size(D,2)
        for k=1:size(D{j},2)
            if D{j}(1,k)~=0
                Drnd{j}(1,k)=indexing(D{j}(1,k));
            end
        end
    end
    for j=1:size(Dprime,2)
        for k=1:size(Dprime{j},2)
            if Dprime{j}(1,k)~=0
                Dprimernd{j}(1,k)=indexing(Dprime{j}(1,k));
            end
        end
    end
    Trnd=T;
    for i=1:size(T,2)
        Trnd(1,i)=indexing(T(1,i));
        Trnd(3,i)=indexing(T(3,i));
    end
    Tprimernd=Tprime;
    for i=1:size(Tprime,2)
        Tprimernd(1,i)=indexing(Tprime(1,i));
        Tprimernd(3,i)=indexing(Tprime(3,i));
    end

    for i=1:size(Xrnd,2)
        TIrnd{i}=find(Trnd(1,:)==i);
    end
    
    for i=1:size(Xprimernd,2)
        TIprimernd{i}=find(Tprimernd(1,:)==i);
    end
    
%% compute consistency relation

    for subsysi=1:size(R,2)
            R{subsysi} = create_consistency_relation(Xrnd,Trnd,Drnd{subsysi},local_c_events{subsysi});
            Rprime{subsysi} = create_consistency_relation(Xprimernd,Tprimernd,Dprimernd{subsysi},local_c_events_prime{subsysi});

%% perform algorithms

        for loop=1:nloops
        
            Cinit=1:size(X,2);
            t1=tic;
            C = localize(Xrnd,Trnd,TIrnd,R{subsysi},Cinit);
            tlocalize=toc(t1);
            ncells = sum(unique(C)~=0);
            
            Cinit=1:size(Xprime,2);
            t2=tic;
            Cprime = localize(Xprimernd,Tprimernd,TIprimernd,Rprime{subsysi},Cinit);
            tlocalizeprime=toc(t2);
            ncellsprime = sum(unique(Cprime)~=0);
            
            t3=tic;
            [Cisolated,ncellsinitialguess] = isolate(Xrnd,Trnd,TIrnd,R{subsysi},Xprimernd,Tprimernd,TIprimernd,Rprime{subsysi},C);
            tisolate=toc(t3);
            ncellsisolated = sum(unique(Cisolated)~=0);
            
            t4=tic;
            Cprimetrans = localize(Xprimernd,Tprimernd,TIprimernd,Rprime{subsysi},Cisolated);
            twarmstartlocalize=toc(t4);
            ncellstransformational = sum(unique(Cprimetrans)~=0);

            result{rdm}{subsysi}{loop}=[ncells ncellsprime ncellsisolated ncellstransformational ncellsinitialguess];
            time{rdm}{subsysi}{loop}=[tlocalize tlocalizeprime tisolate twarmstartlocalize];
        end
    end
end



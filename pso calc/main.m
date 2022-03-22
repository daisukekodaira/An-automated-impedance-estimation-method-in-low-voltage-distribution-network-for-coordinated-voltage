% Case1
Num_itr = 3;

result = zeros(Num_itr,18);
err = zeros(Num_itr,18);

for i = 1:Num_itr
    [result(i,:), err(i,:)] = simul_pso;
    
    X = sprintf('Processing... %d/%d',i,Num_itr);
    disp(X)
end

% output result
% 1. EstimatedImpedance.csv 
hedder = {'Z(2)_Re' 'Z(2)_Im' ...
                'Z(3)_Re' 'Z(3)_Im' ... 
                'Z(4)_Re' 'Z(4)_Im' ... 
                'Z(5)_Re' 'Z(5)_Im' ... 
                'Z(6)_Re' 'Z(6)_Im' ... 
                'Z(7)_Re' 'Z(7)_Im' ... 
                'Z(8)_Re' 'Z(8)_Im' ... 
                'Z(9)_Re' 'Z(9)_Im' ... 
                'Z(10)_Re' 'Z(10)_Im' ... 
                };
fid = fopen('EstimatedImpedance.csv','wt');
fprintf(fid,'%s,',hedder{:});
fprintf(fid,'\n');
for i = 1:size(result,1)
    for j = 1:size(result,2)
        fprintf(fid,'%0.5f,',result(i,j));
    end
    fprintf(fid,'\n');
end
fclose(fid);

% 2. Error.csv 
fid = fopen('Error.csv','wt');
fprintf(fid,'%s,',hedder{:});
fprintf(fid,'\n');
for i = 1:size(result,1)
    for j = 1:size(result,2)
        fprintf(fid,'%0.5f,',err(i,j));
    end
    fprintf(fid,'\n');
end
disp('Done!')

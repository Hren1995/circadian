function [g,SES,p] = skewstderr(data)

% Measures the Skewness of a 1D vector using the formula:
% g = sqrt(n*(n-1))/(n-2)*m_3/(m_2)^(3/2), where m is the moment of the data
% along with the corresponding standard error term, and the corresponding p-value

n = length(data);
g = skewness(data,0);

SES = sqrt((6*n*(n-1))/((n-2)*(n+1)*(n+3)));

Z = g/SES;
p = 1-normcdf(Z);
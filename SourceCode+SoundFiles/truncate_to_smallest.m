%function truncate_to_smallest
%Inputs:---------------------------
%   a,b,c,d (arrays) -the input signals   
%Returns:--------------------------
%   a_t, b_t, c_t, d_t -the truncated signals%
%Additional Notes:-------------------
%   This function finds the smallest among the four arrays and truncates
%   all arrays to the length of the smallest array
function [a_t, b_t, c_t, d_t] = truncate_to_smallest(a,b,c,d)

%finding lengths of all arrays
lengths = [ numel(a) numel(b) numel(c) numel(d)];
%finding the smallest length
n=min(lengths);
%truncating all signals to the smallest length
a_t=a(1:n);
b_t=b(1:n);
c_t=c(1:n);
d_t=d(1:n);
%function ends
end

function [ gcoord,element,A_index ] = coordinate_group
% node  X-coordinate(mm)  Y-coordinate(mm)   Z-coordinate (mm)
b = 60;
node_codinate = ... 
[1   0    0   0
 2   2*b  0   0
 3   2*b  2*b 0
 4   0    2*b 0
 5   0    0   1*b
 6   2*b  0   1*b
 7   2*b  2*b 1*b
 8   0    2*b 1*b
 9   0    0   2*b
 10  2*b  0   2*b
 11  2*b  2*b 2*b
 12  0    2*b 2*b
 13  0    0   3*b
 14  2*b  0   3*b
 15  2*b  2*b 3*b
 16  0    2*b 3*b
 17  0    0   4*b
 18  2*b  0   4*b
 19  2*b  2*b 4*b
 20  0    2*b 4*b];

gcoord = node_codinate(:,[2 3 4])';

% Type element
group = ...
[    1     1     1     5
     2     1     2     6
     3     1     3     7
     4     1     4     8
     5     2     1     6
     6     2     2     5
     7     2     3     6
     8     2     2     7
     9     2     3     8
    10     2     4     7
    11     2     4     5
    12     2     1     8
    13     3     5     6
    14     3     6     7
    15     3     7     8
    16     3     8     5
    17     4     5     7
    18     4     6     8
    19     5     5     9
    20     5     6    10
    21     5     7    11
    22     5     8    12
    23     6     5    10
    24     6     6     9
    25     6     7    10
    26     6     6    11
    27     6     7    12
    28     6     8    11
    29     6     8     9
    30     6     5    12
    31     7     9    10
    32     7    10    11
    33     7    11    12
    34     7    12     9
    35     8     9    11
    36     8    10    12
    37     9     9    13
    38     9    10    14
    39     9    11    15
    40     9    12    16
    41    10     9    14
    42    10    10    13
    43    10    11    14
    44    10    10    15
    45    10    11    16
    46    10    12    15
    47    10    12    13
    48    10     9    16
    49    11    13    14
    50    11    14    15
    51    11    15    16
    52    11    16    13
    53    12    13    15
    54    12    14    16
    55    13    13    17
    56    13    14    18
    57    13    15    19
    58    13    16    20
    59    14    13    18
    60    14    14    17
    61    14    15    18
    62    14    14    19
    63    14    15    20
    64    14    16    19
    65    14    16    17
    66    14    13    20
    67    15    17    18
    68    15    18    19
    69    15    19    20
    70    15    20    17
    71    16    17    19
    72    16    18    20];

element = group(:,[3 4])';
A_index = group(:,2);
end


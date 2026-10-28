Include "guide_vane.geo";

//////////////////////////////////////////////////////////////////////////////////
// Parameters: l = length, t = top, b = bottom                                  //
//////////////////////////////////////////////////////////////////////////////////
l_inlet = 70;
l_outlet = 70;
c = 67.6;
h = 57.5;
l_buffer = 20;
split_frac = 0.83;
wake_frac = 0.06;           // Fraction of bottom tube where the wake ends
wake_arc_frac = 0.7;       // Tube diameter at trailing edge that spans the tube
n_vane_norm_pass_frac = 0.31;     // Fraction of incoming nodes that passes the wake of the vane
n_vane_aft_bottom = 100;
n_vane_aft_bottom_curve_frac = 0.6;
n_vane_aft_top = 100;
n_trailing_edge = 50;
n_arc_2_bottom = 50;
n_outlet_bottom_frac = 0.8;
//////////////////////////////////////////////////////////////////////////////////
// Define the x and y positions of the boundary box position parameters         //
//////////////////////////////////////////////////////////////////////////////////
x1 = -l_inlet;
yt1 = h/2;      yb1 = -h/2;

x2 = 0;
yt2 = h/2;      yb2 = -h/2;

x3 = 27;
yt3 = yt2 - 20;  yb3 = yt3 - h;

///////////////////////////////////////////////////
r1 = - ((x3-x2)^2 + (yt3-yt2)^2) / (2*(yt3-yt2));//
A1 = x2;                                         //
B1 = yt2 - r1;                                   //
dydx = -(x3-A1)/(yt3-B1);  
dxdy = 1/(dydx);                   //
///////////////////////////////////////////////////

x4 = 90;
yt4 = yt3 + (x4-x3)*dydx; yb4 = yt4 - h;

x5 = 120;
yt5 = yt4 - 20;  yb5 = yt5 - h;

///////////////////////////////////////////////////
r2 = - ((x4-x5)^2 + (yt4-yt5)^2) / (2*(yt4-yt5));//
A2 = x5;                                         //
B2 = yt5 - r2;                                   //
///////////////////////////////////////////////////

x6 = x5 + l_outlet;
yt6 = yt5;       yb6 = yb5; 

xbwake = x3+wake_frac*(x4-x3);
ybwake = yb3 + dydx*wake_frac*(x4-x3);
d = h * dxdy / ((1 + dxdy^2)^0.5);
dx = (xbwake-x3)- d * 1 / ((1 + dxdy^2)^0.5);
xtwake = x3 + dx;
ytwake = yt3 + dydx * dx;
xtmwake = xtwake;


//////////////////////////////////////////////////////////////////////////////////
// Define the points of the boundary box                                        //
//////////////////////////////////////////////////////////////////////////////////
Point(1606) = {x1, yt1, 0, 1.0};
Point(1607) = {x1, yb1, 0, 1.0};

Point(1608) = {x2, yt2, 0, 1.0};
Point(1609) = {x2, yb2, 0, 1.0};

Point(1610) = {x3, yt3, 0, 1.0};
Point(1611) = {x3, yb3, 0, 1.0};

Point(1612) = {x4, yt4, 0, 1.0};
Point(1613) = {x4, yb4, 0, 1.0};

Point(1614) = {A1, B1, 0, 1.0};
Point(1615) = {A1, B1-h, 0, 1.0};

Point(1616) = {x5, yt5, 0, 1.0};
Point(1617) = {x5, yb5, 0, 1.0};

Point(1618) = {x6, yt6, 0, 1.0};
Point(1619) = {x6, yb6, 0, 1.0};

Point(1620) = {A2, B2, 0, 1.0};
Point(1621) = {A2, B2-h, 0, 1.0};

Line(4) = {1606, 1607};

Line(11) = {1616, 1618};
Line(12) = {1617, 1619};
Line(13) = {1618, 1619};

Point(1622) = {x2 - l_buffer, yt2 - 10, 0, 1.0};
Point(1623) = {x2 - l_buffer, yb2 + 10, 0, 1.0};
Point(1624) = {x2 - l_buffer, yt2, 0, 1.0};
Point(1625) = {x2 - l_buffer, yb2, 0, 1.0};

Line(14) = {1622, 1624};
Line(15) = {1623, 1625};

Circle(16) = {1622, 603, 1623};
Line(17) = {642, 1622};
Line(18) = {566, 1623};



//+
Circle(19) = {1609, 1615, 1611};
//+
Circle(20) = {1608, 1614, 1610};
//+
Circle(22) = {1612, 1620, 1616};
//+
Circle(23) = {1613, 1621, 1617};
//+
Line(24) = {1624, 1606};
//+
Line(25) = {1625, 1607};
//+
Line(26) = {1609, 1625};
//+
Line(27) = {1608, 1624};
//+
Point(1626) = {6, -19.5, 0, 1.0};
//+
Spline(28) = {1609, 1626, 490};
//+
Line(29) = {1610, 810};
//+
Point(1627) = {4.9, 18.4, 0, 1.0};

Point(1628) = {xbwake, ybwake, 0, 0.1};
Point(1629) = {xtwake, ytwake, 0, 0.1};

Point(1630) = {xbwake + (1-wake_arc_frac)/2 * (xtwake - xbwake), ybwake + (1-wake_arc_frac)/2 * (ytwake - ybwake), 0, 0.1};
Point(1631) = {xtwake - (1-wake_arc_frac)/2 * (xtwake - xbwake), ytwake - (1-wake_arc_frac)/2 * (ytwake - ybwake), 0, 0.1};

rx = 2;
Point(1632) = {(xbwake + xtmwake)/2 - rx, (ybwake + ytwake)/2 - rx*dydx, 0, 0.1};
//+
Spline(30) = {1608, 1627, 720};
Split Curve {1} Point {642, 566};
Split Curve {32} Point {720};
Split Curve {34} Point {810};
Split Curve {36} Point {490};

Line(39) = {1611, 1628, 1613};
Line(40) = {1610, 1629, 1612};

Point(1633) = {x4-(xtwake - xbwake), yt4 - (ytwake - ybwake), 0, 0.1};
rx2 = 2;
Point(1634) = {(xbwake + xtmwake)/2 - rx, (ybwake + ytwake)/2 - rx*dydx, 0, 0.1};

Point(1635) = {x5+35, yb5+40, 0, 0.0};

//////////////////////////////////////////////////////////////////////////////////
// Nodes                                                                        //
//////////////////////////////////////////////////////////////////////////////////
n_inlet = 80;
n_top_in = 80;
f_in_center = 0.6;      // Fraction of inlet nodes that passes through the middle
n_r_nose = 30;          // Number of nodes in radial direction at vane nose surface


//+
n_vane_normal = n_inlet/2*(1-f_in_center)+n_r_nose;
n_ax_tube = n_trailing_edge + 2*n_vane_norm_pass_frac * n_vane_normal+2;
n_tube_wall = 100;

Transfinite Curve {16, 31} = n_inlet*f_in_center Using Progression 1;
Transfinite Curve {17, 18} = n_r_nose Using Progression 1;
Transfinite Curve {24, 25} = n_top_in Using Progression 1;
Transfinite Curve {4} = n_inlet Using Progression 1;
Transfinite Curve {14, 15} = n_inlet/2*(1-f_in_center)+1 Using Progression 1;
Transfinite Curve {30, 29, 28} = n_vane_normal Using Progression 1;
Transfinite Curve {27, 33} = 10 Using Progression 1;
Transfinite Curve {20, 35} = 10 Using Progression 1;
Transfinite Curve {38, 26} = 10 Using Progression 1;

//+
Curve Loop(1) = {16, -18, 31, 17};
Plane Surface(1) = {1};
Transfinite Surface {1};
Recombine Surface {1};//+

//+
Curve Loop(2) = {4, -25, -15, -16, 14, 24};
Plane Surface(2) = {2};
Transfinite Surface {2} = {1607, 1625, 1624, 1606};
Recombine Surface {2};

//+
Curve Loop(3) = {14, -27, 30, -33, 17};
Plane Surface(3) = {3};
Transfinite Surface {3} = {1624, 642, 720, 1608};
Recombine Surface {3};

//+
Curve Loop(4) = {35, -29, -20, 30};
Plane Surface(4) = {4};
Transfinite Surface {4};
Recombine Surface {4};

//+
Curve Loop(5) = {18, 15, -26, 28, 38};
Plane Surface(5) = {5};
Transfinite Surface(5) = {1625, 1609, 490, 566};
Recombine Surface {5};
//+
Line(41) = {1630, 1628};
//+
Line(42) = {1631, 1629};
//+
Circle(43) = {1630, 1632, 1631};
//+
Line(44) = {25, 1630};
//+
Line(45) = {1581, 1631};
//+
Split Curve {37} Point {25, 1581};
Split Curve {39} Point {1628};
Split Curve {40} Point {1629};
//+
Transfinite Curve {48} = n_vane_aft_bottom Using Progression 1;
Transfinite Curve {44, 45} = (1-n_vane_norm_pass_frac) * n_vane_normal Using Progression 1;
Transfinite Curve {41, 42} = n_vane_norm_pass_frac * n_vane_normal+2 Using Progression 1;
Transfinite Curve {19} = n_vane_aft_bottom*n_vane_aft_bottom_curve_frac+1 Using Progression 1;
Transfinite Curve {49} = (1-n_vane_aft_bottom_curve_frac)*n_vane_aft_bottom Using Progression 1;
Transfinite Curve {46, 51} = n_vane_aft_top Using Progression 1;
Transfinite Curve {47, 43} = n_trailing_edge Using Progression 1;
//+

//+
Curve Loop(6) = {19, 49, -41, -44, 48, -28};
Plane Surface(6) = {6};
Transfinite Surface {6} = {1628, 25, 490, 1609};
Recombine Surface{6};
//+

//+
Curve Loop(7) = {29, 46, 45, 42, -51};
Plane Surface(7) = {7};
Transfinite Surface(7) = {810, 1581, 1629, 1610};
Recombine Surface{7};//+


//+
Curve Loop(8) = {47, 44, 43, -45};
Plane Surface(8) = {8};
Transfinite Surface(8);
Recombine Surface{8};
//+
Line(53) = {1633, 1612};
//+
Recursive Delete {
  Curve{50}; 
}
Line(54) = {1628, 1633};
Line(55) = {1633, 1613};
Line(56) = {1613, 1616};

//+
Transfinite Curve {53, 56} = n_ax_tube Using Progression 1;
Transfinite Curve {54, 52} = n_tube_wall Using Progression 1;
//+
Curve Loop(9) = {43, 42, 52, -53, -54, -41};
Plane Surface(9) = {9};
Transfinite Surface {9} = {1628, 1633, 1612, 1629};
Recombine Surface {9};

Transfinite Curve {55, 22} = 10 Using Progression 1;
//+
Curve Loop(10) = {53, 22, -56, -55};
Plane Surface(10) = {10};
Transfinite Surface {10};
Recombine Surface {10};
//+
Transfinite Curve {23, 11} = n_arc_2_bottom Using Progression 1.02;
Transfinite Curve {12} = 100 Using Progression 1;
Transfinite Curve {13} = n_arc_2_bottom + n_ax_tube -1 Using Progression 1;

//+
Line(57) = {1617, 1635};
//+
Line(58) = {1618, 1635};
//+

Transfinite Curve {57, 13} = n_ax_tube * n_outlet_bottom_frac Using Progression 1;
Transfinite Curve {58, 12} = n_ax_tube * (1-n_outlet_bottom_frac) +1 Using Progression 1;


//+
Curve Loop(11) = {56, 11, 58, -57, -23};
Plane Surface(11) = {11};
Transfinite Surface {11} = {1613, 1617, 1618, 1616};
Recombine Surface {11};

//+
Curve Loop(12) = {57, -58, 13, -12};
Plane Surface(12) = {12};
Transfinite Surface {12};
Recombine Surface {12};
//+
Extrude {0, 0, 1} {
  Surface{2}; Surface{1}; Surface{3}; Surface{4}; Surface{5}; Surface{7}; Surface{6}; Surface{8}; Surface{9}; Surface{10}; Surface{11}; Surface{12}; Layers {1}; Recombine;
}
//+
Physical Volume("fluid", 373) = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12};
//+
Physical Surface("inlet", 374) = {69};
//+
Physical Surface("outlet", 375) = {367};
//+
Physical Surface("vane", 376) = {148, 202, 134, 107, 187, 242, 256};
//+
Physical Surface("topWall", 377) = {89, 126, 156, 214, 288, 314, 337};
//+
Physical Surface("bottomWall", 378) = {73, 179, 226, 230, 296, 322, 349, 371};
//+
Physical Surface("side", 379) = {90, 2, 112, 1, 139, 3, 188, 5, 6, 247, 161, 4, 7, 215, 8, 269, 9, 301, 10, 323, 11, 350, 12, 372};

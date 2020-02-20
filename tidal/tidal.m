% Simulation of a simple barbell breaking under tidal forces

% Let's assume steel as the material

r=40; % radius of steel ball
rho=7800; % density of A36 steel
TS=500e6; % 500 MPa, near upper limit of A36 steel
l=1000; % length of cable
d=0.05; % 5cm radius cable
L=6000000; % 6000km baseline
M=6e24; % Mass of earth
G=6.74e-11; % Gravitational constant

m=rho*(4/3)*pi*r^3; % Mass of ball
A=pi*d^2/4; % Cross sectional area of cable

F1=G*M*m/(L+l/2)^2 ;
F2=G*M*m/(L-l/2)^2;
Fin=G*m^2/l^2;
NetTensileForce=F2-F1-Fin;
NetTensileStress=NetTensileForce/A;

% Check break
if NetTensileStress<TS
    cableBreak='No';
else
    cableBreak='Yes';
end

disp(['Central body force on outer mass: ' num2str(F1) ' Newtons']);
disp(['Central body force on inner mass: ' num2str(F2) ' Newtons']);
disp(['Internal force between masses: ' num2str(Fin) ' Newtons']);
disp(['Net tensile force: ' num2str(NetTensileForce) ' Newtons']);
disp(['Net tensile stress: ' num2str(NetTensileStress) ' Newtons']);
disp(['Will cable break? ' cableBreak]);




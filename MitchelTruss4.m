clear; clf; figure(1);

phi = pi/16; 
beta = pi/4;
r0 = 2;

[Q,P] = QP_init(phi,beta,r0);
[dim,q] = size(Q); p = size(P,2); n = q+p;
C = C_init(); b = size(C,1); 
s = 0;
m = b+s;
U= zeros(dim,q); U(2,1)=-0.1; U(1,2)=-1; 
[c_bars,t_strings,V]=tensegrity_statics(b,s,q,p,dim,Q,P,C,U);
tensegrity_plot(Q,P,C,b,s,U,V,true,1,0.08); grid on;

function C = C_init()
    no_bar = 2*[1:4];
    no_node = 1:5;
    C = zeros(sum(no_bar),sum(no_node));
    barindex = 1;
    nodeindex = 1;
    for i = 1:4
        for j = 1:no_node(i)
            C(barindex,nodeindex) = 1;
            C(barindex,nodeindex+no_node(i))=-1;
            barindex = barindex +1;    
            C(barindex,nodeindex) = 1;
            C(barindex,nodeindex+no_node(i)+1)=-1;
            barindex = barindex +1;
            
            nodeindex = nodeindex + 1; 
        end
    end
    
end

function [Q,P] = QP_init(phi,beta,r0)
    node_no = 1:5;
    a = sin(beta)/sin(beta + phi);
    %c = sin(phi)/sin(beta + phi);
    r = r0*a.^(node_no-1);
    Q(:,1) = [r(1),0]; 
    for i = node_no(2:end-1)
        node_end = cumsum(node_no);
        Q(1,(node_end(i)-i+1):node_end(i)) = r(i);
    end
    Q(2,(node_end(2)-node_no(2)+1):node_end(2)) = linspace(-phi,phi,node_no(2));
    Q(2,(node_end(3)-node_no(3)+1):node_end(3)) = linspace(-2*phi,2*phi,node_no(3));
    Q(2,(node_end(4)-node_no(4)+1):node_end(4)) = linspace(-3*phi,3*phi,node_no(4));

    P(1,1:node_no(5))= r(5);
    P(2,1:node_no(5)) = linspace(-4*phi,4*phi,node_no(5));

    Q = [Q(1,:).*cos(Q(2,:));Q(1,:).*sin(Q(2,:))];
    P = [P(1,:).*cos(P(2,:));P(1,:).*sin(P(2,:))];
end



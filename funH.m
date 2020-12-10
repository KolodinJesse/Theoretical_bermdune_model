function F=funH(H,p,CPIn,alpha,beta,theta,DR,DT,Halpha,Walpha)

F=((((H/Halpha)^(-beta))*Walpha*(DR*(CPIn*DT)))/(theta*alpha))^(theta/(theta-1))*(beta*alpha*(H^(beta-1))*(Halpha^(-beta)))-((DR*p*CPIn)*(DT+H));

end
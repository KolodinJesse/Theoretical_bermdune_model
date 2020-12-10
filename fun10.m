function F=fun10(H,p,CPIn,alpha,theta,beta,DR,DT,Halpha,Walpha)

F=((((H/Halpha)^(-theta))*Walpha*(DR*(CPIn*DT)))/(beta*alpha))^(beta/(beta-1))*(theta*alpha*(H^(theta-1))*(Halpha^(-theta)))-((DR*p*CPIn)*(DT+H));

end
function [ D_Mat ] = UpdateD(Coef, Data, DD_Mat,rh )

[ atomNum] = size(DD_Mat,2);
Imat= eye(size(Coef,1));



  TempCoef       = Coef;
  TempData       = Data;
  rho = rh;
  rate_rho = 1.2;
  TempS= DD_Mat;
  TempT  = zeros(size(TempS));
  previousD = DD_Mat;
  Iter = 1;
  ERROR=1;
    

    while(ERROR>1e-8&&Iter<100)
         TempD   = (rho*(TempS-TempT)+TempData*TempCoef')/(rho*Imat+TempCoef*TempCoef');
         TempS   = normcol_lessequal(TempD+TempT);
         TempT   = TempT+TempD-TempS;
         rho     = rate_rho*rho;
         ERROR = mean(mean((previousD- TempD).^2));
         previousD = TempD;
         Iter=Iter+1;

    end  

   
   D_Mat   = TempD;
    

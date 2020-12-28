function pred = FDDL_pred(Y, D, CoefM, opts) % GC
    vgamma = opts.gamma;
    opts.max_iter = 100;
    [X, ~] = lasso_fista(Y, D, zeros(size(D,2), size(Y,2)), vgamma, opts);
    C = size(CoefM,2);%�൱�ڼ���
    w = 0.5;
    E = zeros(C, size(Y,2));%���࣬�����������ж�����
    for c = 1: C 
        Dc = get_block_col(D, c, opts.D_range);%ά��*Դ����ÿ��ѵ����
        Xc = get_block_row(X, c, opts.D_range);%Դ����ÿ��ѵ����*һ����������
        R1 = Y - Dc*Xc;
        E1 = sum(R1.^2);
        R2 = X - repmat(CoefM(:, c), 1, size(Y,2));
        E2 = sum(R2.^2);

 
        E(c,:) = E1+opts.weight*E2;
    end 
    [~, pred] = min(E);
end 

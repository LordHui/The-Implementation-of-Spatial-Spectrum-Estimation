function [theta_search, Pmusic] = test(SNRdB, snapshot, M)
    %----------------------------------��������----------------------------------------                                                              
    f0=200;                                        %����Ƶ��
    fs=600;                                        %������
    c=3e8;                                         %�����ٶ�
    lamda=c/f0;                                 %��������
    d=lamda/2;                                  %��Ԫ��࣬�벨��
    % M=8;                                            %��Ԫ��
    theta=[-20 0 20]*pi/180;         %����Ƕ�-90~90��
    K=length(theta);                         %�źŸ���
    % SNRdB=20;                               %�����
    % snapshot=200;                          %������
    %�������
    A=zeros(M,K);
    for ii=1:K
        A(:,ii)=exp(-1j*2*pi*d*(0:M-1)*sin(theta(ii))/lamda).';
    end

    %�����ź�
    S=zeros(K,snapshot);
    % for ii=1:K
    %     for jj=1:snapshot
    %         S(ii,jj)=(10^(SNRdB/20))*exp(j*2*pi*(f0/fs*jj+rand));%����������ź�
    %     end
    % end
    for ii=1:K
            S(ii,:)=(10^(SNRdB/20))*exp(j*2*pi*(f0/fs*(1:snapshot)+rand));%��������ź�
    end

    Noise = (randn(M, snapshot) + 1i * randn(M, snapshot)) / sqrt(2);
    %������������ź�
    X=A*S+Noise;
    %����Э�������
    R=X*X'/snapshot;%����Э�������
    %% ��������ռ�ƽ��
    m=6;                    %ÿ��������Ԫ��
    p=M+1-m;            %�����������
    Rfk=zeros(m,m);
    Rbk=zeros(m,m);

    for k=1:p
        Zk=[zeros(m,k-1),eye(m),zeros(m,p-k)];%ǰ��ռ�ƽ��ѡ�����
        Rfk=Rfk+Zk*R*Zk';

        Qk=[zeros(m,k-1),fliplr(eye(m)),zeros(m,p-k)];%����ռ�ƽ��ѡ�����
        Rbk=Rbk+Qk*conj(R)*Qk';
    end
    Rf=Rfk/p;                    %ǰ��ռ�ƽ��
    Rb=Rbk/p;                  %����ռ�ƽ��
    Rfb=(Rf+Rb)/2;          %ǰ����ռ�ƽ����ʹ��ǰ����ռ�ƽ���ܹ�������������

    [EV,D]=eig(Rfb);
    [EVA,IBX]=sort(diag(D));%��������
    EV=EV(:,IBX);
    EN=EV(:,1:m-K);            %�����ӿռ����ȡ

    theta_search=(-90:90)*pi/180;
    for ii=1:length(theta_search)
            a=exp(-1j*2*pi*d*(0:m-1)*sin(theta_search(ii))/lamda).';
            Pmusic(ii)=1/(a'*EN*EN'*a);
    end
end

create or replace procedure ScoreToVoucher(ScoreExchThemeID int, CardTypeID int, EmployeeCode varchar2) 
as
V_CardCount Number;/*��������*/
V_MaxVoucherID varchar2(30);/*���ȯ��*/
V_MaxBillNumber varchar2(20);/*�����ֶһ������󵥾ݺ�*/
V_EmployeeName varchar2(60);/*ְԱ����*/
begin
    V_CardCount:=0;/*��ʼ����������*/
    select EmployeeName into V_EmployeeName from tbEmployee;
    delete from temp_Procedure__Card; /*ɾ����ʱ��������*/
    delete from temp_Procedure_Voucher;/*ɾ����ʱ��ȯ����*/
    /*���ݹ���ID�������ͣ���ȡ���п�*/
    insert into temp_Procedure__Card
    select a.MemberCode,a.CardCode,a.AccountsCode,a.CurrentBalance,ExchMoney,b.ExchVParValue,BillNumber,Score 
    from tbCard a,tbScoreExchTheme b
    where 
    a.CardState=2 /*��״̬*/
    and a.IsBlankoutByChangeCard=0 /*���ǷϿ�*/
    and a.IsIntegral=1 /*���ֿ�*/
    and a.typeID=CardTypeID /*������*/
    and a.PeriodOfValidity>to_char(sysdate,'YYYYMMDD')/*��Ч��*/
    and b.ScoreExchThemeID=ScoreExchThemeID 
    and b.ExchMoneyForm=0/*�һ���ʽΪ�����ֽ�*/
    and b.IsSection=0/*�ֶλ��ֲ�����*/
    and case b.CardTypeID when -1 then a.typeID else b.CardTypeID end=a.typeID
    and a.LevelID in (select CardLevelID from tbScoreExchTheme_CardLevel where ScoreExchThemeID=ScoreExchThemeID)
    and a.CurrentBalance>(select min(Score) from tbScoreExchRuleToMoney where ScoreExchThemeID=ScoreExchThemeID);/*��ǰ���ִ��ڹ������С����*/

    select count(*) into V_CardCount from temp_Procedure__Card;

    if V_CardCount>0 then 
    
       /*ѭ������,���ջ��ִ�С���򣬴Ӵ�С*/
        for extRule in (select * from tbScoreExchRuleToMoney where ScoreExchThemeID=ScoreExchThemeID order by Score Desc) loop
            /*���¶һ�����*/
            update temp_Procedure__Card set 
            ExchMoney=ExchMoney+(CurrentBalance-mod(CurrentBalance,extRule.Score))*extRule.ExchMoney/extRule.Score,
            CurrentBalance=mod(CurrentBalance,extRule.Score),
            Score=CurrentBalance-mod(CurrentBalance,extRule.Score)
            where CurrentBalance>=extRule.Score ;
        end loop;
        delete from temp_Procedure__Card where ExchMoney<=0;/*ɾ��û�жһ���*/
        select max(BillNumber) into V_MaxBillNumber from tb201407_ScoreExch where  substr(billNumber,1,4)='9959';/*�һ���Ϣ��󵥾ݺ�*/
        update temp_Procedure__Card set BillNumber=LPad(V_MaxBillNumber + rownum,length(V_MaxBillNumber),'0');/*�������ݺ�*/
        select Max(substr(VoucherID,5,12)) into V_MaxVoucherID from tbVoucher;
        
        /*����ȯ��ʱ��*/
        insert into temp_Procedure_Voucher
        select * from (
        WITH T1 AS(
                SELECT BillNumber,CardCode,MemberCode,AccountsCode,ExchMoney,ParValue,SUM(ExchMoney/ParValue)OVER(ORDER BY CardCode,MemberCode,AccountsCode,ExchMoney,ParValue) RC
                FROM temp_Procedure__Card
            ),T2 AS (
                SELECT ROWNUM RN FROM DUAL
                CONNECT BY ROWNUM<=(SELECT SUM(ExchMoney/ParValue) FROM temp_Procedure__Card)
            )
        SELECT Lpad(V_MaxVoucherID + T2.RN, 4, '0')              VoucherID,
               Lpad(V_MaxVoucherID+T2.RN, 4, '0')
               + To_char(Trunc(DBMS_RANDOM.value(1000, 9999))) VoucherCode,
               T1.MemberCode,
               T1.CardCode,
               T1.AccountsCode,
               T1.BillNUmber
               /*,
               row_number() over(partition by T1.BillNUmber order by T1.BillNUmber) as BillIndex*/
        FROM   T1,
               T2
        WHERE  T1.RC >= T2.RN
               AND T1.RC - T1.ExchMoney / T1.ParValue < T2.RN 
        )aa;
        
        /*����ȯ��ʱ�����ȯ��ʽ��*/
        INSERT INTO tbVoucher
            (VoucherID,
             VoucherCode,
             MemberCode,
             ParValue,
             PeriodOfValidity,
             VoucherState,
             DepartmentCode,
             CheckoutString,
             OutDate,
             vType,
             AccountsCode,
             CardNumber,
             ScoreExchThemeID,
             PrintTempCode)
        select a.VoucherID,a.VoucherCode,a.MemberCode,b.ExchVParValue,b.VouchRetuenEndDate,2 VoucherState,
        '9957',md5(a.VoucherID||b.VouchRetuenEndDate||to_char(b.ExchVParValue)||to_char(2)) CheckoutString,to_char(sysdate,'YYYYMMDD'),0,a.AccountsCode,a.CardCode,b.ScoreExchThemeID,b.PrintTempCode from temp_Procedure_Voucher a,tbScoreExchTheme b
        where b.ScoreExchThemeID=ScoreExchThemeID;
        
        /*����ȯ������ϸ*/
        
        /*���ݿ���ʱ����¿��Ļ������*/
        UPDATE tbCard T1
        SET    ( T1.CurrentBalance,T1.TotalIntegralExchange) = (SELECT T2.CurrentBalance,T1.TotalIntegralExchange+T2.Score
                                        FROM   temp_Procedure__Card T2
                                        WHERE  T1.CardCode = T2.CardCode and T2.ExchMoney>0) ;
        
        /*��¼�һ���Ϣ*/
        /*����*/
        insert into tb201407_ScoreExch
        select a.BillNumber,b.ScoreExchThemeID,a.AccountsCode,ExchDept,to_char(sysdate,'YYYYMMDD'),to_char(sysdate,'YYYYMMDDhh24Miss') ExchDate,EmployeeCode,
        V_EmployeeName ExchEmployName,0 ExchForm,a.Score Score,a.ExchMoney ,CurrentBalance ScoreBalanceEndExch,CancelBillNumber,WsPreBillNumber,a.AccountsCode CAcountsCode
        from temp_Procedure__Card a,tbScoreExchTheme b;
        
        /*��ϸ*/
        insert into tb201407_ScoreExchDetail(BillNumber,Score,ExchMoney)
        select BillNumber,Score,ExchMoney
        from temp_Procedure__Card;
        
        /*��¼���պϼ�*/
        merge into tb201407_DCardSum M
        using temp_Procedure__Card N
        on (M.SumDay=to_char(sysdate,'YYYYMMDD') and M.Accounts=N.AccountsCode)
        when not matched then 
        insert (SumDay,Accounts,IntegralExchange)
        values(to_char(sysdate,'YYYYMMDD'),N.AccountsCode,N.Score)
        when matched then 
        update set IntegralExchange=IntegralExchange+N.Score;
        
        /*��¼���ºϼ�*/
        merge into tb201407_MCardSum M
        using temp_Procedure__Card N
        on (M.Accounts=N.AccountsCode)
        when not matched then 
        insert (SumDay,Accounts,IntegralExchange)
        values(to_char(sysdate,'YYYYMMDD'),N.AccountsCode,N.Score)
        when matched then 
        update set IntegralExchange=IntegralExchange+N.Score;
        
    else 
    DBMS_OUTPUT.PUT_LINE('û�ж�Ӧ�Ŀ����ݣ�');
    end if;
    
    commit;/*�ύ*/
    EXCEPTION   /*�쳣����*/
        WHEN OTHERS THEN  
        DBMS_OUTPUT.PUT_LINE('���������޸�ʧ�ܣ�');   
        ROLLBACK;   

end;

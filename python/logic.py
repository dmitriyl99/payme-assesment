import pandas as pd
import numpy as np
from datetime import date, timedelta


def apply_tot_claim_cnt_l180d(application, contracts_df):
        l180date = pd.to_datetime(date.today() - timedelta(days=180))
        application.tot_claim_cnt_l180d = contracts_df[(contracts_df.claim_date.notnull()) & (contracts_df.claim_date >= l180date)].shape[0]
    
def apply_disb_bank_loan_wo_tbc(application, contracts_df):
    contracts_not_from_tbc = contracts_df[(~contracts_df.bank.isin(['LIZ', 'LOM', 'MKO', 'SUG', np.nan])) & (contracts_df.contract_date != '')]
    if contracts_not_from_tbc.shape[0] == 0:
        disb_bank_loan_wo_tbc = -1
    else:
        disb_bank_loan_wo_tbc = contracts_not_from_tbc.loan_summa.sum()
    application.disb_bank_loan_wo_tbc = int(disb_bank_loan_wo_tbc)

def apply_day_sinlastloan(application, contracts_df):
    last_loans = contracts_df[(~contracts_df.contract_date.isna()) & (contracts_df.loan_summa.notnull())].sort_values(by='contract_date', ascending=False)
    if last_loans.shape[0] == 0:
        application.day_sinlastloan = -1
    else:
        last_loan = last_loans.iloc[0]
        application.day_sinlastloan = (application.application_date.replace(tzinfo=None) - last_loan.contract_date).days

def apply_tot_active_loans(application, contracts_df):
    active_loans = contracts_df[(~contracts_df.contract_date.isna()) & (contracts_df.loan_summa.notnull()) & (contracts_df.loan_summa > 0)]
    application.tot_active_loans_cnt = active_loans.shape[0]
    application.tot_active_loans_sum = int(active_loans.loan_summa.sum()) if active_loans.shape[0] > 0 else -1
    application.avg_loan_sum = int(active_loans.loan_summa.mean()) if active_loans.shape[0] > 0 else -1

def apply_avg_days_between_contracts(application, contracts_df):
    contracts_df['days_between_contracts'] = contracts_df[contracts_df.contract_date.notna()].contract_date.diff().dt.days.fillna(0)
    avg_days_between_contracts = contracts_df['days_between_contracts'].mean()
    if pd.isnull(avg_days_between_contracts):
        avg_days_between_contracts = -1
    application.avg_days_between_contracts = avg_days_between_contracts
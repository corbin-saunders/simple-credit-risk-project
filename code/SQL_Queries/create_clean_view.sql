CREATE VIEW loans_clean AS
SELECT
	loan_amnt, term, int_rate, grade, sub_grade, emp_length,
	home_ownership, annual_inc, purpose, dti, delinq_2yrs, 
	open_acc, pub_rec, revol_bal, revol_util, total_acc,
	addr_state, issue_d,
	CASE WHEN loan_status IN ('Charged Off', 'Default') THEN 1 ELSE 0 END AS is_default
FROM loans
WHERE loan_status IN ('Fully Paid', 'Charged Off', 'Default');	
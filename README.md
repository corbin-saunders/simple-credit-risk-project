# A SIMPLE CREDIT RISK PREDICTION PROJECT

## Setup

1. Download the [Lending Club dataset](https://www.kaggle.com/datasets/adarshsng/lending-club-loan-data-csv) from Kaggle and place `loan.csv` in the `data/` folder at the project root.
2. Run `code/load_data.py` to load the CSV into a local SQLite database (`data/loans.db`).
3. Open `data/loans.db` in [DB Browser for SQLite](https://sqlitebrowser.org) and run `code/sql/03_create_view_loans_clean.sql`, then click **Write Changes**.
4. Open `code/model_and_eval.ipynb` and run all cells.

Requires Python 3 with the packages in `requirements.txt` (`pip install -r requirements.txt`).

## Key Decisions

- **Excluded post-issuance columns** (e.g. `recoveries`, `total_pymnt`, `last_pymnt_d`) to prevent data leakage — these fields are only populated after a loan's outcome is known, so including them would let the model "cheat."
- **Excluded loans with `loan_status = 'Current'`** since their eventual outcome isn't known yet.
- **Dropped rows missing `annual_inc`, `dti`, or `revol_util`** rather than imputing — these are risk-relevant numeric fields where a guessed value could mislead the model; targeted rather than blanket `dropna()`.
- **Used `class_weight='balanced'` / `scale_pos_weight`** to counter the ~80/20 class imbalance between paid and defaulted loans.
- **Evaluated on precision, recall, and ROC-AUC instead of accuracy**, since accuracy is misleading on imbalanced data (see Results above).
- **Standardized features for logistic regression, but not for XGBoost** — tree-based models split on raw thresholds and are scale-invariant, so scaling only matters for the linear model.
- **Compared a linear baseline against a boosted model** rather than jumping straight to the strongest option, to make the improvement from XGBoost demonstrable rather than assumed.

## Results

| Model | Recall (defaults) | Precision (defaults) | ROC-AUC |
| --- | --- | --- | --- |
| Logistic Regression | 0.63 | 0.32 | 0.708 |
| XGBoost | 0.68 | 0.32 | 0.722 |

XGBoost catches more defaults (68% vs 63%) at the same precision as the logistic regression baseline, and improves ROC-AUC from 0.708 to 0.722.

Accuracy isn't reported as the headline metric — defaults make up only ~20% of the dataset, so a model that never predicted a default would already score ~80% accuracy while being useless. Recall and ROC-AUC give a truer picture of how well the model actually distinguishes risk.

## Tableau Dashboard

**[Try the interactive dashboard on Tableau Public](https://public.tableau.com/views/loans_workbook/Dashboard1?:language=en-GB&:sid=&:display_count=n&:origin=viz_share_link)**  

A simple dashboard showing three charts.

1. Default Rate by Grade shows the average default rate and how it climbs as the loan grade increases from A to G.

2. Risk Score Distribution shows the distribution of predicted Risk Scores, this helps showcase how confident my models predictions are.

3. My Loans flagged by Risk Threshold chart is an interactive chart that shows what % of loans would get rejected if they scored above a set Risk Threshold which is dictated by the slider below the graph. Dragging the slider up (stricter) or down (looser) shows the trade-off of my model: tighter thresholds reject more bad loans but also more good ones.

![Tableau Dashboard](screenshots/dashboard_screenshot.png)



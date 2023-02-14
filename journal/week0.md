# Week 0 — Billing and Architecture

##  Destroy your root account credentials, Set MFA, IAM role

Never, ever, use your root account for everyday use. Instead, head to [Identity and Access Management (IAM)](https://youtu.be/OdUnNuKylHg?t=967) and create an administrator user. 

- Protect and lock your root credentials in a secure place 
You will absolutely want to activate Multi Factor Authentication (MFA) too for your root account. And you won’t use this user unless strictly necessary.

- Now, about your newly created admin account, activating MFA for it is a must. It’s actually a requirement for every user in your account if you want to have a security first mindset.

-  Now we set up MFA for the [user](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_mfa_enable_virtual.html)

- we can login into our IAM user after inputing the MFA code 


## Seting up AWS Budgets, AWS Cost Explorer, Billing Alarms

- Go to billing 
![Alt text](../journal_images/billing.png)

- click on budget and create budget

![Alt text](../journal_images/budget.png)



## Use EventBridge to hookup Health Dashboard to SNS and send notification when there is a service health issue.

##  Create an architectural diagram (to the best of your ability) the CI/CD logical pipeline in Lucid Charts
![Alt text](../_docs/assets/Conceptual%20Architecture%20Diagram.png)

- I was able to set up a billing alarm
- I was able to set up aws budget 
- I destroyed my root account credentials and was able to Set MFA & IAM role

- Review all the questions of each pillars in the Well Architected Tool (No specialized lens)

- 
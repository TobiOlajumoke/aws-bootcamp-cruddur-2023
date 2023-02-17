# Billing, Architecture, Security

##  Destroy your root account credentials, Set MFA, 


## Create an IAM user
- Sign in to the AWS Management Console with your root account credentials.
Navigate to the IAM service console.
- Click on the "Users" link in the left-hand menu and then click the "Add user" button.
- Enter a name for the user in the "User name" field.
- Select the "Programmatic access" and/or "AWS Management Console access" checkboxes to grant the user access to AWS resources via the AWS CLI, SDKs, or the AWS Management Console.
- If you select "AWS Management Console access", choose whether to create a custom password or allow the user to create their own password.
- Click "Next: Permissions".
- In the "Set permissions" step, you want to grant budget and cost alert permissions.
- Click on the "Permissions" tab and click the "Attach policies" button.
- In the search bar, search for "AWSBudgetsFullAccess" policy and select it.
- Click on "Attach policy".
The "AWSBudgetsFullAccess" policy grants the user full access to create, edit and delete budgets and also to receive budget notifications.
- Click "Next: Tags" to add tags to the user (optional).
- Click "Next: Review" to review your settings, and then click "Create user" to create the IAM user.


# To activate IAM user and role access to the Billing and Cost Management console
- Sign in to the AWS Management Console with your root user credentials (specifically, the email address and password that you used to create your AWS account).

- On the navigation bar, choose your account name, and then choose Account.

- Next to IAM User and Role Access to Billing Information, choose Edit.

- Select the Activate IAM Access check box to activate access to the Billing and Cost Management console pages.

- Choose Update.

[Read the AWS Official Documentations](https://docs.aws.amazon.com/IAM/latest/UserGuide/tutorial_billing.html?icmpid=docs_iam_console#tutorial-billing-step1)

# MFA
Multifactor authentication (MFA) is a security technology that requires multiple methods of authentication from independent categories of credentials to verify a user's identity for a login or other transaction.
Never, ever, use your root account for everyday use. Instead, head to [Identity and Access Management (IAM)](https://youtu.be/OdUnNuKylHg?t=967) and create an administrator user. 

- Protect and lock your root credentials in a secure place 
You will absolutely want to activate Multi Factor Authentication (MFA) too for your root account. And you won’t use this user unless strictly necessary.

- Now, about your newly created admin account, activating MFA for it is a must. It’s actually a requirement for every user in your account if you want to have a security first mindset.

-  Now we set up MFA for the [user](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_mfa_enable_virtual.html)

- we can login into our IAM user after inputing the MFA code 


## Seting up AWS Budgets & Billing Alarms

AWS Budgets is a service that enables you to set custom cost and usage budgets that notify you when you exceed or are forecasted to exceed your budgeted amount. With AWS Budgets, you can track your service usage and your expenses, so you can optimize your costs and adjust your usage when necessary. You can create budgets for specific services or resource groups, set custom alerts, and receive notifications via email or SMS.

We are gonna create 2 budget one for AWS credits and the other  for actual dollar spend


- Go to billing 
![Alt text](../journal_images/billing.png)

- click on budget and create budget

![Alt text](../journal_images/budget.png)

![Alt text](../journal_images/create_budget.png)

![Alt text](../journal_images/budget1.4.png)

- Give the budget a unique name

![Alt text](../journal_images/budget1.5.png)

- Input your budgeted ammount mine here is $20

![Alt text](../journal_images/budget1.6.png)

- Remove all and add credits

![Alt text](../journal_images/budget1.7.png)

![Alt text](../journal_images/budget1.8.png)
![Alt text](../journal_images/budget1.9.png)

- Next and configure threshold for 50%, 75% and 100% and  email address
![Alt text](../journal_images/budget2.png)

- Add threshold for 75% and 100% 
![Alt text](../journal_images/budget2.1.png)

![Alt text](../journal_images/budget2.2.png)


- In the budget scpoe select all except "credit" 
and CREATE it
It should look ike this
![Alt text](../journal_images/budget2.3.png)
## EventBridge 

EventBridge is a serverless service that uses events to connect application components together, making it easier for you to build scalable event-driven applications.
Use it to route events from sources such as home-grown applications, AWS services, and third- party software to consumer applications across your organization.
EventBridge provides a simple and consistent way to ingest, filter, transform, and deliver events so you can build new applications quickly. 




##  Conceptual Diagram in Lucid Charts or on a Napkin

A conceptual architecture diagram is a high-level representation of the system that shows the major components and how they interact with each other. It is often used in the early stages of a project to communicate the overall design and approach. This diagram is focused on the business concepts, requirements and goals of the system, and does not get into the details of specific technologies, platforms, or protocols.

- Looks like this:

![Alt text](../journal_images/Conceptual%20Architecture%20Diagram.png)

Use this [link](https://lucid.app/lucidchart/b39e0bb3-79e0-4acc-ab83-141eb0596c8e/edit?viewport_loc=-1538%2C14%2C2613%2C1120%2C0_0&invitationId=inv_08af9809-c94e-4378-96ea-1bb6320eb431) to veiw 



## Logical Architectual Diagram in Lucid Charts

A logical architecture diagram is a more detailed representation of the system that shows how the major components and subsystems fit together, as well as how data flows between them. This diagram is focused on the logical components of the system, and often includes information about specific technologies, platforms, and protocols that will be used.

- Looks like this:

![Alt text](../journal_images/Diagram%202.png)

Use this [link](https://lucid.app/lucidchart/fcbe4ace-283c-4290-ab6d-e07f1f619e44/edit?viewport_loc=-106%2C-163%2C3072%2C1317%2C0_0&invitationId=inv_9e537613-e6c5-49fe-a28f-0e9965cccc45) to veiw the diagram
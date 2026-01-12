# Project Overview
This project analyzes an e-commerce user funnel using SQL to understand user behavior on different event stages from visiting the website to purchasing.

## Business goals:
- Track user drop-off at each funnel stage
- Calculate conversion rates between steps
- Analyze and answer user behavioral questions


This project uses a public Kaggle dataset containing page visit events for different stages of an online shopping funnel.

Funnel stages analyzed:
1. Visit – User lands on the website
2. Cart – User adds an item to cart
3. Checkout – User proceeds to checkout
4. Purchase – User completes a purchase

dataset link: https://www.kaggle.com/datasets/mattjberry/page-funnel-visits

### SQL techniques used(Postgresql, pgAdmin 4):

VIEWs, conditional aggregation, Joins, Unions

## 1. Data preparation

- Create tables(visits, cart, checkout, purchase)

<img width="500" height="900" alt="Screenshot 2026-01-11 213823" src="https://github.com/user-attachments/assets/15b0c97e-68b1-4356-8f9b-d269cbc81e71" />


Load CSVs

- Rename timestamp column to its respective event time

<img width="500" height="900" alt="Screenshot 2026-01-11 222549" src="https://github.com/user-attachments/assets/f0f8383c-7bda-4cf4-af34-8e708f74cae3" />


- Build events table

<img width="500" height="900" alt="Screenshot 2026-01-11 222902" src="https://github.com/user-attachments/assets/30072d3f-0f18-471e-85bd-da2048a50092" />



## 2. Funnel construction

- Create a VIEW that shows when each user passed through each stage (visit → cart → checkout → purchase), all in one row per user.

<img width="500" height="900" alt="Screenshot 2026-01-11 225435" src="https://github.com/user-attachments/assets/91c4c122-4993-422e-9c51-74462e260be7" />



## 3. Funnel exploration 

- How many users reached each stage?

<img width="500" height="900" alt="Screenshot 2026-01-11 230053" src="https://github.com/user-attachments/assets/a52fe7e8-92dd-4377-813a-febd7f20291c" />



- How many users abandoned after cart?

<img width="500" height="900" alt="Screenshot 2026-01-11 230609" src="https://github.com/user-attachments/assets/1bb64572-7fd8-419b-b5cd-f1f51fa546d5" />



- Are there users who skipped steps?

<img width="500" height="900" alt="Screenshot 2026-01-11 230835" src="https://github.com/user-attachments/assets/81cf51f1-ca03-4138-8eb2-6a91cbc3d66a" />



## 4. Funnel performance

Conversion rates

<img width="500" height="900" alt="Screenshot 2026-01-11 231126" src="https://github.com/user-attachments/assets/3980be26-d3f0-4457-ac1b-e1e12f016c35" />



Drop-offs

<img width="500" height="900" alt="Screenshot 2026-01-11 231319" src="https://github.com/user-attachments/assets/b5d8c77d-bf50-4787-8ed8-bdd419380b35" />

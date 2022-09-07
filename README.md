# Project Description

Data collected on warehouse operations, product delivery, and customer ratings are investigated here. Approximately 60% of all deliveries made from this warehouse are late. To find out the cause of this issue, I perform EDA using SQL.

For this project, I pull a dataset from Kaggle, host it on pgAdmin and Postgres Docker containers, and query using Psycopg2 in Python on VSCode.

# Dataset

The dataset used here is the [E-Commerce Shipping Data from Kaggle](https://www.kaggle.com/datasets/prachi13/customer-analytics) posted by Prachi Gopalani. 

Contents of the dataset are described on Kaggle but posted here for completeness:

The dataset used for model building contained 10999 observations of 12 variables.
The data contains the following information:

- ID: ID Number of Customers.
- Warehouse block: The Company have big Warehouse which is divided in to block such as A,B,C,D,E.
- Mode of shipment:The Company Ships the products in multiple way such as Ship, Flight and Road.
- Customer care calls: The number of calls made from enquiry for enquiry of the shipment.
- Customer rating: The company has rated from every customer. 1 is the lowest (Worst), 5 is the highest (Best).
- Cost of the product: Cost of the Product in US Dollars.
- Prior purchases: The Number of Prior Purchase.
- Product importance: The company has categorized the product in the various parameter such as low, medium, high.
- Gender: Male and Female.
- Discount offered: Discount offered on that specific product.
- Weight in gms: It is the weight in grams.
- Reached on time: It is the target variable, where 1 Indicates that the product has NOT reached on time and 0 indicates it has reached on time.

**Note:** I changed the column named 'Reached on time' to 'Arrived_late'. In the original dataset, this column contains booleans where 1 refers to product arriving late and 0 to product arriving on time. It is more intuitive for me to change the column name to match the booleans better.

# Setup
## Docker Containers

To install Docker on ubuntu, I followed [these](https://docs.docker.com/desktop/install/ubuntu/) steps.

To work on this project, I spun up the following instances on Docker:

### PgAdmin Container:

For this container, I selected port 5555.

```
docker run -p 5555:80 --name pgadmin -e PGADMIN_DEFAULT_EMAIL="email" -e PGADMIN_DEFAULT_PASSWORD="password" dpage/pgadmin4
```

### Postgres Container:

Here, I selected the port to be 5455. The default is 5432. I made the user and password the same for simplicity. This container has since been destroyed.
```
docker run -p 5455:5432 --name some-postgres -e POSTGRES_USER=postgres -e POSTGRES_PASSWORD=postgres -d postgres
```

To check that both these containers have successfully been created, check for the green colored cube within the Docker app.

## Connecting postgres to PgAdmin

1- Connect to the PgAdmin server page using the port selected when creating the container.

![1](1.png)

2- Input email and password to login into PgAdmin. These should be the same email and password previously specified.

![1](2.png)

3- To connect the postgres container, locate the created server group. Right click > Register > Server.

![1](5.png)

4- Input a server name.

![1](6.png)

5- Select the 'Connection' tab and fill in the Host name, Port, Username, and Password fields. These should be from the created Postgres container. Hit 'Save'.

![1](7.png)

## Adding a dataset to the newly connected database

1- Under the newly connected database > Schemas > Tables 

![1](16.png)

2- Right click on Tables > Create > Table.

![1](8.png)

3- Input a name for the Table

![1](9.png)

4- Input column names and datatypes in the same order as the dataset columns> Save.

![1](10.png)

5- Right click on the newly created table name> Import/Export Data.

![1](11.png)

6- Select filename and format> OK.

![1](12.png)

The dataset should now exist on the server and can be accessed using Psycopg2.




## Psycopg2

I installed binary Psycopg2 onto a conda environment I had set up for this project. 


```
pip install psycopg2-binary
```

Versions:

```
python == 3.8.12
psycopg2-binary == 2.9.3
```

### Connecting to database using Psycopg2 on VSCode

![1](14.png)
# Project Summary and Conclusion

From my queries, it appears that there exists a link between product weight and whether a delivery is made late or on-time. This leads to many questions that can not be answered using this dataset:

Is there an internal processing issue with smaller items causing delays (smaller items falling off conveyer belt? Requiring frequent human intervention?) Are smaller and larger items delivered using different services or carriers?

These questions are worth investigating.

This graph shows that lighter items arrive late more than three times as much as they arrive on time. Heavier items don't seem to have this issue:

![2](graph_visualiser-1662571557102.png)